---@param page Page
return function(page)
    page.config.gm = imgui.new.bool(true)
    page:On("loop", function()
        local state = page.config.gm[0]
        setCharProofs(PLAYER_PED, state, state, state, state, state)
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "GodMode",
        value = page.config.gm
    })
end