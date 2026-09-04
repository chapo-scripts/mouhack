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
    Input = "input"
}

---@class PageItem.Properties
---@field type? PageItemType
---@field uid? number
---@field description? string
---@field label string
---@field onChange? fun()
---@field options? PageItem[]
---@field unsafe? string|boolean

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
---@field items string[]

---@class PageItem.Selector : PageItem.Combo

---@class PageItem.Input : PageItem.Properties
---@field value mimgui.char
---@field onChange? fun()
---@field hint? string
---@field width? number
---@field flags? number

---@class PageItem.Frame : PageItem.Properties
---@field func fun()

---@alias PageItem PageItem.Toggle | PageItem.Button | PageItem.Text | PageItem.NoAction | PageItem.Selector | PageItem.Combo | PageItem.Frame | PageItem.Input





-- -@meta

-- -@class ModuleItemProperties
-- -@field value? unknown
-- -@field type ItemType
-- -@field label string
-- -@field onClick? fun()
-- -@field onFrame? fun()

-- -@class ItemCheckbox : ModuleItemProperties

-- -@class ItemInput : ModuleItemProperties
-- -@field flags? number

-- -@class ItemCombo : ModuleItemProperties
-- -@field items string[]

-- -@class ItemColor : ModuleItemProperties
-- -@field flags? number

-- -@class ItemButton : ModuleItemProperties
-- -@field size ImVec2
-- -@field onClick? fun()

-- -@class ItemFrameCode
-- -@field func fun

-- -@alias ModuleItem ItemCheckbox | ItemInput | ItemCombo | ItemCombo
-- -@alias ModuleConfig table

-- -@class Block
-- -@field name string
-- -@field path? string
-- -@field icon string
-- -@field color ImVec4
-- -@field items ModuleItem[]
-- -@field config ModuleConfig
-- -@field noindex? boolean
-- -@field onInit? fun()
-- -@field onFrame? fun()
-- -@field onLoop? fun()
-- -@field onSave? fun()
-- -@field onBeforeSave? fun()

-- -@class Page
-- -@field id number
-- -@field strId string
-- -@field name string
-- -@field description? string
-- -@field parentCategoryName string
-- -@field icon string
-- -@field color ImVec4
-- -@field blocks Block[]

-- -@class Category
-- -@field id number
-- -@field strId string
-- -@field name string
-- -@field pages Page[]