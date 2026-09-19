## События из SAMP.lua (samp.events)
Для обработки событий неоюходимо использовать переменную Events - экземпляр класса [EventBus](https://github.com/zetsense/EventBus)

Типы для всех событий находятся в `api/types/events.lua`

### Примеры:
```lua
Events:on("onServerMessage", function(color, text)
    print("Received message from server:", text)
end)

Events:on("onSendCommand", function(cmd)
    print("Command sent:", cmd)
end)
```