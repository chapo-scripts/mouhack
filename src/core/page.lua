---@class Page
---@field uid number
---@field strId string
---@field name string
---@field funcs Func[]
---@field handlers table<string, function[]>
---@field config table<string, unknown>
---@field parentPage? Page
local Page = {}

---@overload fun(self: Page, func: fun(page: Page): Func)
---@overload fun(self: Page, func: fun(page: Page))
---@param func Func
function Page:AddFunc(func)
    if (type(func) == "function") then
        func = func(self)
    end
    if (func) then
        func.parentPage = self
        table.insert(self.funcs, func)
        return #self.funcs
    end
end

function Page:On(event, callback)
    -- print("Registering callback for", event, debug.traceback())
    if (not self.handlers[event]) then
        self.handlers[event] = {}
    end
    table.insert(self.handlers[event], callback)
end

---@class Pages
---@field list Page[]
---@field new fun(self, strId: string, name: string): Page
Pages = {
    list = {}
}

function Pages:new(strId, name, parentCategory)
    local instance = {
        uid = #self.list + 1,
        strId = strId,
        name = name,
        funcs = {},
        handlers = {},
        config = {},
        parentCategory = parentCategory
    }
    local newPage = setmetatable(instance, { __index = Page })
    table.insert(self.list, newPage)
    return newPage
end