-- PAGE_NAV_ANIM = {}

-- ---@param strId string
-- ---@param selected mimgui.int
-- ---@param pages {name: string}[]
-- ---@param oneItemWidth number
-- return function(strId, selected, pages, oneItemWidth)
--     if (not PAGE_NAV_self.anim[strId]) then
--         PAGE_NAV_self.anim[strId] = {
--             current = 0,
--             to = 1,
--             start = 0,
--         }
--     end
--     local alpha = imgui.GetStyle().Alpha
--     local gap = 0
--     local newSelected

--     local outerPadding = imgui.ImVec2(5, 5)
--     local innerPadding = imgui.ImVec2(10, 5)

    
--     imgui.PushFont(UI.Font[15].Bold)
--     local itemSize = innerPadding + imgui.ImVec2(oneItemWidth, imgui.GetFontSize()) + innerPadding
--     local totalSize = imgui.ImVec2(
--         (itemSize.x * #pages) + (gap * #pages - 1) + outerPadding.x + outerPadding.x,
--         outerPadding.y + itemSize.y + outerPadding.y
--     )
    
--     imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - totalSize.x / 2)

--     PAGE_NAV_self.anim[strId].current = Utils.bringFloatTo(PAGE_NAV_self.anim[strId].current, PAGE_NAV_self.anim[strId].to, PAGE_NAV_self.anim[strId].start, 1)
--     imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, outerPadding)
--     local childPos = imgui.GetCursorScreenPos()
--     local dl = imgui.GetWindowDrawList()
--     local currentPos = outerPadding + imgui.ImVec2(childPos.x, childPos.y) + imgui.ImVec2((PAGE_NAV_self.anim[strId].current - 1) * itemSize.x, 0)
--     dl:AddRectFilled(childPos, childPos + totalSize, UI.Colors.withAlpha(UI.Colors.Color.First.u32, alpha), 100)
--     dl:AddRectFilled(currentPos, currentPos + itemSize, UI.Colors.withAlpha(UI.Colors.Color.Stroke.u32, alpha), 100)
    
    
--     if (imgui.BeginChild("page-nav", totalSize, true, imgui.WindowFlags.NoBackground)) then
--         for index, page in ipairs(pages) do
--             local p = imgui.GetCursorScreenPos()
--             local labelSize = imgui.CalcTextSize(page.name)
--             dl:AddTextFontPtr(imgui.GetFont(), imgui.GetFontSize(), p + imgui.ImVec2(itemSize.x / 2 - labelSize.x / 2, itemSize.y / 2 - labelSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, alpha - 0.5), page.name)
--             dl:PushClipRect(currentPos, currentPos + itemSize) ---@diagnostic disable-line
--             dl:AddTextFontPtr(imgui.GetFont(), imgui.GetFontSize(), p + imgui.ImVec2(itemSize.x / 2 - labelSize.x / 2, itemSize.y / 2 - labelSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, alpha), page.name)
--             dl:PopClipRect()  ---@diagnostic disable-line
--             if (imgui.InvisibleButton(page.name, itemSize)) then
--                 PAGE_NAV_self.anim[strId].to = index
--                 PAGE_NAV_self.anim[strId].start = os.clock()
--                 selected[0] = index
--             end
--             if (imgui.IsItemHovered()) then
--                 imgui.SetMouseCursor(imgui.MouseCursor.Hand)
--             end
--             imgui.SameLine(nil, gap)
--         end
--     end
--     imgui.EndChild()
--     imgui.PopStyleVar()
--     imgui.PopFont()
--     return newSelected, PAGE_NAV_self.anim[strId].current
-- end

local ANIMATION_SPEED = 1
local PageNav = {
    ---@type table<string, {current: {index: number, x: number, width: number}, to: {index: number, x: number, width: number}, updatedAt: number}>
    anim = {},
    ---@type table<string, {totalWidth: number, items: {x: number, width: number, text: ImVec2}[]}>
    sizes = {}
}

function PageNav:GetWidth(strId, fallback)
    local sizes = self.sizes[strId]
    if (not sizes) then
        return fallback or 50
    end
    return sizes.totalWidth
end

function PageNav:GetAnimationState(strId)
    local anim = self.anim[strId]
    if (not anim) then
        return 0
    end
    return anim.current.index
end

function PageNav:SwitchTo(strId, index)
    for k, v in pairs(self.anim) do print(k, v) end
    assert(self.sizes[strId] and self.sizes[strId].items[index], "Invalid index at " .. strId )
    self.anim[strId].to = { index = index, x = self.sizes[strId].items[index].x, width = self.sizes[strId].items[index].width }
    self.anim[strId].updatedAt = os.clock()
    self.anim[strId].value[0] = index
                
end

function PageNav:Preload(strId, selected, items)
    
end

---@param strId string
---@param selected mimgui.int
---@param items string[]
---@param fixedItemWidth? number
---@param centred? boolean
function PageNav:Draw(strId, selected, items, fixedItemWidth, centred)
    assert(#items > 0 and selected and selected[0])
    local currentItem = selected[0]
    local style = imgui.GetStyle()
    local alpha = style.Alpha
    local colors = {
        background = imgui.GetColorU32(imgui.Col.FrameBg, alpha),
        selector = imgui.GetColorU32(imgui.Col.FrameBgActive, alpha),
        text = imgui.GetColorU32(imgui.Col.TextDisabled, alpha),
        selectorText = imgui.GetColorU32(imgui.Col.Text, alpha)
    }
    local padding = {
        outer = imgui.ImVec2(5, 5),
        inner = imgui.ImVec2(10, 5)
    }

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

    -- s = self.sizes[strId]
    local drawList = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    
    local totalSize = imgui.ImVec2(self.sizes[strId].totalWidth, padding.outer.y * 2 + padding.inner.y * 2 + imgui.GetFontSize())
    drawList:AddRectFilled(p, p + totalSize, colors.background, 20)
    

    self.anim[strId].current.width = Utils.bringFloatTo(self.anim[strId].current.width, self.anim[strId].to.width, self.anim[strId].updatedAt, ANIMATION_SPEED)
    self.anim[strId].current.x = Utils.bringFloatTo(self.anim[strId].current.x, self.anim[strId].to.x, self.anim[strId].updatedAt, ANIMATION_SPEED)
    self.anim[strId].current.index = Utils.bringFloatTo(self.anim[strId].current.index, self.anim[strId].to.index, self.anim[strId].updatedAt, ANIMATION_SPEED)
    -- print(strId, self.anim[strId].progress, self.anim[strId].current.x, self.anim[strId].current.width)

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
            end
            imgui.SameLine(nil, 0)
        end
    end
    imgui.EndChild()
    imgui.PopStyleColor(3)
    imgui.PopStyleVar(2)
end

return setmetatable(PageNav, { __call = PageNav.Draw })