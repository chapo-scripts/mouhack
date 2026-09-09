local Item = require("ui.components.page.item")

---@param size ImVec2
---@param drawList ImDrawList
---@param pageIndex number
---@param page Page
return function(size, drawList, pageIndex, page, category)
    local currentCategoryIndex = UI.Components.Nav.currentTab
    local fgdl = imgui.GetForegroundDrawList()
    local p = imgui.GetCursorScreenPos()
    -- fgdl:AddRect(p, p + size, 0xFF00ff00)

    local drawList, bgDrawList = imgui.GetWindowDrawList(), imgui.GetBackgroundDrawList()

    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
    imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
    if (imgui.BeginChild("page-container-" .. pageIndex, size, true)) then
        imgui.PushFont(UI.Font[15].Bold)
        for itemIndex, item in ipairs(page.items) do
            Item:Draw(page, drawList, bgDrawList, itemIndex, item, nil)
        end
        imgui.PopFont()
    end
    imgui.EndChild()
    imgui.PopStyleVar(2)
end