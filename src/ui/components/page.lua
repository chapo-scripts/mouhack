local HIGHLIGHT_DURATION_SEC = 0.5 * 6
local PageComponent = {
    ---@type {uid: number, startedAt: number, shouldScroll: boolean} | nil
    highlight = nil,
    anim = {
        ["__example"] = {
            expanded = false,
            updatedAt = 0,
            progress = 0
        }
    }
}

---@param uid number
---@param isExpanded boolean
function PageComponent:Expand(uid, isExpanded)
    local strId = "item-" .. uid
    PageComponent.anim[strId].expanded = isExpanded
    PageComponent.anim[strId].updatedAt = os.clock()
end

---@param isExpanded boolean
---@param except number[]
function PageComponent:ExpandAll(isExpanded, except)
    for strId in pairs(self.anim) do
        if (not table.includes(except or {}, tonumber(strId))) then
            self.anim[strId].expanded = isExpanded
            self.anim[strId].updatedAt = os.clock()
        end
    end
end

function PageComponent:IsItemExpanded(uid)
    local strId = "item-" .. uid
    return PageComponent.anim[strId].expanded
end

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
    local strId = "item-" .. item.uid--("%d-item-%d-option-%s"):format(item.uid, itemIndex, optionIndex or "NULL")

    if (not PageComponent.anim[strId]) then
        PageComponent.anim[strId] = {
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
    if (itemIndex == #page.items and not PageComponent.anim[strId].expanded) then
        roundFlags = roundFlags + 4 + 8
    end
    
    drawList:AddRectFilled(itemPos, itemPos + itemSize, isOption and UI.Colors.Color.Second.u32 or UI.Colors.Color.First.u32, 15, roundFlags)
    
    -- highlight
    if (PageComponent.highlight and PageComponent.highlight.uid == item.uid) then
        -- imgui.GetForegroundDrawList():AddRect(itemPos, itemPos + itemSize, UI.Colors.withAlpha(UI.Colors.Color.Text.u32, UI.Blink.alpha), 15)
        drawList:AddRectFilled(itemPos, itemPos + itemSize, UI.Colors.withAlpha(UI.Colors.Color.Stroke.u32, UI.Blink.alpha), 15, roundFlags)
        if (PageComponent.highlight.shouldScroll) then
            imgui.SetScrollHereY(0)
            PageComponent.highlight.shouldScroll = false
        end
        if (os.clock() - PageComponent.highlight.startedAt > HIGHLIGHT_DURATION_SEC) then
            PageComponent.highlight = nil
        end
    end
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
            UI.Components.ImRotate.End(math.rad(180 - (90 * PageComponent.anim[strId].progress)));
            imgui.SameLine(nil, 10)
        end
        imgui.Text(item.label)
        if (imgui.IsItemClicked(1)) then
            sampAddChatMessage("E", -1)
            UI.Components.Page:Expand(item.uid, true)
        end

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
            PageComponent:Expand(item.uid, not PageComponent:IsItemExpanded(item.uid))
        end
        if (item.options and imgui.IsItemHovered()) then
            imgui.SetMouseCursor(imgui.MouseCursor.Hand)
        end
        imgui.SameLine()
        -- Item
        local defaultElementHeight = imgui.GetFontSize() + style.FramePadding.y * 2
        local count = UI.Style:Push(isOption)
        imgui.SetCursorPosY(itemSize.y / 2 - defaultElementHeight / 2)
        if (item.type == PageItemType.Toggle) then
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - 40 - 15, itemSize.y / 2 - 10))
            UI.Components.TggleButton(item.label, item.value, imgui.ImVec2(40, 20))
        elseif (item.type == PageItemType.Button) then
            local size = item.size or imgui.CalcTextSize(item.text) + style.FramePadding + style.FramePadding
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - size.x - 15, itemSize.y / 2 - size.y / 2))
            -- imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(1, 1, 0, 1))
            if (UI.Components.Button(item.text .. "##" .. strId, size)) then
                item.onClick()
            end
            -- imgui.PopStyleColor()
        elseif (item.type == PageItemType.Input) then
            local inputHeight = imgui.GetFontSize() + style.FramePadding.y * 2
            local inputWidth = item.width or 40
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - inputWidth - 15, itemSize.y / 2 - inputHeight / 2))
            imgui.SetNextItemWidth(inputWidth)
            if (imgui.InputTextWithHint("##" .. strId, item.hint or "", item.value, ffi.sizeof(item.value), item.flags or 0)) then
                if (item.onChange) then
                    item.onChange()
                end
            end
        elseif (item.type == PageItemType.NoAction) then
            -- No action
        elseif (item.type == PageItemType.InputInt) then

        elseif (item.type == PageItemType.TextArea) then

        elseif (item.type == PageItemType.Checkbox) then
            ---@cast item PageItem.Checkbox
            local elementSize = style.FramePadding * 2 + imgui.ImVec2(imgui.GetFontSize(), imgui.GetFontSize())
            imgui.SetCursorPos(imgui.ImVec2(itemSize.x - elementSize.x - 15, itemSize.y / 2 - elementSize.y / 2))
            imgui.Checkbox("##" .. item.label, item.value)
        elseif (item.type == PageItemType.Color) then
        elseif (item.type == PageItemType.Selector) then
            ---@cast item PageItem.Selector
            local currentItem = item.items[item.value[0] + 1]
            local currentItemSize = imgui.CalcTextSize(currentItem)
            local elementSize = style.FramePadding * 2 + imgui.ImVec2(currentItemSize.x, imgui.GetFontSize())
            UI.Components.Selector("selector-" .. strId, elementSize, currentItemSize.x, item.value, item.items)
        elseif (item.type == PageItemType.Combo) then
            ---@cast item PageItem.Combo
            local width = item.width or 100
            imgui.SetCursorPosX(itemSize.x - 20 - width)
            imgui.SetNextItemWidth(width)
            imgui.ComboStr("##combo-" .. strId, item.value, table.concat(item.items, "\0") .. "\0")
        else
            imgui.SameLine()
            imgui.TextColored(UI.Colors.Color.Red.vec4, "UNSUPPORTED_TYPE " .. tostring(item.type))
        end
        UI.Style:Pop(count)
        imgui.SameLine()

        if (item.onFrame) then
            item.onFrame(drawList)
        end
    end
    imgui.EndChild()
    

    PageComponent.anim[strId].progress = Utils.bringFloatTo(PageComponent.anim[strId].progress, PageComponent.anim[strId].expanded and 1 or 0, PageComponent.anim[strId].updatedAt, 1)
    if (item.options) then
        local maxHeight = #item.options * itemSize.y
        if (PageComponent.anim[strId].progress > 0) then
            if (maxHeight * PageComponent.anim[strId].progress > 2) then
                imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
                local optionsContainerSize, optionsContainerPos = imgui.ImVec2(itemSize.x, maxHeight * PageComponent.anim[strId].progress), imgui.GetCursorScreenPos()
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
function PageComponent:Draw(drawList, bgDrawList, page, size)
    imgui.PushFont(UI.Font[15].Bold)
    local fd = imgui.GetForegroundDrawList()
    local p = imgui.GetCursorScreenPos()    
    
    if (imgui.BeginChild("page-container-" .. page.name, size, true, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)) then
        UI.Components.Scroller("page-scroller-" .. page.name, 70, 350)
        local pContDrawList = imgui.GetWindowDrawList()
        local width = imgui.GetWindowWidth()
        local itemWidth = width - 15
        imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
        for itemIndex, item in ipairs(page.items) do
            drawItem(page, drawList, bgDrawList, itemIndex, item, itemWidth)
        end

        -- Top and bottom darken
        do
            local scrollY = imgui.GetScrollY()
            local col, colUpper, colTrans = imgui.GetColorU32(imgui.Col.FrameBg), imgui.GetColorU32(imgui.Col.FrameBg, 0.5 * (scrollY / 10)), imgui.GetColorU32(imgui.Col.FrameBg, 0)
            if (scrollY > 0) then
                pContDrawList:AddRectFilledMultiColor(p, p + imgui.ImVec2(size.x, 50), colUpper, colUpper, colTrans, colTrans)
            end
            fd:AddText(p, 0xFFffffff, ("Y %d, MAX %d, %s"):format(scrollY, imgui.GetScrollMaxY(), 0.5 * (scrollY / 10)))
            if (imgui.GetScrollMaxY() > 0) then
                pContDrawList:AddRectFilledMultiColor(p + imgui.ImVec2(0, size.y), p + imgui.ImVec2(size.x, size.y - 50), col, col, colTrans, colTrans)
            end
        end
        imgui.PopStyleVar()
    end
    imgui.EndChild()
    imgui.PopFont()
end

return setmetatable(PageComponent, {__call = PageComponent.Draw})