# Android toolchain for Unity 2017.4.30f1 baseline

Recorded on the Windows worker while preparing the baseline APK.

| Tool | Path / version |
|---|---|
| Unity | `C:\SOURCE\LunexUfa\Toolchain\Unity2017.4.30f1\Editor\Unity.exe` (2017.4.30f1) |
| Android Build Support | `...\PlaybackEngines\AndroidPlayer` present |
| JDK for Unity build | OpenJDK 8 from Unity 2018 Hub: `C:\Program Files\Unity\Hub\Editor\2018.4.12f1\Editor\Data\PlaybackEngines\AndroidPlayer\OpenJDK` |
| JDK for sdkmanager only | Microsoft JDK 17.0.21 (`C:\Program Files\Microsoft\jdk-17.0.21.102-hotspot`) — not for Unity 2017 builds |
| Android SDK | `C:\SOURCE\LunexUfa\Toolchain\AndroidSdk` |
| platform-tools | installed (`adb.exe` present) |
| platforms | `android-27` |
| build-tools | `28.0.3` |
| NDK | `16.1.4479499` |
| Project minSdk | 16 (`ProjectSettings.asset`) |
| Project targetSdk | 0 (Unity default) |
| Architectures (project) | `AndroidTargetArchitectures: 5` (ARMv7 + ARM64). Test APK script forces ARMv7 for first smoke build. |
| Test keystore | `Builds\Android\lunexufa-debug.keystore` (created by `Baseline\Build-Android-Apk.ps1`) |

## Reproducible commands

```powershell
# 1) Clean Android import (only if no Unity process and import failed)
powershell -File C:\SOURCE\LunexUfa\Baseline\Import-Android.ps1

# 2) Open four scenes under Android target
powershell -File C:\SOURCE\LunexUfa\Baseline\Inspect-Android-Scenes.ps1

# 3) Build baseline APK
powershell -File C:\SOURCE\LunexUfa\Baseline\Build-Android-Apk.ps1

# 4) Devices / install (when a device or emulator is attached)
C:\SOURCE\LunexUfa\Toolchain\AndroidSdk\platform-tools\adb.exe devices
C:\SOURCE\LunexUfa\Toolchain\AndroidSdk\platform-tools\adb.exe install -r C:\SOURCE\LunexUfa\Builds\Android\Darklord-Android-baseline.apk
```

## Launch / connect notes

- ADB currently reports no devices. Install/start on Android is **not confirmed** until a device or emulator appears.
- Before launching the baseline APK, check login/server endpoints in Lua (`PageServer`, `LoginModel`, `NetMgr`) and force a test world — do not use the production VPS.

## Client server list

- Common.ServerUrl in Baseline/Darklord-Android/Assets/Resources/Lua/Common.lua.txt is `http://127.0.0.1/ServerList.xml` (already localhost for formal channel mode).

