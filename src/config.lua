CONFIG_PATH = BASE_PATH .. "\\config\\" .. thisScript().name .. ".json"
Config = {
    modules = {}
}

CarbJsonConfig.load(CONFIG_PATH, Config)