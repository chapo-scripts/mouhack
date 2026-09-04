CONFIG_PATH = BASE_PATH .. "\\config\\" .. thisScript().name .. ".json"
Config = {
    fileName = imgui.new.char[128](""),
    menu = {
        hideUnsafeWarning = imgui.new.bool(false),
        command = imgui.new.char[16]("mh"),
        cheat = imgui.new.char[16]("")
    },
    modules = {}
}

CarbJsonConfig.load(CONFIG_PATH, Config)