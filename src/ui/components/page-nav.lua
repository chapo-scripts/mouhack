PAGE_NAV_ANIM = {}

local selected = 1

---@param strId string
---@param selected mimgui.int
---@param pages Page[]
---@param oneItemWidth number
return function(strId, selected, pages, oneItemWidth)
    if (not PAGE_NAV_ANIM[strId]) then
        PAGE_NAV_ANIM[strId] = {
            current = 0,
            to = 1,
            start = 0,
        }
    end
    local alpha = imgui.GetStyle().Alpha
    local gap = 0
    local newSelected

    local outerPadding = imgui.ImVec2(5, 5)
    local innerPadding = imgui.ImVec2(10, 5)

    
    imgui.PushFont(UI.Font[15].Bold)
    local itemSize = innerPadding + imgui.ImVec2(oneItemWidth, imgui.GetFontSize()) + innerPadding
    local totalSize = imgui.ImVec2(
        (itemSize.x * #pages) + (gap * #pages - 1) + outerPadding.x + outerPadding.x,
        outerPadding.y + itemSize.y + outerPadding.y
    )
    
    imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - totalSize.x / 2)

    PAGE_NAV_ANIM[strId].current = Utils.bringFloatTo(PAGE_NAV_ANIM[strId].current, PAGE_NAV_ANIM[strId].to, PAGE_NAV_ANIM[strId].start, 1)
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, outerPadding)
    local childPos = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()
    local currentPos = outerPadding + imgui.ImVec2(childPos.x, childPos.y) + imgui.ImVec2((PAGE_NAV_ANIM[strId].current - 1) * itemSize.x, 0)
    dl:AddRectFilled(childPos, childPos + totalSize, UI.Colors.withAlpha(UI.Colors.Color.First.u32, alpha), 100)
    dl:AddRectFilled(currentPos, currentPos + itemSize, UI.Colors.withAlpha(UI.Colors.Color.Stroke.u32, alpha), 100)
    
    
    if (imgui.BeginChild("page-nav", totalSize, true, imgui.WindowFlags.NoBackground)) then
        for index, page in ipairs(pages) do
            local p = imgui.GetCursorScreenPos()
            local labelSize = imgui.CalcTextSize(page.name)
            dl:AddTextFontPtr(imgui.GetFont(), imgui.GetFontSize(), p + imgui.ImVec2(itemSize.x / 2 - labelSize.x / 2, itemSize.y / 2 - labelSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, alpha - 0.5), page.name)
            dl:PushClipRect(currentPos, currentPos + itemSize)
            dl:AddTextFontPtr(imgui.GetFont(), imgui.GetFontSize(), p + imgui.ImVec2(itemSize.x / 2 - labelSize.x / 2, itemSize.y / 2 - labelSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, alpha), page.name)
            dl:PopClipRect()
            if (imgui.InvisibleButton(page.name, itemSize)) then
                PAGE_NAV_ANIM[strId].to = index
                PAGE_NAV_ANIM[strId].start = os.clock()
                selected[0] = index
            end
            if (imgui.IsItemHovered()) then
                imgui.SetMouseCursor(imgui.MouseCursor.Hand)
            end
            imgui.SameLine(nil, gap)
        end
    end
    imgui.EndChild()
    imgui.PopStyleVar()
    imgui.PopFont()
    return newSelected, PAGE_NAV_ANIM[strId].current
end