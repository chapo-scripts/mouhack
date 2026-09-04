local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Функции")

Page:AddItem(PageItemType.NoAction, {
    label = "Отключится от сервера",
    options = {
        Page:AddItem(PageItemType.Button, { label = "Выход (0)", text = "Отключиться", onClick = function() end }, true),
        Page:AddItem(PageItemType.Button, { label = "Кик/Бан (1)", text = "Отключиться", onClick = function() end }, true)
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