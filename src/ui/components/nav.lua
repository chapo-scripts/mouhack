local anim = {
    current = 1,
    progress = 1,
    updatedAt = 0
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
        local firstPos = imgui.GetCursorScreenPos()
        local oneItemSize = imgui.ImVec2(size.x, 74)
         -- draw selected
        local currentPos = firstPos + imgui.ImVec2(0, oneItemSize.y * (anim.progress - 1))
        local blockPos = imgui.ImVec2(size.x, 15)
        drawList:AddRectFilled(currentPos, currentPos + oneItemSize, UI.Colors.Color.Second.u32, 15, 8)
        drawList:AddRectFilled(currentPos, currentPos + blockPos, UI.Colors.Color.First.u32, 15, 8)
        drawList:AddRectFilled(currentPos + imgui.ImVec2(0, oneItemSize.y - blockPos.y), currentPos + imgui.ImVec2(0, oneItemSize.y - blockPos.y) + blockPos, UI.Colors.Color.First.u32, 15, 2)
        
        for k, v in ipairs(items) do
            local labelSize, iconSize = imgui.CalcTextSize(v.name), imgui.CalcTextSize(faicons("PERSON_WALKING"))
            local p = imgui.GetCursorScreenPos()
            drawList:AddTextFontPtr(UI.Font[20].Bold, 20, p + imgui.ImVec2(25, oneItemSize.y / 2 - labelSize.y / 2), 0xFFffffff, faicons("PERSON_WALKING"))
            drawList:AddTextFontPtr(UI.Font[20].Bold, 20, p + imgui.ImVec2(25 + iconSize.x + 25, oneItemSize.y / 2 - labelSize.y / 2), 0xFFffffff, v.name)
            if imgui.InvisibleButton(v.name, oneItemSize) then
                newCategory = k
                anim.current = k
                anim.updatedAt = os.clock()
            end
        end
    end
    imgui.EndChild()
    imgui.PopStyleVar()
    imgui.PopFont()
    return newCategory
end