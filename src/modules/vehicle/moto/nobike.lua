return function(page)
    page.config.nobike = { enabled = imgui.new.bool(false), fallInWater = imgui.new.bool(true), fallOnVehicle = imgui.new.bool(true), fallOnPed = imgui.new.bool(true) }
    page:On("loop", function()
        if (isCharInAnyCar(PLAYER_PED)) then
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            setCharCanBeKnockedOffBike(PLAYER_PED, page.config.nobike.enabled[0] and (not page.config.nobike.fallInWater[0] or not isCarInWater(veh)))
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "NoBike",
        value = page.config.nobike.enabled,
        description = "Не позволяет персонажу падать при столкновениях (не работает в воде)",
        options = {
            Funcs:new(FuncType.Toggle, { value = page.config.nobike.fallInWater, label = "Падать в воде", isOption = true })
        }
    })
end