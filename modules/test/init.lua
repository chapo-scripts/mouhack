local Category = ModuleCore.Category:new("Test Module")
local Page = ModuleCore.Page:new("Камера")

Page.config.chat = imgui.new.bool(true)
Page:AddItem(PageItemType.Toggle, {
    label = "Add to chat",
    value = Page.config.chat
})

Page.config.console = imgui.new.bool(true)
Page:AddItem(PageItemType.Toggle, {
    label = "Add to console",
    value = Page.config.console
})

Page.config.input = imgui.new.char[128]("")
Page:AddItem(PageItemType.Input, {
    label = "Text",
    value = Page.config.input
})

Page:AddItem(PageItemType.Button, {
    label = "Add",
    onClick = function()
        if (Page.config.chat[0]) then
            sampAddChatMessage("Message: " .. ffi.string(Page.config.input), 0xFF00ff00)
        end
        if (Page.config.console[0]) then
            print("Message: " .. ffi.string(Page.config.input))
        end
    end
})

Category:AddPage(Page)
