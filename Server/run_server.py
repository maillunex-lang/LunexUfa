#!/usr/bin/env python3
"""LunexUfa local game server — stdlib only. Windows now, Ubuntu later."""
from __future__ import annotations

import json
import threading
import time
import uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any
from urllib.parse import parse_qs, urlparse

ROOT = Path(__file__).resolve().parents[1]
DATA = Path(__file__).resolve().parent / "data"
CONTENT = ROOT / "Content"
HOST, PORT = "127.0.0.1", 8080

DATA.mkdir(parents=True, exist_ok=True)

_lock = threading.RLock()
_state: dict[str, Any] = {
    "worlds": {},
    "players": {},
    "shop": {
        "version": 1,
        "items": [
            {"id": "potion_small", "name": "Малое зелье", "price": 100, "currency": "money"},
            {"id": "teleport_scroll", "name": "Свиток телепорта", "price": 500, "currency": "money"},
        ],
    },
    "bots": {},
    "chat": {},  # worldId -> list
}


def _load_json(path: Path, default: Any) -> Any:
    if path.exists():
        return json.loads(path.read_text(encoding="utf-8"))
    return default


def _save_worlds() -> None:
    (DATA / "worlds.json").write_text(
        json.dumps(_state["worlds"], ensure_ascii=False, indent=2), encoding="utf-8"
    )


def _quests() -> list[dict[str, Any]]:
    doc = _load_json(CONTENT / "HaitanPrototypeQuests.json", {"quests": []})
    return list(doc.get("quests", []))


def _quest_by_id(qid: int) -> dict[str, Any] | None:
    for q in _quests():
        if int(q["id"]) == int(qid):
            return q
    return None


def _ensure_default_world() -> None:
    if _state["worlds"]:
        return
    wid = "world-haitan-1"
    _state["worlds"][wid] = {
        "id": wid,
        "name": "Хайтен (тест)",
        "template": "haitan",
        "mapId": 110200011,
        "botsEnabled": True,
        "createdAt": time.time(),
    }
    _state["chat"][wid] = []
    _save_worlds()


def _player_default(world_id: str, name: str) -> dict[str, Any]:
    first = _quests()[0] if _quests() else None
    spawns = _load_json(CONTENT / "HaitanPrototypeSpawns.json", {})
    birth = spawns.get("heroBirth", {"x": 11, "y": 50.02655, "z": 58, "direction": 0})
    return {
        "id": str(uuid.uuid4()),
        "name": name,
        "worldId": world_id,
        "mapId": 110200011,
        "x": birth["x"],
        "y": birth["y"],
        "z": birth["z"],
        "direction": birth.get("direction", 0),
        "experience": 0,
        "money": 0,
        "hp": 100,
        "maxHp": 100,
        "questId": first["id"] if first else None,
        "questProgress": 0,
        "questGoalCount": (first.get("goal") or {}).get("count", 0) if first else 0,
        "inventory": {},
        "updatedAt": time.time(),
    }


def _apply_quest_event(player: dict[str, Any], event: dict[str, Any]) -> dict[str, Any]:
    q = _quest_by_id(player.get("questId") or 0)
    if not q:
        return {"ok": False, "error": "no_active_quest"}

    kind = int(q.get("kind", 0))
    goal = q.get("goal") or {}
    et = event.get("type")
    rewarded = []

    if kind == 1 and et == "talk_npc":
        if int(event.get("npcId", 0)) != int(q.get("finishNpcId", 0)):
            return {"ok": False, "error": "wrong_npc"}
        # gossip auto-complete on correct NPC
        player["experience"] += int(q.get("experience", 0))
        player["money"] += int(q.get("money", 0))
        rewarded = [{"experience": q.get("experience"), "money": q.get("money")}]
        nxt = q.get("nextQuestId")
        nq = _quest_by_id(nxt) if nxt else None
        player["questId"] = nq["id"] if nq else None
        player["questProgress"] = 0
        player["questGoalCount"] = (nq.get("goal") or {}).get("count", 0) if nq else 0
        return {"ok": True, "player": player, "rewards": rewarded, "completedQuestId": q["id"]}

    if kind == 4 and et == "gather":
        if int(event.get("gatherId", 0)) != int(goal.get("id", -1)):
            return {"ok": False, "error": "wrong_gather"}
        player["questProgress"] = min(
            int(player.get("questProgress", 0)) + 1, int(goal.get("count", 1))
        )
    elif kind == 2 and et == "kill":
        if int(event.get("monsterId", 0)) != int(goal.get("id", -1)):
            return {"ok": False, "error": "wrong_monster"}
        # HP change acknowledgment for combat proof
        target_hp = event.get("targetHpAfter")
        player["questProgress"] = min(
            int(player.get("questProgress", 0)) + 1, int(goal.get("count", 1))
        )
        if target_hp is not None:
            player["lastHitTargetHp"] = target_hp
    else:
        return {"ok": False, "error": "event_mismatch", "questKind": kind, "eventType": et}

    if player["questProgress"] >= int(goal.get("count", 1)):
        player["experience"] += int(q.get("experience", 0))
        player["money"] += int(q.get("money", 0))
        rewarded = [{"experience": q.get("experience"), "money": q.get("money")}]
        nxt = q.get("nextQuestId")
        nq = _quest_by_id(nxt) if nxt else None
        player["questId"] = nq["id"] if nq else None
        player["questProgress"] = 0
        player["questGoalCount"] = (nq.get("goal") or {}).get("count", 0) if nq else 0
        return {"ok": True, "player": player, "rewards": rewarded, "completedQuestId": q["id"]}

    return {"ok": True, "player": player, "rewards": [], "completedQuestId": None}


def _json_bytes(obj: Any, code: int = 200) -> tuple[int, bytes, str]:
    body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
    return code, body, "application/json; charset=utf-8"


class Handler(BaseHTTPRequestHandler):
    server_version = "LunexUfaServer/0.1"

    def log_message(self, fmt: str, *args: Any) -> None:
        print("[%s] %s" % (self.log_date_time_string(), fmt % args))

    def _read_json(self) -> Any:
        length = int(self.headers.get("Content-Length", "0") or 0)
        if length <= 0:
            return {}
        raw = self.rfile.read(length)
        return json.loads(raw.decode("utf-8") or "{}")

    def _send(self, code: int, body: bytes, ctype: str) -> None:
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET,POST,PUT,OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self) -> None:  # noqa: N802
        self._send(204, b"", "text/plain")

    def do_GET(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        path = parsed.path.rstrip("/") or "/"
        qs = parse_qs(parsed.query)

        with _lock:
            if path == "/health":
                return self._send(*_json_bytes({"ok": True, "service": "lunexufa-server"}))
            if path == "/worlds":
                return self._send(*_json_bytes({"worlds": list(_state["worlds"].values())}))
            if path == "/quests":
                return self._send(*_json_bytes({"quests": _quests()}))
            if path == "/spawns":
                return self._send(
                    *_json_bytes(_load_json(CONTENT / "HaitanPrototypeSpawns.json", {}))
                )
            if path == "/shop/items":
                return self._send(*_json_bytes(_state["shop"]))
            if path == "/bots":
                return self._send(*_json_bytes({"bots": list(_state["bots"].values())}))
            if path == "/chat":
                wid = (qs.get("worldId") or ["world-haitan-1"])[0]
                return self._send(
                    *_json_bytes({"worldId": wid, "messages": _state["chat"].get(wid, [])[-100:]})
                )
            if path.startswith("/players/") and path.endswith("/state"):
                pid = path.split("/")[2]
                p = _state["players"].get(pid)
                if not p:
                    return self._send(*_json_bytes({"ok": False, "error": "not_found"}, 404))
                others = [
                    x
                    for x in _state["players"].values()
                    if x["worldId"] == p["worldId"] and x["id"] != pid
                ]
                bots = [
                    b
                    for b in _state["bots"].values()
                    if b.get("worldId") == p["worldId"] and b.get("enabled")
                ]
                return self._send(
                    *_json_bytes({"ok": True, "player": p, "others": others, "bots": bots})
                )

        self._send(*_json_bytes({"ok": False, "error": "not_found", "path": path}, 404))

    def do_POST(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        path = parsed.path.rstrip("/") or "/"
        data = self._read_json()

        with _lock:
            if path == "/worlds":
                wid = "world-" + str(uuid.uuid4())[:8]
                world = {
                    "id": wid,
                    "name": data.get("name") or ("Мир " + wid),
                    "template": data.get("template") or "haitan",
                    "mapId": int(data.get("mapId") or 110200011),
                    "botsEnabled": True,
                    "createdAt": time.time(),
                }
                _state["worlds"][wid] = world
                _state["chat"][wid] = []
                _save_worlds()
                return self._send(*_json_bytes({"ok": True, "world": world}))

            if path.startswith("/worlds/") and path.endswith("/enter"):
                wid = path.split("/")[2]
                if wid not in _state["worlds"]:
                    return self._send(*_json_bytes({"ok": False, "error": "world_missing"}, 404))
                player = _player_default(wid, data.get("name") or "Герой")
                _state["players"][player["id"]] = player
                return self._send(*_json_bytes({"ok": True, "player": player, "shop": _state["shop"]}))

            if path.startswith("/players/") and path.endswith("/quest/event"):
                pid = path.split("/")[2]
                player = _state["players"].get(pid)
                if not player:
                    return self._send(*_json_bytes({"ok": False, "error": "not_found"}, 404))
                result = _apply_quest_event(player, data)
                player["updatedAt"] = time.time()
                return self._send(*_json_bytes(result))

            if path.startswith("/players/") and path.endswith("/move"):
                pid = path.split("/")[2]
                player = _state["players"].get(pid)
                if not player:
                    return self._send(*_json_bytes({"ok": False, "error": "not_found"}, 404))
                for k in ("x", "y", "z", "direction"):
                    if k in data:
                        player[k] = data[k]
                player["updatedAt"] = time.time()
                return self._send(*_json_bytes({"ok": True, "player": player}))

            if path == "/bots/start":
                wid = data.get("worldId") or "world-haitan-1"
                if wid not in _state["worlds"]:
                    return self._send(*_json_bytes({"ok": False, "error": "world_missing"}, 404))
                bid = "bot-" + str(uuid.uuid4())[:8]
                bot = {
                    "id": bid,
                    "worldId": wid,
                    "name": data.get("name") or "Тестовый бот",
                    "x": 20.0,
                    "y": 50.1,
                    "z": 40.0,
                    "enabled": True,
                    "chatLine": data.get("chatLine") or "Привет! Я бот из админки.",
                }
                _state["bots"][bid] = bot
                _state["chat"].setdefault(wid, []).append(
                    {
                        "at": time.time(),
                        "from": bot["name"],
                        "fromId": bid,
                        "isBot": True,
                        "text": bot["chatLine"],
                    }
                )
                # simple motion tick
                def _move(bot_id: str) -> None:
                    for i in range(20):
                        time.sleep(0.5)
                        with _lock:
                            b = _state["bots"].get(bot_id)
                            if not b or not b.get("enabled"):
                                return
                            b["x"] = float(b["x"]) + 0.4
                            b["z"] = float(b["z"]) + 0.1

                threading.Thread(target=_move, args=(bid,), daemon=True).start()
                return self._send(*_json_bytes({"ok": True, "bot": bot}))

            if path == "/bots/stop-all":
                wid = data.get("worldId")
                for b in _state["bots"].values():
                    if wid is None or b.get("worldId") == wid:
                        b["enabled"] = False
                return self._send(*_json_bytes({"ok": True}))

            if path == "/chat":
                wid = data.get("worldId") or "world-haitan-1"
                msg = {
                    "at": time.time(),
                    "from": data.get("from") or "player",
                    "fromId": data.get("fromId"),
                    "isBot": bool(data.get("isBot")),
                    "text": data.get("text") or "",
                }
                _state["chat"].setdefault(wid, []).append(msg)
                return self._send(*_json_bytes({"ok": True, "message": msg}))

        self._send(*_json_bytes({"ok": False, "error": "not_found", "path": path}, 404))

    def do_PUT(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        path = parsed.path.rstrip("/") or "/"
        data = self._read_json()
        with _lock:
            if path == "/shop/items":
                item_id = data.get("id")
                price = data.get("price")
                for item in _state["shop"]["items"]:
                    if item["id"] == item_id:
                        item["price"] = int(price)
                        _state["shop"]["version"] = int(_state["shop"]["version"]) + 1
                        return self._send(*_json_bytes({"ok": True, "shop": _state["shop"]}))
                return self._send(*_json_bytes({"ok": False, "error": "item_missing"}, 404))
            if path.startswith("/worlds/"):
                wid = path.split("/")[2]
                world = _state["worlds"].get(wid)
                if not world:
                    return self._send(*_json_bytes({"ok": False, "error": "world_missing"}, 404))
                if "botsEnabled" in data:
                    world["botsEnabled"] = bool(data["botsEnabled"])
                if "name" in data:
                    world["name"] = data["name"]
                _save_worlds()
                return self._send(*_json_bytes({"ok": True, "world": world}))
        self._send(*_json_bytes({"ok": False, "error": "not_found"}, 404))


def main() -> None:
    existing = _load_json(DATA / "worlds.json", {})
    if existing:
        _state["worlds"] = existing
        for wid in existing:
            _state["chat"].setdefault(wid, [])
    _ensure_default_world()
    httpd = ThreadingHTTPServer((HOST, PORT), Handler)
    print("LunexUfa server on http://%s:%s" % (HOST, PORT))
    print("Worlds: %s" % ", ".join(_state["worlds"].keys()))
    httpd.serve_forever()


if __name__ == "__main__":
    main()
