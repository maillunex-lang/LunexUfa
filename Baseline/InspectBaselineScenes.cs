using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System.IO;
using System.Text;

namespace LunexUfa.Baseline
{
    /// <summary>
    /// Batchmode entry: LunexUfa.Baseline.InspectBaselineScenes.Run
    /// Expects active build target Android. Writes Unity-Android-Scenes.log via -logFile.
    /// </summary>
    public static class InspectBaselineScenes
    {
        private static readonly string[] ScenePaths =
        {
            "Assets/Scene/allMap/ui/ThirdPartyUI.unity",
            "Assets/Scene/allMap/ui/LoginUI.unity",
            "Assets/Scene/allMap/ui/RoleUI.unity",
            "Assets/Scene/allMap/cs_yw_haitan01/cs_yw_haitan01.unity"
        };

        private static readonly string[] WatchedObjects =
        {
            "RoleRsPlugin",
            "GameDrawManager",
            "HT1RsPlugin"
        };

        public static void Run()
        {
            if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.Android)
                throw new System.InvalidOperationException("Expected Android as active build target.");

            Debug.LogFormat("ANDROID_INSPECT begin target={0} version={1}",
                EditorUserBuildSettings.activeBuildTarget, Application.unityVersion);

            foreach (string path in ScenePaths)
            {
                var scene = EditorSceneManager.OpenScene(path, OpenSceneMode.Single);
                int objectCount = 0;
                int missingScripts = 0;
                int missingShaders = 0;
                int animators = 0;
                int animatorsWithoutController = 0;

                foreach (GameObject root in scene.GetRootGameObjects())
                {
                    foreach (Transform transform in root.GetComponentsInChildren<Transform>(true))
                    {
                        objectCount++;
                        string hierarchy = HierarchyPath(transform);
                        bool watched = IsWatched(transform.name);

                        MonoBehaviour[] behaviours = transform.GetComponents<MonoBehaviour>();
                        Component[] components = transform.GetComponents<Component>();
                        for (int i = 0; i < components.Length; i++)
                        {
                            if (components[i] == null)
                            {
                                missingScripts++;
                                Debug.LogWarning("Missing script: " + hierarchy);
                                if (watched)
                                    Debug.LogWarning("WATCHED_MISSING_SCRIPT object=" + hierarchy);
                            }
                        }

                        if (watched)
                        {
                            Debug.LogFormat("WATCHED_OBJECT scene={0} path={1} components={2} monoBehaviours={3}",
                                path, hierarchy, components.Length, behaviours.Length);
                            foreach (MonoBehaviour behaviour in behaviours)
                            {
                                if (behaviour == null)
                                    continue;
                                MonoScript script = MonoScript.FromMonoBehaviour(behaviour);
                                string scriptName = script != null ? script.name : "(null-script)";
                                string assetPath = script != null ? AssetDatabase.GetAssetPath(script) : "";
                                Debug.LogFormat("WATCHED_SCRIPT object={0} type={1} monoScript={2} asset={3}",
                                    hierarchy, behaviour.GetType().FullName, scriptName, assetPath);
                            }
                        }
                    }

                    foreach (Renderer renderer in root.GetComponentsInChildren<Renderer>(true))
                    {
                        foreach (Material material in renderer.sharedMaterials)
                        {
                            if (material != null && (material.shader == null || material.shader.name == "Hidden/InternalErrorShader"))
                            {
                                missingShaders++;
                                Debug.LogWarning("Missing shader: " + material.name + " on " + HierarchyPath(renderer.transform));
                            }
                        }
                    }

                    foreach (Animator animator in root.GetComponentsInChildren<Animator>(true))
                    {
                        animators++;
                        if (animator.runtimeAnimatorController == null)
                        {
                            animatorsWithoutController++;
                            Debug.LogWarning("Animator without controller: " + HierarchyPath(animator.transform));
                        }
                        else
                        {
                            string controllerPath = AssetDatabase.GetAssetPath(animator.runtimeAnimatorController);
                            Debug.LogFormat("Animator controller assigned: {0} -> {1}",
                                HierarchyPath(animator.transform), controllerPath);
                        }
                    }
                }

                Debug.LogFormat("BASELINE scene={0} objects={1} missingScripts={2} missingShaders={3} animators={4} animatorsWithoutController={5}",
                    path, objectCount, missingScripts, missingShaders, animators, animatorsWithoutController);
            }

            Debug.Log("ANDROID_INSPECT end");
        }

        private static bool IsWatched(string name)
        {
            for (int i = 0; i < WatchedObjects.Length; i++)
            {
                if (name == WatchedObjects[i])
                    return true;
            }
            return false;
        }

        private static string HierarchyPath(Transform transform)
        {
            string path = transform.name;
            while (transform.parent != null)
            {
                transform = transform.parent;
                path = transform.name + "/" + path;
            }
            return path;
        }
    }
}
