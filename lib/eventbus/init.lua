---@class EventBusEvent
---@field name string Имя события
---@field data any Данные события
---@field canceled boolean	Отменено ли
---@field results any Таблица результатов всех обработчиков
---@field channel string	Имя канала
---@field priority number	Приоритет текущего обработчика
---@field index	number Порядковый номер текущего обработчика
---@field cancel fun()	Отменить событие + остановить propagation
---@field stop_propagation fun()	Остановить без отметки canceled
---@field set_result fun(value)	Записать результат текущего обработчика
---@field get_result fun(index)	Получить результат по индексу
---@field is_canceled fun()	Проверка отмены

---@class EventBusChannel
---@field on fun(self: EventBusChannel, event, fn, opts?)	Подписка. opts.priority (по умолч. 0), opts.once
---@field once fun(self: EventBusChannel, event, fn, opts?)	Одноразовая подписка
---@field off fun(self: EventBusChannel, sub)	Отписка по объекту подписки
---@field off fun(self: EventBusChannel, event: string, sub_id: number)	Отписка по имени события и ID
---@field off_all fun(self: EventBusChannel, event?: string)	Отписка всех. Без аргумента — очистка всех событий
---@field emit fun(self: EventBusChannel, event: string, data?: unknown) Post
---@field emit_async fun(self: EventBusChannel, event: string, data?, callback?)	Post to lua_thread
---@field define fun(self: EventBusChannel, event: string, schema)	Create validation schema
---@field trace fun(self: EventBusChannel, enabled: boolean) Toggle console trace
---@field stats fun(self: EventBusChannel, ) Call statistics
---@field list fun(self: EventBusChannel, ) Subscriptions list
---@field clear fun(self: EventBusChannel, ) Clear channel

---@class EventBus
---@field channel fun(name: string): EventBusChannel Create or find channel by name
---@field default fun(): EventBusChannel Get default channel "default"
---@field channels fun(): string[] Get all channels
---@field get fun(name: string): EventBusChannel? Get channel by name
---@field clear_all fun() Delete all channels

---@type EventBus
return require("eventbus.core")