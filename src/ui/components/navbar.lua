local anim = {
    current = nil,
    to = nil,
    updatedAt = 0
}

local poslist = {}
-- local selected = {category = 1, page = 1}

---@param drawList ImDrawList
---@param pos ImVec2
---@param size ImVec2
---@param items Category
return function(drawList, pos, size, items)
    local newCategory, newPage
    imgui.PushFont(UI.Font[15].Bold)
    local categories = ModuleCore.categories

    local itemSize = imgui.ImVec2(210, 34)
    for categoryIndex, category in ipairs(categories) do
        imgui.TextColored(imgui.ImVec4(1, 1, 1, 0.5), category.name)
        for pageIndex, page in ipairs(category.pages) do
            local strId = categoryIndex .. ":" .. pageIndex
            
            
            local p = imgui.GetCursorScreenPos()
            if (poslist[strId]) then
                poslist[strId] = p
                if (not anim.current) then
                    anim.current = p
                end
            end

            if (imgui.InvisibleButton("nav-" .. strId, itemSize)) then
                newCategory, newPage = categoryIndex, pageIndex
            end
            if (UI.selected.category == categoryIndex and UI.selected.page == pageIndex) then
                drawList:AddRectFilled(p, p + itemSize, imgui.GetColorU32(imgui.Col.ButtonActive), 10)
            end

            local icon = faicons(page.icon)
            local iconBgSize = imgui.ImVec2(itemSize.y - 10, itemSize.y - 10)
            -- drawList:AddRectFilled(p + imgui.ImVec2(5, 5), p + imgui.ImVec2(5, 5) + iconBgSize, 0xFF0000ff, 5)
            local c = {UI.Colors.getGradientColors(page.color or imgui.ImVec4(0.64, 0.17, 0.17, 1))}
            UI.Components.RoundedGradientRect(drawList, p + imgui.ImVec2(5, 5), iconBgSize, c[1], c[2], c[3], c[4], 5)
    
            local iconSize = imgui.CalcTextSize(icon)
            drawList:AddTextFontPtr(UI.Font[15].Bold, 15, p + imgui.ImVec2(5 + iconBgSize.x / 2 - iconSize.x / 2, 7 + iconBgSize.y / 2 - iconSize.y / 2), 0xFFffffff, icon)
            drawList:AddTextFontPtr(UI.Font[15].Bold, 15, p + imgui.ImVec2(5 + iconBgSize.x + 5, 5 + iconBgSize.y / 2 - 15 / 2), 0xFFffffff, page.name)
        end
        imgui.NewLine()
    end
    imgui.PopFont()
    return newCategory, newPage
end