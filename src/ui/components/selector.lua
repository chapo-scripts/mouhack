---@param strId string
---@param size ImVec2
---@param itemWidth number
---@param var mimgui.int
---@param items string[]
return function(strId, size, itemWidth, var, items)
    local arrowButtonWidth = (size.x - itemWidth) / 2
    local drawList, p = imgui.GetWindowDrawList(), imgui.GetCursorScreenPos()
    drawList:AddRectFilled(p, p + size, UI.Colors.Color.First.u32, 10)

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(0, 0, 0, 0))
    local prev = imgui.Button(faicons("CARET_LEFT") .. "##-prev" .. strId, imgui.ImVec2(arrowButtonWidth, size.y))
    imgui.SameLine()
    imgui.Button(items[var[0] + 1], imgui.ImVec2(itemWidth, size.y))
    imgui.SameLine()
    local next = imgui.Button(faicons("CARET_RIGHT") .. "##-next" .. strId, imgui.ImVec2(arrowButtonWidth, size.y))
    imgui.PopStyleColor()

    local nextValue
    if (prev) then
        var[0] = var[0] - 1
    elseif (next) then
        var[0] = var[0] + 1
    end
    if ((var[0]) < 0) then
        var[0] = #items - 1
    elseif ((var[0] + 1) > #items) then
        var[0] = 0
    end
    -- imgui.InvisibleButton("selector-" .. strId, size)
end