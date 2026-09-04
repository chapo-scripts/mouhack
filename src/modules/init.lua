require("modules.types")
ModuleCore = {
    Category = require("modules.core.category"),
    Page = require("modules.core.page"),
    categories = {},
    ---@private
    lastUniqueIndex = 0,
    handlers = {}
}

function ModuleCore:GenerateItemIndex()
    self.lastUniqueIndex = self.lastUniqueIndex + 1
    return self.lastUniqueIndex
end

require("modules.player")
require("modules.network")
require("modules.vehicle")