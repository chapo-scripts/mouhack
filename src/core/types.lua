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
    Color = "color"
}

---@class PageItem.Properties
---@field type? PageItemType
---@field uid? number
---@field description? string
---@field label string
---@field onChange? fun()
---@field options? PageItem[]
---@field unsafe? string|boolean
---@field hint? string
---@field noIndexInSearch? boolean
---@field onFrame? fun(drawList: ImDrawList)

---@class PageItem.NoAction : PageItem.Properties

---@class PageItem.Toggle : PageItem.Properties
---@field value mimgui.bool

---@class PageItem.Button : PageItem.Properties
---@field text string
---@field size? ImVec2
---@field onClick fun()

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

-----@alias PageItem PageItem.Toggle | PageItem.Button | PageItem.Text | PageItem.NoAction | PageItem.Selector | PageItem.Combo | PageItem.Frame | PageItem.Input | PageItem.InputInt | PageItem.TextArea | PageItem.Checkbox | PageItem.Color
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