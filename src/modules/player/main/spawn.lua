---@param page Page
return function(page)
    return Funcs:new(FuncType.Button, {
        label = "Заспавнится",
        text = "Спавн",
        onClick = function()
            sampSendSpawn()
        end
    })
end