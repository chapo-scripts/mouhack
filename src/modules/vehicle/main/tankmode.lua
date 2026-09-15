local memory = require("memory")
return function(page)
    page.config.tankMode = imgui.new.bool(false)
    page.config.tankModeDrawIcon = imgui.new.bool(false)
    page:On("loop", function()
        if (isCharInAnyCar(PLAYER_PED)) then
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            memory.setint8(getCarPointer(veh) + 0x40 + 0x0, page.config.tankMode[0] and 7 or 2, true)

            if (page.config.tankModeDrawIcon[0]) then
                local x, y = convert3DCoordsToScreen(getCarCoordinates(veh))
                renderDrawPolygon(x, y, 22, 22, 4, 0, 0xFF000000)
                renderDrawPolygon(x, y, 20, 20, 4, 0, 0xFFffffff)
                renderDrawPolygon(x, y, 12, 12, 4, 0, 0xFF000000)
                renderDrawPolygon(x, y, 10, 10, 4, 0, 0xFFfff700)
            end
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "TankMode",
        description = "Устанавливает большую массу вашему т/с. Рекомендуется использовать вместе с GodMode",
        value = page.config.tankMode,
        options = {
            Funcs:new(FuncType.Toggle, {
                label = "Отображать индикатор",
                value = page.config.tankModeDrawIcon
            })
        }
    })
end