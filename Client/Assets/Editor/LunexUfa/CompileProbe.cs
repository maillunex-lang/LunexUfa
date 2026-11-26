using System.IO;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEngine;

namespace LunexUfa.Client
{
    /// <summary>
    /// Writes compile status for agent verification without relying on screenshots.
    /// </summary>
    public static class CompileProbe
    {
        const string OutPath = "Assets/../CompileStatus.txt";

        [DidReloadScripts]
        static void OnScriptsReloaded()
        {
            Write("ok scripts_reloaded " + System.DateTime.Now.ToString("o"));
            Debug.Log("LunexUfa CompileProbe: scripts reloaded OK");
        }

        [MenuItem("LunexUfa/Diagnostics/Write Compile Status")]
        public static void WriteNow()
        {
            Write("ok manual " + System.DateTime.Now.ToString("o"));
        }

        static void Write(string line)
        {
            try
            {
                File.WriteAllText(OutPath, line + "\n");
            }
            catch (System.Exception e)
            {
                Debug.LogWarning("CompileProbe write failed: " + e.Message);
            }
        }
    }
}
