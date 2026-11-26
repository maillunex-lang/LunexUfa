#!/usr/bin/env python3
"""Smoke-test local LunexUfa server quest/shop/world/bot flow."""
from __future__ import annotations

import json
import sys
import urllib.error
import urllib.request

BASE = "http://127.0.0.1:8080"


def req(method: str, path: str, data: dict | None = None) -> dict:
    body = None if data is None else json.dumps(data).encode("utf-8")
    r = urllib.request.Request(
        BASE + path,
        data=body,
        method=method,
        headers={"Content-Type": "application/json"} if body else {},
    )
    with urllib.request.urlopen(r, timeout=5) as resp:
        return json.loads(resp.read().decode("utf-8"))


def main() -> int:
    steps = []
    try:
        h = req("GET", "/health")
        assert h.get("ok"), h
        steps.append("health ok")

        worlds = req("GET", "/worlds")["worlds"]
        assert worlds, "no worlds"
        wid = worlds[0]["id"]
        steps.append("worlds=%d default=%s" % (len(worlds), wid))

        w2 = req("POST", "/worlds", {"name": "Хайтен-2", "template": "haitan"})
        assert w2.get("ok"), w2
        steps.append("created world %s" % w2["world"]["id"])

        enter = req("POST", "/worlds/%s/enter" % wid, {"name": "SmokeHero"})
        assert enter.get("ok"), enter
        p = enter["player"]
        pid = p["id"]
        assert p["questId"] == 1001701, p
        steps.append("enter quest=%s birth=(%s,%s,%s)" % (p["questId"], p["x"], p["y"], p["z"]))

        talk = req(
            "POST",
            "/players/%s/quest/event" % pid,
            {"type": "talk_npc", "npcId": 201001001},
        )
        assert talk.get("ok") and talk.get("completedQuestId") == 1001701, talk
        assert talk["player"]["questId"] == 1001702, talk
        steps.append("talk done -> 1001702 exp=%s money=%s" % (talk["player"]["experience"], talk["player"]["money"]))

        gather = req(
            "POST",
            "/players/%s/quest/event" % pid,
            {"type": "gather", "gatherId": 180},
        )
        assert gather.get("ok") and gather.get("completedQuestId") == 1001702, gather
        assert gather["player"]["questId"] == 1001703, gather
        steps.append("gather done -> 1001703")

        for i in range(3):
            kill = req(
                "POST",
                "/players/%s/quest/event" % pid,
                {"type": "kill", "monsterId": 100101001, "targetHpAfter": max(0, 20 - i * 10)},
            )
            assert kill.get("ok"), kill
        assert kill.get("completedQuestId") == 1001703, kill
        steps.append("kill x3 done exp=%s money=%s" % (kill["player"]["experience"], kill["player"]["money"]))

        shop0 = req("GET", "/shop/items")
        put = req("PUT", "/shop/items", {"id": "potion_small", "price": 150})
        assert put.get("ok") and put["shop"]["version"] == shop0["version"] + 1, put
        steps.append("shop price potion_small=150 version=%s" % put["shop"]["version"])

        bot = req("POST", "/bots/start", {"worldId": wid, "chatLine": "smoke bot"})
        assert bot.get("ok"), bot
        chat = req("GET", "/chat?worldId=%s" % wid)
        assert any(m.get("isBot") for m in chat.get("messages", [])), chat
        req("POST", "/bots/stop-all", {"worldId": wid})
        steps.append("bot start/chat/stop ok")

        print("SMOKE OK")
        for s in steps:
            print(" -", s)
        return 0
    except Exception as e:
        print("SMOKE FAIL:", e)
        for s in steps:
            print(" -", s)
        return 1


if __name__ == "__main__":
    sys.exit(main())
