---@param page Page
return function(page)
    page.config.addMessage = { text = imgui.new.char[128]("Your message text"), color = imgui.new.float[4](1, 0, 0, 1) }
    return Funcs:new(FuncType.NoAction, {
        label = "Добавить сообщение",
        options = {
            Funcs:new(FuncType.Input, {
                label = "Текст",
                value = page.config.addMessage.text,
                isOption = true
            }),
            Funcs:new(FuncType.Color, {
                label = "Цвет",
                value = page.config.addMessage.color,
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "Добавить сообщение",
                text = "Добавить",
                onClick = function()
                    local text = u8:decode(ffi.string(page.config.addMessage.text))
                    sampAddChatMessage(text, -1)
                end,
                isOption = true
            })
        }
    })
end