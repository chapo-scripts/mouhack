---@class Page
---@field icon string
---@field name string
---@field items PageItem
---@field config table<string, unknown>

---@class Page
local Page = {}

setmetatable(Page, {__call = function(t, ...)
    return t:new(...)
end})

---@param name string
---@return Page
function Page:new(name)
    local instance = {
        name = name,
        config = {},
        items = {}
    };
    return setmetatable(instance, {__index = self})
end

---@overload fun(self: Page, type: "toggle", options: PageItem.Toggle, isOption?: boolean)
---@overload fun(self: Page, type: "button", options: PageItem.Button, isOption?: boolean)
---@overload fun(self: Page, type: "no_action", options: PageItem.NoAction, isOption?: boolean)
function Page:AddItem(type, options, isOption)
    options.type = type
    if (isOption) then
        return options
    end
    table.insert(self.items, options)
end

return Page