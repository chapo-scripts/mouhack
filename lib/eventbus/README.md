# EventBus

Pub/Sub шина событий для MoonLoader / LuaJIT. Изоляция каналов, приоритеты, отмена, once, wildcard, типизированные события.

## Установка

Скопируйте папку `eventbus` в `moonloader/lib/`.

```
moonloader/lib/eventbus/
├── init.lua        Точка входа
├── core.lua        Публичный API
├── channel.lua     Канал событий
├── event.lua       Объект события
└── errors.lua      Ошибки
```

## Зависимости

- MoonLoader (LuaJIT 2.1)
- `lua_thread.create` — опционально, для `emit_async`

## Быстрый старт

**main.lua:**

```lua
local eventbus = require("lib.eventbus")
local bus = eventbus.channel("my_script")

require("modules.anti_spam")
require("modules.logger")
require("modules.welcome")

-- Мост: samp.events -> eventbus
function onPlayerJoin(id, name)
    bus:emit("player_join", { id = id, name = name })
end
```

**modules/logger.lua:**

```lua
local bus = require("lib.eventbus").channel("my_script")

bus:on("player_join", function(ev)
    print("[LOG] " .. ev.data.name .. " joined (id=" .. ev.data.id .. ")")
end)
```

**modules/welcome.lua:**

```lua
local bus = require("lib.eventbus").channel("my_script")

bus:on("player_join", function(ev)
    sampAddChatMessage("Welcome, " .. ev.data.name .. "!", -1)
end)
```

Каждый модуль получает тот же канал через `channel("my_script")`, но ни один не импортирует другие. Можно добавить или убрать модуль, не трогая остальные.

EventBus не генерирует события сам — он маршрутизирует то, что поймано через `samp.events` или опубликовано через `bus:emit()`.

## API

### core

| Функция | Описание |
|---|---|
| `eventbus.channel(name)` | Создать или получить канал по имени |
| `eventbus.default()` | Получить глобальный канал `"default"` |
| `eventbus.channels()` | Список имён всех каналов |
| `eventbus.get(name)` | Получить канал по имени или `nil` |
| `eventbus.clear_all()` | Удалить все каналы |

### channel

| Метод | Описание |
|---|---|
| `bus:on(event, fn, opts?)` | Подписка. `opts.priority` (по умолч. 0), `opts.once` |
| `bus:once(event, fn, opts?)` | Одноразовая подписка |
| `bus:off(sub)` | Отписка по объекту подписки |
| `bus:off(event, sub_id)` | Отписка по имени события и ID |
| `bus:off_all(event?)` | Отписка всех. Без аргумента — очистка всех событий |
| `bus:emit(event, data?)` | Публикация. Возвращает таблицу результатов |
| `bus:emit_async(event, data?, callback?)` | Публикация в `lua_thread` |
| `bus:define(event, schema)` | Регистрация схемы для валидации |
| `bus:trace(bool)` | Включить/выключить трейсинг в консоль |
| `bus:stats()` | Статистика вызовов |
| `bus:list()` | Список всех подписок |
| `bus:clear()` | Полная очистка канала |

### event

| Метод / поле | Описание |
|---|---|
| `event.name` | Имя события |
| `event.data` | Данные события |
| `event.canceled` | Отменено ли |
| `event.results` | Таблица результатов всех обработчиков |
| `event.channel` | Имя канала |
| `event.priority` | Приоритет текущего обработчика |
| `event.index` | Порядковый номер текущего обработчика |
| `event:cancel()` | Отменить событие + остановить propagation |
| `event:stop_propagation()` | Остановить без отметки canceled |
| `event:set_result(value)` | Записать результат текущего обработчика |
| `event:get_result(index)` | Получить результат по индексу |
| `event:is_canceled()` | Проверка отмены |

## Примеры

### Приоритеты

```lua
local bus = eventbus.channel("combat")

-- Pre-hook: валидация (сработает первым)
bus:on("attack", function(ev)
    if ev.data.hp <= 0 then
        ev:cancel()
        print("Cannot attack: dead")
    end
end, { priority = -100 })

-- Основной обработчик
bus:on("attack", function(ev)
    ev:set_result(ev.data.damage)
    print("Dealt " .. ev.data.damage .. " damage")
end, { priority = 0 })

-- Post-hook: логирование
bus:on("attack", function(ev)
    if not ev.canceled then
        print("Attack done: " .. ev.results[2] .. " dmg")
    end
end, { priority = 100 })

bus:emit("attack", { hp = 50, damage = 35 })
-- Dealt 35 damage
-- Attack done: 35 dmg

bus:emit("attack", { hp = 0, damage = 35 })
-- Cannot attack: dead
```

### Once

```lua
local bus = eventbus.channel("net")

bus:once("connected", function(ev)
    print("Connected to " .. ev.data.ip)
end)

bus:emit("connected", { ip = "127.0.0.1" })  -- сработает
bus:emit("connected", { ip = "127.0.0.1" })  -- не сработает
```

### Wildcard

```lua
local bus = eventbus.channel("ui")

bus:on("*", function(ev)
    print(string.format("[%s] %s", ev.channel, ev.name))
end)

bus:emit("button_click", {})
-- [ui] button_click
bus:emit("window_close", {})
-- [ui] window_close
```

### Изоляция каналов

```lua
local bus_a = eventbus.channel("script_a")
local bus_b = eventbus.channel("script_b")

bus_a:on("init", function() print("A") end)
bus_b:on("init", function() print("B") end)

bus_a:emit("init", {})  -- A
bus_b:emit("init", {})  -- B
```

### Интеграция с samp.events

```lua
local bus = eventbus.channel("samp")

function onSendChat(message)
    local results = bus:emit("send_chat", { message = message })
    -- если обработчик отменил, вернём false
    for _, r in ipairs(results) do
        if r == false then return false end
    end
end

function onServerMessage(color, message)
    bus:emit("server_message", { color = color, message = message })
end

-- Модуль анти-спама
bus:on("send_chat", function(ev)
    if ev.data.message:len() > 200 then
        ev:cancel()
        ev:set_result(false)
    end
end, { priority = -100 })

-- Модуль логирования
bus:on("send_chat", function(ev)
    print("Chat: " .. ev.data.message)
end, { priority = 0 })
```

### Типизированные события

```lua
local bus = eventbus.channel("typed")

bus:define("player_damage", {
    required = { "attacker_id", "victim_id", "amount" },
    optional = { "weapon" },
    types = {
        attacker_id = "number",
        victim_id = "number",
        amount = "number",
        weapon = "string",
    }
})

local ok, err = bus:emit("player_damage", {
    attacker_id = 1,
    victim_id = 2,
    amount = 50,
    weapon = "ak47",
})
-- ok = results table

local ok, err = bus:emit("player_damage", {
    attacker_id = "abc",
    victim_id = 2,
    amount = 50,
})
-- ok = nil, err = VALIDATION_ERROR
```

### Async emit

```lua
local bus = eventbus.channel("async")

bus:on("fetch", function(ev)
    wait(2000)
    ev:set_result({ status = 200 })
end)

bus:emit_async("fetch", { url = "http://example.com" }, function(results)
    print("Done: " .. tostring(results[1].status))
end)
```

### Статистика и отладка

```lua
local bus = eventbus.channel("debug")
bus:trace(true)

bus:on("test", function(ev) ev:set_result(42) end)
bus:emit("test", {})

local stats = bus:stats()
-- {
--   total_emits = 1,
--   total_duration = 0.0001,
--   events = { test = { count = 1, avg_duration = 0.0001, ... } },
--   subscribers = 1
-- }

local subs = bus:list()
-- { { event = "test", id = 1, priority = 0, once = false, calls = 1 } }
```

## Структура

```
eventbus/
├── init.lua        -> core.lua
├── core.lua        Управление каналами
├── channel.lua     Логика шины (on/off/emit/define/trace/stats)
├── event.lua       Объект события (cancel/set_result/stop_propagation)
└── errors.lua      Типизированные ошибки, safe_call
```
