local Item = require("ui.components.page.item")

local PageComponent = {
    Item = Item,
}
---@param size ImVec2
---@param drawList ImDrawList
---@param pageIndex number
---@param page Page
function PageComponent:Draw(size, drawList, pageIndex, page, category)
    local currentCategoryIndex = UI.Components.Nav.currentTab
    local fgdl = imgui.GetForegroundDrawList()
    local p = imgui.GetCursorScreenPos()
    -- fgdl:AddRect(p, p + size, 0xFF00ff00)

    local drawList, bgDrawList = imgui.GetWindowDrawList(), imgui.GetBackgroundDrawList()

    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 0))
    imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 0))
    if (imgui.BeginChild("page-container-" .. pageIndex, size, true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)) then
        UI.Components.Scroller("page-scroller-" .. pageIndex, 150, 150)
        imgui.PushFont(UI.Font[15].Bold)
        for itemIndex, item in ipairs(page.funcs) do
            Item:Draw(page, drawList, bgDrawList, itemIndex, item, nil)
            -- imgui.Text(tostring(item.label or "NULL"))
        end
        imgui.PopFont()
    end
    imgui.EndChild()
    imgui.PopStyleVar(2)
end

return setmetatable(PageComponent, { __call = PageComponent.Draw })