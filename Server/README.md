# LunexUfa Server (локально на Windows)

Целевое развёртывание позже — Ubuntu VPS. Сейчас локальный прототип на Python 3 (stdlib).

## Запуск

```powershell
python C:\SOURCE\LunexUfa\Server\run_server.py
```

Слушает `http://127.0.0.1:8080`. Данные миров: `Server/data/`.

## API (кратко)

| Метод | Путь | Назначение |
|---|---|---|
| GET | `/health` | живость |
| GET/POST | `/worlds` | список / создать из шаблона |
| POST | `/worlds/{id}/enter` | вход игрока в мир |
| GET/POST | `/players/{id}/state` | прогресс (квест, exp, money, позиция) |
| POST | `/players/{id}/quest/event` | gather / kill / talk_npc |
| GET/PUT | `/shop/items` | каталог и цена |
| POST | `/bots/start` | запуск тестового бота в мире |
| GET | `/bots` | список ботов |
| POST | `/chat` | сообщение (игрок/бот) |
| GET | `/chat` | лента чата мира |

Правила квестов читаются из `Content/HaitanPrototypeQuests.json`.
