local ToggleButton = {
    ---@type {active: boolean, updatedAt: number, progress: number}[]
    anim = {}
}

function ToggleButton:Draw(label, v, size)
    if (not self.anim[label]) then
        self.anim[label] = {
            active = v[0],
            updatedAt = 0,
            progress = v[0] and 1 or 0
        }
    end

    local style = imgui.GetStyle()
    local colors = {
        background = imgui.GetColorU32(imgui.Col.FrameBg, style.Alpha),
        backgroundActive = imgui.GetColorU32(imgui.Col.FrameBgActive, self.anim[label].progress * style.Alpha),
        mark = imgui.GetColorU32(imgui.Col.TextDisabled, style.Alpha),
        markActive = imgui.GetColorU32(imgui.Col.Text, self.anim[label].progress * style.Alpha)
    }

    if (self.anim[label].active ~= v[0]) then
        self.anim[label].active = v[0]
    end
    self.anim[label].progress = Utils.bringFloatTo(self.anim[label].progress, v[0] and 1 or 0, self.anim[label].updatedAt, 0.5)

    local drawList = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    drawList:AddRectFilled(p, p + size, colors.background, style.FrameRounding)
    drawList:AddRectFilled(p, p + size, colors.backgroundActive, style.FrameRounding)
    
    local activePointSize = imgui.ImVec2(size.x / 2, size.y - 4)
    local activePointPosMin = p + imgui.ImVec2(2, 2)
    local activePointPosMax = p + size - imgui.ImVec2(activePointSize.x + 2, 2)
    local activePointPos = imgui.ImVec2(activePointPosMin.x + (activePointPosMax.x - activePointPosMin.x) * self.anim[label].progress, activePointPosMin.y)
    drawList:AddRectFilled(activePointPos, activePointPos + activePointSize, colors.mark, style.FrameRounding)
    drawList:AddRectFilled(activePointPos, activePointPos + activePointSize, colors.markActive, style.FrameRounding)

    if (imgui.InvisibleButton("button=" .. label, size)) then
        v[0] = not v[0]
        self.anim[label].updatedAt = os.clock()
        return true
    end
    if (imgui.IsItemHovered()) then
        imgui.SetMouseCursor(imgui.MouseCursor.Hand)
    end
end

return setmetatable(ToggleButton, { __call = ToggleButton.Draw })