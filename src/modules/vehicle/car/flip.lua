local function flip()
    if (not isCharInAnyCar(PLAYER_PED)) then
        return
    end
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    setCarCoordinates(veh, getCarCoordinates(veh))
end

return function(page)
    page.config.autoflip = imgui.new.bool(false)
    page:On("loop", function()
        if (page.config.autoflip[0] and isCharInAnyCar(PLAYER_PED)) then
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            local roll = getCarRoll(veh)
            if (roll > 110 and roll < 160) then
                flip()
            end
        end
    end)
    return Funcs:new(FuncType.Button, {
        label = "Перевернуть машину",
        onClick = flip,
        options = {
            Funcs:new(FuncType.Toggle, {
                label = "Автоматически переворачивать машину на колеса",
                value = page.config.autoflip,
                isOption = true
            })
        }
    })
end