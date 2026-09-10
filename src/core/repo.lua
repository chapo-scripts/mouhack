-- local Repo = {
--     State = {
--         None = 0,
--         Loading = 1,
--         Loaded = 2,
--         Error = 3
--     },
--     BASE_URL = "https://api.github.com/repos/chapo-scripts/mouhack/git/trees/main?recursive=1",
--     BASE_PATH = BASE_PATH .. "\\MouTools\\modules"
-- }

-- Repo.modules = {
--     state = Repo.State.None,
--     error = nil,
--     ---@type Module[]
--     list = {}
-- }

-- ---@class Module
-- ---@field name string
-- ---@field author string
-- ---@field description string
-- ---@field version string
-- ---@field info {state: "not_loaded" | "loading" | "loaded" | "update_available", loadState: {error?: string, bytes?: {current: number, total: number}}}

-- ---@class GitHubContentResponseItem
-- ---@field name string
-- ---@field path string
-- ---@field sha string
-- ---@field size number
-- ---@field url string
-- ---@field html_url string
-- ---@field git_url string
-- ---@field download_url? string
-- ---@field type "dir" | "file"
-- ---@field _links {self: string, git: string, html: string}

-- ---@alias GitHubContentResponse GitHubContentResponseItem[]

-- function Repo:GetModulesList()
--     if (not doesDirectoryExist(self.BASE_PATH)) then
--         createDirectory(self.BASE_PATH)
--     end
--     self.modules.state = self.State.Loading

--     ---@type string[]
--     local gitModules = {}

--     Utils.asyncHttpRequest(
--         "GET",
--         self.BASE_URL,
--         nil,
--         function(response)
--             if (response.status_code ~= 200) then
--                 self.modules.error = response.status_code
--                 self.modules.state = self.State.Error
--                 return
--             end
--             local decodeStatus, dir = pcall(decodeJson, response.text)
--             if (not decodeStatus or not dir.tree or #dir.tree == 0) then
--                 self.modules.error = "NO_MODULES"
--                 self.modules.state = self.State.Error
--                 return
--             end
        
--             for _, file in ipairs(dir.tree) do
--                 if (file.path:find("modules/(%w+)/module%.json$")) then
--                     local dirName = file.path:match("modules/(%w+)/module%.json$")
--                     table.insert(gitModules, dirName)
--                     print("Foun module:", dirName)
--                 end
--                 -- print(file.path, file.path:find("modules/(%w+)/module%.json$"))
--             end
--             Repo:LoadModulesInfo(gitModules)
--         end,
--         function(err)
--             self.modules.error = err
--             self.modules.state = self.State.Error
--         end
--     )
-- end

-- local dlstatus = require('moonloader').download_status

-- function Repo:LoadModulesInfo(paths)
--     local tempPath = self.BASE_PATH .. "\\temp"
--     if (not doesDirectoryExist(tempPath)) then
--         createDirectory(tempPath)
--     end

    
--     local manifestURL = "https://raw.githubusercontent.com/chapo-scripts/mouhack/refs/heads/main/modules/%s/module.json"
--     for _, modulePath in ipairs(paths) do
--         local manifestPath = ("%s\\%s.json"):format(tempPath, modulePath)
--         downloadUrlToFile(
--             manifestURL:format(modulePath),
--             manifestPath,
--             function(id, status, p1, p2)
--                 if (status == dlstatus.STATUS_DOWNLOADINGDATA) then
--                     print(string.format('Загружено %d из %d.', p1, p2))
--                 elseif (status == dlstatus.STATUS_ENDDOWNLOADDATA) then
--                     print('Загрузка завершена.')
--                     local file = io.open(manifestPath, "r")
--                     if (not file) then
--                         print("Unable to read", manifestPath)
--                         return
--                     end
--                     local json = file:read("*a")
--                     file:close()

--                     local decodeStatus, data = pcall(decodeJson, json)
--                     if (not decodeStatus or not data.name) then
--                         return print("Unable to read", modulePath, "INVALID_JSON")
--                     end

--                     table.insert(self.modules.list, {
--                         strId = ("%s:%s"):format(data.author, data.name),
--                         name = data.name,
--                         author = data.author,
--                         description = data.description or "",
--                         version = data.version,
--                         info = {
--                             state = self:IsModuleInstalled(modulePath), --"not_loaded" | "loading" | "loaded" | "update_available",
--                             loadState = nil--{error?: string, bytes?: {current: number, total: number}}
--                         }
--                     })
--                     print("MANIFEST LOADED", data.name, data.author, data.version)
--                 end
--             end
--         )
--         print("LoadModulesInfo:", modulePath)
--     end
-- end

-- function Repo:IsModuleInstalled(modulePath)
--     local moduleDir = self.BASE_PATH .. "\\" .. modulePath
--     return doesDirectoryExist(moduleDir) and doesFileExist(moduleDir .. "\\module.json")
-- end

-- function Repo:GetModuleState(moduleStrId)
--     if (Config.modules[moduleStrId]) then
--         local version
--         return 
--     else
--         return "not_loaded"
--     end
--     if (Config.modules[moduleStrId]) then

--     end
-- end

-- function Repo:DownloadModule(moduleName)
--     downloadUrlToFile(
--         "https://api.github.com/repos/chapo-scripts/mouhack/contents/modules/" .. moduleName,
--         self.BASE_PATH .. "\\moduleName",
--         function(id, status, p1, p2)
--             if (status == dlstatus.STATUS_DOWNLOADINGDATA) then
--                 print(string.format('Загружено %d из %d.', p1, p2))
--             elseif (status == dlstatus.STATUS_ENDDOWNLOADDATA) then
--                 print('Загрузка завершена.')
--             end
--         end
--     )
-- end

-- return Repo

local MODULES_PATH = BASE_PATH .. "\\modules\\"
local Repo = {
    ---@type {status: "none" | "fetching" | "done" | "error", error?: string, list: Module[]}
    availableModules = {
        status = "none",
        error = nil,
        list = {}
    },
    ---@type {}[]
    modules = {}
}

---@class Module
---@field name string
---@field author string
---@field description string
---@field version string
---@field status "not_installed" | "installing" | "installed"
---@field info {updateAvailable: boolean, downloadInfo?: {error?: string, bytesCurrent?: number, bytesTotal?: number}}

function Repo:GetAvailableModules()
    ---@param paths string[]
    local function downloadModulesInfo(paths)
        -- for k, v in ipairs(paths) do
        --     local manifestURL = "https://raw.githubusercontent.com/chapo-scripts/mouhack/refs/heads/main/modules/%s/module.json"
        --     for _, modulePath in ipairs(paths) do
        --         local manifestPath = ("%s\\%s.json"):format(tempPath, modulePath)
        --         downloadUrlToFile(
        --             manifestURL:format(modulePath),
        --             manifestPath,
        --             function(id, status, p1, p2)
        --                 if (status == dlstatus.STATUS_DOWNLOADINGDATA) then
        --                     print(string.format('Загружено %d из %d.', p1, p2))
        --                 elseif (status == dlstatus.STATUS_ENDDOWNLOADDATA) then
        --                     print('Загрузка завершена.')
        --                     local file = io.open(manifestPath, "r")
        --                     if (not file) then
        --                         print("Unable to read", manifestPath)
        --                         return
        --                     end
        --                     local json = file:read("*a")
        --                     file:close()
        --                     local decodeStatus, data = pcall(decodeJson, json)
        --                     if (not decodeStatus or not data.name) then
        --                         return print("Unable to read", modulePath, "INVALID_JSON")
        --                     end
        --                     table.insert(self.modules.list, {
        --                         strId = ("%s:%s"):format(data.author, data.name),
        --                         name = data.name,
        --                         author = data.author,
        --                         description = data.description or "",
        --                         version = data.version,
        --                         info = {
        --                             state = self:IsModuleInstalled(modulePath), --"not_loaded" | "loading" | "loaded" | "update_available",
        --                             loadState = nil--{error?: string, bytes?: {current: number, total: number}}
        --                         }
        --                     })
        --                     print("MANIFEST LOADED", data.name, data.author, data.version)
        --                 end
        --             end
        --         )
        --     table.insert(self.availableModules.list, {
                
        --     })
        -- end
    end
    
    local tempPath = MODULES_PATH .. "\\temp"
    if (not doesDirectoryExist(tempPath)) then
        createDirectory(tempPath)
    end

    self.availableModules.status = "fetching"
    self.availableModules.error = nil
    self.availableModules.list = {}
    local pathsList = {}
    Utils.asyncHttpRequest(
        "GET",
        self.BASE_URL,
        nil,
        function(response)
            if (response.status_code ~= 200) then
                self.availableModules.error = response.status_code
                self.availableModules.status = "error"
                return
            end
            local decodeStatus, dir = pcall(decodeJson, response.text)
            if (not decodeStatus or not dir.tree or #dir.tree == 0) then
                self.availableModules.error = "NO_MODULES"
                self.availableModules.status = "error"
                return
            end
        
            for _, file in ipairs(dir.tree) do
                if (file.path:find("modules/(%w+)/module%.json$")) then
                    local dirName = file.path:match("modules/(%w+)/module%.json$")
                    table.insert(pathsList, dirName)
                    print("Foun module:", dirName)
                end
            end
        end,
        function(err)
            self.availableModules.error = err
            self.availableModules.status = "error"
        end
    )
end

function Repo:DownloadModule(name)
    -- Get all files in: modules/{NAME}/
    local files

    -- Download all files
end

function Repo:InModuleInstalled(name)
    return doesDirectoryExist(MODULES_PATH .. name)
end

function Repo:DeleteModule(name)
    if (self:InModuleInstalled(name)) then
        -- os.remoe(targetDir)
        print("DELETE", MODULES_PATH .. name)
    end
end

return Repo