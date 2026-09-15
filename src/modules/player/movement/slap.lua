local function slap(zOffset)
    local x, y, z = getCharCoordinates(PLAYER_PED)
    setCharCoordinates(PLAYER_PED, x, y, z + (zOffset or 2))
end

---@param page Page
return function(page)
    page.config.slapHeight = imgui.new.float(3)
    return Funcs:new(FuncType.NoAction, {
        label = "Слап",
        options = {
            Funcs:new(FuncType.Button, {
                label = "Вверх",
                text = "Слапнуть",
                onClick = function()
                    slap(page.config.slapHeight[0] or 2)
                end,
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "Вниз",
                text = "Слапнуть",
                onClick = function()
                    slap(-page.config.slapHeight[0] or -2)
                end,
                isOption = true
            }),
            Funcs:new(FuncType.SliderFloat, {
                label = "Высота слапа",
                min = 0.1,
                max = 20,
                value = page.config.slapHeight,
                isOption = true
            })
        }
    })
end