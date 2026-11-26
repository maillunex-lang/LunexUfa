# Эталон Android

Рабочая копия: `Baseline\Darklord-Android`. Unity 2017.4.30f1 + Android Build Support в `Toolchain\Unity2017.4.30f1`.

## Статус

| Шаг | Статус | Доказательство |
|---|---|---|
| Копия эталона | сделано | `Baseline\Darklord-Android` |
| Чистый импорт Android | **успех** | `Baseline\Unity-Android-Import.log` — `Exiting batchmode successfully now!` |
| 4 сцены под Android | **успех** | `Baseline\Unity-Android-Scenes.log`, сводка `Baseline\Android-Scene-Results.txt` |
| Missing scripts RoleRsPlugin / GameDrawManager / HT1RsPlugin | **подтверждены и на Android** | совпадают с Windows64; GUID без исходников — `Baseline\MissingScripts-YAML-Notes.md` |
| Animator без controller | **подтверждены** | RoleUI 3/7; Haitan 14/14 (декор: лодки/статуи; часть Camera в RoleUI) |
| Play Mode (вместо APK) | **успех** | `Baseline\Android-Play-Results.txt`, скрин `artifacts\unity_loginui_play_now.png`, лог `Baseline\Unity-Android-Play.log` |
| APK | **пропущен по запросу** | проверка через Editor Play / RDP |
| ADB / устройство | нет устройств | запуск на Android-девайсе не подтверждён |
| Перенос Haitan в Client | **сцена + GUID-deps** | сцена `Client\Assets\Scene\allMap\cs_yw_haitan01\...`; отчёт `Client\Haitan-Dependency-Copy-Report.txt` (≈88 copied / 7 unmapped: builtins + known missing GameDrawManager) |
| Прототип Client overlay | **каркас** | `HaitanBootstrap` / `FollowCamera` / `PrototypeNetClient`; меню `LunexUfa/Haitan/*` |
| Локальный Server :8080 | **smoke OK** | `python Server\run_server.py`; `Baseline\Server-Admin-Smoke.txt` |
| Русская Admin :8090 | **smoke OK** | `python Admin\run_admin.py`; UI миры/магазин/боты/чат |

## Play Mode (проверено после разблокировки Windows)

- Редактор: Unity 2017.4.30f1, проект Darklord-Android, цель **Android**, сцена **LoginUI.unity**.
- Play активен: Game view — арт логина, «Версия Проверка», поля Логин=`default` / Пароль.
- Инициализация: `LuaInit` → `MapMgr.EnterLoginScene` → `CoreEntry` → `GameDBMgr` (XML загружен).
- Список серверов: `Common.ServerUrl = http://127.0.0.1/ServerList.xml` (`Assets\Resources\Lua\Common.lua.txt`).
- Unity оставлен запущенным для дальнейшей ручной/агентной проверки.

## Android scene inspect (сводка)

```
ThirdPartyUI: objects=9 missingScripts=0
LoginUI: objects=1 missingScripts=0
RoleUI: objects=69 missingScripts=1 (RoleRsPlugin) animators=7 withoutController=3
Haitan: objects=1558 missingScripts=2 (GameDrawManager, HT1RsPlugin) animators=14 withoutController=14
```

Совпадает с `Cached-Reference-Scene-Results.txt` (Windows64).

## Toolchain (на диске)

См. `Builds\Android\TOOLCHAIN.md`. SDK: `Toolchain\AndroidSdk` (platform-tools, android-27, build-tools 28.0.3, ndk 16.1). JDK8 для Unity: OpenJDK из Hub 2018.4.12f1. APK не собирался.

## Сценарий Haitan (данные)

Birth `(11, 50.02655, 58)`; Tias `201001001` `(16, 50.1, 44)`; 10×`100101001`; collect `180` для цели `180,1`; kill `100101001,3`. Цепочка квестов 1001701–1001703.

## Server / Admin smoke (локально)

```
SMOKE OK
 - health ok
 - enter quest=1001701 birth=(11,50.02655,58)
 - talk -> 1001702; gather -> 1001703; kill x3
 - shop price bump increments version
 - bot start/chat/stop ok
Admin UI http://127.0.0.1:8090 — 200
```

Клиентский Play поверх перенесённой сцены Haitan — следующий шаг (Unity сейчас занят Baseline LoginUI Play; меню `LunexUfa/Haitan/Open Map Scene` + `Add Prototype Bootstrap`).

## Client compile fix (����� Play Prototype)

��������� Darklord-������� � �������� �������������: `CameraFollow` / `CameraHeight` / `DeemoRadialBlur` (�������� ���������� `FollowCamera`).
������������ T4M: `T4MLodObjSC`, `T4MBillBObjSC`, `T4MPartSC`, `T4MPlantObjSC`.
`SceneDetailObject` ������ �� ��������� �� `Titan.CoreEntry` (`Camera.main`).
����� �������� Client ��������� ������ ���������� > ���� **LunexUfa > Haitan > Play Prototype Now**.
