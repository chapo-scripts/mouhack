---@alias SearchResultType "category"|"page"|"item"|"option"

---@class SearchResult
---@field type SearchResultType
---@field path string[]
---@field pathString string
---@field pathLower string
---@field categoryIndex number
---@field pageIndex? number
---@field itemIndex? number
---@field optinIndex? number
---@field positions? number[]

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
    query = "",
    ---@type SearchResult[]
    searchResults = {},
    ---@type SearchResult[]
    possibleResults = {}
}

local searchResultType = {
    category = { label = "Категория", icon = faicons("BOOK") },
    page = { label = "Страница", icon = faicons("CODE_FORK") },
    item = { label = "Функция", icon = faicons("CODE_COMMIT") },
    option = { label = "Параметр", icon = faicons("CODE_BRANCH") },
}

function Search:Init()
    ---@param type SearchResultType
    ---@param index number[]
    ---@param path string[]
    local function pushItem(type, index, path)
        local item = {
            type = type,
            categoryIndex = index[1] or nil,
            pageIndex = index[2] or nil,
            itemIndex = index[3] or nil,
            optionIndex = index[4] or nil,
            path = path,
            pathString = table.concat(path, " > "),
        }
        item.pathLower = u8(string.toLower(u8:decode(item.pathString)))
        table.insert(self.possibleResults, item)
    end

    self.possibleResults = {}
    for categoryIndex, category in ipairs(ModuleCore.categories) do
        ---@cast category Category
        pushItem("category", { categoryIndex }, { category.name })
        for pageIndex, page in ipairs(category.pages) do
            pushItem("page", { categoryIndex, pageIndex }, { category.name, page.name })
            for itemIndex, item in ipairs(page.items) do
                pushItem("item", { categoryIndex, pageIndex, itemIndex }, { category.name, page.name, item.label })
                if (item.options) then
                    for optionIndex, option in ipairs(item.options) do
                        pushItem("option", { categoryIndex, pageIndex, itemIndex, optionIndex }, { category.name, page.name, item.label, option.label })
                    end
                end
            end
        end
    end
end

function Search:Find()
    if (#self.possibleResults) then
        self:Init()
    end

    self.searchResults = {}
    local query = u8(string.toLower(u8:decode(ffi.string(self.buffer))))
    for _, r in ipairs(self.possibleResults) do

        local pathLower = u8(string.toLower(u8:decode(r.pathString)))
        local hasFound = pathLower:find(query)
        print(hasFound, u8:decode(query), u8:decode(pathLower))
        if (hasFound) then
            local positions, searchIndex = {}, 1;
            while true do
                local s, e = string.find(pathLower, query, searchIndex, nil);
                if (not s) then
                    break;
                end
                table.insert(positions, {s, e});
                searchIndex = s + 1;
            end
            r.positions = positions
            table.insert(self.searchResults, r)
        end
    end
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
                    cDrawList:AddRectFilled(rPos, rPos + oneResultSize, UI.Colors.withAlpha(UI.Colors.Color.Stroke.u32, self.resultsAnim.hover[k].progress), 15)
                    -- cDrawList:AddRect(rPos + imgui.ImVec2(1, 1), rPos + oneResultSize - imgui.ImVec2(1, 1), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, self.resultsAnim.hover[k].progress), 15)
                    cDrawList:AddText(rPos + imgui.ImVec2(10, 10), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, Search.anim.progress - 0.5), searchResultType[v.type].icon .. " " .. searchResultType[v.type].label)
                    
                    
                    imgui.PushFont(UI.Font[20].Bold)
                    -- TODO: Add search hightlight
                    cDrawList:AddTextFontPtr(UI.Font[20].Bold, 20, rPos + imgui.ImVec2(10, 10 + 15 + 5), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, Search.anim.progress), v.pathString)
                    imgui.PopFont()
                    -- UI.Components.TextWithSearch(cDrawList, v.pathString)
                    
                    local arrowIcon = faicons("CARET_RIGHT")
                    local arrowIconSize = imgui.CalcTextSize(arrowIcon)
                    cDrawList:AddTextFontPtr(UI.Font[20].Bold, 20, rPos + imgui.ImVec2(oneResultSize.x - arrowIconSize.x - 15, oneResultSize.y / 2 - arrowIconSize.y / 2), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, self.resultsAnim.hover[k].progress), arrowIcon)

                    imgui.InvisibleButton("SR:" .. v.pathString, oneResultSize)
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
        end
        imgui.EndChild()
        imgui.PopStyleVar()
    end
end

return Search