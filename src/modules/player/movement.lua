local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Передвижение")

local function slap(zOffset)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    setCharCoordinates(PLAYER_PED, x, y, z + (zOffset or 2))
end

Page.config.infinityRun = imgui.new.bool(true)
Page.config.sprintHook = imgui.new.bool(true)

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.infinityRun,
    label = "Бесконечный бег"
})

Page:AddItem(PageItemType.NoAction, {
    label = "Слап",
    options = {
        Page:AddItem(PageItemType.Button, { text = "Слап", label = "Вверх", onClick = function() slap(2) end }, true),
        Page:AddItem(PageItemType.Button, { text = "Слап", label = "Вниз", onClick = function() slap(-2) end }, true),
    }
}, false)

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.sprintHook,
    label = "SprintHook"
})

return Page