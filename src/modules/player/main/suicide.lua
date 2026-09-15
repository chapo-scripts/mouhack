---@param page Page
return function(page)
    return Funcs:new(FuncType.Button, {
        label = "Суицид",
        text = "Умереть",
        onClick = function()
            setCharHealth(PLAYER_PED, 0)
        end
    })
end