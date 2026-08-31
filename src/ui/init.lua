---@diagnostic disable:lowercase-global
Encoding.default = "CP1251"
u8 = Encoding.UTF8

UI = {
    Style = require("ui.style"),
    Components = {
        CenterText = require("ui.components.center-text"),
        Link = require("ui.components.link")
    },
    Windows = {
        Main = require("ui.windows.main")
    },
    Font = {},
    IniFilename = nil
}

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = UI.IniFilename
    local style = imgui.GetStyle()
    ---@cast style imgui.Style
    UI.Style(style, style.Colors)
end)