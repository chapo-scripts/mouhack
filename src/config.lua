local imgui = require("mimgui")
CONFIG_PATH = BASE_PATH .. "\\config\\" .. thisScript().name .. ".json"
Config = {
    scriptFileName = imgui.new.char[128](""),
    menu = {
        hideUnsafeWarning = imgui.new.bool(false),
        command = imgui.new.char[16]("mh"),
        cheat = imgui.new.char[16]("")
    },

    ---@type {path: string, keys: number[], state: boolean, useHold: boolean}[]
    binds = {
        
    },
    pages = {},
    ---@type table<string, {enabled: mimgui.bool, pages: table<string, unknown>}>
    modules = {
        ["author:module_name"] = {
            enabled = imgui.new.bool(false),
            pages = {}
        }
    }
}

function LoadConfig()
    for _, page in ipairs(Pages.list) do
        if (page.parentCategory) then
            local cfgKey = ("%s:%s"):format(page.parentCategory.name, page.name)
            Config.pages[cfgKey] = page.config

            local fieldsCount = 0
            for _ in pairs(page.config) do
                fieldsCount = fieldsCount + 1
            end

            print("Init config for page", page.name)
        else
            print("Unable to initialize page config for", page.name)
        end
    end
    CarbJsonConfig.load(CONFIG_PATH, Config)
end