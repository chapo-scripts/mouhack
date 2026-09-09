local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Камера")


Page.config.fov = { enabled = imgui.new.bool(true), value = imgui.new.float(90) }
Page:AddItem(PageItemType.Toggle, {
    label = "FOV",
    description = "Поле зрения камеры",
    value = Page.config.fov.enabled,
    options = {
        Page:AddItem(PageItemType.SliderFloat, {
            label = "FOV",
            width = 200,
            value = Page.config.fov.value,
            min = 50,
            max = 200,
            format = "%0.1f"
        }, true),
    }
}, false)

Page.config.dist = { enabled = imgui.new.bool(true), value = imgui.new.float(90) }
Page:AddItem(PageItemType.Toggle, {
    label = "Расстояние",
    description = "Расстояние от камеры до персонажа",
    value = Page.config.dist.enabled,
    options = {
        Page:AddItem(PageItemType.SliderFloat, {
            label = "FOV",
            width = 200,
            value = Page.config.dist.value,
            min = 0.5,
            max = 20,
            format = "%0.1f м."
        }, true),
    }
}, false)



Page:on("loop", function()
    
end)

return Page