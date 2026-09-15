local memory = require("memory")
return function(page)
    page.config.rideOnWater = imgui.new.bool(false)
    page:On("loop", function()
        if (isCharInAnyCar(PLAYER_PED)) then
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            memory.write(9867602, page.config.rideOnWater[0] and 1 or 0, 4)
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "Езда по воде",
        description = "Позволяет вашему т/с ездить по воде",
        unsafe = Const.UNSAFE_ITEM_LABEL_PLAYERS,
        value = page.config.rideOnWater
    })
end