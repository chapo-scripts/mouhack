local font = renderCreateFont("Trebuchet MS", 10, 5)
local containerIndex

return function(page)
    page.config.drawId = imgui.new.bool(false)

    page:On("loop", function()
        if (page.config.drawId[0]) then
            for id = 0, 4096 do
                if (sampTextdrawIsExists(id)) then
                    local gameX, gameY = sampTextdrawGetPos(id)
                    local screenX, screenY = convertGameScreenCoordsToWindowScreenCoords(gameX, gameY)
                    
                    local text = "ID: " .. id
                    local textSizeX, textSizeY = renderGetFontDrawTextLength(font, text, true), renderGetFontDrawHeight(font)
                    local isHovered = false
                    
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
                local strId = "##devtools-textdraws-click-" .. id
                table.insert(page.funcs[containerIndex].options, Funcs:new(FuncType.Button, {
                    label = ("#%d \"%s\""):format(id, text),
                    text = "Взаимодействие",
                    noIndexInSearch = true,
                    onClick = function()
                        imgui.OpenPopup(strId .. "popup")
                    end,
                    width = 200,
                    onFrame = function()
                        imgui.SetNextWindowPos(imgui.GetCursorScreenPos() - imgui.ImVec2(200, -25), imgui.Cond.Always, imgui.ImVec2(0, 0))
                        -- imgui.GetForegroundDrawList():AddCircleFilled(p, 10, 0xFFff0000)
                        imgui.SetNextWindowSize(imgui.ImVec2(200, -1), imgui.Cond.Always)
                        local sCount = UI.Style:Push(true)
                        if (imgui.BeginPopup(strId .. "popup", imgui.WindowFlags.NoMove)) then
                            local buttonSize = imgui.ImVec2(200, 30)
                            if (UI.Components.Button("Кликнуть" .. strId, buttonSize)) then
                                sampSendClickTextdraw(id)
                                imgui.CloseCurrentPopup()
                            end
                            if (UI.Components.Button("Удалить" .. strId, buttonSize)) then
                                sampTextdrawDelete(id)
                                imgui.CloseCurrentPopup()
                            end
                            imgui.EndPopup()
                        end
                        UI.Style:Pop(sCount)
                    end
                }))
            end
        end
    end
    page:On("sampLoaded", update)
    
    page:AddFunc(Funcs:new(FuncType.Toggle, {
        label = "Отображать ID текстдравов",
        description = "Отображает ID текстдравов и выводит в консоль подробную информацию о текстдраве при клике на его ID",
        value = page.config.drawId,
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
end