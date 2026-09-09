---@meta

---@enum PageItemType
PageItemType = {
    Toggle = "toggle",
    Button = "button",
    Text = "text",
    NoAction = "no_action",
    Selector = "selector",
    Combo = "combo",
    Frame = "frame",
    Input = "input",
    InputInt = "input_int",
    TextArea = "textarea",
    Checkbox = "checkbox",
    Color = "color",
    SliderFloat = "slider_float",
    SliderInt = "slider_int"
}

---@class PageItem.Properties
---@field label string
---@field type? PageItemType
---@field uid? number
---@field description? string
---@field options? PageItem[]
---@field unsafe? string|boolean
---@field noIndexInSearch? boolean
---@field onClick? fun()
---@field onFrame? fun(drawList: ImDrawList)

---@class PageItem.NoAction : PageItem.Properties

---@class PageItem.Toggle : PageItem.Properties
---@field value mimgui.bool

---@class PageItem.Button : PageItem.Properties
---@field text? string
---@field size? ImVec2

---@class PageItem.Text : PageItem.Properties
---@field text string

---@class PageItem.Combo : PageItem.Properties
---@field value mimgui.int
---@field items string[]
---@field width? number

---@class PageItem.Selector : PageItem.Properties
---@field value mimgui.int
---@field items string[]

---@class PageItem.Input : PageItem.Properties
---@field value mimgui.char
---@field onChange? fun()
---@field hint? string
---@field width? number
---@field flags? number

---@class PageItem.Color : PageItem.Properties
---@field value mimgui.float[]
---@field flags? number

---@class PageItem.InputInt : PageItem.Properties
---@field value mimgui.int

---@class PageItem.TextArea : PageItem.Input

---@class PageItem.Checkbox : PageItem.Properties
---@field value mimgui.bool

---@class PageItem.Frame : PageItem.Properties
---@field value mimgui.int
---@field onChange? fun()
---@field width? number
---@field flags? number

---@class PageItem.SliderFloat : PageItem.Properties
---@field value mimgui.float
---@field min number
---@field max number
---@field width? number
---@field format? string

---@class PageItem.SliderInt : PageItem.Properties
---@field value mimgui.int
---@field min number
---@field max number
---@field width? number
---@field format? string

---@alias PageItem
---| PageItem.Toggle
---| PageItem.Button
---| PageItem.Text
---| PageItem.NoAction
---| PageItem.Selector
---| PageItem.Combo
---| PageItem.Frame
---| PageItem.Input
---| PageItem.InputInt
---| PageItem.TextArea
---| PageItem.Checkbox
---| PageItem.Color
---| PageItem.SliderFloat
---| PageItem.SliderInt