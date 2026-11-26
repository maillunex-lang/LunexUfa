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
| Перенос Haitan в Client | каркас | `Client\ProjectSettings\ProjectVersion.txt`, `Client\Assets\Editor\LunexUfa\TransferHaitan.cs` |

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
