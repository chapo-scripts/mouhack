local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Вело/Мото")


Page.config.nobike = imgui.new.bool(false)
Page.config.autoboost = imgui.new.bool(false)

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.nobike,
    label = "NoBike",
    description = "Не позволяет персонажу падать при столкновениях (не работает в воде)"
})

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.autoboost,
    label = "Автоускорение",
    description = "Автоматически кликает стрелку вверх на мото и W на вело"
})

Page:on("loop", function()

end)

return Page