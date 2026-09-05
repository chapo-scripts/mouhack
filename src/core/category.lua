---@class Category
---@field name string
---@field pages Page[]
---@field pagesLabels string[]

local Category = {}

setmetatable(Category, {__call = function(t, ...)
    return t:new(...)
end})

---@param name string
---@return Category
function Category:new(name)
    local id = #ModuleCore.categories + 1
    local instance = {
        id = id,
        name = name,
        pages = {},
        pagesLabels = {}
    };
    local new = setmetatable(instance, {__index = self})
    table.insert(ModuleCore.categories, new)
    return new
end

---@param page Page
function Category:AddPage(page)
    table.insert(self.pagesLabels, page.name)
    table.insert(self.pages, page)
end

---@cast Category Category
return Category