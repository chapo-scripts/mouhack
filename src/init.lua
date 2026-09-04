---@diagnostic disable:lowercase-global
DEVELOPMENT = MOONLY_BUNDLED == nil ---@diagnostic disable-line
BASE_PATH = getGameDirectory() .. "\\moonloader"
BUILT_AT = DEVELOPMENT and os.time() or MOONLY_BUNDLE_TIMESTAMP / 1000 ---@diagnostic disable-line

script_name(DEVELOPMENT and NAME or thisScript().name) ---@diagnostic disable-line
script_version(DEVELOPMENT and VERSION or "DEVELOPMENT") ---@diagnostic disable-line
script_author(DEVELOPMENT and AUTHOR or "DEV") ---@diagnostic disable-line

require("libchecker")
ffi = require("ffi")
Const = require("constants")
require("core")
Encoding = require("encoding")
CarbJsonConfig = require("carbJsonConfig")
imgui = require("mimgui")
faicons = require("fAwesome6")
require("moonloader")
require("utils")
require("config")
require("ui")

function main()
    while (not isSampAvailable()) do wait(0) end
    sampRegisterChatCommand("mh", function()
        MainWindowState[0] = not MainWindowState[0]
    end)
    while (true) do
        wait(0)
        UI.Blink:Update()
        
        -- WIP
        for k, v in ipairs(ModuleCore.categories) do
            for _, p in ipairs(v.pages) do
                p:Call("loop")
            end
        end
    end
end