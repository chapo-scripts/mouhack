local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Вело/Мото")
local memory = require("memory")


Page.config.nobike = { enabled = imgui.new.bool(false), fallInWater = imgui.new.bool(true), fallOnVehicle = imgui.new.bool(true), fallOnPed = imgui.new.bool(true) }
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.nobike.enabled,
    label = "NoBike",
    description = "Не позволяет персонажу падать при столкновениях (не работает в воде)",
    options = {
        Page:AddItem(PageItemType.Toggle, { value = Page.config.nobike.fallInWater, label = "Падать в воде" }, true)
    }
})

local autoboostLastPressed = 0
Page.config.autoboost = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.autoboost,
    label = "Автоускорение",
    description = "Автоматически кликает стрелку вверх на мото и W на вело"
})

Page.config.bikeJump = { enabled = imgui.new.bool(false), power = imgui.new.float(0.1) }
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.bikeJump.enabled,
    label = "Высокий прыжок для велосипедов",
    description = "Изменяет высоту прыжка на велосипедах (стандартная: 0.06)\nАвтор: @",
    options = {
        Page:AddItem(PageItemType.SliderFloat, {
            value = Page.config.bikeJump.power,
            min = 0.001,
            max = 0.5,
            label = "Высота",
            format = "%0.3f"
        }, true)
    }
})



Page:on("loop", function()
    if (isCharInAnyCar(PLAYER_PED)) then
        local veh = storeCarCharIsInNoSave(PLAYER_PED)
        setCharCanBeKnockedOffBike(PLAYER_PED, Page.config.nobike.enabled[0] and (not Page.config.nobike.fallInWater[0] or not isCarInWater(veh)))
    end
    if (Page.config.autoboost[0] and isCharOnAnyBike(PLAYER_PED)) then
        if (isButtonPressed(nil, 16)) then
            if (os.clock() - autoboostLastPressed > 0.1) then
                setGameKeyState(16, 256)
                setGameKeyState(16, 0)
                autoboostLastPressed = os.clock()
            end
        end
    end
    memory.setfloat(memory.getuint32(0x6C0449 + 2, true), Page.config.bikeJump.enabled[0] and Page.config.bikeJump.power[0] or 0.0599, true)
end)

return Page