require("core.func")
require("core.page")
require("core.category")

Core = {}

require("core.typegen")
require("modules")

function Core:EmitAllPages(event, ...)
    for _, page in pairs(Pages.list) do
        local callbacks = page.handlers[event]
        if (callbacks) then
            for _, cb in ipairs(callbacks) do
                cb(...)
            end
        end
    end
end

---@class Element
---@field type "category" | "page" | "func" | "option"
---@field categoryIndex? number
---@field pageIndex? number
---@field funcIndex? number
---@field optionIndex? number
---@field funcUid? number
---@field optionUid? number
---@field path string[]
---@field pathString string
---@field name string

---@param types {category?: boolean, page?: boolean, func?: boolean, option?: boolean}
---@param queryFilter? string
---@return
function Core:GetElements(types, queryFilter)
    local result = {}
    -- local collections = {
    --     category = Categories.list,
    --     page = Pages.list,
    --     func = Funcs.list
    -- }
    local function pushResult()
        
    end
end