---@diagnostic disable:lowercase-global
DEVELOPMENT = MOONLY_BUNDLED == nil ---@diagnostic disable-line
BASE_PATH = getGameDirectory() .. "\\moonloader"
BUILT_AT = DEVELOPMENT and os.time() or MOONLY_BUNDLE_TIMESTAMP / 1000 ---@diagnostic disable-line

script_name(DEVELOPMENT and NAME or thisScript().name) ---@diagnostic disable-line
script_version(DEVELOPMENT and VERSION or "DEVELOPMENT") ---@diagnostic disable-line
script_author(DEVELOPMENT and AUTHOR or "DEV") ---@diagnostic disable-line

ffi = require("ffi")
Encoding = require("encoding")
CarbJsonConfig = require("carbJsonConfig")
imgui = require("mimgui")
require("moonloader")
require("utils")
require("config")
require("ui")

function main()
    while (not isSampAvailable()) do wait(0) end
    sampRegisterChatCommand("template", function()
        MainWindowState[0] = not MainWindowState[0]
    end)
    wait(-1)
end