---@alias Func
---| FuncType.Toggle
---| FuncType.InputInt
---| FuncType.SliderFloat
---| FuncType.Button
---| FuncType.Combo
---| FuncType.Frame
---| FuncType.Color
---| FuncType.SliderInt
---| FuncType.Input
---| FuncType.Checkbox
---| FuncType.TextArea
---| FuncType.Selector
---| FuncType.NoAction
---| FuncType.Text

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
    

---@class FuncType.Toggle : FuncBase
---@field value mimgui.bool

---@class FuncType.InputInt : FuncBase
---@field flags number?
---@field width number?
---@field hint string?
---@field value mimgui.char

---@class FuncType.SliderFloat : FuncBase
---@field max number
---@field format string?
---@field value mimgui.float
---@field min number
---@field width number?

---@class FuncType.Button : FuncBase
---@field size ImVec2?
---@field text string?

---@class FuncType.Combo : FuncBase
---@field items string[]
---@field width number?
---@field value mimgui.int

---@class FuncType.Frame : FuncBase

---@class FuncType.Color : FuncBase
---@field flags number?
---@field value mimgui.float[4]

---@class FuncType.SliderInt : FuncBase
---@field max number
---@field format string?
---@field value mimgui.float
---@field min number
---@field width number?

---@class FuncType.Input : FuncBase
---@field flags number?
---@field width number?
---@field hint string?
---@field value mimgui.char

---@class FuncType.Checkbox : FuncBase
---@field value mimgui.bool

---@class FuncType.TextArea : FuncBase
---@field width number?
---@field hint string?
---@field value mimgui.char

---@class FuncType.Selector : FuncBase
---@field items string[]
---@field width number?
---@field value mimgui.int

---@class FuncType.NoAction : FuncBase

---@class FuncType.Text : FuncBase
---@field text string

---@class Funcs
---@field list Func[]
---@field new fun(self: Funcs, type: "Toggle",  options: FuncType.Toggle): Func
---@field new fun(self: Funcs, type: "InputInt",  options: FuncType.InputInt): Func
---@field new fun(self: Funcs, type: "SliderFloat",  options: FuncType.SliderFloat): Func
---@field new fun(self: Funcs, type: "Button",  options: FuncType.Button): Func
---@field new fun(self: Funcs, type: "Combo",  options: FuncType.Combo): Func
---@field new fun(self: Funcs, type: "Frame",  options: FuncType.Frame): Func
---@field new fun(self: Funcs, type: "Color",  options: FuncType.Color): Func
---@field new fun(self: Funcs, type: "SliderInt",  options: FuncType.SliderInt): Func
---@field new fun(self: Funcs, type: "Input",  options: FuncType.Input): Func
---@field new fun(self: Funcs, type: "Checkbox",  options: FuncType.Checkbox): Func
---@field new fun(self: Funcs, type: "TextArea",  options: FuncType.TextArea): Func
---@field new fun(self: Funcs, type: "Selector",  options: FuncType.Selector): Func
---@field new fun(self: Funcs, type: "NoAction",  options: FuncType.NoAction): Func
---@field new fun(self: Funcs, type: "Text",  options: FuncType.Text): Func