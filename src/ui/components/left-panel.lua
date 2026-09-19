local anim = {
    nav = {
        from = 1,
        to = 1,
        current = 1,
        updatedAt = 0
    },
    navHover = {
        ["__example"] = {
            hovered = false,
            updatedAt = 0,
            progress = 0
        }
    },
    search = {
        hovered = false,
        updatedAt = 0,
        progress = 0
    },
    searchHint = {
        state = "in",
        currentText = "GodMode",
        updatedAt = os.clock(),
        progress = 0,
        phrases = {}
    },
    contentDarken = {
        state = "none",
        progress = 0,
        updatedAt = 0
    }
}

return function(bgDrawList, size, headerHeight, windowPos, windowSize)
    if (#anim.searchHint.phrases == 0) then
        for _, f in ipairs(Funcs.list) do
            if (#f.label > 3 and #f.label < 20 and not f.isOption and not f.noIndexInSearch) then
                table.insert(anim.searchHint.phrases, f.label)
            end
        end
    end
    imgui.PushFont(UI.Font[15].Bold)
    if (imgui.BeginChild("header", imgui.ImVec2(size.x, headerHeight), true)) then
        local size = imgui.GetWindowSize()
        anim.searchHint.progress = Utils.bringFloatTo(anim.searchHint.progress, anim.searchHint.state == "in" and #anim.searchHint.currentText or 0, anim.searchHint.updatedAt, anim.searchHint.state == "out" and 0.5 or 2)
        local searchLabel = faicons("MAGNIFYING_GLASS") .. " Поиск"-- .. anim.searchHint.currentText:sub(0, math.ceil(anim.searchHint.progress))
        -- if (anim.searchHint.state == "in" and anim.searchHint.progress == #anim.searchHint.currentText) then
        --     anim.searchHint.state = "out"
        --     anim.searchHint.updatedAt = os.clock()
        -- elseif (anim.searchHint.state == "out" and anim.searchHint.progress == 0) then
        --     anim.searchHint.state = "in"
        --     anim.searchHint.updatedAt = os.clock()
        --     math.randomseed(os.clock())
        --     anim.searchHint.currentText = anim.searchHint.phrases[math.random(1, #anim.searchHint.phrases)]
        -- end

        local searchLabelSize = imgui.CalcTextSize(searchLabel)
        local searchButtonSize = imgui.ImVec2(size.x - 20, size.y - 20)
        imgui.SetCursorPos(imgui.ImVec2(size.x / 2 - searchButtonSize.x / 2, 10))
        local p = imgui.GetCursorScreenPos()
        bgDrawList:AddRectFilled(p, p + searchButtonSize, UI.Colors.Color.Second.u32, 10)
        bgDrawList:AddRect(p, p + searchButtonSize, UI.Colors.withAlpha(UI.Colors.Color.Stroke.u32, anim.search.progress + 0.5), 10)
        bgDrawList:AddText(p + imgui.ImVec2(searchButtonSize.x / 2 - searchLabelSize.x / 2, searchButtonSize.y / 2 - searchLabelSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, anim.search.progress + 0.5), searchLabel)
        if (imgui.InvisibleButton("search", searchButtonSize)) then
            UI.SubMenu.Search:Show(true)
        end
        anim.search.progress = Utils.bringFloatTo(anim.search.progress, anim.search.hovered and 1 or 0, anim.search.updatedAt, 1)
        local isHovered = imgui.IsItemHovered()
        if (anim.search.hovered ~= isHovered) then
            anim.search.hovered = isHovered
            anim.search.updatedAt = os.clock()
        end
    end
    imgui.EndChild()

    imgui.SetCursorPos(imgui.ImVec2(0, headerHeight))

    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
    imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 10))
    if (imgui.BeginChild("nav", size, true)) then
        local buttonSize = imgui.ImVec2(size.x - 20, 34)
        
        imgui.PushFont(UI.Font[16].Bold)
        imgui.SetCursorPosY(0)
        -- Draw selected
        local p = imgui.GetCursorScreenPos() + imgui.ImVec2(0, buttonSize.y * (anim.nav.current - 1) + (anim.nav.current - 1) * 10)
        bgDrawList:AddRectFilled(p, p + buttonSize, UI.Colors.Color.Second.u32, 5)
        anim.nav.current = Utils.bringFloatTo(anim.nav.current, anim.nav.to, anim.nav.updatedAt, 1)
        -- anim.nav.progress = Utils.bringFloatTo(anim.nav.progress, 1, anim.nav.updatedAt, 1)

        for categoryIndex, category in ipairs(Categories.list) do
            if (not anim.navHover[categoryIndex]) then
                anim.navHover[categoryIndex] = { hovered = false, progress = 0, updatedAt = 0}
            end
            anim.navHover[categoryIndex].progress = Utils.bringFloatTo(anim.navHover[categoryIndex].progress, anim.navHover[categoryIndex].hovered and 1 or 0, anim.navHover[categoryIndex].updatedAt, 1)
            
            local p = imgui.GetCursorScreenPos()
            local iconWidth = buttonSize.y - 10
            bgDrawList:AddRectFilled(p + imgui.ImVec2(5, 5), p + imgui.ImVec2(5 + iconWidth, 5 + iconWidth), UI.Colors.Color.Stroke.u32, 5)
            local labelSize = imgui.CalcTextSize(category.name)
            bgDrawList:AddTextFontPtr(UI.Font[16].Bold, 16, p + imgui.ImVec2(10 + iconWidth + 5, buttonSize.y / 2 - labelSize.y / 2), imgui.GetColorU32(imgui.Col.Text, anim.navHover[categoryIndex].progress + (anim.nav.to == categoryIndex and 1 or 0.5)), category.name)
            if (imgui.InvisibleButton(category.name, buttonSize)) then
                anim.nav.from = UI.selected.category
                anim.nav.to = categoryIndex
                anim.nav.updatedAt = os.clock()
                anim.contentDarken.state = "in"
                anim.contentDarken.progress = 0
                anim.contentDarken.updatedAt = os.clock()
                -- UI.selected.category = categoryIndex
            end
            local isHovered = imgui.IsItemHovered()
            if (anim.navHover[categoryIndex].hovered ~= isHovered) then
                anim.navHover[categoryIndex].hovered = isHovered
                anim.navHover[categoryIndex].updatedAt = os.clock()
            end
        end
        imgui.PopFont()
    end
    imgui.EndChild()
    imgui.PopStyleVar(2)

    -- Draw category selection animation
    anim.contentDarken.progress = Utils.bringFloatTo(anim.contentDarken.progress, anim.contentDarken.state == "in" and 1 or 0, anim.contentDarken.updatedAt, 0.2)
    if (anim.contentDarken.state ~= "none") then
        imgui.GetForegroundDrawList():AddRectFilled(windowPos + imgui.ImVec2(size.x, 0), windowPos + windowSize, UI.Colors.withAlpha(UI.Colors.Color.Second.u32, anim.contentDarken.progress), 15)
        if (anim.contentDarken.state == "in" and anim.contentDarken.progress == 1) then
            anim.contentDarken.state = "out"
            anim.contentDarken.updatedAt = os.clock()
            UI.selected.category = anim.nav.to
        elseif (anim.contentDarken.state == "out" and anim.contentDarken.progress == 0) then
            anim.contentDarken.state = "none"
            anim.contentDarken.updatedAt = os.clock()
        end
    end
end