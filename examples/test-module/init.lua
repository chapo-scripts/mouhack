local Category = ModuleCore.Category:new("test", "Тестовый раздел")
local Page = ModuleCore.Page:new("test_page1")
Page:AddItem(ModuleCore.Item:new("button", {}))

Category:AddPage(Page)


-- modules/MODULE_NAME/init.lua
local Category = ModuleCore.Category:new("test", "Тестовый раздел")
Category:AddPage(require("modules/MODULE_NAME/page1"))
-- modules/MODULE_NAME/page1/init.lua
local Page = ModuleCore.Page:new("page1")
Page:AddItem(require("modules/MODULE_NAME/page1/func_1.lua"))
Page:AddItem(require("modules/MODULE_NAME/page1/func_2.lua"))
return Page

-- modules/MODULE_NAME/page1/func_1.lua
return ModuleCore.Item:new()

-- modules/MODULE_NAME/page1/func_2.lua
return ModuleCore.Item:new()
