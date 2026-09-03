local anim = {
    ["__example"] = {
        active = false,
        updatedAt = 0,
        progress = 0
    }
}

return function(label, v, size)
    if (not anim[label]) then
        anim[label] = {
            active = v[0],
            updatedAt = 0,
            progress = v[0] and 1 or 0
        }
    end

    if (anim[label].active ~= v[0]) then
        anim[label].active = v[0]
    end
    anim[label].progress = Utils.bringFloatTo(anim[label].progress, v[0] and 1 or 0, anim[label].updatedAt, 0.5)

    local drawList = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    drawList:AddRectFilled(p, p + size, UI.Colors.Color.Stroke.u32, 10)
    
    local activePointSize = imgui.ImVec2(size.x / 2, size.y - 2)
    local activePointPosMin = p + imgui.ImVec2(1, 1)
    local activePointPosMax = p + size - imgui.ImVec2(activePointSize.x + 1, 1)
    local activePointPos = imgui.ImVec2(activePointPosMin.x + (activePointPosMax.x - activePointPosMin.x) * anim[label].progress, activePointPosMin.y)
    drawList:AddRectFilled(activePointPos, activePointPos + activePointSize, UI.Colors.Color.First.u32, 7)
    drawList:AddRectFilled(activePointPos, activePointPos + activePointSize, UI.Colors.withAlpha(UI.Colors.Color.Text.u32, anim[label].progress), 7)

    if (imgui.InvisibleButton("button=" .. label, size)) then
        v[0] = not v[0]
        anim[label].updatedAt = os.clock()
        return true
    end
end