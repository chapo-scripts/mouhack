MainWindowState = imgui.new.bool(true)

local pageAnim = {
    current = 1,
    to = 1,
    updatedAt = 0
}

local headerSearch = imgui.new.char[128]("")
local function header(pos, size)
    imgui.SetCursorScreenPos(pos)
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(0, 10))
    if (imgui.BeginChild("menu-header", size, true)) then
        imgui.SetNextItemWidth(250)
        imgui.InputTextWithHint("##UI.search", "Поиск", headerSearch, ffi.sizeof(headerSearch))
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
            bgDrawList:AddRectFilled(pos + imgui.ImVec2(leftWidth, headerHeight), pos + size, UI.Colors.Color.Second.u32, 15, 1 + 8)
            header(pos + imgui.ImVec2(leftWidth, 0), imgui.ImVec2(size.x, headerHeight))
            imgui.PopFont()

            local newCategory = UI.Components.Nav(drawList, pos, imgui.ImVec2(leftWidth, 250), ModuleCore.categories)
            if (newCategory) then
                UI.selected = { category = newCategory, page = 1 }
                PAGE_NAV_ANIM.to = 1
            end

            imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
            imgui.SetCursorPos(imgui.ImVec2(leftWidth, headerHeight))
            if (imgui.BeginChild("menu-container", imgui.ImVec2(size.x - leftWidth, size.y - headerHeight), true)) then
                local currentCategory = ModuleCore.categories[UI.selected.category]
                if (currentCategory) then
                    if (#currentCategory.pages > 1) then
                        local newPage = UI.Components.PageNav(currentCategory.pages, 150)
                        if (newPage) then
                            UI.selected.page = newPage
                        end
                    end
                    
                    local currentPage = currentCategory.pages[UI.selected.page]
                    if (currentPage) then
                        UI.Components.Page(imgui.GetWindowDrawList(), currentPage)
                    else
                        imgui.TextColored(UI.Colors.Color.Red.vec4, "Error, page does not exists: " .. UI.selected.category .. " -> " .. UI.selected.page)
                    end
                else
                    imgui.TextColored(UI.Colors.Color.Red.vec4, "Error, category does not exists: " .. UI.selected.category)
                end
            end
            imgui.EndChild()
            imgui.PopStyleVar()

            imgui.End()
        end
    end
)