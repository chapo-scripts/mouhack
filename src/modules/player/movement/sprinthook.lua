local sprintHookLastPressed = 0

return function(page)
    page.config.sprintHook = imgui.new.bool(true)
    page:On("loop", function()
        if (page.config.sprintHook[0] and isCharOnFoot(PLAYER_PED)) then
            if (isButtonPressed(nil, 16)) then ---@diagnostic disable-line
                if (os.clock() - sprintHookLastPressed > 0.1) then
                    setGameKeyState(16, 256)
                    setGameKeyState(16, 0)
                    sprintHookLastPressed = os.clock()
                end
                
            end
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "SprintHook",
        description = "Флудит клавишей спринта для увеличения скорости бега",
        unsafe = true,
        value = page.config.sprintHook
    })
end