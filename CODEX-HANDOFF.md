# Что сказать Codex (скопировать)

```
Рабочая папка: C:\SOURCE\LunexUfa на моём Windows.

Сначала прочитай ROADMAP.md и CURSOR-TASK.md. Не начинай заново Android-импорт эталона и inspect четырёх сцен — это уже закрыто.

Сделано: Haitan в Client, Play Prototype работает (меню LunexUfa → Haitan → Play Prototype Now), Server :8080 и Admin :8090, Titan/XLua Actor-скрипты в Client отключены (.cs.disabled) — не включай их. Компиляцию проверяй сам через Unity batchmode LunexUfa.Client.CompileProbe.WriteNow.

Следующая итерация — вертикальный вход, не новые локации:
1) Server: register/login, герои аккаунта, persistence на диск, сессия;
2) Client: минимальный UI регистрация → логин → список миров → создание/выбор героя → вход на cs_yw_haitan01 / HaitanBootstrap;
3) заменить временный скин L_ZS_01 на нормальный префаб класса;
4) smoke + Editor Play всего цикла; обновить ROADMAP.md и Baseline/STATUS.md.

Ограничения: Unity 2017 Path.Combine только 2 аргумента; APK не собирать пока не попрошу; не тащить полный Titan/XLua ради моделей.
```
