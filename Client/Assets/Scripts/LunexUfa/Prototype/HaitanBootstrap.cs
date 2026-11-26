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
            FixBrokenMaterials();
            BuildSceneActors();
            StartCoroutine(BootNet());
        }

        /// <summary>
        /// Magenta/pink in Scene/Game = missing Darklord shaders. Force a visible fallback.
        /// </summary>
        static void FixBrokenMaterials()
        {
            Shader fallback = Shader.Find("Legacy Shaders/Diffuse");
            if (fallback == null)
                fallback = Shader.Find("Standard");
            if (fallback == null)
                return;
            Material ground = new Material(fallback);
            ground.color = new Color(0.35f, 0.45f, 0.28f);
            Renderer[] renderers = UnityEngine.Object.FindObjectsOfType<Renderer>();
            for (int i = 0; i < renderers.Length; i++)
            {
                Renderer r = renderers[i];
                if (r == null)
                    continue;
                Material mat = r.sharedMaterial;
                bool broken = mat == null || mat.shader == null
                    || mat.shader.name == "Hidden/InternalErrorShader"
                    || mat.shader.name.IndexOf("InternalError") >= 0;
                if (broken)
                    r.sharedMaterial = ground;
            }
            // Clear pink clear-color if no skybox
            Camera cam = Camera.main;
            if (cam != null)
            {
                cam.clearFlags = CameraClearFlags.SolidColor;
                cam.backgroundColor = new Color(0.45f, 0.65f, 0.9f);
            }
        }

        void BuildSceneActors()
        {
            if (_spawns == null)
            {
                _status = "no_spawns_json";
                return;
            }

            // Real Darklord Resources prefabs when present; colored capsules as fallback.
            hero = CreateActor(
                "Hero",
                "Animation/player/zhanshi/L_ZS_01/L_ZS_01_pre",
                new Color(0.2f, 0.7f, 1f),
                _spawns.heroBirth,
                1.0f);
            tias = CreateActor(
                "NPC_Tias_201001001",
                "Animation/npc/NPC_034/NPC_034_pre",
                new Color(0.2f, 1f, 0.4f),
                _spawns.npc,
                1.0f);
            tias.gameObject.AddComponent<NpcEditableMarker>().npcId = _spawns.npc.id;

            if (_spawns.gather != null)
                gather = CreateActor(
                    "Gather_180",
                    "Animation/collection/cs_caijiwu_wuqi",
                    new Color(1f, 0.85f, 0.2f),
                    _spawns.gather,
                    1.0f);

            monsters.Clear();
            if (_spawns.monsterSpawns != null)
            {
                for (int i = 0; i < _spawns.monsterSpawns.Length; i++)
                {
                    MonsterSpawn m = _spawns.monsterSpawns[i];
                    Transform t = CreateActor(
                        "Enemy_" + m.spawnIndex + "_" + m.id,
                        "Animation/monster/monster_111/monster_111_pre",
                        new Color(1f, 0.1f, 0.1f),
                        m,
                        1.0f);
                    EnemyMarker em = t.gameObject.AddComponent<EnemyMarker>();
                    em.monsterId = m.id;
                    em.hp = 10;
                    em.maxHp = 10;
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
            FixBrokenMaterials();
            _status = "actors_ready";
        }

        Transform CreateActor(string name, string resourcesPath, Color fallbackColor, SpawnVec spawn, float scale)
        {
            GameObject go = null;
            if (!string.IsNullOrEmpty(resourcesPath))
            {
                GameObject prefab = Resources.Load<GameObject>(resourcesPath);
                if (prefab != null)
                    go = UnityEngine.Object.Instantiate(prefab);
            }
            if (go == null)
            {
                go = GameObject.CreatePrimitive(PrimitiveType.Capsule);
                Renderer r = go.GetComponent<Renderer>();
                if (r != null)
                {
                    Shader sh = Shader.Find("Legacy Shaders/Diffuse");
                    if (sh == null)
                        sh = Shader.Find("Standard");
                    Material mat = new Material(sh);
                    mat.color = fallbackColor;
                    r.sharedMaterial = mat;
                }
            }
            go.name = name;
            go.transform.position = new Vector3(spawn.x, spawn.y, spawn.z);
            go.transform.rotation = Quaternion.Euler(0f, spawn.direction * Mathf.Rad2Deg, 0f);
            if (scale != 1f)
                go.transform.localScale = go.transform.localScale * scale;
            // Prefabs reference Titan/XLua scripts we deliberately exclude from Client compile.
            // Keep mesh/Animator only — strip every MonoBehaviour on instantiate.
            MonoBehaviour[] behaviours = go.GetComponentsInChildren<MonoBehaviour>(true);
            for (int i = 0; i < behaviours.Length; i++)
            {
                if (behaviours[i] != null)
                    UnityEngine.Object.Destroy(behaviours[i]);
            }
            return go.transform;
        }

        EnemyMarker FindNearestEnemy(out float dist)
        {
            EnemyMarker nearest = null;
            dist = 9999f;
            for (int i = 0; i < monsters.Count; i++)
            {
                if (monsters[i] == null || !monsters[i].gameObject.activeInHierarchy)
                    continue;
                EnemyMarker em = monsters[i].GetComponent<EnemyMarker>();
                if (em == null || em.hp <= 0)
                    continue;
                float d = Vector3.Distance(hero.position, monsters[i].position);
                if (d < dist)
                {
                    dist = d;
                    nearest = em;
                }
            }
            return nearest;
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

            // F = teleport onto nearest enemy (no map needed on pink/broken view)
            if (Input.GetKeyDown(KeyCode.F))
            {
                float d;
                EnemyMarker near = FindNearestEnemy(out d);
                if (near != null)
                    hero.position = near.transform.position + Vector3.up * 0.5f;
            }

            // Keys for quest proofing: T talk, G gather, K kill nearest (any distance)
            if (Input.GetKeyDown(KeyCode.T))
                StartCoroutine(net.SendQuestEvent("talk_npc", 201001001, 0, 0, 0));
            if (Input.GetKeyDown(KeyCode.G))
                StartCoroutine(net.SendQuestEvent("gather", 0, 180, 0, 0));
            if (Input.GetKeyDown(KeyCode.K))
            {
                float best;
                EnemyMarker nearest = FindNearestEnemy(out best);
                if (nearest != null)
                {
                    nearest.hp = 0;
                    StartCoroutine(net.SendQuestEvent("kill", 0, 0, nearest.monsterId, 0));
                    nearest.gameObject.SetActive(false);
                }
            }
        }

        void OnGUI()
        {
            GUILayout.BeginArea(new Rect(12, 12, 480, 200));
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
            float dist = 0f;
            EnemyMarker n = (hero != null) ? FindNearestEnemy(out dist) : null;
            if (n != null)
                GUILayout.Label("Ближайший враг: " + dist.ToString("0.0") + " м — жми F (телепорт) потом K");
            else
                GUILayout.Label("Живых врагов нет");
            GUILayout.Label("T разговор | G сбор | F к врагу | K убить | WASD ход");
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
