---@class UpdateInfo
---@field version string
---@field changelog {version: string, release_date: string, changes: string[]}[]
---@field url string
---@field thanks string[]
---@field links string[]

AutoUpdate = {
    baseUrl = "https://github.com/chapo-scripts/mouhack/",
    infoFile = Const.SCRIPT_PATH .. "\\update.json",
    scriptTempFile = Const.SCRIPT_PATH .. "\\update.lua",
    ---@type UpdateInfo
    updateInfo = nil,
    download = {
        ---@type "info" | "script"
        file = nil,
        ---@type "none" | "downloading" | "error" | "success"
        state = "none",
        bytes = { loaded = 0, total = 0 }
    }
}

function AutoUpdate:GetUpdateInfo()

end

function AutoUpdate:DownloadUpdate()

end