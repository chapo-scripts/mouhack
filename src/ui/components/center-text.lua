---@param text string
---@param color? ImVec4
return function(text, color)
    imgui.SetCursorPosX(imgui.GetWindowWidth() / 2 - imgui.CalcTextSize(text).x / 2)
    imgui.TextColored(color or imgui.GetStyle().Colors[imgui.Col.Text], text)
end