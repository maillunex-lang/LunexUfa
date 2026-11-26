using System.IO;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LunexUfa.Client
{
    /// <summary>
    /// Batchmode / -executeMethod helper: open Haitan map, add bootstrap, enter Play.
    /// </summary>
    public static class AutoPlayHaitanPrototype
    {
        const string ScenePath = "Assets/Scene/allMap/cs_yw_haitan01/cs_yw_haitan01.unity";
        const string Marker = "LunexUfa_HaitanPrototype";

        [MenuItem("LunexUfa/Haitan/Play Prototype Now")]
        public static void PlayNow()
        {
            if (!File.Exists(ScenePath))
            {
                Debug.LogError("Missing scene " + ScenePath);
                return;
            }
            EditorSceneManager.OpenScene(ScenePath);
            GameObject go = GameObject.Find(Marker);
            if (go == null)
                go = new GameObject(Marker);
            if (go.GetComponent<LunexUfa.Prototype.HaitanBootstrap>() == null)
                go.AddComponent<LunexUfa.Prototype.HaitanBootstrap>();
            EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            EditorApplication.isPlaying = true;
            Debug.Log("LunexUfa Haitan prototype Play started");
        }

        public static void BatchPlay()
        {
            PlayNow();
        }
    }
}
