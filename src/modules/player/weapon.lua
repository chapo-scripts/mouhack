local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Оружие")


Page.config.noSpread = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noSpread,
    label = "No Spread"
})

Page.config.skills = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.skills,
    label = "Скиллы"
})

Page:AddItem(PageItemType.Button, {
    text = "Click",
    label = "Test"
})

Page.config.noReload = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noReload,
    label = "No Reload"
})

return Page