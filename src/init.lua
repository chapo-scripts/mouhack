---@diagnostic disable:lowercase-global
DEVELOPMENT = MOONLY_BUNDLED == nil ---@diagnostic disable-line
PROJECT_PATH = getWorkingDirectory()
BASE_PATH = getGameDirectory() .. "\\moonloader"
BUILT_AT = DEVELOPMENT and os.time() or MOONLY_BUNDLE_TIMESTAMP / 1000 ---@diagnostic disable-line

script_name(DEVELOPMENT and NAME or thisScript().name) ---@diagnostic disable-line
script_version(DEVELOPMENT and VERSION or "DEVELOPMENT") ---@diagnostic disable-line
script_author(DEVELOPMENT and AUTHOR or "DEV") ---@diagnostic disable-line

require("libchecker")
SampEvents = require("samp.events")
SampEventsCore = require("samp.events.core")
EventBus = require("eventbus")
vkeys = require("vkeys")
Memory = require("memory")
ffi = require("ffi")
Const = require("constants")
Encoding = require("encoding")
Encoding.default = "CP1251"
u8 = Encoding.UTF8
CarbJsonConfig = require("carbJsonConfig")
require("utils")
require("config")
require("core")
imgui = require("mimgui")
faicons = require("fAwesome6")
require("moonloader")
require("ui")

if (DEVELOPMENT) then
    require("tools.typegen.funcs"):Generate()
    require("tools.typegen.events"):Generate()
    require("tools.docgen.funcs"):Generate()
end

function main()
    while (not isSampAvailable()) do wait(0) end
    print("[MouHack] Config path:", CONFIG_PATH)
    sampRegisterChatCommand("mh", function()
        MainWindowState[0] = not MainWindowState[0]
    end)
    if (DEVELOPMENT) then
        -- print("pacsage.loaded = ", table.toString(package.loaded))
        sampRegisterChatCommand("log", function(arg)
            a = TestChannel:emit("log", arg)
            print("TestChannel list", table.toString(a))
            print(table.toString(TestChannel:list()))
        end)
    end

    Core:EmitAllPages("sampLoaded")
    Binds:Register()
    while (true) do
        wait(0)
        UI.Blink:Update()
        Core:EmitAllPages("loop")
        if (wasKeyPressed(VK_G)) then
            UI.Notf:Push("Hello world", 5, "wc")
        end
    end
end
-- SampEvents = require("samp.events")
-- SampEvents.onServerMessage = function(c, t)
--     sampAddChatMessage("SE: {ffffff}" .. t, 0xFFff0000)
-- end