return function(page)
    return Funcs:new(FuncType.NoAction, {
        label = "Подключиться к серверу",
        options = {
            Funcs:new(FuncType.Button, {
                label = "Переподключится к текущему",
                text = "Подключиться",
                onClick = function() sampConnectToServer(sampGetCurrentServerAddress()) end,
                isOption = true
            }),
            Funcs:new(FuncType.NoAction, {
                label = "Сохраненные сервера:",
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "",
                text = "Редактировать список",
                onClick = function() sampConnectToServer(sampGetCurrentServerAddress()) end,
                isOption = true
            }),
        }
    })
end