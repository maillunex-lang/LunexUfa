# Дорожная карта LunexUfa (лаборатория / эталон)

**27.11.2026 — продуктовый поворот:** целевой Android-клиент и APK ведутся в **`C:\LegacyOfEternity`** (репозиторий [LegacyOfEternity](https://github.com/maillunex-lang/LegacyOfEternity), Unity 6).  
Этот репозиторий (`C:\SOURCE\LunexUfa`) остаётся:

- эталоном Darklord / Unity 2017 и картой Haitan;
- локальным Server `:8080` + Admin `:8090` для прототипов API;
- складом Content/Baseline и материалов переноса.

Актуальная игровая дорожная карта: `C:\LegacyOfEternity\Docs\ROADMAP.md`.

## Что сюда больше не целимся

- Не собирать основной APK из `Client/` Unity 2017.
- Не развивать параллельный Android-клиент «вместо» LoE.

## Что ещё полезно здесь

- [x] Haitan 110200011, квесты 1001701–1001703, Server/Admin smoke.
- [x] Идеи вертикали login→hero→quest (перенесены в LoE как оффлайн `OfflineDemoStore`).
- [ ] По мере M06 LoE — сверять online API с `Server/run_server.py` или заменить Go-бэкендом LoE.

Подробный исторический статус прототипа 2017: `Baseline/STATUS.md`.
