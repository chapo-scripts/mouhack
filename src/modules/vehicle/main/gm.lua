return function(page)
    page.config.gm = imgui.new.bool(false)
    page:On("loop", function()
        if (isCharInAnyCar(PLAYER_PED)) then
            local gmState = page.config.gm[0]
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            setCarProofs(veh, gmState, gmState, gmState, gmState, gmState)
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "GodMode",
        description = "Не позволяет вашему транспорту терять здоровье",
        unsafe = Const.UNSAFE_ITEM_LABEL_PLAYERS,
        value = page.config.gm
    })
end