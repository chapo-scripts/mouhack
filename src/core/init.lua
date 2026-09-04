require("core.types")
ModuleCore = {
    ---@type Category
    Category = require("core.category"),
    ---@type Page
    Page = require("core.page"),
    ---@type Category[]
    categories = {},
    ---@private
    lastUniqueIndex = 0,
    handlers = {}
}

function ModuleCore:GenerateItemIndex()
    self.lastUniqueIndex = self.lastUniqueIndex + 1
    return self.lastUniqueIndex
end

require("modules")