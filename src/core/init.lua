require("core.types")
ModuleCore = {
    ---@type Category
    Category = require("core.category"),
    ---@type Page
    Page = require("core.page"),
    Item = require("core.item"),
    Repo = require("core.repo"),
    categories = {},
    lastUniqueIndex = 0,
    handlers = {},
    index = { category = {}, page = {} }
}

function ModuleCore:GenerateItemIndex()
    self.lastUniqueIndex = self.lastUniqueIndex + 1
    return self.lastUniqueIndex
end

function ModuleCore:GetAllItems()
    local items = {}
    
    for _, category in ipairs(self.categories) do

    end

    return items
end

require("modules")