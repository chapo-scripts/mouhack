local anim = {
    current = 1,
    progress = 1,
    updatedAt = 0,
    hover = {}
}

---@param drawList ImDrawList
---@param pos ImVec2
---@param size ImVec2
---@param items Category[]
return function(drawList, pos, size, items, selected)
    local newCategory

    anim.progress = Utils.bringFloatTo(anim.progress, anim.current, anim.updatedAt, 1)
    imgui.PushFont(UI.Font[20].Bold)
    imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
    if (imgui.BeginChild("menu-nav", size, true)) then
        -- imgui.NewLine()
        local firstPos = imgui.GetCursorScreenPos()
        local oneItemSize = imgui.ImVec2(size.x, 50)
         -- draw selected
        local currentPos = firstPos + imgui.ImVec2(0, oneItemSize.y * (anim.progress - 1))
        local blockPos = imgui.ImVec2(size.x, 15)
        local blockSize = imgui.ImVec2(oneItemSize.x, 10)
        local blockBgSize = imgui.ImVec2(oneItemSize.x, oneItemSize.y + blockSize.y * 2)
        drawList:AddRectFilled(currentPos - imgui.ImVec2(0, blockSize.y), currentPos + imgui.ImVec2(0, blockSize.y) + oneItemSize, UI.Colors.Color.Second.u32, 15, 0)

        -- upper
        drawList:AddRectFilled(currentPos - imgui.ImVec2(0, blockSize.y * 2), currentPos + imgui.ImVec2(blockSize.x, 0), UI.Colors.Color.First.u32, 15, 8)

        drawList:AddRectFilled(currentPos + imgui.ImVec2(0, oneItemSize.y), currentPos + imgui.ImVec2(blockSize.x, blockSize.y + oneItemSize.y + 10), UI.Colors.Color.First.u32, 15, 2)

        -- lower
        -- drawList:AddRectFilled(currentPos + imgui.ImVec2(0, 10 + oneItemSize.y - blockPos.y), currentPos + imgui.ImVec2(0, 10 + oneItemSize.y - blockPos.y) + blockPos, UI.Colors.Color.Red.u32, 15, 2)
        
        
        for k, v in ipairs(items) do
            if (not anim.hover[k]) then
                anim.hover[k] = { hovered = false, updatedAt = 0, progress = 0, current = 0 }
            end
            anim.hover[k].current = Utils.bringFloatTo(anim.hover[k].current, anim.hover[k].hovered and 1 or 0, anim.hover[k].updatedAt, 1)

            local labelSize, iconSize = imgui.CalcTextSize(v.name), imgui.CalcTextSize(faicons("PERSON_WALKING"))
            local p = imgui.GetCursorScreenPos()
            local labelPos = p + imgui.ImVec2(oneItemSize.x / 2 - labelSize.x / 2, oneItemSize.y / 2 - labelSize.y / 2)
            -- drawList:AddTextFontPtr(UI.Font[20].Bold, 20, p + imgui.ImVec2(25, oneItemSize.y / 2 - labelSize.y / 2), 0xFFffffff, faicons("PERSON_WALKING"))
            drawList:AddTextFontPtr(UI.Font[20].Bold, 20, labelPos, UI.Colors.withAlpha(UI.Colors.Color.Text.u32, anim.hover[k].current + 0.5), v.name)
            if imgui.InvisibleButton(v.name, oneItemSize) then
                newCategory = k
                anim.current = k
                anim.updatedAt = os.clock()
            end
            local isHovered = imgui.IsItemHovered() or anim.current == k
            if (isHovered ~= anim.hover[k].hovered) then
                anim.hover[k].hovered = isHovered
                anim.hover[k].updatedAt = os.clock()
            end
        end
    end
    imgui.EndChild()
    imgui.PopStyleVar()
    imgui.PopFont()
    return newCategory
end