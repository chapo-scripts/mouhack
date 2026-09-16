---@class Category
---@field uid number
---@field strId string
---@field name string
---@field pages Page[]
---@field pagesLabels string[]
---@field parentCategory? Category
local Category = {}

function Category:Print(...)
    print('[CATEGORY]', self.uid, self.strId, self.name, "=>", ...)
end

---@return Page
function Category:AddPage(strId, name)
    local page = Pages:new(strId, name, self)
    page.parentCategory = self
    table.insert(self.pages, page)
    table.insert(self.pagesLabels, name)
    return page
end

---@class Categories
---@field new fun(self: Categories, strId: string, name: string): Category
---@field Find fun(self: Categories, name?: string, strId?: string)
Categories = {
    list = {},
    labels = {}
}

function Categories:Find(name, strId)

end

function Categories:new(strId, name)
    local instance = {
        uid = #self.list + 1,
        strId = strId,
        name = name,
        pages = {},
        pagesLabels = {}
    }
    local newCategory = setmetatable(instance, { __index = Category })
    table.insert(self.list, newCategory)
    table.insert(self.labels, name)
    print("Categories->new:", strId, name)
    return newCategory
end