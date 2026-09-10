local Item = {
    ---@type PageItem[]
    items = {}
}

function Item:new(type, options, isOption)
    options.type = type
    options.uid = ModuleCore:GenerateItemIndex()
    if isOption then
        return options
    end
    return options
end

return Item