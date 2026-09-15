return function(page)
    page.config.visualGm = imgui.new.bool(false)
    page:On("loop", function()
        if (page.config.visualGm[0] and isCharInAnyCar(PLAYER_PED)) then
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            for i = 0, 5 do fixCarDoor(veh, i) end
            for i = 0, 6 do fixCarPanel(veh, i) end
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "Визуальный GodMode",
        description = "Выключает визуальные повреждения вашего транспорта",
        value = page.config.visualGm
    })
end