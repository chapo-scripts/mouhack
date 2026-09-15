local showDialog = {
    id = imgui.new.char[128]("1"),
    style = imgui.new.int(1),
    title = imgui.new.char[128]("Заголовок"),
    text = imgui.new.char[4096]("Текст"),
    b1 = imgui.new.char[32]("Ок"),
    b2 = imgui.new.char[32]("Закрыть"),
    styleList = { "MSGBOX", "INPUT", "LIST", "PASSWORD", "TABLIST", "TABLIST_HEADERS" }
}

function showDialog:show()
    sampShowDialog(
        tonumber(ffi.string(self.id)) or 0,
        u8:decode(ffi.string(self.title)),
        u8:decode(ffi.string(self.text)),
        u8:decode(ffi.string(self.b1)),
        u8:decode(ffi.string(self.b2)),
        self.style[0]
    )
end


---@param page Page
return function(page)
    return Funcs:new(FuncType.Button, {
        label = "Показать диалог",
        text = "Показать",
        onClick = function() 
            showDialog:show()
        end,
        options = {
            Funcs:new(FuncType.Input, { isOption = true, noIndexInSearch = true, width = 150, label = "ID", value = showDialog.id, flags = imgui.InputTextFlags.CharsDecimal }),
            Funcs:new(FuncType.Input, { isOption = true, noIndexInSearch = true, width = 150, label = "Заголовок", value = showDialog.title }),
            Funcs:new(FuncType.TextArea, { isOption = true, noIndexInSearch = true, width = 150, label = "Текст", value = showDialog.text }),
            Funcs:new(FuncType.Input, { isOption = true, noIndexInSearch = true, width = 150, label = "Кнопка #1", value = showDialog.b1 }),
            Funcs:new(FuncType.Input, { isOption = true, noIndexInSearch = true, width = 150, label = "Кнопка #2", value = showDialog.b2 }),
            Funcs:new(FuncType.Combo, { isOption = true, noIndexInSearch = true, width = 150, label = "Тип", items = showDialog.styleList, value = showDialog.style }),
        }
    })
end