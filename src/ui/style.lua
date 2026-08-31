---@param style imgui.Style
---@param colors table<mimgui.Col, ImVec4>
return function(style, colors)
    style.WindowPadding = imgui.ImVec2(10, 10)
    style.WindowRounding = 10

    colors[imgui.Col.Text] = imgui.ImVec4(1, 1, 1, 1)
end