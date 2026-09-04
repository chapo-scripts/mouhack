local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Машина")

local function flipCar()
    if (not isCharInAnyCar(PLAYER_PED)) then
        return
    end
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    setCarCoordinates(veh, getCarCoordinates(veh))
end

Page:AddItem(PageItemType.Button, {
    label = "Перевернуть транспорт",
    text = "Перевернуть",
    onClick = flipCar
})

Page.config.autoflip = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.autoflip,
    label = "Авто Флип",
    description = "Автоматически возвращает транспорт на колеса при переворотах",
    unsafe = Const.UNSAFE_ITEM_LABEL_PLAYERS
})

Page.config.visualGm = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.visualGm,
    label = "Визуальный GodMode",
    description = "Выключает визуальные повреждения транспорта"
})

Page.config.gm = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.gm,
    label = "GodMode",
    description = "Не позволяет транспорту терять уровень здоровья",
    unsafe = Const.UNSAFE_ITEM_LABEL_PLAYERS
})

Page.config.noFuckingProps = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noFuckingProps,
    label = "NoFuckingProps",
    description = "Разрушает разрушаемые объекты без вреда для транспорта. Автор: Cosmo",
})

Page.config.alwaysEngine = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.alwaysEngine,
    label = "Включить двигатель",
    description = "Принудительно включает двигатель (даже если в транспорте нет топлива или ключей)",
    unsafe = Const.UNSAFE_ITEM_LABEL_PLAYERS
})

Page:on("loop", function()

end)

return Page