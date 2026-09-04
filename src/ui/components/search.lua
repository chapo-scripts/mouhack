---@class SearchResult
---@field type "category"|"page"|"item"|"item_option"
---@field path string

local Search = {
    anim = {
        enabled = false,
        progress = 0,
        updatedAt = 0
    },
    resultsAnim = {
        hover = {}
    },
    buffer = imgui.new.char[128](""),
    ---@type SearchResult[]
    searchResults = {}
}

function Search:Find()
    self.searchResults = {}
    local query = string.lower(ffi.string(self.buffer))
    for categoryIndex, category in ipairs(ModuleCore.categories) do
        if (category.name:find(query)) then
            table.insert(self.searchResults, { type = "category", path = category.name })
        end
        for pageIndex, page in ipairs(category.pages) do
            if (page.name:find(query)) then
                table.insert(self.searchResults, { type = "page", path = category.name .. "->" .. page.name })
            end
            for itemIndex, item in ipairs(page.items) do
                if (item.label:find(query)) then
                    table.insert(self.searchResults, { type = "item", path = category.name .. "->" .. page.name .. "->" .. item.label })
                end
                if (item.options) then
                    for optionIndex, option in ipairs(item.options) do
                        if (item.label:find(query)) then
                            table.insert(self.searchResults, { type = "option", path = category.name .. "->" .. page.name .. "->" .. item.label .. "->" .. option.label })
                        end
                    end
                end
            end
        end
    end
    print("FOUND:", #self.searchResults)
end

function Search:Show(enabled)
    self.anim.enabled = enabled
    self.anim.updatedAt = os.clock()
end

function Search:IsEnabled()
    return self.anim.enabled, self.anim.progress == (self.anim.enabled and 1 or 0)
end

local function drawSearchInput(width)
    imgui.PushStyleVarVec2(imgui.StyleVar.FramePadding, imgui.ImVec2(15, 15))
    imgui.PushStyleVarFloat(imgui.StyleVar.FrameRounding, 15)
    imgui.SetNextItemWidth(width)
    if (imgui.InputTextWithHint("##Search.buffer", "Начните вводить название функции", Search.buffer, ffi.sizeof(Search.buffer))) then
        Search:Find()
    end
    imgui.SetKeyboardFocusHere()
    imgui.PopStyleVar(2)
end


local searchResultType = {
    category = { label = "Категория", icon = faicons("BOOK") },
    page = { label = "Страница", icon = faicons("CODE_FORK") },
    item = { label = "Функция", icon = faicons("CODE_COMMIT") },
    option = { label = "Параметр", icon = faicons("CODE_BRANCH") },
}

---@param windowPos ImVec2
---@param windowSize ImVec2
---@param bgDrawList ImDrawList
function Search:Draw(windowPos, windowSize, bgDrawList)
    self.anim.progress = Utils.bringFloatTo(self.anim.progress, self.anim.enabled and 1 or 0, self.anim.updatedAt, 1)
    if (self.anim.progress > 0) then
        imgui.SetCursorScreenPos(windowPos)
        imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, self.anim.progress)
        if (imgui.BeginChild("search-bg", windowSize, true)) then
            local dl = imgui.GetWindowDrawList()
            dl:AddRectFilled(windowPos, windowPos + windowSize, UI.Colors.withAlpha(0xFF000000, self.anim.progress - 0.5), 15)
            
            imgui.PushFont(UI.Font[20].Bold)
            local style = imgui.GetStyle()
            local contentWidth = windowSize.x / 2
            -- local contentHeight = inputSize.y
            
            imgui.SetCursorPos(imgui.ImVec2(windowSize.x / 2 - contentWidth / 2, 50))
            local posStart = imgui.GetCursorScreenPos()
            drawSearchInput(contentWidth)

            local oneResultSize = imgui.ImVec2(contentWidth, 10 + 15 + 5 + 20 + 10)
            imgui.NewLine()
            local containerSize = imgui.ImVec2(contentWidth, imgui.GetWindowHeight() - 175)--oneResultSize.y * #self.searchResults)
            imgui.SetCursorPosX(windowSize.x / 2 - contentWidth / 2)
            local p1 = imgui.GetCursorScreenPos()
            -- dl:AddRectFilled(p1, p1 + imgui.ImVec2(containerSize.x, oneResultSize.y * #self.searchResults), 0xFF00ff00)
            -- dl:AddRectFilledMultiColor(p1)
            if (imgui.BeginChild("search-results-container", containerSize, true, imgui.WindowFlags.NoScrollbar)) then
                imgui.PushFont(UI.Font[15].Bold)
                local cDrawList = imgui.GetWindowDrawList()
                imgui.PushStyleVarVec2(imgui.StyleVar.ItemSpacing, imgui.ImVec2(0, 10))
                for k, v in ipairs(Search.searchResults) do
                    if (not self.resultsAnim.hover[k]) then
                        self.resultsAnim.hover[k] = { hovered = false, progress = 0, updatedAt = 0 }
                    end
                    local rPos = imgui.GetCursorScreenPos()
                    cDrawList:AddRectFilled(rPos, rPos + oneResultSize, UI.Colors.withAlpha(UI.Colors.Color.Second.u32, Search.anim.progress), 15)
                    cDrawList:AddRect(rPos, rPos + oneResultSize, UI.Colors.withAlpha(UI.Colors.Color.Text.u32, self.resultsAnim.hover[k].progress), 15)
                    cDrawList:AddText(rPos + imgui.ImVec2(10, 10), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, Search.anim.progress - 0.5), searchResultType[v.type].icon .. " " .. searchResultType[v.type].label)
                    cDrawList:AddTextFontPtr(UI.Font[20].Bold, 20, rPos + imgui.ImVec2(10, 10 + 15 + 5), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, Search.anim.progress), v.path)
                    
                    local arrowIcon = faicons("CARET_RIGHT")
                    local arrowIconSize = imgui.CalcTextSize(arrowIcon)
                    cDrawList:AddTextFontPtr(UI.Font[20].Bold, 20, rPos + imgui.ImVec2(oneResultSize.x - arrowIconSize.x - 15, oneResultSize.y / 2 - arrowIconSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, self.resultsAnim.hover[k].progress), arrowIcon)

                    imgui.InvisibleButton("SR:" .. v.path, oneResultSize)
                    local isHovered = imgui.IsItemHovered()
                    self.resultsAnim.hover[k].progress = Utils.bringFloatTo(self.resultsAnim.hover[k].progress, self.resultsAnim.hover[k].hovered and 1 or 0, self.resultsAnim.hover[k].updatedAt, 1)
                    if (self.resultsAnim.hover[k].hovered ~= isHovered) then
                        self.resultsAnim.hover[k].hovered = isHovered
                        self.resultsAnim.hover[k].updatedAt = os.clock()
                    end
                end
                imgui.PopStyleVar()
                imgui.PopFont()
            end
            imgui.EndChild()
            UI.Components.CenterText("Нажмите ESC для выхода",UI.Colors.withAlpha(UI.Colors.Color.Text.vec4, self.anim.progress - 0.5) )
            imgui.PopFont()
            -- local oneResultHeight = 10 + 10 + 15 + 15 + 10
            -- imgui.SetCursorPos(imgui.ImVec2(windowSize.x / 2 - width / 2, 50))
            -- local containerPos, containerSize = imgui.GetCursorScreenPos(), imgui.ImVec2(width, imgui.GetFontSize() + imgui.GetStyle().FramePadding.y * 2)
            -- dl:AddRectFilled(containerPos - imgui.ImVec2(15, 15), containerPos + containerSize + imgui.ImVec2(15, 15), UI.Colors.withAlpha(UI.Colors.Color.First.u32, Search.anim.progress), 15)

            -- if (imgui.BeginChild("search-container", containerSize, true)) then
            --     imgui.PushFont(UI.Font[20].Bold)
            --     drawSearchInput(width)

            --     local hintText = #self.searchResults == 0 and "Ничего не найдено :(" or "Результаты поиска:"
            --     imgui.Spacing()
            --     imgui.SetCursorPosX(containerSize.x / 2 - imgui.CalcTextSize(hintText).x / 2)
            --     imgui.TextDisabled(hintText)
            --     imgui.PopFont()
            --     local p = imgui.GetCursorScreenPos()
            --     drawSearchResults(dl, p, imgui.ImVec2(width, imgui.GetWindowWidth() - imgui.GetCursorPosY() - 15))
            -- end
            -- imgui.EndChild()
        end
        imgui.EndChild()
        imgui.PopStyleVar()
    end
end

return Search