---@meta

---@class EventBusOptions
---@field priority? number

---@class EventBusSubscription
---@field id number
---@field fn function,
---@field priority number
---@field once boolean
---@field calls number
---@field event string

---@class EventBusEvent
---@field name string Event name
---@field data any Event data
---@field canceled boolean	Is cancelled
---@field results table Handlers results
---@field channel string	Имя канала
---@field priority number	Current handler priority
---@field index	number Current handler index
---@field cancel fun()	Cancel event and stop propagation
---@field stop_propagation fun()	Strop withour cancelling
---@field set_result fun(value: any)	Set current handler result
---@field get_result fun(index: number)	Get handler result by index
---@field is_canceled fun()	Проверка отмены

---@class EventBusChannel
---@field on fun(self: EventBusChannel, event, fn, opts?: EventBusOptions): EventBusSubscription	Подписка. opts.priority (по умолч. 0), opts.once
---@field once fun(self: EventBusChannel, event, fn, opts?: EventBusOptions): EventBusSubscription	Одноразовая подписка
---@field off fun(self: EventBusChannel, sub: EventBusSubscription)	Отписка по объекту подписки
---@field off fun(self: EventBusChannel, event: string, sub_id: number)	Отписка по имени события и ID
---@field off_all fun(self: EventBusChannel, event?: string)	Отписка всех. Без аргумента — очистка всех событий
---@field emit fun(self: EventBusChannel, event: string, data?: any) Post
---@field emit_async fun(self: EventBusChannel, event: string, data?: any, callback?: function)	Post to lua_thread
---@field define fun(self: EventBusChannel, event: string, schema: table)	Create validation schema
---@field trace fun(self: EventBusChannel, enabled: boolean) Toggle console trace
---@field stats fun(self: EventBusChannel) Call statistics
---@field list fun(self: EventBusChannel) Subscriptions list
---@field clear fun(self: EventBusChannel) Clear channel

---@class EventBus
---@field channel fun(name: string): EventBusChannel Create or find channel by name
---@field default fun(): EventBusChannel Get default channel "default"
---@field channels fun(): string[] Get all channels
---@field get fun(name: string): EventBusChannel? Get channel by name
---@field clear_all fun() Delete all channels