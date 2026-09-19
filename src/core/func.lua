FuncType = {
    Toggle = "Toggle",
    Button = "Button",
    Text = "Text",
    NoAction = "NoAction",
    Selector = "Selector",
    Combo = "Combo",
    Frame = "Frame",
    Input = "Input",
    InputInt = "InputInt",
    TextArea = "TextArea",
    Checkbox = "Checkbox",
    Color = "Color",
    SliderFloat = "SliderFloat",
    SliderInt = "SliderInt",
}

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

---@type Funcs
Funcs = { ---@diagnostic disable-line
    list = {}
}

---@param type string
---@param options table
function Funcs:new(type, options)
    options.uid = #self.list + 1
    options.type = type
    options.isOption = options.isOption or nil
    table.insert(self.list, options)
    return options
end