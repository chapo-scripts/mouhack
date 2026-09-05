---@class Page
---@field icon string
---@field name string
---@field items PageItem[]
---@field config table<string, unknown>
---@field handlers table<string, function>

---@type Page
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
        items = {},
        handlers = {}
    };
    return setmetatable(instance, {__index = self})
end

---@overload fun(self: Page, type: "toggle", options: PageItem.Toggle, isOption?: boolean)
---@overload fun(self: Page, type: "button", options: PageItem.Button, isOption?: boolean)
---@overload fun(self: Page, type: "no_action", options: PageItem.NoAction, isOption?: boolean)
---@overload fun(self: Page, type: "selector", options: PageItem.Selector, isOption?: boolean)
---@overload fun(self: Page, type: "combo", options: PageItem.Selector, isOption?: boolean)
---@overload fun(self: Page, type: "frame", options: PageItem.Frame, isOption?: boolean)
---@overload fun(self: Page, type: "input", options: PageItem.Input, isOption?: boolean)
function Page:AddItem(type, options, isOption)
    options.type = type
    options.uid = ModuleCore:GenerateItemIndex()
    if (isOption) then
        return options
    end
    table.insert(self.items, options)
end

---@overload fun(self: Page, event: "loop", callback: fun())
function Page:on(event, callback)
    self.handlers[event] = callback
end

function Page:Call(event, ...)
    if (self.handlers[event]) then
        self.handlers[event](self, ...)
    end
end

---@cast Page Page
return Page