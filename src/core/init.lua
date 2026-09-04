require("core.types")
ModuleCore = {
    Category = require("core.category"),
    Page = require("core.page"),
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