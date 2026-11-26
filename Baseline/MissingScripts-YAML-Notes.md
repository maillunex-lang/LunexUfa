# Missing scripts and Animators — YAML/code check (before Android scene open)

Verified against disk assets without reopening Unity. Android editor inspection still pending (`Unity-Android-Scenes.log`).

## RoleRsPlugin

- Prefab: `Baseline/Darklord-Android/Assets/Scene/mapPlugin/RoleRsPlugin.prefab`
- Prefab GUID: `563a11968e07b6f4d9dcf9deac6a0dad`
- Instantiated in `RoleUI.unity`
- MonoScript GUID on prefab: `4d98c549ffc3a50408079700bc754325`
- Matching `.cs` / `.meta` / `.dll.meta`: **not found** in Baseline or `Darklord-Final/Client/Assets`
- Decision: treat as **permanently missing source** in the shipped tree; scene open will keep reporting missing script. Do not invent a replacement without owner approval.

## HT1RsPlugin

- Prefab: `Baseline/Darklord-Android/Assets/Scene/mapPlugin/HT1RsPlugin.prefab`
- Prefab GUID: `9dfcc151204a1014ab13f4d671cb3a81`
- Instantiated in `cs_yw_haitan01.unity`
- MonoScript GUID: `06499db5a8fde4a48b7d6fbc1567faab`
- Matching source: **not found**
- Decision: same as RoleRsPlugin — missing in original assets.

## GameDrawManager

- Root object in `cs_yw_haitan01.unity` (~line 65405)
- MonoBehaviour script ref: `fileID: 1074409957, guid: c8ec32a81b1c30145acc9c42b292b2bb`
- Matching `.cs` / `.meta`: **not found**
- Decision: missing binding in original tree; confirm again under Android via `InspectBaselineScenes`.

## Animator controllers

- `RoleUI.unity` YAML: 2 Animators with `m_Controller: {fileID: 0}` (one is inactive `Camera`), 4 with assigned controllers.
- Cached Windows64 inspect reported 3/7 without controller and 14/14 on Haitan — Haitan null controllers are likely on **prefab instances** expanded only when the scene is opened in the editor.
- Runtime assignment of controllers: no `RsPlugin` / `GameDrawManager` / `runtimeAnimatorController` hits under `Assets/Scripts` for these names. Confirm at Android scene open whether controllers stay null or are filled by loaders.

## Windows64 reference (already done)

See `Baseline/Cached-Reference-Scene-Results.txt`.
