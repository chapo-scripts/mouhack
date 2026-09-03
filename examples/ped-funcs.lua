local imgui = require("mimgui")

---@type Module
local M = {
    name = "Ped Funcs",
    icon = "USER",
    color = imgui.ImVec4(1, 1, 1, 1),
    category = "player",
    page = "Ped funcs",
    config = {
        enabled = imgui.new.bool(true),
        settings = {}
    },
}

return M