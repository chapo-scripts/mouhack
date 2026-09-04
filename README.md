# Template project for moonly
## Функции
### Персонаж
#### Передвижение
* Infinity Run
* AirBrake
* ClickWarp
#### Оружие
* ExtraWS
### Транспорт


## Building
1. Install **[moonly-cli](https://github.com/themusaigen/moonly-command-tool)**
2. Run `moonly.exe bundle`

## API
Вы можете с легкостью дополнять функционал чита путем создания "модулей".
### Подготовка
1. клонируйте репозиторий: `git clone https://github.com/chapo-scripts/mouhack`
2. перейдите в папку и откройте ее в IDE: `cd mouhack && code .`
### Создание модуля
1. перейдите в папку `mouhack\src\modules`
2. создайте папку c названием вашего модуля, например `test-module`
3. создайте файл `init.lua` внутри созданной папки
4. используйте ModuleCore API для создания модуля

## Примеры
### `src\modules\test-module\init.lua`
```lua
-- Создаем новую категорию
local Category = ModuleCore.Category:new("Тестовый модуль")

-- Добавляем страницу в нашу категорию из "modules.test-module.chat"
Category:AddPage(require("modules.test-module.chat"))
```
### `src\modules\test-module\chat.lua`
```lua
local ffi, imgui = require("ffi"), require("mimgui")

-- Создаем новую страницу
local Page = ModuleCore.Page:new("Чат")

Page.config.text = imgui.new.char[128]("")
Page.config.color = imgui.new.float[3](1, 1, 1)
Page.config.addToChat = imgui.new.bool(true)
Page.config.addToConsole = imgui.new.bool(true)

local function onClick()
    local text = ffi.string(Page.config.text)
    if (Page.config.addToChat[0]) then
        sampAddChatMessage(text, -1)
    end
    if (Page.config.addToConsole[0]) then
        print(text)
    end
end

Page:AddItem(PageItemType.Toggle, { value = Page.config.addToChat, label = "Добавлять сообщения в чат" })
Page:AddItem(PageItemType.Toggle, { value = Page.config.addToConsole, label = "Добавлять сообщения в консоль" })
Page:AddItem(PageItemType.Input, { value = Page.config.text, label = "Текст сообщения" })
Page:AddItem(PageItemType.Button, { label = "Добавить сообщение", text = "Выполнить", onClick = onClick })

return Page
```