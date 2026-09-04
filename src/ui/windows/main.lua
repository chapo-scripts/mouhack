---@global
MainWindowState = imgui.new.bool(true)

local searchAnim = {
    hovered = false,
    updatedAt = 0,
    progress = 0
}

local function header(totalWindowSize, pos, size)
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
            UI.Components.Search:Show(true)
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
            UI.Components.Settings:Show(true)
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


imgui.OnFrame(
    function() return MainWindowState[0] end,
    function(frame)
        frame.HideCursor = false
        local res, size = imgui.GetIO().DisplaySize, imgui.ImVec2(1000, 700)
        imgui.SetNextWindowPos(imgui.ImVec2(res.x / 2, res.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(size, imgui.Cond.Once)
        if (imgui.Begin("MouHack", MainWindowState, imgui.WindowFlags.NoDecoration + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoScrollbar)) then
            local pos, size = imgui.GetWindowPos(), imgui.GetWindowSize()
            local drawList, bgDrawList, fgDrawList = imgui.GetWindowDrawList(), imgui.GetBackgroundDrawList(), imgui.GetForegroundDrawList()
            local style = imgui.GetStyle()
            local leftWidth, headerHeight = 250, 50

            imgui.PushFont(UI.Font[15].Bold)
            -- Background
            bgDrawList:AddRectFilled(pos, pos + size, UI.Colors.Color.First.u32, 15)
            bgDrawList:AddRectFilled(pos + imgui.ImVec2(leftWidth, headerHeight), pos + size, UI.Colors.Color.Second.u32, 25, 1 + 8)
            bgDrawList:AddRect(pos, pos + size, UI.Colors.Color.Stroke.u32, 15, nil, 2)
            header(size, pos, imgui.ImVec2(size.x, headerHeight))
            imgui.PopFont()


            local logoOffset = imgui.ImVec2(30, 30)
            local imageSize = imgui.ImVec2(40, 40)
            bgDrawList:AddImage(UI.Texture.logo, pos + logoOffset, pos + logoOffset + imageSize)
            -- bgDrawList:AddRectFilled(pos + imgui.ImVec2(15, 15), pos + imgui.ImVec2(15, 15) + imageSize, 0xFFffffff, 5)
            bgDrawList:AddTextFontPtr(UI.Font[20].Bold, 20, pos + imgui.ImVec2(logoOffset.x + imageSize.x + 15, logoOffset.y + 3), UI.Colors.Color.Text.u32, "MouHack")
            bgDrawList:AddTextFontPtr(UI.Font[15].Bold, 15, pos + imgui.ImVec2(logoOffset.x + imageSize.x + 15, logoOffset.y + 3 + 20), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, 0.5), "v1.0.2")
            imgui.NewLine()
            imgui.NewLine()
            local newCategory = UI.Components.Nav(drawList, pos, imgui.ImVec2(leftWidth, 250), ModuleCore.categories)
            if (newCategory) then
                UI.selected = { category = newCategory, page = 1 }
                PAGE_NAV_ANIM.to = 1
            end

            imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
            imgui.SetCursorPos(imgui.ImVec2(leftWidth, headerHeight))
            if (imgui.BeginChild("menu-container", imgui.ImVec2(size.x - leftWidth, size.y - headerHeight), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)) then
                if (not UI.pageNavigation[UI.selected.category]) then
                    UI.pageNavigation[UI.selected.category] = imgui.new.int(1)
                end
                local currentCategory = ModuleCore.categories[UI.selected.category]
                if (currentCategory) then
                    if (#currentCategory.pages > 1) then
                        UI.Components.PageNav("category:" .. UI.selected.category, UI.pageNavigation[UI.selected.category], currentCategory.pages, 150)
                    end
                    
                    local pageSize = imgui.GetWindowSize() - imgui.ImVec2(15 + 15, imgui.GetCursorPosY())
                    imgui.SetCursorPosX(10 - (pageSize.x * (PAGE_NAV_ANIM["category:" .. UI.selected.category].current - 1)) - (20 * (PAGE_NAV_ANIM["category:" .. UI.selected.category].current - 1)))
                    local pageDrawList = imgui.GetWindowDrawList()
                    for pageIndex, page in ipairs(currentCategory.pages) do
                        local pagePos = imgui.GetCursorScreenPos()
                        pageDrawList:PushClipRect(pagePos, pagePos + pageSize) ---@diagnostic disable-line
                        bgDrawList:PushClipRect(pagePos, pagePos + pageSize) ---@diagnostic disable-line
                        UI.Components.Page(pageDrawList, bgDrawList, page, pageSize)
                        pageDrawList:PopClipRect() ---@diagnostic disable-line
                        bgDrawList:PopClipRect() ---@diagnostic disable-line
                        imgui.SameLine(nil, 20)
                    end
                else
                    imgui.TextColored(UI.Colors.Color.Red.vec4, "Error, category does not exists: " .. UI.selected.category)
                end
            end
            imgui.EndChild()
            imgui.PopStyleVar()

            UI.Components.Search:Draw(pos, size, imgui.GetForegroundDrawList())
            UI.Components.Settings:Draw(pos, size, imgui.GetForegroundDrawList())
            imgui.End()
        end
    end
)