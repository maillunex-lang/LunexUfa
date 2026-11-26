using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LunexUfa.Client
{
    public static class CreateHaitanPrototype
    {
        const string ScenePath = "Assets/Scene/allMap/cs_yw_haitan01/cs_yw_haitan01.unity";

        [MenuItem("LunexUfa/Haitan/Add Prototype Bootstrap To Open Scene")]
        public static void AddBootstrap()
        {
            GameObject go = GameObject.Find("LunexUfa_HaitanPrototype");
            if (go == null)
                go = new GameObject("LunexUfa_HaitanPrototype");
            if (go.GetComponent<LunexUfa.Prototype.HaitanBootstrap>() == null)
                go.AddComponent<LunexUfa.Prototype.HaitanBootstrap>();
            EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            Debug.Log("Added LunexUfa_HaitanPrototype bootstrap");
        }

        [MenuItem("LunexUfa/Haitan/Open Map Scene")]
        public static void OpenMap()
        {
            if (System.IO.File.Exists(ScenePath))
                EditorSceneManager.OpenScene(ScenePath);
            else
                Debug.LogError("Missing scene " + ScenePath);
        }
    }
}
