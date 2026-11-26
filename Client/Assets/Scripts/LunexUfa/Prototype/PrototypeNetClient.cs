using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

namespace LunexUfa.Prototype
{
    [Serializable]
    public class ServerPlayer
    {
        public string id;
        public string name;
        public string worldId;
        public int mapId;
        public float x;
        public float y;
        public float z;
        public float direction;
        public int experience;
        public int money;
        public int hp;
        public int maxHp;
        public int questId;
        public int questProgress;
        public int questGoalCount;
    }

    [Serializable]
    public class EnterResponse
    {
        public bool ok;
        public ServerPlayer player;
    }

    [Serializable]
    public class QuestEventResponse
    {
        public bool ok;
        public string error;
        public ServerPlayer player;
        public int completedQuestId;
    }

    [Serializable]
    public class ShopResponse
    {
        public int version;
    }

    /// <summary>
    /// Minimal HTTP client to local LunexUfa server (Unity WWW / UnityWebRequest-compatible via WWW for 2017).
    /// </summary>
    public class PrototypeNetClient : MonoBehaviour
    {
        public string baseUrl = "http://127.0.0.1:8080";
        public ServerPlayer player;
        public int shopVersion;
        public string lastError;

        public IEnumerator EnterWorld(string worldId, string name)
        {
            string url = baseUrl + "/worlds/" + worldId + "/enter";
            byte[] body = Encoding.UTF8.GetBytes("{\"name\":\"" + name + "\"}");
            Dictionary<string, string> headers = new Dictionary<string, string>();
            headers["Content-Type"] = "application/json";
            using (WWW www = new WWW(url, body, headers))
            {
                yield return www;
                if (!string.IsNullOrEmpty(www.error))
                {
                    lastError = www.error;
                    yield break;
                }
                EnterResponse resp = JsonUtility.FromJson<EnterResponse>(www.text);
                if (resp != null && resp.ok)
                    player = resp.player;
                else
                    lastError = www.text;
            }
        }

        public IEnumerator SendQuestEvent(string type, int npcId, int gatherId, int monsterId, int targetHpAfter)
        {
            if (player == null)
                yield break;
            string url = baseUrl + "/players/" + player.id + "/quest/event";
            string json = "{"
                + "\"type\":\"" + type + "\","
                + "\"npcId\":" + npcId + ","
                + "\"gatherId\":" + gatherId + ","
                + "\"monsterId\":" + monsterId + ","
                + "\"targetHpAfter\":" + targetHpAfter
                + "}";
            byte[] body = Encoding.UTF8.GetBytes(json);
            Dictionary<string, string> headers = new Dictionary<string, string>();
            headers["Content-Type"] = "application/json";
            using (WWW www = new WWW(url, body, headers))
            {
                yield return www;
                if (!string.IsNullOrEmpty(www.error))
                {
                    lastError = www.error;
                    yield break;
                }
                QuestEventResponse resp = JsonUtility.FromJson<QuestEventResponse>(www.text);
                if (resp != null && resp.ok && resp.player != null)
                    player = resp.player;
                else if (resp != null)
                    lastError = resp.error;
            }
        }

        public IEnumerator RefreshShopVersion()
        {
            using (WWW www = new WWW(baseUrl + "/shop/items"))
            {
                yield return www;
                if (string.IsNullOrEmpty(www.error))
                {
                    // crude parse of version field
                    int idx = www.text.IndexOf("\"version\"");
                    if (idx >= 0)
                    {
                        string tail = www.text.Substring(idx);
                        int colon = tail.IndexOf(':');
                        int comma = tail.IndexOfAny(new char[] { ',', '}' }, colon);
                        if (colon > 0 && comma > colon)
                        {
                            int v;
                            if (int.TryParse(tail.Substring(colon + 1, comma - colon - 1).Trim(), out v))
                                shopVersion = v;
                        }
                    }
                }
            }
        }

        public IEnumerator PostChat(string text)
        {
            if (player == null)
                yield break;
            string url = baseUrl + "/chat";
            string json = "{\"worldId\":\"" + player.worldId + "\",\"from\":\"" + player.name
                + "\",\"fromId\":\"" + player.id + "\",\"text\":\"" + text + "\"}";
            byte[] body = Encoding.UTF8.GetBytes(json);
            Dictionary<string, string> headers = new Dictionary<string, string>();
            headers["Content-Type"] = "application/json";
            using (WWW www = new WWW(url, body, headers))
                yield return www;
        }
    }
}
