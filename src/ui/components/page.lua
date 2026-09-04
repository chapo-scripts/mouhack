local anim = {
    ["__example"] = {
        expanded = false,
        updatedAt = 0,
        progress = 0
    }
}

---@param page Page
---@param drawList ImDrawList
---@param bgDrawList ImDrawList
---@param itemIndex number
---@param item PageItem
---@param width number
---@param optionIndex? number
local function drawItem(page, drawList, bgDrawList, itemIndex, item, width, optionIndex)
    local isOption = optionIndex ~= nil
    local drawList = imgui.GetWindowDrawList()  
    local strId = ("%d-item-%d-option-%s"):format(item.uid, itemIndex, optionIndex or "NULL")

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

    if (not isOption and itemIndex > 1) then
        local linePos = imgui.GetCursorScreenPos()
        drawList:AddLine(linePos, linePos + imgui.ImVec2(itemSize.x, 0), UI.Colors.Color.Stroke.u32, 1)
    end

    local itemPos = imgui.GetCursorScreenPos()
    local bgZoneRounding = 15

    local roundFlags = 0
    if (itemIndex == 1) then
        roundFlags = roundFlags + 1 + 2
    end
    if (itemIndex == #page.items and not anim[strId].expanded) then
        roundFlags = roundFlags + 4 + 8
    end
    
    drawList:AddRectFilled(itemPos, itemPos + itemSize, isOption and UI.Colors.Color.Second.u32 or UI.Colors.Color.First.u32, 15, roundFlags)
    if (itemIndex > 1 and not isOption) then
        drawList:AddLine(itemPos - imgui.ImVec2(0, 1), imgui.ImVec2(itemPos.x + itemSize.x, itemPos.y - 1), UI.Colors.Color.Stroke.u32)
    end
    if (imgui.BeginChild("container-" .. strId, itemSize, true, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)) then
        imgui.SetCursorPos(imgui.ImVec2(0, 0))
        
        -- Label and tags
        imgui.SetCursorPos(imgui.ImVec2(15, itemSize.y / 2 - fontSize / 2))
        if (not isOption and item.options) then
            UI.Components.ImRotate.Start();
            imgui.Text(faicons("CARET_DOWN"))
            UI.Components.ImRotate.End(math.rad(180 - (90 * anim[strId].progress)));
            imgui.SameLine(nil, 10)
        end
        imgui.Text(item.label)
        if (item.description) then
            imgui.SameLine(nil, 10)
            imgui.TextDisabled(faicons("CIRCLE_QUESTION"))
            UI.Components.Hint("hint-" .. strId, item.description)
        end
        if (item.unsafe) then
            imgui.SameLine(nil, 10)
            local unsafeLabel = type(item.unsafe) == "string" and item.unsafe or Const.UNSAFE_ITEM_LABEL
            imgui.TextDisabled(faicons("TRIANGLE_EXCLAMATION"))
            UI.Components.Hint("hint-unsafe-" .. strId, unsafeLabel)
        end
        
        -- Expand click zone
        imgui.SetCursorPos(imgui.ImVec2(0, 0))
        if (imgui.InvisibleButton("clickzone-" .. strId, imgui.ImVec2(item.type == PageItemType.NoAction and itemSize.x or imgui.GetContentRegionAvail().x - 100, itemSize.y))) then
            anim[strId].expanded = not anim[strId].expanded
            anim[strId].updatedAt = os.clock()
        end
        if (item.options and imgui.IsItemHovered()) then
            imgui.SetMouseCursor(imgui.MouseCursor.Hand)
        end

        -- Item
        if (item.type == PageItemType.Toggle) then
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - 40 - 15, itemSize.y / 2 - 10))
            UI.Components.TggleButton(item.label, item.value, imgui.ImVec2(40, 20))
        elseif (item.type == PageItemType.Button) then
            local size = item.size or imgui.CalcTextSize(item.text) + style.FramePadding + style.FramePadding
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - size.x - 15, itemSize.y / 2 - size.y / 2))
            if (UI.Components.Button(item.text .. "##" .. strId, size)) then
                item.onClick()
            end
        elseif (item.type == PageItemType.Input) then
            local inputHeight = imgui.GetFontSize() + style.FramePadding.y * 2
            local inputWidth = item.width or 40
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - inputWidth - 15, itemSize.y / 2 - inputHeight / 2))
            imgui.SetNextItemWidth(inputWidth)
            if (imgui.InputTextWithHint("##" .. strId, item.hint or "", item.value, ffi.sizeof(item.value), item.flags or 0)) then
                item.onChange()
            end
        elseif (item.type == PageItemType.NoAction) then
            -- No action
        else
            imgui.SameLine()
            imgui.TextColored(UI.Colors.Color.Red.vec4, "UNSUPPORTED_TYPE " .. tostring(item.type))
        end
        imgui.SameLine()
    end
    imgui.EndChild()
    

    anim[strId].progress = Utils.bringFloatTo(anim[strId].progress, anim[strId].expanded and 1 or 0, anim[strId].updatedAt, 1)
    if (not isOption and item.options) then
        local maxHeight = #item.options * itemSize.y
        if (anim[strId].progress > 0) then
            if (maxHeight * anim[strId].progress > 2) then
                imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
                local optionsContainerSize, optionsContainerPos = imgui.ImVec2(itemSize.x, maxHeight * anim[strId].progress), imgui.GetCursorScreenPos()
                drawList:AddRectFilled(optionsContainerPos, optionsContainerPos + optionsContainerSize, UI.Colors.Color.Second.u32, 15, 4 + 8)
                if (imgui.BeginChild("options-for-" .. itemIndex, optionsContainerSize, false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse) or true) then -- "or true" for PopStyleVar
                    imgui.PopStyleVar()
                    for k, v in ipairs(item.options) do
                        drawItem(page, drawList, bgDrawList, itemIndex, v, width, k)
                    end
                end
                imgui.EndChild()
            end
        end
    end
end

---@param drawList ImDrawList
---@param bgDrawList ImDrawList
---@param page Page
---@param size ImVec2
return function(drawList, bgDrawList, page, size)
    imgui.PushFont(UI.Font[15].Bold)
    if (imgui.BeginChild("page-container-" .. page.name, size, true)) then
        local width = imgui.GetWindowWidth()
        local itemWidth = width - 15
        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
        for itemIndex, item in ipairs(page.items) do
            drawItem(page, drawList, bgDrawList, itemIndex, item, itemWidth)
        end
        imgui.PopStyleVar()
    end
    imgui.EndChild()
    imgui.PopFont()
end