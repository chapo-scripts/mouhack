local font = renderCreateFont("Trebuchet MS", 8, 5)
local renderModeList = { "Все", "Содержат фильтры", "НЕ содержат фильтры" }

local labelInfoPattern = [=[

3D Text Label:
| ID: %s
| Text: [[%s]]
| Color: %s
| X / Y / Z: %0.1f / %0.1f / %0.1f
| Dist: %s
| IgnoreWalls: %s
| Attached (playerId / vehicleId): %s / %s
]=]

---@param page Page
return function(page)
    page.config.arizonaRpFix = imgui.new.bool(false)
    page.config.renderEnabled = imgui.new.bool(false)
    page.config.renderShowDistance = imgui.new.bool(true)
    page.config.renderShowModel = imgui.new.bool(true)
    page.config.renderMode = imgui.new.int(0)
    page.config.renderCustomList = { "NPC" }
    page.config.renderCustomListAddBuffer = imgui.new.char[64]("")
    page.config.renderMaxDist = imgui.new.float(100)

    Events:on("onCreate3DText", function(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
        if (page.config.arizonaRpFix[0]) then
            sampCreate3dTextEx(id, text, color, position.x, position.y, position.z, distance, testLOS, attachedPlayerId, attachedVehicleId)
        end
    end)

    Events:on("onRemove3DTextLabel", function(textLabelId)
        if (page.config.arizonaRpFix[0]) then
            sampDestroy3dText(textLabelId)
        end
    end)

    local function checkLabelsFilter(text)
        for _, query in ipairs(page.config.renderCustomList) do
            if (text:find(query)) then
                return true
            end
        end
    end

    imgui.OnFrame(
        function() return page.config.renderEnabled[0] end,
        function(frame)
            frame.HideCursor = false
            local drawList = imgui.GetBackgroundDrawList()
            for id = 0, 2048 do
                local result = sampIs3dTextDefined(id)
                if (result) then
                    local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                    if (
                        page.config.renderMode[0] == 0 or
                        (page.config.renderMode[0] == 1 and checkLabelsFilter(text)) or
                        (page.config.renderMode[0] == 2 and not checkLabelsFilter(text))
                    ) then
                        local sX, sY = convert3DCoordsToScreen(posX, posY, posZ)
                        local pedX, pedY, pedZ = getCharCoordinates(PLAYER_PED)
                        
                        if (isPointOnScreen(posX, posY, posZ, 0.1)) then
                            local label = "3D Label\nID: " .. id
                            local textWidth, textHeight = renderGetFontDrawTextLength(font, label, false), renderGetFontDrawHeight(font) * 2
                            local curX, curY = getCursorPos()
                            if (curX >= sX and curX <= sX + textWidth) then
                                if (curY >= sY and curY <= sY + textHeight) then
                                    drawList:AddTextFontPtr(UI.Font[15].Bold, 15, imgui.ImVec2(sX, sY + 15 * 2), 0xFFffffff, "Click LMB to print info in SF console!")
                                    if (wasKeyPressed(1)) then
                                        print(labelInfoPattern:format(id, text, color, posX, posY, posZ, distance, tostring(ignoreWalls), tostring(playerId), tostring(vehicleId)))
                                    end
                                end
                            end
                            drawList:AddTextFontPtr(UI.Font[15].Bold, 15, imgui.ImVec2(sX, sY), 0xFFffffff, label)
                        end
                    end
                end
            end
        end
    )
    
    ---@param drawList ImDrawList
    local function drawItemModelListPopup(drawList)
        if (imgui.BeginPopupModal("devtools-objects-render-list-popup", nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration)) then
            local size = imgui.GetWindowSize()

            imgui.PushFont(UI.Font[15].Bold)
            imgui.TextDisabled("Фильтры для 3D текстов")
            -- for index, 

            if (imgui.BeginChild("devtools-objects-render-list-popup-container", imgui.ImVec2(300, 400), true)) then
                for index, model in ipairs(page.config.renderCustomList) do
                    imgui.Text(("%d. %s"):format(index, model))
                    imgui.SameLine(imgui.GetWindowWidth() - 20)
                    imgui.TextColored(UI.Colors.Color.Red.vec4, faicons("XMARK"))
                    if (imgui.IsItemClicked(0)) then
                        table.remove(page.config.renderCustomList, index)
                    end
                end
            end
            imgui.EndChild()
            imgui.PopFont()

            imgui.SetNextItemWidth(size.x - 20)
            if (imgui.InputTextWithHint("##Page.config.objects.render.customListAddBuffer", "Введите ID модели и нажмите Enter", page.config.renderCustomListAddBuffer, 64, imgui.InputTextFlags.EnterReturnsTrue)) then
                local id = tonumber(ffi.string(page.config.renderCustomListAddBuffer))
                if (id) then
                    table.insert(page.config.renderCustomList, id)
                    imgui.StrCopy(page.config.renderCustomListAddBuffer, "")
                end
            end
            imgui.NewLine()
            if (UI.Components.Button("Закрыть##devtools-objects-render-list-popup-container-close", imgui.ImVec2(size.x - 20, 30))) then
                imgui.CloseCurrentPopup()
            end
            imgui.EndPopup()
        end
    end

    page:AddFunc(Funcs:new(FuncType.Toggle, {
        label = "Фикс для Arizona RP",
        description = "Восстанавливает работоспособность функций взаимодействия с 3D-Текстами на лаунчере Arizona RP\nАвтор: @XRLM",
        value = page.config.arizonaRpFix
    }))

    return Funcs:new(FuncType.Toggle, {
        value = page.config.renderEnabled,
        label = "Рендер объектов",
        options = {
            Funcs:new(FuncType.Combo, {
                width = 200,
                label = "Режим",
                value = page.config.renderMode,
                items = renderModeList,
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "Список моделей",
                text = "Редактировать",
                onClick = function() imgui.OpenPopup("devtools-objects-render-list-popup") end,
                onFrame = drawItemModelListPopup,
                isOption = true
            })
        }
    })
end