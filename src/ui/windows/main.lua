---@global
MainWindowState = imgui.new.bool(true)


local eyeAnim = {
    start = 0,
    y = 0,
    state = 'in'
}
function eyeAnim.getOffset(dx, dy)
    local size = 4
    return {x = math.max(-size/2, math.min(size/2, dx / 10)), y = math.max(-size/2, math.min(size/2, dy / 10))}
end

---@param drawList ImDrawList
---@param pos ImVec2
---@param size ImVec2
local function drawLogo(drawList, pos, size)
    -- drawList = imgui.GetForegroundDrawList()
    drawList:AddImage(UI.Texture.logo, pos, pos + size)
    -- Logo eye
    local eyeOffset = imgui.ImVec2(0, 70);
    local eyeCenter = pos + imgui.ImVec2(size.x / 2 + 2, size.y / 2.8);
    drawList:AddCircleFilled(eyeCenter, 5, UI.Colors.Color.First.u32, 25);
    local mousePos = imgui.GetMousePos();
    eyeOffset = eyeAnim.getOffset(mousePos.x - (eyeCenter.x + 2), mousePos.y - (eyeCenter.y + 2)); ---@diagnostic disable-line
    local eyePos = imgui.ImVec2(eyeOffset.x + eyeCenter.x, eyeOffset.y + eyeCenter.y);
    drawList:AddCircleFilled(eyePos, 2, UI.Colors.Color.Text.u32, 25);

    -- Eye blinking
    if (eyeAnim.state ~= 'wait') then
        eyeAnim.y = Utils.bringFloatTo(eyeAnim.state == 'in' and -4 or 4, eyeAnim.state == 'in' and 4 or -4, eyeAnim.start, 0.5);
        drawList:AddRectFilled(eyeCenter - imgui.ImVec2(4, 4), eyeCenter + imgui.ImVec2(4, eyeAnim.y), UI.Colors.Color.First.u32, 25);
    end
    if (eyeAnim.state == 'in' and eyeAnim.y == 4) then
        eyeAnim.state = 'out';
        eyeAnim.start = os.clock();
    elseif (eyeAnim.state == 'out' and eyeAnim.y == -4) then
        eyeAnim.state = 'wait';
        eyeAnim.start = os.clock();
    elseif (eyeAnim.state == 'wait') then
        if (os.clock() - eyeAnim.start > 3.5) then
            eyeAnim.state = 'in';
            eyeAnim.start = os.clock();
        end
    end

    -- Texts
    --drawList:AddTextFontPtr(UI.Font[20].Bold, 20, pos + imgui.ImVec2(pos.x + size.x + 15, pos.y + 3), UI.Colors.Color.Text.u32, "MouHack")
    --drawList:AddTextFontPtr(UI.Font[15].Bold, 15, pos + imgui.ImVec2(pos.x + size.x + 15, pos.y + 3 + 20), UI.Colors.withAlpha(UI.Colors.Color.Text.u32, 0.5), "v1.0.2")        
end


local function drawMenuBackbround()

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

            -- Background
            imgui.PushFont(UI.Font[15].Bold)
            bgDrawList:AddRectFilled(pos, pos + size, UI.Colors.Color.First.u32, 15)
            bgDrawList:AddRectFilled(pos + imgui.ImVec2(leftWidth, headerHeight), pos + size, UI.Colors.Color.Second.u32, 25, 1 + 8)
            bgDrawList:AddRect(pos, pos + size, UI.Colors.Color.Stroke.u32, 15, nil, 2)
            UI.Components.Header(size, pos, imgui.ImVec2(size.x, headerHeight))
            imgui.PopFont()

            -- Logo
            local logoOffset = imgui.ImVec2(15, 15)
            local imageSize = imgui.ImVec2(45, 45)
            drawLogo(bgDrawList, pos + logoOffset, imageSize)
            
            -- Category navigation
            imgui.SetCursorPosY(100)
            UI.Components.Nav(drawList, pos, imgui.ImVec2(leftWidth, size.y - 100), ModuleCore.categories)
            local currentCategoryIndex = UI.Components.Nav.currentTab

            imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
            imgui.SetCursorPos(imgui.ImVec2(leftWidth, headerHeight))
            if (imgui.BeginChild("menu-container", imgui.ImVec2(size.x - leftWidth, size.y - headerHeight), true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)) then
                if (not UI.pageNavigation[currentCategoryIndex]) then
                    UI.pageNavigation[currentCategoryIndex] = imgui.new.int(1)
                end
                local currentCategory = ModuleCore.categories[currentCategoryIndex]
                local pageNameStrId = "pagenav-category:" .. currentCategoryIndex
                if (currentCategory) then
                    if (#currentCategory.pages > 1) then
                        local count = UI.Style:Push(true)
                        imgui.PushFont(UI.Font[15].Bold)
                        imgui.SetCursorPos(imgui.ImVec2(imgui.GetWindowWidth() / 2 - UI.Components.PageNav:GetWidth(pageNameStrId) / 2, 10))
                        UI.Components.PageNav(pageNameStrId, UI.pageNavigation[UI.selected.category], currentCategory.pagesLabels)
                        imgui.PopFont()
                        UI.Style:Pop(count)
                    end
                    
                    local pageSize = imgui.GetWindowSize() - imgui.ImVec2(15 + 5, imgui.GetCursorPosY())
                    local pageAnimationState = UI.Components.PageNav:GetAnimationState(pageNameStrId)
                    imgui.SetCursorPosX(10 - (pageSize.x * (pageAnimationState - 1)) - (20 * (pageAnimationState - 1)))
                    local pageDrawList = imgui.GetWindowDrawList()
                    for pageIndex, page in ipairs(currentCategory.pages) do
                        local pagePos = imgui.GetCursorScreenPos()
                        -- pageDrawList:PushClipRect(pagePos, pagePos + pageSize) ---@diagnostic disable-line
                        -- bgDrawList:PushClipRect(pagePos, pagePos + pageSize) ---@diagnostic disable-line
                        local styleVarsCount = UI.Style:Push(false)
                        UI.Components.Page(pageSize, drawList, pageIndex, page, currentCategory)
                        UI.Style:Pop(styleVarsCount)
                        -- pageDrawList:PopClipRect() ---@diagnostic disable-line
                        -- bgDrawList:PopClipRect() ---@diagnostic disable-line
                        imgui.SameLine(nil, 20)
                    end
                else
                    imgui.TextColored(UI.Colors.Color.Red.vec4, "Error, category does not exists: " .. UI.selected.category)
                end
            end
            imgui.EndChild()
            imgui.PopStyleVar()

            UI.SubMenu.Search:Draw(pos, size, imgui.GetForegroundDrawList())
            UI.SubMenu.Settings:Draw(pos, size, imgui.GetForegroundDrawList())
            imgui.End()
        end
    end
)