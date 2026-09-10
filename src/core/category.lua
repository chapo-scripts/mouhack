---@global
---@class Category
---@field strId string
---@field name string
---@field pages Page[]
---@field pagesLabels string[]
---@field new fun(self, strId: string, name: string): Category
---@field AddPage fun(self: Category, strId: string, page: Page)

local Category = {}

---@param strId string
---@param name string
---@return Category
function Category:new(strId, name)
    assert(strId and name, "Invalid category strId or name")
    local id = #ModuleCore.categories + 1
    local instance = {
        id = id,
        strId = strId,
        name = name,
        pages = {},
        pagesLabels = {}
    };
    local new = setmetatable(instance, {__index = self})
    table.insert(ModuleCore.categories, new)
    ModuleCore.index.category[strId] = #ModuleCore.categories
    return new
end

---@param strId string
---@param page Page
function Category:AddPage(strId, page)
    page.strId = strId
    page.category = self
    print("ADDPAGE", strId, page)
    for k, v in pairs(page) do print(k, v) end
    table.insert(self.pagesLabels, page.name or strId)
    table.insert(self.pages, page)
    ModuleCore.index.page[strId] = #self.pages
end

---@cast Category Category
return Category