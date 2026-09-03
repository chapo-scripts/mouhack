local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Оружие")

Page.config.noSpread = imgui.new.bool(true)
Page.config.noReload = imgui.new.bool(true)

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noSpread,
    label = "No Spread"
})

Page:AddItem(PageItemType.Button, {
    text = "Click",
    label = "Test"
})

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noReload,
    label = "No Reload"
})

return Page