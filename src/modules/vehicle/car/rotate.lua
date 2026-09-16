local function rotateCar(direction)
    if (not isCharInAnyCar(PLAYER_PED)) then
        return
    end
    local veh = storeCarCharIsInNoSave(PLAYER_PED)
    setCarHeading(veh, getCarHeading(veh) + direction)
end

return function()
    return Funcs:new(FuncType.NoAction, {
        label = "Повернуть машину",
        options = {
            Funcs:new(FuncType.Button, { label = "Назад", width = 150, onClick = function() rotateCar(180) end, isOption = true }),
            Funcs:new(FuncType.Button, { label = "Влево", width = 150, onClick = function() rotateCar(90) end, isOption = true }),
            Funcs:new(FuncType.Button, { label = "Вправо", width = 150, onClick = function() rotateCar(-90) end, isOption = true })
        }
    })
end