$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent
$Editor = Join-Path $Root 'Toolchain\Unity2017.4.30f1\Editor\Unity.exe'
$Project = Join-Path $PSScriptRoot 'Darklord-Android'
$OutDir = Join-Path $Root 'Builds\Android'
$Log = Join-Path $OutDir 'Unity-Android-Apk.log'
$Sdk = Join-Path $Root 'Toolchain\AndroidSdk'
$Jdk8 = 'C:\Program Files\Unity\Hub\Editor\2018.4.12f1\Editor\Data\PlaybackEngines\AndroidPlayer\OpenJDK'
$Ndk = Join-Path $Sdk 'ndk\16.1.4479499'
$Keystore = Join-Path $OutDir 'lunexufa-debug.keystore'
$BuildScript = Join-Path $Project 'Assets\Editor\LunexUfa\BuildBaselineApk.cs'

if (!(Test-Path -LiteralPath $Editor)) { throw "Unity missing: $Editor" }
if (!(Test-Path -LiteralPath $Sdk)) { throw "Android SDK missing: $Sdk" }
if (!(Test-Path -LiteralPath $Jdk8)) { throw "JDK8 missing: $Jdk8" }
if (Get-Process Unity -ErrorAction SilentlyContinue) {
    throw 'Unity is still running. Wait for import/inspect to finish.'
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $BuildScript) | Out-Null

if (!(Test-Path -LiteralPath $Keystore)) {
    $keytool = Join-Path $Jdk8 'bin\keytool.exe'
    & $keytool -genkeypair -v -keystore $Keystore -storepass lunexufa -alias lunexufa -keypass lunexufa -keyalg RSA -keysize 2048 -validity 10000 -dname 'CN=LunexUfa Debug,OU=Dev,O=Lunex,L=Ufa,C=RU'
}

@'
using UnityEditor;
using UnityEngine;
using System.IO;

namespace LunexUfa.Baseline
{
    public static class BuildBaselineApk
    {
        public static void Run()
        {
            if (EditorUserBuildSettings.activeBuildTarget != BuildTarget.Android)
                throw new System.InvalidOperationException("Expected Android build target.");

            // Unity 2017 / .NET 3.5: Path.Combine accepts only two arguments.
            string root = Path.GetFullPath(Path.Combine(Path.Combine(Path.Combine(Application.dataPath, ".."), ".."), ".."));
            string outDir = Path.Combine(Path.Combine(root, "Builds"), "Android");
            Directory.CreateDirectory(outDir);
            string apk = Path.Combine(outDir, "Darklord-Android-baseline.apk");

            string sdk = Path.Combine(Path.Combine(root, "Toolchain"), "AndroidSdk");
            string jdk = @"C:\Program Files\Unity\Hub\Editor\2018.4.12f1\Editor\Data\PlaybackEngines\AndroidPlayer\OpenJDK";
            string ndk = Path.Combine(Path.Combine(sdk, "ndk"), "16.1.4479499");
            string keystore = Path.Combine(outDir, "lunexufa-debug.keystore");

            EditorPrefs.SetString("AndroidSdkRoot", sdk);
            EditorPrefs.SetString("JdkPath", jdk);
            EditorPrefs.SetString("AndroidNdkRoot", ndk);

            PlayerSettings.Android.keystoreName = keystore;
            PlayerSettings.Android.keystorePass = "lunexufa";
            PlayerSettings.Android.keyaliasName = "lunexufa";
            PlayerSettings.Android.keyaliasPass = "lunexufa";
            PlayerSettings.applicationIdentifier = "com.lunexufa.darklord.baseline";
            PlayerSettings.bundleVersion = "0.0.1-baseline";
            PlayerSettings.Android.bundleVersionCode = 1;

            // Prefer ARMv7 for widest device coverage on 2017.4 test builds.
            PlayerSettings.Android.targetArchitectures = AndroidArchitecture.ARMv7;

            var scenes = EditorBuildSettings.scenes;
            var enabled = new System.Collections.Generic.List<string>();
            foreach (var s in scenes)
            {
                if (s.enabled) enabled.Add(s.path);
            }
            if (enabled.Count == 0)
            {
                enabled.Add("Assets/Scene/allMap/ui/ThirdPartyUI.unity");
                enabled.Add("Assets/Scene/allMap/ui/LoginUI.unity");
                enabled.Add("Assets/Scene/allMap/ui/RoleUI.unity");
            }

            Debug.Log("BASELINE_APK scenes=" + string.Join(",", enabled.ToArray()));
            Debug.Log("BASELINE_APK sdk=" + sdk + " jdk=" + jdk + " ndk=" + ndk);
            Debug.Log("BASELINE_APK out=" + apk);

            string err = BuildPipeline.BuildPlayer(enabled.ToArray(), apk, BuildTarget.Android, BuildOptions.None);
            if (!string.IsNullOrEmpty(err))
            {
                Debug.LogError("BASELINE_APK_FAILED " + err);
                throw new System.Exception(err);
            }
            Debug.Log("BASELINE_APK_OK " + apk);
        }
    }
}
'@ | Set-Content -LiteralPath $BuildScript -Encoding UTF8

$UnityArguments = @(
    '-batchmode', '-nographics', '-quit',
    '-buildTarget', 'Android',
    '-projectPath', $Project,
    '-logFile', $Log,
    '-executeMethod', 'LunexUfa.Baseline.BuildBaselineApk.Run'
)

Write-Output "Building APK. Log $Log"
Write-Output "SDK=$Sdk JDK8=$Jdk8 NDK=$Ndk"
$Process = Start-Process -FilePath $Editor -ArgumentList $UnityArguments -Wait -PassThru
Write-Output "Unity exit code $($Process.ExitCode)"
if (Test-Path (Join-Path $OutDir 'Darklord-Android-baseline.apk')) {
    Get-Item (Join-Path $OutDir 'Darklord-Android-baseline.apk') | Format-List FullName, Length, LastWriteTime
}
exit $Process.ExitCode
