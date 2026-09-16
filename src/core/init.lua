require("core.func")
require("core.page")
require("core.category")

Core = {
    ---@type Listed[]
    list = {}
}

require("core.typegen")
require("modules")
require("core.binds")

-- Binds:Init()
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

-- for k, v in ipairs(Funcs.list) do
--     if (v.parentPage) then
--         print("FUNC", u8:decode(v.label), u8:decode(v.parentPage.name), u8:decode(v.parentPage.parentCategory.name))
--     end
-- end

---@class Listed
---@field type SearchResultType
---@field path string[]
---@field label string
---@field pathString string
---@field pathLower string
---@field categoryIndex number
---@field pageIndex? number
---@field itemIndex? number
---@field optionIndex? number
---@field targetItemUid? number
---@field targetOptionUid? number
---@field optinIndex? number
---@field positions? number[]
---@field target? Func | Page | Category

function Core:ListLoadedFuncs()
    ---@param label string
    ---@param type SearchResultType
    ---@param target Func | Page | Category
    ---@param index number[]
    ---@param path string[]
    ---@param uids? number[]
    local function pushItem(label, type, target, index, path, uids)
        if (not uids) then uids = {} end
        local item = {
            type = type,
            target = target,
            categoryIndex = index[1] or nil,
            pageIndex = index[2] or nil,
            itemIndex = index[3] or nil,
            optionIndex = index[4] or nil,
            targetItemUid = uids[1] or nil,
            targetOptionUid = uids[2] or nil,
            path = path,
            pathString = table.concat(path, " > "),
            label = label
        }
        item.pathLower = u8(string.toLower(u8:decode(item.pathString .. " > " .. item.label)))
        table.insert(self.list, item)
    end

    self.list = {}
    for categoryIndex, category in ipairs(Categories.list) do
        ---@cast category Category
        pushItem(category.name, "category", category, { categoryIndex }, { category.name })
        for pageIndex, page in ipairs(category.pages) do
            pushItem(page.name, "page", page, { categoryIndex, pageIndex }, { category.name, page.name })
            for itemIndex, item in ipairs(page.funcs) do
                if (not item.noIndexInSearch) then
                    pushItem(item.label, "item", item, { categoryIndex, pageIndex, itemIndex }, { category.name, page.name }, {item.uid})
                end
                if (item.options) then
                    for optionIndex, option in ipairs(item.options) do
                        if (not option.noIndexInSearch) then
                            pushItem(option.label, "option", option, { categoryIndex, pageIndex, itemIndex, optionIndex }, { category.name, page.name, item.label }, {item.uid, option.uid})
                        end
                    end
                end
            end
        end
    end
end

Core:ListLoadedFuncs()
Binds:Init()