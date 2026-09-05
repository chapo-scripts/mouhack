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
        Nav = require("ui.components.nav"),
        PageNav = require("ui.components.page-nav"),
        Selector = require("ui.components.selector"),
        Hint = require("ui.components.hint"),
        RoundButton = require("ui.components.round-button"),
        Button = require("ui.components.button"),
        RoundedGradientRect = require("ui.components.rounded-gradient-rect"),
        -- Search = require("ui.components.search"),
        -- Settings = require("ui.components.settings"),
        ImRotate = require("ui.components.imrotate"),
        TextWithSearch = require("ui.components.text-with-search")
    },
    Windows = {
        Main = require("ui.windows.main")
    },
    SubMenu = {
        Search = require("ui.submenu.search"),
        Settings = require("ui.submenu.settings")
    },
    Resource = {
        Fonts = require("ui.resource.fonts"),
        Logo = require("ui.resource.logo")
    },
    Texture = {
        logo = nil
    },
    ---@type table<number, {Regular: unknown, Bold: unknown, Black: unknown}>
    Font = {
        Init = require("ui.fonts"),
        requiredSizes = { 12, 15, 16, 20, 24, 40, 64 },
        requiredIcons = {
            "MAGNIFYING_GLASS",
            "BOOK",
            "CODE_COMMIT",
            "CODE_BRANCH",
            "CODE_FORK",
            "CIRCLE_QUESTION",
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
            "XMARK",
            "COG",
            "GEAR",
            "CIRCLE",
            "PERSON_WALKING",
            "SIGNAL",
            "IMAGE",
            "IMAGES",
            "CIRCLE_EXCLAMATION",
            "TRIANGLE_EXCLAMATION"
        }
    },
    selected = { category = 1, page = 1 },
    pageNavigation = {},
    IniFilename = nil,
    Blink = {
        state = 0,
        alpha = 0,
        updatedAt = os.clock(),
        duration = 0.5
    }
}

---@overload fun(self, color: number): number
---@overload fun(self, color: ImVec4): ImVec4
function UI.Blink:GetColor(color)
    return UI.Colors.withAlpha(color, self.alpha)
end

function UI.Blink:Update()
    self.alpha = Utils.bringFloatTo(self.alpha, self.state == 1 and 1 or 0, self.updatedAt, self.duration)
    if (self.alpha == 1) then
        self.updatedAt = os.clock()
        self.state = 0
    elseif (self.alpha == 0) then
        self.updatedAt = os.clock()
        self.state = 1
    end
end

imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = UI.IniFilename
    local style = imgui.GetStyle()
    UI.Font.Init(UI.Font.requiredSizes, UI.Font.requiredIcons) ---@diagnostic disable-line
    ---@cast style imgui.Style
    UI.Style(style, style.Colors)
    UI.Colors:Init()
    UI.Texture.logo = imgui.CreateTextureFromFileInMemory(imgui.new('const char*', UI.Resource.Logo), #UI.Resource.Logo);
end)

addEventHandler("onWindowMessage", function(msg, key)
    if (msg == 0x0100) then
        if (key == VK_ESCAPE and MainWindowState[0]) then
            if (UI.SubMenu.Search:IsEnabled()) then
                UI.SubMenu.Search:Show(false)
            elseif (UI.SubMenu.Settings:IsEnabled()) then
                UI.SubMenu.Settings:Show(false)
            else
                MainWindowState[0] = false
            end
            consumeWindowMessage(true, true)
        end
    end
end)