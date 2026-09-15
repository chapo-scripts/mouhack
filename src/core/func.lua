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