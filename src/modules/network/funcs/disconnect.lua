return function(page)
    return Funcs:new(FuncType.NoAction, {
        label = "Отключиться от сервера",
        options = {
            Funcs:new(FuncType.Button, {
                label = "Выход (0)",
                text = "Отключиться",
                onClick = function() sampDisconnectWithReason(0) end,
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "Кик / бан (1)",
                text = "Отключиться",
                onClick = function() sampDisconnectWithReason(1) end,
                isOption = true
            })
        }
    })
end