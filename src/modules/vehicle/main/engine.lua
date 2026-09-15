return function(page)
    page.config.forceEngine = imgui.new.bool(false)
    page:On("loop", function()
        if (page.config.forceEngine[0] and isCharInAnyCar(PLAYER_PED)) then
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            setCarEngineOn(veh, true)
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "ForceEngine",
        description = "Принудительно включает двигатель в транспорте",
        unsage = true,
        value = page.config.forceEngine
    })
end