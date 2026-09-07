local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Функции")

Page:AddItem(PageItemType.NoAction, {
    label = "Отключится от сервера",
    options = {
        Page:AddItem(PageItemType.Button, { label = "Выход (0)", text = "Отключиться", onClick = function() end }, true),
        Page:AddItem(PageItemType.Button, { label = "Кик/Бан (1)", text = "Отключиться", onClick = function() end }, true)
    }
})

Page:AddItem(PageItemType.NoAction, {
    label = "Подключиться к серверу",
    options = {
        Page:AddItem(PageItemType.Button,
        {
            label = "Выход (0)",
            text = "Отключиться",
            onClick = function() end,
            options = {
                Page:AddItem(PageItemType.Button,
                    {
                        label = "test",
                        text = "2",
                        onClick = function() end
                    }, true)
            }
        }, true)
    }
})

Page:AddItem(PageItemType.Button, { label = "Заспавнится", text = "Выполнить", onClick = function() sampSendSpawn() end })

Page.config.death = { playerId = imgui.new.char[16]("0"), reason = imgui.new.char[16]("0") }
Page:AddItem(PageItemType.Button, {
    label = "Отправить смерть от игрока",
    hint = "Отправить серверу информацию о смерти от рук игрока",
    text = "Выполнить",
    onClick = function()
        local playerId = tonumber(ffi.string(Page.config.death.playerId))
        local reason = tonumber(ffi.string(Page.config.death.reason))
        sampSendDeathByPlayer(playerId or 0, reason or 0)
    end,
    options = {
        Page:AddItem(PageItemType.Input, {
            label = "ID убийцы",
            value = Page.config.death.playerId,
            flags = imgui.InputTextFlags.CharsDecimal
        }, true),
        Page:AddItem(PageItemType.Input, {
            label = "ID оружия",
            value = Page.config.death.reason,
            flags = imgui.InputTextFlags.CharsDecimal
        }, true)
    }
})

-- Page:AddItem(PageItemType.Toggle, {
--     value = Page.config.airbrake.enabled,
--     label = "AirBrake",
--     unsafe = true,
--     options = {
--         Page:AddItem(PageItemType.NoAction, { label = "Скорость" }, true),
--         Page:AddItem(PageItemType.Toggle, { label = "Изменять скорость колесиком мыши", value = Page.config.airbrake.mouseWheelSpeedControl }, true)
--     }
-- })

return Page