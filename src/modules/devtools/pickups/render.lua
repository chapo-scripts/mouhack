
local font = renderCreateFont("Trebuchet MS", 8, 5)
local renderModeList = { "Все", "Указанные", "Все, кроме указанных" }

local function getPickupModel(id) -- https://www.blast.hk/threads/13380/page-15#post-604316
    PICKUP_POOL = sampGetPickupPoolPtr()
    return ffi.cast("int *", (id * 20 + 61444) + PICKUP_POOL)[0]
end

local function getAllPickups() -- https://www.blast.hk/threads/13380/page-8#post-361600
    local pu = {}
    pPu = sampGetPickupPoolPtr() + 16388
    for i = 0, 4095 do
        local id = readMemory(pPu + 4 * i, 4)
        if id ~= -1 then
            table.insert(pu, sampGetPickupHandleBySampId(i))
        end
    end
    return pu
end

---@param page Page
return function(page)
    page.config.renderEnabled = imgui.new.bool(false)
    page.config.renderShowDistance = imgui.new.bool(true)
    page.config.renderShowModel = imgui.new.bool(true)
    page.config.renderMode = imgui.new.int(0)
    page.config.renderCustomList = { 312, 123, 221}
    page.config.renderCustomListAddBuffer = imgui.new.char[64]("")
    page.config.renderMaxDist = imgui.new.float(100)

    page:On("loop", function()
        if (page.config.renderEnabled[0]) then
            local px, py, pz = getCharCoordinates(PLAYER_PED)
            for _, handle in ipairs(getAllPickups()) do
                if (doesPickupExist(handle)) then
                    local sampId = sampGetPickupSampIdByHandle(handle)
                    local x, y, z = getPickupCoordinates(handle)
                    local model = getPickupModel(handle)
                    local dist = getDistanceBetweenCoords3d(x, y, z, px, py, pz)
                    if (isPointOnScreen(x, y, z, 0.1)) then
                        local sx, sy = convert3DCoordsToScreen(x, y, z)
                        renderFontDrawText(font, ("Pickup\nID: %d\nModel: %d\nDist: %0.1f"):format(sampId or -1, model, dist), sx, sy, 0xFFffffff, false)
                    end
                end
            end
        end
    end)
    
    ---@param drawList ImDrawList
    local function drawItemModelListPopup(drawList)
        if (imgui.BeginPopupModal("devtools-objects-render-list-popup", nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration)) then
            local size = imgui.GetWindowSize()

            imgui.PushFont(UI.Font[15].Bold)
            imgui.TextDisabled("Список моделей объектов")
            -- for index, 

            if (imgui.BeginChild("devtools-objects-render-list-popup-container", imgui.ImVec2(300, 400), true)) then
                for index, model in ipairs(page.config.renderCustomList) do
                    imgui.Text(("%d. %d"):format(index, model))
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
            if (imgui.InputTextWithHint("##Page.config.objects.render.customListAddBuffer", "Введите ID модели и нажмите Enter", page.config.renderCustomListAddBuffer, 64, imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.CharsDecimal)) then
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