local PageNav = {
    ---@type table<string, {current: {index: number, x: number, width: number}, to: {index: number, x: number, width: number}, updatedAt: number}>
    anim = {},
    ---@type table<string, {totalWidth: number, items: {x: number, width: number, text: ImVec2}[]}>
    sizes = {},
    animationSpeed = 1
}

---@param strId string
---@param fallback? number
---@return number
function PageNav:GetWidth(strId, fallback)
    local sizes = self.sizes[strId]
    if (not sizes) then
        return fallback or 50
    end
    return sizes.totalWidth
end

---@param strId string
---@return number
function PageNav:GetAnimationState(strId)
    local anim = self.anim[strId]
    if (not anim) then
        return 0
    end
    return anim.current.index
end

---@param strId string
---@param index number
function PageNav:SwitchTo(strId, index)
    assert(self.sizes[strId] and self.sizes[strId].items[index], "Invalid index at " .. strId )
    self.anim[strId].to = { index = index, x = self.sizes[strId].items[index].x, width = self.sizes[strId].items[index].width }
    self.anim[strId].updatedAt = os.clock()
end

---@param strId string
---@param selected mimgui.int
---@param items string[]
---@param fixedItemWidth? number
function PageNav:Draw(strId, selected, items, fixedItemWidth)
    local clicked
    assert(type(items) == "table" and #items > 0, "items must be a string[]")
    assert(selected and selected[0], "selected must be ffi.new(int)")
    
    local currentItem = selected[0]
    local style = imgui.GetStyle()
    local alpha = style.Alpha
    local padding = {
        outer = style.FramePadding,
        inner = style.FramePadding + imgui.ImVec2(style.FramePadding.x, 0)
    }
    local colors = {
        background = imgui.GetColorU32(imgui.Col.FrameBg, alpha),
        selector = imgui.GetColorU32(imgui.Col.FrameBgActive, alpha),
        text = imgui.GetColorU32(imgui.Col.TextDisabled, alpha),
        selectorText = imgui.GetColorU32(imgui.Col.Text, alpha)
    }

     if (not self.sizes[strId]) then
        self.sizes[strId] = { totalWidth = padding.outer.x * 2, items = {} }
        local posX = 0
        for k, v in ipairs(items) do
            local size = imgui.CalcTextSize(v)
            local tabWidth = (fixedItemWidth or size.x) + padding.inner.x * 2
            table.insert(self.sizes[strId].items, {width = tabWidth, x = posX, text = size})
            self.sizes[strId].totalWidth = self.sizes[strId].totalWidth + tabWidth
            posX = posX + tabWidth
        end
    end

    if (not self.anim[strId]) then
        self.anim[strId] = {
            value = selected,
            current = { index = 1, progress = 1, x = self.sizes[strId].items[1].x, width = self.sizes[strId].items[1].width },
            to = { index = 1, progress = 1, x = self.sizes[strId].items[1].x, width = self.sizes[strId].items[1].width },
            updatedAt = 0
        }
    end


    local drawList = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    
    -- Background
    local totalSize = imgui.ImVec2(self.sizes[strId].totalWidth, padding.outer.y * 2 + padding.inner.y * 2 + imgui.GetFontSize())
    drawList:AddRectFilled(p, p + totalSize, colors.background, 20)
    
    -- Process Animation
    self.anim[strId].current.width = Utils.bringFloatTo(self.anim[strId].current.width, self.anim[strId].to.width, self.anim[strId].updatedAt, self.animationSpeed)
    self.anim[strId].current.x = Utils.bringFloatTo(self.anim[strId].current.x, self.anim[strId].to.x, self.anim[strId].updatedAt, self.animationSpeed)
    self.anim[strId].current.index = Utils.bringFloatTo(self.anim[strId].current.index, self.anim[strId].to.index, self.anim[strId].updatedAt, self.animationSpeed)

    -- Current tab
    local currentSize = imgui.ImVec2(self.anim[strId].current.width, totalSize.y - padding.outer.y * 2)
    local currentPos = p + padding.outer + imgui.ImVec2(self.anim[strId].current.x, 0)
    drawList:AddRectFilled(currentPos, currentPos + currentSize, colors.selector, 20)
    
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, padding.outer)
    imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, padding.inner)
    if (imgui.BeginChild("page-nav-" .. strId, totalSize, true)) then
        local childDrawList = imgui.GetWindowDrawList()
        for index, label in ipairs(items) do
            local labelSize, buttonPos, buttonSize = self.sizes[strId].items[index].text, imgui.GetCursorScreenPos(), imgui.ImVec2(self.sizes[strId].items[index].width, currentSize.y)
            -- Unselected label
            childDrawList:AddText(buttonPos + imgui.ImVec2(buttonSize.x / 2 - labelSize.x / 2, buttonSize.y / 2 - labelSize.y / 2), colors.text, label) ---@diagnostic disable-line
            
            -- Selected label
            childDrawList:PushClipRect(currentPos, currentPos + currentSize) ---@diagnostic disable-line
            childDrawList:AddText(buttonPos + imgui.ImVec2(buttonSize.x / 2 - labelSize.x / 2, buttonSize.y / 2 - labelSize.y / 2), colors.selectorText, label) ---@diagnostic disable-line
            childDrawList:PopClipRect() ---@diagnostic disable-line

            -- Click zone
            if (imgui.InvisibleButton(("%s##page-nav-%s-page-%d"):format(label, strId, index), buttonSize)) then
                self:SwitchTo(strId, index)
                selected[0] = index
                clicked = true
            end
            if (imgui.IsItemHovered()) then
                imgui.SetMouseCursor(imgui.MouseCursor.Hand)
            end
            if (index < #items) then
                imgui.SameLine(nil, 0)
            end
        end
    end
    imgui.EndChild()
    imgui.PopStyleVar(2)
    return clicked
end

return setmetatable(PageNav, { __call = PageNav.Draw })