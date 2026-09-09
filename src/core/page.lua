---@class Page
---@field icon string
---@field name string
---@field items PageItem[]
---@field config table<string, unknown>
---@field handlers table<string, function>
---@field new fun(self: Page, name: string): Page
---@field AddItem fun(self: Page, type: "toggle", options: PageItem.Toggle, isOption?: boolean)
---@field AddItem fun(self: Page, type: "button", options: PageItem.Button, isOption?: boolean)
---@field AddItem fun(self: Page, type: "text", options: PageItem.Text, isOption?: boolean)
---@field AddItem fun(self: Page, type: "no_action", options: PageItem.NoAction, isOption?: boolean)
---@field AddItem fun(self: Page, type: "selector", options: PageItem.Selector, isOption?: boolean)
---@field AddItem fun(self: Page, type: "combo", options: PageItem.Combo, isOption?: boolean)
---@field AddItem fun(self: Page, type: "frame", options: PageItem.Frame, isOption?: boolean)
---@field AddItem fun(self: Page, type: "input", options: PageItem.Input, isOption?: boolean)
---@field AddItem fun(self: Page, type: "input_int", options: PageItem.InputInt, isOption?: boolean)
---@field AddItem fun(self: Page, type: "textarea", options: PageItem.TextArea, isOption?: boolean)
---@field AddItem fun(self: Page, type: "checkbox", options: PageItem.Checkbox, isOption?: boolean)
---@field AddItem fun(self: Page, type: "color", options: PageItem.Color, isOption?: boolean)
---@field AddItem fun(self: Page, type: "slider_float", options: PageItem.SliderFloat, isOption?: boolean)
---@field AddItem fun(self: Page, type: "slider_int", options: PageItem.SliderInt, isOption?: boolean)

local Page = {}

setmetatable(Page, {__call = function(t, ...) return t:new(...) end})

---@param name string
---@return Page
function Page:new(name)
    local instance = {
        name = name,
        config = {},
        items = {},
        handlers = {}
    }
    return setmetatable(instance, {__index = self})
end

function Page:InitializeConfig()
    
end

---@param type string
---@param options table
---@param isOption boolean
function Page:AddItem(type, options, isOption)
    options.type = type
    options.uid = ModuleCore:GenerateItemIndex()
    if isOption then
        return options
    end
    table.insert(self.items, options)
end

---@overload fun(self: Page, event: "loop", callback: fun())
function Page:on(event, callback)
    self.handlers[event] = callback
end

function Page:Call(event, ...)
    if self.handlers[event] then
        self.handlers[event](self, ...)
    end
end

---@cast Page Page
return Page