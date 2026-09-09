CONFIG_PATH = BASE_PATH .. "\\config\\" .. thisScript().name .. ".json"
Config = {
    scriptFileName = imgui.new.char[128](""),
    menu = {
        hideUnsafeWarning = imgui.new.bool(false),
        command = imgui.new.char[16]("mh"),
        cheat = imgui.new.char[16]("")
    },

    ---@type table<string, {enabled: mimgui.bool, pages: table<string, unknown>}>
    modules = {
        ["author:module_name"] = {
            enabled = imgui.new.bool(false),
            pages = {}
        }
    }
}

CarbJsonConfig.load(CONFIG_PATH, Config)