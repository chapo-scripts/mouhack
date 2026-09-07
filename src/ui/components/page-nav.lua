local ANIMATION_SPEED = 1
local PageNav = {
    ---@type table<string, {current: {index: number, x: number, width: number}, to: {index: number, x: number, width: number}, updatedAt: number}>
    anim = {},
    ---@type table<string, {totalWidth: number, items: {x: number, width: number, text: ImVec2}[]}>
    sizes = {},
    preloaded = false
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
    for k, v in pairs(self.anim) do print(k, v) end
    assert(self.sizes[strId] and self.sizes[strId].items[index], "Invalid index at " .. strId )
    self.anim[strId].to = { index = index, x = self.sizes[strId].items[index].x, width = self.sizes[strId].items[index].width }
    self.anim[strId].updatedAt = os.clock()
end

---@param list {strId: string, items: string[]}[]
function PageNav:Preload(list)
    for _, navData in ipairs(list) do
        if (not self.sizes[navData.strId]) then
            self:CalcSizes(navData.strId, navData.items)
        end
        print("PRELOAD PAGENAV", navData.strId)
    end
end

---@param strId string
---@param items string[]
---@param currentItem? number
function PageNav:CalcSizes(strId, items, currentItem)
    local padding = imgui.GetStyle().FramePadding
    local innerPadding = padding + imgui.ImVec2(padding.x, 0)
    self.sizes[strId] = { totalWidth = padding.x * 2, items = {} }
    local posX = 0
    -- for _, label in ipairs(items) do
    --     local size = imgui.CalcTextSize(label)
    --     local tabWidth = size.x + innerPadding.x * 2
    --     table.insert(self.sizes[strId].items, {width = tabWidth, x = posX, text = size})
    --     self.sizes[strId].totalWidth = self.sizes[strId].totalWidth + tabWidth
    --     posX = posX + tabWidth
    -- end

    -- if (not self.anim[strId]) then
    --     if (not currentItem) then
    --         currentItem = 1
    --     end
    --     self.anim[strId] = {
    --         current = { index = currentItem, x = self.sizes[strId].items[currentItem].x, width = self.sizes[strId].items[currentItem].width },
    --         to = { index = currentItem, x = self.sizes[strId].items[currentItem].x, width = self.sizes[strId].items[currentItem].width },
    --         updatedAt = 0
    --     }
    -- end
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

    if (not self.sizes[strId] or not self.anim[strId]) then
        -- self:CalcSizes(strId, items)
    end
     if (not self.sizes[strId]) then
        self.sizes[strId] = { totalWidth = padding.outer.x * 2, items = {} }
        local posX = 0
        for k, v in ipairs(items) do
            local size = imgui.CalcTextSize(v)
            local tabWidth = size.x + padding.inner.x * 2
            table.insert(self.sizes[strId].items, {width = tabWidth, x = posX, text = size})
            self.sizes[strId].totalWidth = self.sizes[strId].totalWidth + tabWidth
            posX = posX + tabWidth
        end
    end

    if (not self.anim[strId]) then
        for k, v in ipairs(self.sizes[strId].items) do print(k, v) end
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
    self.anim[strId].current.width = Utils.bringFloatTo(self.anim[strId].current.width, self.anim[strId].to.width, self.anim[strId].updatedAt, ANIMATION_SPEED)
    self.anim[strId].current.x = Utils.bringFloatTo(self.anim[strId].current.x, self.anim[strId].to.x, self.anim[strId].updatedAt, ANIMATION_SPEED)
    self.anim[strId].current.index = Utils.bringFloatTo(self.anim[strId].current.index, self.anim[strId].to.index, self.anim[strId].updatedAt, ANIMATION_SPEED)

    -- Current tab
    local currentSize = imgui.ImVec2(self.anim[strId].current.width, totalSize.y - padding.outer.y * 2)
    local currentPos = p + padding.outer + imgui.ImVec2(self.anim[strId].current.x, 0)
    drawList:AddRectFilled(currentPos, currentPos + currentSize, colors.selector, 20)
    
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, padding.outer)
    imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, padding.inner)
    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(0, 0, 0, 0))
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(0, 0, 0, 0))
    if (imgui.BeginChild("page-nav-" .. strId, totalSize, true)) then
        local childDrawList = imgui.GetWindowDrawList()
        for index, label in ipairs(items) do
            local labelSize, buttonPos, buttonSize = self.sizes[strId].items[index].text, imgui.GetCursorScreenPos(), imgui.ImVec2(self.sizes[strId].items[index].width, currentSize.y)
            childDrawList:AddText(buttonPos + imgui.ImVec2(buttonSize.x / 2 - labelSize.x / 2, buttonSize.y / 2 - labelSize.y / 2), colors.text, label) ---@diagnostic disable-line
            
            childDrawList:PushClipRect(currentPos, currentPos + currentSize) ---@diagnostic disable-line
            childDrawList:AddText(buttonPos + imgui.ImVec2(buttonSize.x / 2 - labelSize.x / 2, buttonSize.y / 2 - labelSize.y / 2), colors.selectorText, label) ---@diagnostic disable-line
            childDrawList:PopClipRect() ---@diagnostic disable-line
            if (imgui.InvisibleButton(("%s##page-nav-%s-page-%d"):format(label, strId, index), buttonSize)) then
                self:SwitchTo(strId, index)
                -- selected[0] = index
                clicked = true
            end
            imgui.SameLine(nil, 0)
        end
    end
    imgui.EndChild()
    imgui.PopStyleColor(3)
    imgui.PopStyleVar(2)
    return clicked
end

return setmetatable(PageNav, { __call = PageNav.Draw })