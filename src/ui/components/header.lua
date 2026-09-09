local searchAnim = {
    hovered = false,
    updatedAt = 0,
    progress = 0
}


return function(totalWindowSize, pos, size)
    local mainWindowSize = imgui.GetWindowSize()
    imgui.SetCursorScreenPos(pos)
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 10))
    if (imgui.BeginChild("menu-header", size, true)) then
        local headerDrawList = imgui.GetWindowDrawList()
        imgui.SetNextItemWidth(250)
        
        -- Search
        imgui.PushFont(UI.Font[15].Bold)
        local searchLabel = faicons("MAGNIFYING_GLASS") .. " Поиск"
        local searchLabelSize = imgui.CalcTextSize(searchLabel)
        local searchButtonSize = imgui.ImVec2(size.x / 3, size.y - 20)
        imgui.SetCursorPos(imgui.ImVec2(totalWindowSize.x / 2 - searchButtonSize.x / 2, 10))
        local p = imgui.GetCursorScreenPos()
        headerDrawList:AddRectFilled(p, p + searchButtonSize, UI.Colors.Color.Second.u32, 10)
        headerDrawList:AddRect(p, p + searchButtonSize, UI.Colors.withAlpha(UI.Colors.Color.Stroke.u32, searchAnim.progress), 10)
        headerDrawList:AddText(p + imgui.ImVec2(searchButtonSize.x / 2 - searchLabelSize.x / 2, searchButtonSize.y / 2 - searchLabelSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, searchAnim.progress + 0.5), searchLabel)
        if (imgui.InvisibleButton("search", searchButtonSize)) then
            UI.SubMenu.Search:Show(true)
        end
        local isHovered = imgui.IsItemHovered()
        if (isHovered) then
            imgui.SetMouseCursor(imgui.MouseCursor.Hand)
        end
        searchAnim.progress = Utils.bringFloatTo(searchAnim.progress, searchAnim.hovered and 1 or 0, searchAnim.updatedAt, 0.5)
        if (searchAnim.hovered ~= isHovered) then
            searchAnim.hovered = isHovered
            searchAnim.updatedAt = os.clock()
        end
        imgui.PopFont()
        
        imgui.SameLine(size.x - ((size.y - 20) * 3) + 15)
        imgui.PushStyleColor(imgui.Col.Button, UI.Colors.Color.Second.vec4)
        imgui.PushFont(UI.Font[20].Bold)
        imgui.PushStyleColor(imgui.Col.ButtonHovered, UI.Colors.Color.Stroke.vec4)
        if (UI.Components.RoundButton("menu:settings", faicons("GEAR"), size.y - 20, true)) then
            UI.SubMenu.Settings:Show(true)
        end
        imgui.PopStyleColor()
        imgui.SameLine()
        imgui.PushStyleColor(imgui.Col.ButtonHovered, UI.Colors.Color.Red.vec4)
        if (UI.Components.RoundButton("menu:close", faicons("XMARK"), size.y - 20)) then
            MainWindowState[0] = false
        end
        imgui.PopStyleColor()
        imgui.PopFont()
        imgui.PopStyleColor()
    end
    imgui.EndChild()
    imgui.PopStyleVar()
end