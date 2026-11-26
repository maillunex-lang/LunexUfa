# Эталон Android / статус прототипа

Рабочая копия эталона: `Baseline\Darklord-Android`. Unity: `Toolchain\Unity2017.4.30f1`. Клиент прототипа: `Client`.

## Сводка

| Шаг | Статус | Доказательство |
|---|---|---|
| Импорт Android эталона | успех | `Unity-Android-Import.log` |
| 4 сцены Android inspect | успех | `Android-Scene-Results.txt` |
| Play LoginUI (эталон) | успех | `Android-Play-Results.txt` |
| APK / ADB | пропуск / нет устройства | по запросу владельца |
| Haitan → Client | сцена + deps + шейдеры/текстуры | `Haitan-Dependency-Copy-Report.txt` |
| Server :8080 / Admin :8090 | smoke OK | `Server-Admin-Smoke.txt` |
| Client Play Prototype | **успех (владелец)** | HUD online, квест/магазин, карта видна |
| Client compile без Titan/XLua | **успех batchmode** | `Unity-Client-Compile-Check.log`, `Client/CompileStatus.txt` |
| Вертикальный вход (login→hero→map) | **следующее** | см. `CURSOR-TASK.md` / `ROADMAP.md` |

## Haitan Play (подтверждено)

- Меню `LunexUfa → Haitan → Play Prototype Now`.
- Online, квест/магазин; T/G/F/K; временный скин героя (`L_ZS_01`).
- Titan Actor scripts отключены (`.cs.disabled`) — не реактивировать без XLua.

## Следующая итерация

Вертикальный цикл: регистрация → логин → мир → герой → Haitan. Текст для Codex: `CODEX-HANDOFF.md`.
