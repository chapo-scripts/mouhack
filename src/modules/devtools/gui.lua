local imgui = require("mimgui")
-- ModuleCore.Page.
local Page = ModuleCore.Page:new("Диалоги и текстдравы")


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

Page:AddItem(PageItemType.Checkbox, {
    label = "Test",
    value = imgui.new.bool(true)
})

Page:AddItem(PageItemType.Button, {
    label = "Показать диалог",
    text = "Показать",
    onClick = function() 
        showDialog:show()
    end,
    options = {
        Page:AddItem(PageItemType.Input, { noIndexInSearch = true, width = 150, label = "ID", value = showDialog.id, flags = imgui.InputTextFlags.CharsDecimal }, true),
        Page:AddItem(PageItemType.Input, { noIndexInSearch = true, width = 150, label = "Заголовок", value = showDialog.title }, true),
        Page:AddItem(PageItemType.TextArea, { noIndexInSearch = true, width = 150, label = "Текст", value = showDialog.text }, true),
        Page:AddItem(PageItemType.Input, { noIndexInSearch = true, width = 150, label = "Кнопка #1", value = showDialog.b1 }, true),
        Page:AddItem(PageItemType.Input, { noIndexInSearch = true, width = 150, label = "Кнопка #2", value = showDialog.b2 }, true),
        Page:AddItem(PageItemType.Combo, { noIndexInSearch = true, width = 150, label = "Тип", items = showDialog.styleList, value = showDialog.style }, true)
    }
})

return Page