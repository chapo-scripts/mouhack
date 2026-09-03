---@diagnostic disable:lowercase-global
Encoding.default = "CP1251"
u8 = Encoding.UTF8

UI = {
    Colors = require("ui.colors"),
    Style = require("ui.style"),
    Components = {
        CenterText = require("ui.components.center-text"),
        TggleButton = require("ui.components.toggle-button"),
        Page = require("ui.components.page"),
        Link = require("ui.components.link"),
        Navbar = require("ui.components.navbar"), -- unused
        Nav = require("ui.components.nav"),
        PageNav = require("ui.components.page-nav"),
        Selector = require("ui.components.selector"),
        RoundedGradientRect = require("ui.components.rounded-gradient-rect")
    },
    Windows = {
        Main = require("ui.windows.main")
    },
    Resource = {
        Fonts = require("ui.resource.fonts"),
    },
    ---@type table<number, {Regular: unknown, Bold: unknown, Black: unknown}>
    Font = {
        Init = require("ui.fonts"),
        requiredSizes = { 12, 15, 16, 20, 24, 40, 64 },
        requiredIcons = {
            "PLUS",
            "HEART",
            "VEST",
            "SHIELD",
            "STAR",
            "BURGER",
            "HAND_FIST",
            "BAN",
            "GAS_PUMP",
            "ROAD",
            "USER",
            "USERS",
            "LOCK",
            "UNLOCK",
            "GEAR",
            "CARET_UP",
            "CARET_DOWN",
            "CARET_LEFT",
            "CARET_RIGHT",
            
            "CALENDAR",
            "CLOCK",

            "PERSON",

            "CIRCLE",
            "PERSON_WALKING",
            "SIGNAL",
            "IMAGE",
            "IMAGES"
        }
    },
    selected = { category = 1, page = 1 },
    IniFilename = nil
}

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = UI.IniFilename
    local style = imgui.GetStyle()
    UI.Font.Init(UI.Font.requiredSizes, UI.Font.requiredIcons) ---@diagnostic disable-line
    ---@cast style imgui.Style
    UI.Style(style, style.Colors)
    UI.Colors:Init()
end)