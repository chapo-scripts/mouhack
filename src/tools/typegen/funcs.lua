local FuncTypeGenerator = {
    publicPath = PROJECT_PATH .. "\\api\\types\\funcs.lua",
    path = PROJECT_PATH .. "\\src\\core\\types.lua"
}

function FuncTypeGenerator:Generate()
    if (not DEVELOPMENT) then
        return
    end

    for _, t in pairs(FuncType) do
        assert(FUNC_TYPE_DATA[t], ("No type fields for item type \"%s\""):format(t))
    end
    local lines = {}

    -- Alias
    table.insert(lines, "---@alias Func")
    for typeKey in pairs(FUNC_TYPE_DATA) do
        table.insert(lines, "---| FuncType." .. typeKey)
    end
    
    -- Types
    table.insert(lines, [[

---@class FuncBase
---@field uid? number
---@field type? Func
---@field width? number
---@field height? number
---@field noIndexInSearch? boolean
---@field notBindable? boolean
---@field options? Func[]
---@field tags? {icon: string, text: string}[]
---@field label string
---@field description? string
---@field unsafe? string | boolean
---@field isOption? boolean
---@field onChanged? fun()
---@field onFrame? fun()
---@field parentPage? Page
    ]])
    
    for typeKey, typeData in pairs(FUNC_TYPE_DATA) do
        table.insert(lines, ("\n---@class FuncType.%s : FuncBase"):format(typeKey))
        for field, fieldType in pairs(typeData) do
            table.insert(lines, ("---@field %s %s"):format(field, fieldType))
        end
    end

    -- Constructor overload
    table.insert(lines, "\n---@class Funcs\n---@field list Func[]")
    for typeKey, typeData in pairs(FUNC_TYPE_DATA) do
        table.insert(lines, ("---@field new fun(self: Funcs, type: \"%s\",  options: FuncType.%s): Func"):format(typeKey, typeKey))
    end
    
    for _, path in ipairs({ self.publicPath, self.path }) do
        local file = io.open(path, "w")
        assert(file, "Error creating type file")
        file:write(table.concat(lines, "\n"))
        file:close()
        print("[TOOLS] Func types written to:", path)
    end
end

return FuncTypeGenerator