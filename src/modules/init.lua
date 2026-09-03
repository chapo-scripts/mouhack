---@enum ItemType
ItemType = {
    Toggle = "toggle",
    Button = "button",
    Text = "text"
}

require("modules.types")
ModuleCore = {
    Category = require("modules.core.category"),
    Page = require("modules.core.page"),
    categories = {}
}

require("modules.player")