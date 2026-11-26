using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LunexUfa.Prototype
{
    [Serializable]
    public class SpawnVec
    {
        public float x;
        public float y;
        public float z;
        public float direction;
    }

    [Serializable]
    public class NpcSpawn : SpawnVec
    {
        public int id;
        public string name;
        public int spawnIndex;
        public int modelId;
        public bool editableInScene = true;
    }

    [Serializable]
    public class GatherSpawn : SpawnVec
    {
        public int id;
        public int spawnIndex;
        public int modelId;
    }

    [Serializable]
    public class MonsterSpawn : SpawnVec
    {
        public int id;
        public int spawnIndex;
        public int modelId;
    }

    [Serializable]
    public class CameraDefaults
    {
        public float distance = 5f;
        public float height = 10f;
        public float rotationAngle = 50f;
    }

    [Serializable]
    public class SpawnsDoc
    {
        public int mapId;
        public SpawnVec heroBirth;
        public CameraDefaults camera;
        public NpcSpawn npc;
        public GatherSpawn gather;
        public MonsterSpawn[] monsterSpawns;
    }

    /// <summary>
    /// Builds a playable Haitan prototype overlay: hero, editable Tias NPC, gather point, enemies.
    /// Place on an empty object in the transferred cs_yw_haitan01 scene (or a thin wrapper scene).
    /// </summary>
    public class HaitanBootstrap : MonoBehaviour
    {
        public string worldId = "world-haitan-1";
        public string playerName = "Герой1";
        public TextAsset spawnsJson;
        public PrototypeNetClient net;
        public FollowCamera followCamera;

        public Transform hero;
        public Transform tias;
        public Transform gather;
        public readonly List<Transform> monsters = new List<Transform>();

        SpawnsDoc _spawns;
        string _status = "init";

        void Awake()
        {
            if (net == null)
                net = gameObject.AddComponent<PrototypeNetClient>();
            if (spawnsJson == null)
                spawnsJson = Resources.Load<TextAsset>("HaitanPrototypeSpawns");
            if (spawnsJson != null)
                _spawns = JsonUtility.FromJson<SpawnsDoc>(spawnsJson.text);
            BuildSceneActors();
            StartCoroutine(BootNet());
        }

        void BuildSceneActors()
        {
            if (_spawns == null)
            {
                _status = "no_spawns_json";
                return;
            }

            hero = CreateMarker("Hero", new Color(0.2f, 0.7f, 1f), _spawns.heroBirth, 1.0f);
            tias = CreateMarker("NPC_Tias_201001001", new Color(0.2f, 1f, 0.4f), _spawns.npc, 1.2f);
            // Editable in scene: keep as regular transform the designer can move.
            tias.gameObject.AddComponent<NpcEditableMarker>().npcId = _spawns.npc.id;

            if (_spawns.gather != null)
                gather = CreateMarker("Gather_180", new Color(1f, 0.85f, 0.2f), _spawns.gather, 0.7f);

            monsters.Clear();
            if (_spawns.monsterSpawns != null)
            {
                for (int i = 0; i < _spawns.monsterSpawns.Length; i++)
                {
                    MonsterSpawn m = _spawns.monsterSpawns[i];
                    Transform t = CreateMarker("Enemy_" + m.spawnIndex + "_" + m.id, new Color(1f, 0.25f, 0.25f), m, 0.9f);
                    EnemyMarker em = t.gameObject.AddComponent<EnemyMarker>();
                    em.monsterId = m.id;
                    em.hp = 30;
                    em.maxHp = 30;
                    monsters.Add(t);
                }
            }

            if (followCamera == null)
            {
                Camera cam = Camera.main;
                if (cam == null)
                {
                    GameObject go = new GameObject("PrototypeCamera");
                    cam = go.AddComponent<Camera>();
                    go.tag = "MainCamera";
                }
                followCamera = cam.gameObject.GetComponent<FollowCamera>();
                if (followCamera == null)
                    followCamera = cam.gameObject.AddComponent<FollowCamera>();
            }
            followCamera.target = hero;
            if (_spawns.camera != null)
            {
                followCamera.distance = _spawns.camera.distance;
                followCamera.height = _spawns.camera.height;
                followCamera.rotationAngle = _spawns.camera.rotationAngle;
            }
            _status = "actors_ready";
        }

        Transform CreateMarker(string name, Color color, SpawnVec spawn, float scale)
        {
            GameObject go = GameObject.CreatePrimitive(PrimitiveType.Capsule);
            go.name = name;
            go.transform.position = new Vector3(spawn.x, spawn.y, spawn.z);
            go.transform.rotation = Quaternion.Euler(0f, spawn.direction * Mathf.Rad2Deg, 0f);
            go.transform.localScale = Vector3.one * scale;
            Renderer r = go.GetComponent<Renderer>();
            if (r != null)
                r.sharedMaterial = new Material(Shader.Find("Standard")) { color = color };
            return go.transform;
        }

        IEnumerator BootNet()
        {
            yield return net.EnterWorld(worldId, playerName);
            if (net.player != null)
            {
                _status = "online quest=" + net.player.questId;
                hero.position = new Vector3(net.player.x, net.player.y, net.player.z);
            }
            else
                _status = "offline: " + net.lastError;
            yield return net.RefreshShopVersion();
        }

        void Update()
        {
            if (hero == null)
                return;
            float h = Input.GetAxis("Horizontal");
            float v = Input.GetAxis("Vertical");
            if (Mathf.Abs(h) > 0.01f || Mathf.Abs(v) > 0.01f)
            {
                Vector3 delta = new Vector3(h, 0f, v) * Time.deltaTime * 6f;
                hero.position += delta;
            }

            // Keys for quest proofing: T talk, G gather, K kill nearest
            if (Input.GetKeyDown(KeyCode.T))
                StartCoroutine(net.SendQuestEvent("talk_npc", 201001001, 0, 0, 0));
            if (Input.GetKeyDown(KeyCode.G))
                StartCoroutine(net.SendQuestEvent("gather", 0, 180, 0, 0));
            if (Input.GetKeyDown(KeyCode.K))
            {
                EnemyMarker nearest = null;
                float best = 999f;
                for (int i = 0; i < monsters.Count; i++)
                {
                    if (monsters[i] == null)
                        continue;
                    EnemyMarker em = monsters[i].GetComponent<EnemyMarker>();
                    if (em == null || em.hp <= 0)
                        continue;
                    float d = Vector3.Distance(hero.position, monsters[i].position);
                    if (d < best)
                    {
                        best = d;
                        nearest = em;
                    }
                }
                if (nearest != null && best < 8f)
                {
                    nearest.hp = Mathf.Max(0, nearest.hp - 10);
                    StartCoroutine(net.SendQuestEvent("kill", 0, 0, nearest.monsterId, nearest.hp));
                    if (nearest.hp <= 0)
                        nearest.gameObject.SetActive(false);
                }
            }
        }

        void OnGUI()
        {
            GUILayout.BeginArea(new Rect(12, 12, 420, 160));
            GUILayout.Box("LunexUfa Haitan prototype");
            GUILayout.Label(_status);
            if (net != null && net.player != null)
            {
                GUILayout.Label("HP " + net.player.hp + "/" + net.player.maxHp
                    + "  EXP " + net.player.experience
                    + "  $" + net.player.money);
                GUILayout.Label("Квест " + net.player.questId
                    + "  прогресс " + net.player.questProgress + "/" + net.player.questGoalCount);
                GUILayout.Label("Магазин version=" + net.shopVersion);
            }
            GUILayout.Label("WASD ход | T разговор с Tias | G сбор 180 | K удар");
            GUILayout.EndArea();
        }
    }

    public class NpcEditableMarker : MonoBehaviour
    {
        public int npcId;
    }

    public class EnemyMarker : MonoBehaviour
    {
        public int monsterId;
        public int hp = 30;
        public int maxHp = 30;
    }
}
