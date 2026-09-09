local HIGHLIGHT_DURATION_SEC = 0.5 * 6
local Item = {
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
function Item:Expand(uid, isExpanded)
    local strId = "item-" .. uid
    self.anim[strId].expanded = isExpanded
    self.anim[strId].updatedAt = os.clock()
end

---@param isExpanded boolean
---@param except number[]
function Item:ExpandAll(isExpanded, except)
    for strId in pairs(self.anim) do
        if (not table.includes(except or {}, tonumber(strId))) then
            self.anim[strId].expanded = isExpanded
            self.anim[strId].updatedAt = os.clock()
        end
    end
end

function Item:IsItemExpanded(uid)
    local strId = "item-" .. uid
    return self.anim[strId].expanded
end

---@param strId string
---@param itemIndex number
---@param item PageItem
function Item:DrawItemControls(strId, itemIndex, item)
    local elementStrId = "##" .. strId .. "-item-" .. itemIndex
    local style = imgui.GetStyle()
    local winSize, fontSize, framePadding = imgui.GetWindowSize(), imgui.GetFontSize(), style.FramePadding
    local itemWidth = item.width or 150
    local itemHeight = item.height or imgui.GetFontSize() + style.FramePadding.y * 2
    local paddingFromEnd = (winSize.y - itemHeight) / 2
    local function call(fn, ...)
        if (type(item[fn]) == "function") then
            item[fn](item, ...)
        end
    end

    local element
    imgui.SetCursorPosX(winSize.x - paddingFromEnd - itemWidth)
    imgui.SetCursorPosY(winSize.y / 2 - itemHeight / 2)
    imgui.SetNextItemWidth(itemWidth)
    if (item.type == PageItemType.Toggle) then
        ---@cast item PageItem.Toggle
        imgui.SetCursorPosX(winSize.x - paddingFromEnd - framePadding.x * 2 - itemHeight * 2)
        imgui.SetCursorPosY(winSize.y / 2 - 20 / 2)
        UI.Components.TggleButton:Draw(elementStrId, item.value, imgui.ImVec2(itemHeight * 2, 20))
    elseif (item.type == PageItemType.Button) then
        ---@cast item PageItem.Button
        local buttonText = (item.text or item.label) .. "##" .. item.uid
        local buttonSize = item.size or (imgui.CalcTextSize(buttonText) + framePadding + framePadding)
        imgui.SetCursorPosX(winSize.x - paddingFromEnd - buttonSize.x)
        element = UI.Components.Button(buttonText, buttonSize)
    elseif (item.type == PageItemType.Text) then
        ---@cast item PageItem.Text
    elseif (item.type == PageItemType.NoAction) then
        ---@cast item PageItem.NoAction
    elseif (item.type == PageItemType.Selector) then
        ---@cast item PageItem.Selector
    elseif (item.type == PageItemType.Combo) then
        ---@cast item PageItem.Combo
        element = imgui.ComboStr(elementStrId, item.value, table.concat(item.items, "\0") .. "\0")
    elseif (item.type == PageItemType.Frame) then
        ---@cast item PageItem.Frame
    elseif (item.type == PageItemType.Input) then
        ---@cast item PageItem.Input
        element = imgui.InputTextWithHint(elementStrId, item.hint or "", item.value, ffi.sizeof(item.value), item.flags or 0)
    elseif (item.type == PageItemType.InputInt) then
        ---@cast item PageItem.InputInt
    elseif (item.type == PageItemType.TextArea) then
        ---@cast item PageItem.TextArea
        imgui.InputTextWithHint(elementStrId, item.hint or "", item.value, ffi.sizeof(item.value), item.flags or 0)
        if (imgui.IsItemClicked(0)) then
            imgui.OpenPopup(elementStrId .. "-popup")
        end
        if (imgui.BeginPopupModal(elementStrId .. "-popup", nil, imgui.WindowFlags.NoTitleBar)) then
            local size = imgui.GetWindowSize()
            imgui.PushFont(UI.Font[20].Bold)
            imgui.Text(item.label)
            imgui.SameLine()
            if (imgui.Button("X##" .. elementStrId)) then
                imgui.CloseCurrentPopup()
            end
            imgui.PopFont()
            element = imgui.InputTextMultiline(elementStrId, item.value, ffi.sizeof(item.value), size - imgui.ImVec2(30, imgui.GetCursorPosY()))
            imgui.EndPopup()
        end
    elseif (item.type == PageItemType.Checkbox) then
        ---@cast item PageItem.Checkbox
        imgui.SetCursorPosX(winSize.x - paddingFromEnd - framePadding.x * 2 - fontSize)
        element = imgui.Checkbox(elementStrId, item.value)
    elseif (item.type == PageItemType.Color) then
        ---@cast item PageItem.Color
    elseif (item.type == PageItemType.SliderFloat) then
        ---@cast item PageItem.SliderFloat
        element = imgui.SliderFloat(elementStrId, item.value, item.min, item.max, item.format or "%0.1f")
    elseif (item.type == PageItemType.SliderInt) then
        ---@cast item PageItem.SliderInt
        element = imgui.SliderInt(elementStrId, item.value, item.min, item.max, item.format or "%0.1f")
    end

    if (element) then
        call("onClick")
    end
    --[[
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
        elseif (item.type == PageItemType.SliderFloat) then
            ---@cast item PageItem.SliderFloat
            local width = item.width or 100
            imgui.SetCursorPosX(itemSize.x - 20 - width)
            imgui.SetNextItemWidth(width)
            imgui.SliderFloat("##sliderfloat-" .. strId, item.value, item.min, item.max, item.format or "%0.1f")
        else
            imgui.SameLine()
            imgui.TextColored(UI.Colors.Color.Red.vec4, "UNSUPPORTED_TYPE " .. tostring(item.type))
        end
    ]]
end

function Item:ProcessItemAnimation(strId, isHovered)
    if (not self.anim[strId]) then
        self.anim[strId] = {
            expaneded = false,
            progress = 0,
            updatedAt = 0
        }
    end
    self.anim[strId].progress = Utils.bringFloatTo(self.anim[strId].progress, self.anim[strId].expanded and 1 or 0, self.anim[strId].updatedAt, 1)
end

function Item:DrawItemLabels(strId, item)
    imgui.SetCursorPos(imgui.ImVec2(15, imgui.GetWindowHeight() / 2 - imgui.GetFontSize() / 2))
    if (item.options) then
        UI.Components.ImRotate.Start();
        imgui.Text(faicons("CARET_DOWN"))
        UI.Components.ImRotate.End(math.rad(180 - (90 * self.anim[strId].progress)));
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
    -- if (item.description) then
    --     imgui.SameLine(nil, 10)
    --     imgui.TextDisabled(item.description)
    -- end
end

---@param page Page
---@param drawList ImDrawList
---@param bgDrawList ImDrawList
---@param itemIndex number
---@param item PageItem
---@param optionIndex? number
function Item:Draw(page, drawList, bgDrawList, itemIndex, item, optionIndex)
    local isOption = optionIndex ~= nil
    local drawList = imgui.GetWindowDrawList()
    local strId = "item-" .. item.uid

    self:ProcessItemAnimation(strId)

    local itemSize = imgui.ImVec2(imgui.GetWindowWidth(), 48)
    local style = imgui.GetStyle()

    if (not isOption and itemIndex > 1) then
        local linePos = imgui.GetCursorScreenPos()
        drawList:AddLine(linePos, linePos + imgui.ImVec2(itemSize.x, 0), UI.Colors.Color.Stroke.u32, 1)
    end

    local itemPos = imgui.GetCursorScreenPos()

    local roundFlags = 0
    if (itemIndex == 1) then
        roundFlags = roundFlags + 1 + 2
    end
    if (itemIndex == #page.items and not self.anim[strId].expanded) then
        roundFlags = roundFlags + 4 + 8
    end
    
    drawList:AddRectFilled(itemPos, itemPos + itemSize, isOption and UI.Colors.Color.Second.u32 or UI.Colors.Color.First.u32, 15, roundFlags)
    
    -- highlight
    if (self.highlight and self.highlight.uid == item.uid) then
        -- imgui.GetForegroundDrawList():AddRect(itemPos, itemPos + itemSize, UI.Colors.withAlpha(UI.Colors.Color.Text.u32, UI.Blink.alpha), 15)
        drawList:AddRectFilled(itemPos, itemPos + itemSize, UI.Colors.withAlpha(UI.Colors.Color.Stroke.u32, UI.Blink.alpha), 15, roundFlags)
        if (self.highlight.shouldScroll) then
            imgui.SetScrollHereY(0)
            self.highlight.shouldScroll = false
        end
        if (os.clock() - self.highlight.startedAt > HIGHLIGHT_DURATION_SEC) then
            self.highlight = nil
        end
    end
    if (itemIndex > 1 and not isOption) then
        drawList:AddLine(itemPos - imgui.ImVec2(0, 1), imgui.ImVec2(itemPos.x + itemSize.x, itemPos.y - 1), UI.Colors.Color.Stroke.u32)
    end
    if (imgui.BeginChild("container-" .. strId, itemSize, true, imgui.WindowFlags.NoScrollWithMouse + imgui.WindowFlags.NoScrollbar)) then
        imgui.SetCursorPos(imgui.ImVec2(0, 0))
        
        -- Label and tags
        self:DrawItemLabels(strId, item)
        
        -- Expand click zone
        imgui.SetCursorPos(imgui.ImVec2(0, 0))
        if (imgui.InvisibleButton("clickzone-" .. strId, imgui.ImVec2(itemSize.x / 2, itemSize.y))) then
            Item:Expand(item.uid, not Item:IsItemExpanded(item.uid))
        end
        if (item.options and imgui.IsItemHovered()) then
            imgui.SetMouseCursor(imgui.MouseCursor.Hand)
        end
        imgui.SameLine()

        -- Item
        local defaultElementHeight = imgui.GetFontSize() + style.FramePadding.y * 2
        local count = UI.Style:Push(isOption)
        imgui.SetCursorPosY(itemSize.y / 2 - defaultElementHeight / 2)
        self:DrawItemControls(strId, itemIndex, item)
        UI.Style:Pop(count)
        imgui.SameLine()

        if (item.onFrame) then
            item.onFrame(drawList)
        end
    end
    imgui.EndChild()
    

    
    if (item.options) then
        local maxHeight = #item.options * itemSize.y
        if (self.anim[strId].progress > 0) then
            if (maxHeight * self.anim[strId].progress > 2) then
                imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
                local optionsContainerSize, optionsContainerPos = imgui.ImVec2(itemSize.x, maxHeight * self.anim[strId].progress), imgui.GetCursorScreenPos()
                drawList:AddRectFilled(optionsContainerPos, optionsContainerPos + optionsContainerSize, UI.Colors.Color.Second.u32, 15, 4 + 8)
                if (imgui.BeginChild("options-for-" .. itemIndex, optionsContainerSize, false, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse) or true) then -- "or true" for PopStyleVar
                    imgui.PopStyleVar()
                    for k, v in ipairs(item.options) do
                        self:Draw(page, drawList, bgDrawList, itemIndex, v, k)
                    end
                end
                imgui.EndChild()
            end
        end
    end
end

return Item