---@param style imgui.Style
---@param colors table<mimgui.Col, ImVec4>
return function(style, colors)
    style.WindowPadding = imgui.ImVec2(0, 0)
    style.WindowRounding = 10
    style.FrameRounding = 5
    style.PopupRounding = 15
    style.FramePadding = imgui.ImVec2(5, 5)

    colors[imgui.Col.Text] = imgui.ImVec4(1, 1, 1, 1)
    colors[imgui.Col.Border] = imgui.ImVec4(1, 0, 0, 1)

    colors[imgui.Col.FrameBg] = UI.Colors.Color.First.vec4
    colors[imgui.Col.FrameBgActive] = UI.Colors.Color.Stroke.vec4
    -- colors[imgui.Col.ChildBg] = imgui.ImVec4(1, 0, 0, 0)
end