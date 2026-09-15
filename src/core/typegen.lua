FUNC_TYPE_DATA = {
    [FuncType.Toggle] = { value = "mimgui.bool" },
    [FuncType.Button] = { text = "string?", size = "ImVec2?" },
    [FuncType.Text] = { text = "string" },
    [FuncType.NoAction] = {  },
    [FuncType.Selector] = { value = "mimgui.int", items = "string[]", width = "number?" },
    [FuncType.Combo] = { value = "mimgui.int", items = "string[]", width = "number?" },
    [FuncType.Frame] = {  },
    [FuncType.Input] = { value = "mimgui.char", hint = "string?", width = "number?", flags = "number?" },
    [FuncType.InputInt] = { value = "mimgui.char", hint = "string?", width = "number?", flags = "number?" },
    [FuncType.TextArea] = { value = "mimgui.char", hint = "string?", width = "number?" },
    [FuncType.Checkbox] = { value = "mimgui.bool" },
    [FuncType.Color] = { value = "mimgui.float[4]", flags = "number?" },
    [FuncType.SliderFloat] = { value = "mimgui.float", min = "number", max = "number", format = "string?", width = "number?" },
    [FuncType.SliderInt] = { value = "mimgui.float", min = "number", max = "number", format = "string?", width = "number?" },
}

local function generateFuncTypes()
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
---@field noIndexInSearch? boolean
---@field options? Func[]
---@field tags? {icon: string, text: string}[]
---@field label string
---@field description? string
---@field unsafe? string | boolean
---@field isOption? boolean
---@field onChanged? fun()
---@field onFrame? fun()
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
    print(getWorkingDirectory() .. "\\src\\core\\types.lua")
    local file = io.open(getWorkingDirectory() .. "\\src\\core\\types.lua", "w")
    assert(file, "Error creating type file")
    file:write(table.concat(lines, "\n"))
    file:close()
end
generateFuncTypes()