local Style = {}

function Style:Push(inversed)
    -- print("Style:Push(inversed) CALL", inversed)
    local first = UI.Colors.Color[inversed and "First" or "Second"].vec4
    local second = UI.Colors.Color[inversed and "Second" or "First"].vec4
    local colors = {
        [imgui.Col.FrameBg] = first,
        [imgui.Col.Button] = first,
    }
    local count = 0
    for k, v in pairs(colors) do
        count = count + 1
        imgui.PushStyleColor(k, v)
        -- print(k, v)
    end
    return count
end

function Style:Pop(count)
    imgui.PopStyleColor(count or 1)
end

---@param style imgui.Style
---@param colors table<mimgui.Col, ImVec4>
function Style:ApplyDefaultStyle(style, colors, inversed)
    local first = UI.Colors.Color[inversed and "First" or "Second"].vec4
    local second = UI.Colors.Color[inversed and "Second" or "First"].vec4


    style.WindowPadding = imgui.ImVec2(0, 0)
    style.WindowRounding = 10
    style.FrameRounding = 5
    style.PopupRounding = 15
    style.FramePadding = imgui.ImVec2(5, 5)

    colors[imgui.Col.Text] = imgui.ImVec4(1, 1, 1, 1)
    colors[imgui.Col.Border] = imgui.ImVec4(1, 0, 0, 0)
    colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0, 0, 0, 0.25)
    colors[imgui.Col.FrameBg] = first
    colors[imgui.Col.FrameBgActive] = UI.Colors.Color.Stroke.vec4
    -- colors[imgui.Col.ChildBg] = imgui.ImVec4(1, 0, 0, 0)
end

return setmetatable(Style, { __call = Style.ApplyDefaultStyle })