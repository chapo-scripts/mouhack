---@class ModuleInfo
---@field index number
---@field dir string
---@field name string
---@field author string
---@field description string
---@field version string
---@field filesList string[]
---@field state "not_loaded" | "loading" | "loaded" | "update_available" | "error"
---@field download? {current?: number, total?: number, error?: string}

REPOSITORY = "chapo-scripts/mouhack"

---@class Repo
---@field GetAvailableModules fun(self)
---@field GetModuleInfo fun(self, dir: string): boolean, string[]
---@field DownloadModule fun(self, module: ModuleInfo)
Repo = {
    TREE_URL = ("https://api.github.com/repos/%s/git/trees/main?recursive=1"):format(REPOSITORY),
    MODULE_DIR_URL = ("https://api.github.com/repos/%s/contents/modules/"):format(REPOSITORY),
    MODULES_PATH = BASE_PATH .. "\\modules",
    availableModules = {
        ---@type "none" | "loading" | "ok" | "error"
        state = "none",
        ---@type string | nil
        error = nil,
        ---@type string[]
        list = {}
    },
}

Repo.State = {
    FetchingModulesList = 0,
    FetchingModulesInfo = 1,
    DownloadingModule = 2
}

function Repo:DownloadModule(module)
    module.state = "loading"
    module.download = {}
    Utils.asyncHttpRequest(
        "GET",
        self.MODULE_DIR_URL .. module.dir,
        nil,
        function(response)
            if (response.status_code ~= 200) then
                module.state = "error"
                module.download = { error = "CODE_" .. response.status_code }
                return
            end

            local decodeStatus, decodeResult = pcall(decodeJson, response.text)
            if (not decodeStatus or #decodeResult == 0) then
                module.state = "error"
                module.download = { error = "INVALID_DIR_JSON" }
                return
            end
            
            
            for _, file in ipairs(decodeResult) do
                downloadUrlToFile(
                    file.download_url,
                    ("%s\\%s"):format(self.MODULES_PATH, file.path),
                    function()

                    end
                )
            end
            module.state = "loaded"
        end,
        function(err)
            module.state = "error"
            module.download = { error = tostring(err) }
        end
    )
end

function Repo:GetAvailableModules()
    self.availableModules.state = "loading"
    Utils.asyncHttpRequest(
        "GET",
        self.TREE_URL,
        nil,
        function(response)
            if (response.status_code ~= 200) then
                self.availableModules.error = tostring(response.status_code)
                self.availableModules.state = "error"
                return
            end

            local decodeStatus, decodeResult = pcall(decodeJson, response.text)
            if (not decodeStatus or not decodeResult.tree) then
                self.availableModules.error = "INVALID_JSON"
                self.availableModules.state = "error"
                return
            end

            for _, item in ipairs(decodeResult.tree) do
                if (item.path:find("^modules/(.+)/module%.json$")) then
                    local dir = item.path:match("^modules/(.+)/module%.json$")
                    table.insert(self.availableModules, dir)
                    print("FOUND MODULE:", dir)
                end
            end
            self.availableModules.state = "ok"
        end,
        function(err)
            self.availableModules.error = tostring(err)
            self.availableModules.state = "error"
        end
    )
end