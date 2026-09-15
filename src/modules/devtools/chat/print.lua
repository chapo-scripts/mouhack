local ev = require("samp.events")
---@param page Page
return function(page)
    page.config.logChat = { server = imgui.new.bool(false), outMsg = imgui.new.bool(true), outCmd = imgui.new.bool(true) }
    ev.onServerMessage = function(color, text)
        if (page.config.logChat.server[0]) then
            print(("[CHAT] \"%s\" [color:\"%s\"]"):format(text, color))
        end
    end
    ev.onSendChat = function(text)
        if (page.config.logChat.outMsg[0]) then
            print(("[CHAT] Sent message: \"%s\""):format(text))
        end
    end
    ev.onSendCommand = function(cmd)
        if (page.config.logChat.outCmd[0]) then
            print(("[CHAT] Sent command: \"%s\""):format(cmd))
        end
    end

    return Funcs:new(FuncType.NoAction, {
        label = "Выводить сообщения в консоль",
        options = {
            Funcs:new(FuncType.Toggle, { label = "Серверные сообщения", value = page.config.logChat.server, isOption = true }),
            Funcs:new(FuncType.Toggle, { label = "Отправляемые сообщения", value = page.config.logChat.outMsg, isOption = true }),
            Funcs:new(FuncType.Toggle, { label = "Отправляемые команды", value = page.config.logChat.outCmd, isOption = true }),
        }
    })
end