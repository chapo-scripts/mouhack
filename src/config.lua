CONFIG_PATH = BASE_PATH .. "\\config\\" .. thisScript().name .. ".json"
Config = {}

CarbJsonConfig.load(CONFIG_PATH, Config)