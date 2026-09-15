local gameStateLabel = {
    [-1] = "UNKNOWN",
    [0] = "GAMESTATE_NONE",
    [1] = "GAMESTATE_WAIT_CONNECT",
    [2] = "GAMESTATE_AWAIT_JOIN",
    [3] = "GAMESTATE_CONNECTED",
    [4] = "GAMESTATE_RESTARTING",
    [5] = "GAMESTATE_DISCONNECTED"
}
return function(page)
    local currentState = -1

    local gameStateFunc = Funcs:new(FuncType.NoAction, {
        label = "Статус игры (GameState)",
        options = {
            -- Funcs:new(FuncType.NoAction, {
            --     label = "Текущий статус: " .. gameStateLabel[currentState]
            -- })
        }
    })
    for i = 0, 5 do
        table.insert(gameStateFunc.options, Funcs:new(FuncType.Button, {
            label = gameStateLabel[i],
            text = "Установить",
            onClick = function()
                sampSetGamestate(i)
            end,
            isOption = true
        }))
    end
    return gameStateFunc
end