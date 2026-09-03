local anim = {
    ["__example"] = {
        expanded = false,
        updatedAt = 0,
        progress = 0
    }
}

---@param drawList ImDrawList
---@param itemIndex number
---@param item PageItem
---@param width number
---@param optionIndex? number
---@param otiginalItem? PageItem
local function drawItem(drawList, itemIndex, item, width, optionIndex, originalItem)
    local isOption = optionIndex ~= nil
    local strId = ("item-%d-option-%s"):format(itemIndex, optionIndex or "NULL")
    -- if (isOption) then
    --     imgui.SetCursorPosX(imgui.GetCursorPosX() + 50)
    -- end

    if (not anim[strId]) then
        anim[strId] = {
            expaneded = false,
            progress = 0,
            updatedAt = 0
        }
    end

    local itemSize = imgui.ImVec2(width, 48)
    local fontSize = imgui.GetFontSize()
    local style = imgui.GetStyle()

    if (isOption) then
        -- local optionsSize = imgui.ImVec2(itemSize.x, itemSize.y * #item.options)
    end

    local p = imgui.GetCursorScreenPos()
    if (isOption) then
        
    end
    if (imgui.BeginChild("container-" .. strId, itemSize, true, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)) then
        -- if (isOption) then
        --     item
        -- end
        imgui.SetCursorPosY(itemSize.y / 2 - fontSize / 2)
        if (not isOption and item.options) then
            imgui.Text(faicons("CARET_DOWN") .. string.rep(" ", 4) .. item.label)
            if (imgui.IsItemClicked()) then
                anim[strId].expanded = not anim[strId].expanded
                anim[strId].updatedAt = os.clock()
            end
        else
            imgui.Text(item.label)
        end


        if (item.type == PageItemType.Toggle) then
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - 40 - 15, itemSize.y / 2 - 10))
            UI.Components.TggleButton(item.label, item.value, imgui.ImVec2(40, 20))
        elseif (item.type == PageItemType.Button) then
            local size = item.size or imgui.CalcTextSize(item.text) + style.FramePadding + style.FramePadding
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - size.x - 15, itemSize.y / 2 - size.y / 2))
            if (imgui.Button(item.text .. "##" .. strId, size)) then
                item.onClick()
            end
        elseif (item.type == PageItemType.NoAction) then
            -- No action
        else
            imgui.SameLine()
            imgui.TextColored(UI.Colors.Color.Red.vec4, "UNSUPPORTED_TYPE " .. tostring(item.type))
        end
    end
    imgui.EndChild()

    print("NEW")
    anim[strId].progress = Utils.bringFloatTo(anim[strId].progress, anim[strId].expanded and 1 or 0, anim[strId].updatedAt, 1)
    print(strId, anim[strId].progress)
    if (not isOption and item.options) then
        local maxHeight = #item.options * itemSize.y
        print(anim[strId].progress)
        if (anim[strId].progress > 0) then
            -- for k, v in ipairs(item.options) do
            --     imgui.Text("option-" .. k)
            -- end
            if (maxHeight * anim[strId].progress > 2) then
                imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
                local optionsContainerSize, optionsContainerPos = imgui.ImVec2(itemSize.x, maxHeight * anim[strId].progress), imgui.GetCursorScreenPos()
                drawList:AddRectFilled(optionsContainerPos, optionsContainerPos + optionsContainerSize, UI.Colors.Color.Second.u32, 15, 4 + 8)
                if (imgui.BeginChild("options-for-" .. itemIndex, optionsContainerSize, false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)) then -- "or true" for PopStyleVar
                    imgui.PopStyleVar()
                    for k, v in ipairs(item.options) do
                        drawItem(drawList, itemIndex, v, width, k, item)
                    end
                end
                imgui.EndChild()
            end
        end
    end

    return
end

---@param drawList ImDrawList
---@param page Page
return function(drawList, page)
    imgui.PushFont(UI.Font[15].Bold)
    local width = imgui.GetWindowWidth()
    local posStart = imgui.GetCursorScreenPos()
    local itemWidth = width - 50
    imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
    for itemIndex, item in ipairs(page.items) do
        drawItem(drawList, itemIndex, item, itemWidth)
    end
    imgui.PopStyleVar()
    local posEnd = imgui.GetCursorScreenPos()
    imgui.GetBackgroundDrawList():AddRectFilled(posStart, imgui.ImVec2(posStart.x + itemWidth, posEnd.y), UI.Colors.Color.First.u32, 15)
    imgui.PopFont()
end