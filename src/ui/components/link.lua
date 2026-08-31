---@param link string
---@param text string
---@param disableClickAction? boolean
---@return boolean
return function(link, text, disableClickAction) -- https://www.blast.hk/threads/13380/post-507875
    text = text or link
    local tSize = imgui.CalcTextSize(text)
    local p = imgui.GetCursorScreenPos()
    local DL = imgui.GetWindowDrawList()
    local col = { 0xFFFF7700, 0xFFFF9900 }
    local result = imgui.InvisibleButton("##" .. link, tSize)
    local color = imgui.IsItemHovered() and col[1] or col[2]
    DL:AddText(p, color, text)
    DL:AddLine(imgui.ImVec2(p.x, p.y + tSize.y), imgui.ImVec2(p.x + tSize.x, p.y + tSize.y), color)
    if (result and not disableClickAction) then
        os.execute("explorer " .. link)
    end
    return result ---@diagnostic disable-line
end