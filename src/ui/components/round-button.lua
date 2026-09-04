ROUND_BUTTON_ANIM = {}

-- TODO: Add click/active animation
return function(strId, icon, width)
    local c = imgui.GetStyle().Colors
    if (not ROUND_BUTTON_ANIM[strId]) then
        ROUND_BUTTON_ANIM[strId] = {
            hovered = false,
            color = c[imgui.Col.Button],
            nextColor = c[imgui.Col.Button],
            updatedAt = 0
        }
    end
    
    local nextColor = ROUND_BUTTON_ANIM[strId].hovered and c[imgui.Col.ButtonHovered] or c[imgui.Col.Button]
    ROUND_BUTTON_ANIM[strId].color = Utils.bringVec4To(ROUND_BUTTON_ANIM[strId].color, nextColor, ROUND_BUTTON_ANIM[strId].updatedAt, 1)
    
    local p = imgui.GetCursorScreenPos()
    local result = imgui.InvisibleButton(icon .. strId, imgui.ImVec2(width, width))
    local isHovered, isActive = imgui.IsItemHovered(), imgui.IsItemActive()

    if (ROUND_BUTTON_ANIM[strId].hovered ~= isHovered) then
        ROUND_BUTTON_ANIM[strId].hovered = isHovered
        ROUND_BUTTON_ANIM[strId].updatedAt = os.clock()
    end
    local drawList = imgui.GetWindowDrawList()

    local iconSize = imgui.CalcTextSize(icon)
    drawList:AddCircleFilled(p + imgui.ImVec2(width / 2, width / 2), width / 2, imgui.GetColorU32Vec4(ROUND_BUTTON_ANIM[strId].color))
    drawList:AddText(p + imgui.ImVec2(width / 2 - iconSize.x / 2, width / 2 - iconSize.y / 2 + 2), imgui.GetColorU32(imgui.Col.Text), icon)

    return result
end