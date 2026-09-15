local font = renderCreateFont("Trebuchet MS", 10, 5)
local containerIndex

return function(page)
    page.config.drawId = imgui.new.bool(false)
    page.config.clickable = imgui.new.bool(true)

    page:On("loop", function()
        if (page.config.drawId[0]) then
            for id = 0, 4096 do
                if (sampTextdrawIsExists(id)) then
                    local gameX, gameY = sampTextdrawGetPos(id)
                    local screenX, screenY = convertGameScreenCoordsToWindowScreenCoords(gameX, gameY)
                    
                    local text = "ID: " .. id
                    local textSizeX, textSizeY = renderGetFontDrawTextLength(font, text, true), renderGetFontDrawHeight(font)
                    local isHovered = false
                    if (page.config.clickable[0]) then
                        local curX, curY = getCursorPos()
                        if (curX >= screenX and curX <= screenX + textSizeX) then
                            if (curY >= screenY and curY <= screenY + textSizeY) then
                                isHovered = true
                                if (wasKeyPressed(1)) then
                                    print("TextDraw ID: " .. id)
                                    for _, item in ipairs({
                                        {"Text", sampTextdrawGetString},
                                        {"Box (width / color / sizeX / sizeY)", sampTextdrawGetBoxEnabledColorAndSize},
                                        {"Align", sampTextdrawGetAlign},
                                        {"Proportional", sampTextdrawGetProportional},
                                        {"Style", sampTextdrawGetStyle},
                                        {"Shadow (size / color)", sampTextdrawGetShadowColor},
                                        {"Outline (width / color)", sampTextdrawGetOutlineColor},
                                        {"Model (id / rotX / rotY / rotZ / zoom / color1 / color2)", sampTextdrawGetModelRotationZoomVehColor},
                                        {"Pos (x / y)", sampTextdrawGetPos},
                                        {"Letters (sizeX / sizeY / color)", sampTextdrawGetLetterSizeAndColor}
                                    }) do
                                        print(item[1] .. ':', table.concat({item[2](id)}, " / "))
                                    end
                                end
                            end
                        end
                    end
                    renderFontDrawText(font, text, screenX, screenY, isHovered and 0xFF00ff00 or 0xFFffffff, false)
                end
            end
        end
    end)
    
    local function update()        
        if (not containerIndex) then
            return
        end
        for _ = 1, #page.funcs[containerIndex].options - 1 do
            table.remove(page.funcs[containerIndex].options, 2)
        end
        for id = 0, 4096 do
            if (sampTextdrawIsExists(id)) then
                local text = sampTextdrawGetString(id)
                table.insert(page.funcs[containerIndex].options, Funcs:new(FuncType.Button, {
                    label = ("#%d \"%s\""):format(id, text),
                    text = "Взаимодействие",
                    noIndexInSearch = true
                }))
            end
        end
    end
    
    page:AddFunc(Funcs:new(FuncType.Toggle, {
        label = "Отображать ID текстдравов",
        value = page.config.drawId,
        options = {
            Funcs:new(FuncType.Toggle, {
                label = "Отображать информацию при наведении",
                value = page.config.clickable,
                isOption = true
            })
        }
    }))

    containerIndex = page:AddFunc(Funcs:new(FuncType.NoAction, {
        label = "Список текстдравов",
        options = {
            Funcs:new(FuncType.Button, {
                label = "Обновить список",
                text = "Обновить",
                onClick = update
            })
        }
    }))
    update()
end