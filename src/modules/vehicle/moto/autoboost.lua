require("moonloader")
local isBikeModel = ffi.cast('bool (__cdecl *)(int)', 0x4C5B60)
local isBmxModel = ffi.cast('bool (__cdecl *)(int)', 0x4C5C20)
local autoboostLastPressed = 0

return function(page)
    page.config.autoboost = imgui.new.bool(false)
    page:On("loop", function()
        if (isKeyDown(VK_SHIFT) and isCharInAnyCar(PLAYER_PED) and page.config.autoboost[0] and isCharOnAnyBike(PLAYER_PED)) then
            local vehModel = getCarModel(storeCarCharIsInNoSave(PLAYER_PED)) ---@diagnostic disable-line
            local gameKey = isBikeModel(vehModel) and 1 or (isBmxModel(vehModel) and 16)
            if (isButtonPressed(nil, 16)) then ---@diagnostic disable-line
                if (os.clock() - autoboostLastPressed > 0.1) then
                    setGameKeyState(gameKey, gameKey == 1 and -256 or 256)
                    setGameKeyState(gameKey, 0)
                    autoboostLastPressed = os.clock()
                end
            end
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "Автоускорение",
        description = "Автоматически кликает стрелку вверх на мото и W на велосипеде ЕСЛИ ЗАЖАТ L.SHIFT",
        value = page.config.autoboost
    })
end