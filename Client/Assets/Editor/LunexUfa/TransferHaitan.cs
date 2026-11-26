using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using System.IO;
using System.Collections.Generic;

namespace LunexUfa.Client
{
    /// <summary>
    /// Copies Haitan scene closure from Baseline/Darklord-Android (or Darklord-Final) into this Client project.
    /// Batchmode: LunexUfa.Client.TransferHaitan.Run
    /// </summary>
    public static class TransferHaitan
    {
        private const string SceneRel = "Assets/Scene/allMap/cs_yw_haitan01/cs_yw_haitan01.unity";

        public static void Run()
        {
            string clientRoot = Path.GetFullPath(Path.Combine(Application.dataPath, ".."));
            string lunexRoot = Path.GetFullPath(Path.Combine(clientRoot, ".."));
            string baselineAssets = Path.Combine(lunexRoot, "Baseline", "Darklord-Android", "Assets");
            string darklordAssets = @"C:\SOURCE\Darklord-Final\Client\Assets";
            string sourceAssets = Directory.Exists(baselineAssets) ? baselineAssets : darklordAssets;
            string sourceProject = Path.GetDirectoryName(sourceAssets);

            Debug.Log("TRANSFER source=" + sourceProject);

            // Ensure scene exists in this project by copying dependency closure from source via AssetDatabase after linking.
            // Strategy: open source path list from a temporary copy of the scene tree already present,
            // or import by copying files with meta then Refresh.
            string srcScene = Path.Combine(sourceAssets, "Scene", "allMap", "cs_yw_haitan01", "cs_yw_haitan01.unity");
            if (!File.Exists(srcScene))
                throw new FileNotFoundException("Haitan scene not found", srcScene);

            CopyWithMeta(Path.Combine(sourceAssets, "Scene", "allMap", "cs_yw_haitan01"),
                Path.Combine(Application.dataPath, "Scene", "allMap", "cs_yw_haitan01"));

            AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);

            string[] deps = AssetDatabase.GetDependencies(SceneRel, true);
            var missing = new List<string>();
            var report = new List<string>();
            report.Add("TRANSFER scene=" + SceneRel + " deps=" + deps.Length);

            foreach (string dep in deps)
            {
                string absInClient = Path.Combine(clientRoot, dep.Replace('/', Path.DirectorySeparatorChar));
                if (File.Exists(absInClient))
                {
                    report.Add("HAVE " + dep);
                    continue;
                }

                string absInSource = Path.Combine(sourceProject, dep.Replace('/', Path.DirectorySeparatorChar));
                if (!File.Exists(absInSource))
                {
                    missing.Add(dep);
                    report.Add("MISSING_SOURCE " + dep);
                    continue;
                }

                string destDir = Path.GetDirectoryName(absInClient);
                Directory.CreateDirectory(destDir);
                File.Copy(absInSource, absInClient, true);
                string metaSrc = absInSource + ".meta";
                string metaDst = absInClient + ".meta";
                if (File.Exists(metaSrc))
                    File.Copy(metaSrc, metaDst, true);
                report.Add("COPIED " + dep);
            }

            // Dynamic data used by map 110200011
            string[] dynamicRels = new string[]
            {
                "Assets/Resources/Data/MapData/110200011.xml",
                "Assets/Resources/Lua/Data/t_map.lua.txt",
                "Assets/Scene/mapPlugin/HT1RsPlugin.prefab"
            };
            foreach (string rel in dynamicRels)
            {
                string absInClient = Path.Combine(clientRoot, rel.Replace('/', Path.DirectorySeparatorChar));
                if (File.Exists(absInClient))
                    continue;
                string absInSource = Path.Combine(sourceProject, rel.Replace('/', Path.DirectorySeparatorChar));
                if (!File.Exists(absInSource))
                {
                    missing.Add(rel);
                    report.Add("MISSING_DYNAMIC " + rel);
                    continue;
                }
                Directory.CreateDirectory(Path.GetDirectoryName(absInClient));
                File.Copy(absInSource, absInClient, true);
                if (File.Exists(absInSource + ".meta"))
                    File.Copy(absInSource + ".meta", absInClient + ".meta", true);
                report.Add("COPIED_DYNAMIC " + rel);
            }

            AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
            var scene = EditorSceneManager.OpenScene(SceneRel, OpenSceneMode.Single);
            int missingScripts = 0;
            foreach (GameObject root in scene.GetRootGameObjects())
            {
                foreach (Transform t in root.GetComponentsInChildren<Transform>(true))
                {
                    foreach (Component c in t.GetComponents<Component>())
                    {
                        if (c == null)
                        {
                            missingScripts++;
                            Debug.LogWarning("TRANSFER missing script on " + t.name);
                        }
                    }
                }
            }

            string reportPath = Path.Combine(lunexRoot, "Client", "Haitan-Transfer-Report.txt");
            report.Add("OPENED scene roots=" + scene.rootCount + " missingScripts=" + missingScripts);
            report.Add("MISSING_COUNT " + missing.Count);
            File.WriteAllLines(reportPath, report.ToArray());
            Debug.Log("TRANSFER report=" + reportPath + " missing=" + missing.Count);
            if (missing.Count > 0)
            {
                foreach (string m in missing)
                    Debug.LogWarning("TRANSFER unresolved " + m);
            }
        }

        private static void CopyWithMeta(string srcDir, string dstDir)
        {
            Directory.CreateDirectory(dstDir);
            foreach (string file in Directory.GetFiles(srcDir, "*", SearchOption.AllDirectories))
            {
                string rel = file.Substring(srcDir.Length).TrimStart('\\', '/');
                string dest = Path.Combine(dstDir, rel);
                Directory.CreateDirectory(Path.GetDirectoryName(dest));
                File.Copy(file, dest, true);
            }
        }
    }
}
