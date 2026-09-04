local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Передвижение")

local function slap(zOffset)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    setCharCoordinates(PLAYER_PED, x, y, z + (zOffset or 2))
end

Page.config.infinityRun = imgui.new.bool(true)
Page.config.sprintHook = imgui.new.bool(true)
Page.config.clickwarp = imgui.new.bool(false)
Page.config.airbrake = {
    enabled = imgui.new.bool(false),
    speed = imgui.new.float(2),
    mouseWheelSpeedControl = imgui.new.bool(true)
}

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.infinityRun,
    label = "Бесконечный бег"
})

Page:AddItem(PageItemType.NoAction, {
    label = "Слап",
    description = "Подкинуть игрока на 2 метра вниз или вверх",
    options = {
        Page:AddItem(PageItemType.Button, { text = "Слап", label = "Вниз", onClick = function() slap(-2) end }, true),
        Page:AddItem(PageItemType.Button, { text = "Слап", label = "Вверх", onClick = function() slap(2) end }, true),
    }
}, false)

Page:AddItem(PageItemType.NoAction, {
    label = "Телепорт",
    options = {
        Page:AddItem(PageItemType.Selector, { label = "Метод телепорта", items = { "Телепорт (небезопасно)", "Курдмастер" }, onClick = function() slap(2) end }, true),
        Page:AddItem(PageItemType.Button, {
            text = "Телепортироваться",
            unsafe = true,
            label = "ТП на МЕТКУ",
            onClick = function()
                local blip, x, y, z = getTargetBlipCoordinates()
                if (not blip) then
                    return
                end
                setCharCoordinates(PLAYER_PED, x, y, z)
            end
        }, true),
    }
}, false)

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.sprintHook,
    label = "SprintHook"
})

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.sprintHook,
    label = "ClickWarp"
})

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.airbrake.enabled,
    label = "AirBrake",
    unsafe = true,
    options = {
        Page:AddItem(PageItemType.NoAction, { label = "Скорость" }, true),
        Page:AddItem(PageItemType.Toggle, { label = "Изменять скорость колесиком мыши", value = Page.config.airbrake.mouseWheelSpeedControl }, true)
    }
})

local function togglePlayerControllable(frozen)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, frozen and 1 or 0)
    raknetEmulRpcReceiveBitStream(15, bs)
    raknetDeleteBitStream(bs)
end
Page:AddItem(PageItemType.NoAction, {
    value = Page.config.airbrake.enabled,
    label = "Фриз",
    options = {
        Page:AddItem(PageItemType.Button, { label = "Разморозить персонажа", text = "Разморозить", onClick = function() togglePlayerControllable(true) end }, true),
        Page:AddItem(PageItemType.Button, { label = "Заморозить персонажа", text = "Заморозить", onClick = function() togglePlayerControllable(false) end }, true),
    }
})

Page:on("loop", function()
    if (Page.config.airbrake.enabled[0]) then
        printStringNow("ASD", 100)
    end
end)

return Page