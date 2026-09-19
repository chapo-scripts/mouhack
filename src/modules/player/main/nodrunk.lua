---@param page Page
return function(page)
    page.config.nodrunk = imgui.new.bool(false)
    
    Events:on("onSetPlayerDrunk", function()
        if (page.config.nodrunk[0]) then
            return false
        end
    end)

    return Funcs:new(FuncType.Toggle, {
        label = "NoDrunk",
        description = "Не позволяет серверу установить уровень опьянения вашего персонажа",
        value = page.config.nodrunk
    })
end