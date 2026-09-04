local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Основные")

Page.config.gm = imgui.new.bool(false)

-- Page:AddItem(PageItemType.Toggle, {
--     value = Page.config.infinityRun,
--     label = "Бесконечный бег"
-- })

return Page