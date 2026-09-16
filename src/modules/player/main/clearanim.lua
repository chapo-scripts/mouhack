return function(page)
    page.config.unfreeze = imgui.new.bool(true)
    return Funcs:new(FuncType.Button, {
        label = "Сбив анимации",
        text = "Сбить",
        onClick = function()
            clearCharTasksImmediately(PLAYER_PED)
            if (page.config.unfreeze[0]) then
                local bs = raknetNewBitStream()
                raknetBitStreamWriteInt8(bs, 1)
                raknetEmulRpcReceiveBitStream(15, bs)
                raknetDeleteBitStream(bs)
            end
        end,
        options = {
            Funcs:new(FuncType.Toggle, {
                label = "Разморозка",
                value = page.config.unfreeze,
                description = "Размораживать персонажа при сбиве",
                isOption = true
            })
        }
    })
end