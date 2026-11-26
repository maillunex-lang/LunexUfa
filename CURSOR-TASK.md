# Задание для агента — LunexUfa (следующая итерация)

Рабочая папка: `C:\SOURCE\LunexUfa`. Сначала прочитай `ROADMAP.md` и `Baseline/STATUS.md`. Клиент — Android; проверки — Windows Editor Play / RDP. APK не собирай, пока владелец не попросит. Не начинай импорт эталона и сценовой inspect заново — это уже закрыто.

## Пути

| Путь | Назначение |
|---|---|
| `Baseline/Darklord-Android` | Эталон Unity (LoginUI / RoleUI / Haitan уже проверены) |
| `Client` | Unity-проект прототипа LunexUfa (открывать этот, не Baseline) |
| `Server/run_server.py` | Локальный API `:8080` |
| `Admin/` | Русская админка `:8090` |
| `Content/HaitanPrototype*.json` | Спавны и квесты Haitan |
| `Toolchain/Unity2017.4.30f1/Editor/Unity.exe` | Редактор |
| `C:\SOURCE\Darklord-Final` | Исходный снимок (LoginUI/RoleUI/Lua) — только чтение/копирование с `.meta` |

## Уже сделано (не повторять)

- Android baseline import + 4 scenes + LoginUI Play.
- Haitan в Client, шейдеры/текстуры, Play Prototype (`LunexUfa → Haitan → Play Prototype Now`).
- Server/Admin smoke; Titan/XLua Actor-скрипты в Client отключены (`.cs.disabled`) — **не включать** без полного порта XLua.
- Компиляция Client: batchmode `LunexUfa.Client.CompileProbe.WriteNow` → `Client/CompileStatus.txt`, лог `Baseline/Unity-Client-Compile-Check.log`.

## Сделай сейчас — вертикальный вход

Цель итерации: **регистрация → логин → список миров/серверов → создание/выбор героя → вход на Haitan** на локальном Server, без полного порта Darklord Lua.

1. Расширь `Server/run_server.py`: аккаунты (register/login), список миров уже есть; привязка героя к аккаунту; persistence на диск (`Server/data/`); после логина выдать token/session id.
2. В Client добавь минимальный UI входа (OnGUI или отдельная сцена) до Haitan: регистрация, логин, выбор мира из `GET /worlds`, создание/выбор героя (имя + класс). Не тяни весь Titan/XLua.
3. После выбора героя загружай `cs_yw_haitan01` + существующий `HaitanBootstrap` / меню Play Prototype; герой на сервере = выбранный, не анонимный `Герой1`.
4. Замени временный скин `L_ZS_01` на нормальный префаб класса из эталона (например `zhanshi`/`cike`/`fashi` по выбору), сохрани fallback-капсулу.
5. Smoke: `python Server/smoke_test.py` (дополни сценарием login→hero→enter) + Editor Play цикл входа → Haitan → T/G/K. Компиляцию проверь сам batchmode/`CompileProbe`, не через владельца.
6. Обнови `ROADMAP.md` и `Baseline/STATUS.md` с путями к доказательствам.

## Ограничения

- Unity 2017 / .NET 3.5: `Path.Combine` только с 2 аргументами.
- Не копируй Titan Actor / XLua скрипты в Client «для моделей» — только меши/prefab/материалы/анимации; поведения стрипай как в `HaitanBootstrap.CreateActor`.
- Не убивай процессы по имени; Unity batchmode — при закрытом редакторе того же проекта.
- Владелец смотрит монитор: длинный GUI-клик через агента не нужен — дай короткие шаги Play после своей проверки.

## Приёмка этой итерации

Один проход в Editor: новый аккаунт → логин → выбор мира → создание героя → Haitan online → квест 1001701–1001703. Прогресс героя виден после перезапуска Server+клиента. В STATUS — лог smoke и краткий Play-отчёт.
