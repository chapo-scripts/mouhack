local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Основные")

local sampev = require('lib.samp.events')

Page.config.noLimit = imgui.new.bool(false)

function sampev.onSetVehicleVelocity()
    if (Page.config.noLimit[0]) then
        return false
    end
end

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noLimit,
    label = "Антиограничение скорости",
    description = "Не позволяет серверу менять скорость вашего т/с"
})

Page.config.noDoors = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noDoors,
    label = "NoDoors",
    description = "Удаляет двери со всех машин"
})

Page:on("loop", function()
    if (Page.config.noDoors[0]) then
        for _, handle in ipairs(getAllVehicles()) do
            popCarDoor(handle, 2)
            popCarDoor(handle, 3)
        end
    end
end)

return Page