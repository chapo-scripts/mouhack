local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Arizona CEF")

Page:AddItem(PageItemType.Checkbox, {
    label = "Test",
    value = imgui.new.bool(true)
})

Page:AddItem(PageItemType.Button, {
    label = "Выполнить JavaScript",
    text = "Запустить",
    onClick = function() 
        
    end,
    options = {
        -- Page:AddItem(PageItemType.TextArea, { noIndexInSearch = true, width = 150, label = "ID", value = showDialog.id, flags = imgui.InputTextFlags.CharsDecimal }, true),
    }
})

return Page