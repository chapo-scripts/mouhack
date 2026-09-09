local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Общие")


Page.config.godmode = imgui.new.bool(true)
Page:AddItem(PageItemType.Toggle, { label = "GodMode", description = "Бессмертие персонажа", value = Page.config.godmode }, false)

Page.config.bunnyHop = imgui.new.bool(true)
Page:AddItem(PageItemType.Toggle, { label = "AllowBunnyHop", description = "Не позволяет серверу установить анимацию при прыжке во время бена", value = Page.config.bunnyHop })

Page:AddItem(PageItemType.Button, { label = "Умереть", onClick = function() setCharHealth(PLAYER_PED, 0) end })


Page:on("loop", function()
    
end)

return Page