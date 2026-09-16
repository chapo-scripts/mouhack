local Settings = {
    anim = {
        enabled = false,
        progress = 0,
        updatedAt = 0
    }
}

function Settings:Show(enabled)
    self.anim.enabled = enabled
    self.anim.updatedAt = os.clock()
end

function Settings:IsEnabled()
    return self.anim.enabled, self.anim.progress == (self.anim.enabled and 1 or 0)
end

local tab = imgui.new.int(1)

local tabs = {}

tabs[1] = function()

end

---@param windowPos ImVec2
---@param windowSize ImVec2
---@param bgDrawList ImDrawList
function Settings:Draw(windowPos, windowSize, bgDrawList)
    if (not self.anim.enabled and self.anim.progress == 0) then
        return
    end
    if (#UI.SubMenu.Search.possibleResults == 0) then
        UI.SubMenu.Search:Init()
    end
    self.anim.progress = Utils.bringFloatTo(self.anim.progress, self.anim.enabled and 1 or 0, self.anim.updatedAt, 1)
    imgui.OpenPopup("settings")
    imgui.SetNextWindowPos(windowPos, imgui.Cond.Always)
    imgui.SetNextWindowSize(windowSize, imgui.Cond.Always)
    imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, self.anim.progress)
    imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(15, 15))
    imgui.PushStyleColor(imgui.Col.PopupBg, UI.Colors.withAlpha(UI.Colors.Color.Second.vec4, self.anim.progress - 0.1))
    if (imgui.BeginPopup("settings", 0)) then
        local style = imgui.GetStyle()
        local size = imgui.GetWindowSize()
        imgui.SetWindowFocus()
        
        imgui.PushFont(UI.Font[24].Bold)
        imgui.TextDisabled("Настройки")
        imgui.PopFont()

        imgui.PushFont(UI.Font[15].Bold)
        local sCount = UI.Style:Push(true)
        local navWidth = UI.Components.PageNav:GetWidth("script:settings")
        imgui.SetCursorPos(imgui.ImVec2(size.x / 2 - navWidth / 2, 50 * self.anim.progress))
        UI.Components.PageNav("script:settings", tab, {
            "Скрипт",
            "Модули",
            "Бинды",
            "Авторы"
        }, 150)
        UI.Style:Pop(sCount)
        local dl = imgui.GetWindowDrawList()
        imgui.SetCursorPos(imgui.ImVec2(15, (50 + style.FramePadding.y * 2 + imgui.GetFontSize()) * self.anim.progress))
        if (imgui.BeginChild("settings-container", imgui.ImVec2(size.x - 15 - 15, size.y - 50 - 50 - 15 - 20), true)) then
            local size = imgui.GetWindowSize()
            if (tab[0] == 3) then
                
                -- imgui.PushStyleColor(imgui.Col.ChildBg, imgui.GetStyle().Colors[imgui.Col.WindowBg])
                imgui.PushFont(UI.Font[20].Bold)
                local bindSize = imgui.ImVec2(size.x - 30, 50)
                local drawList = imgui.GetWindowDrawList()
                local style = imgui.GetStyle()
                for index, bind in ipairs(Config.binds) do
                    
                    local p = imgui.GetCursorScreenPos()
                    drawList:AddRectFilled(p, p + bindSize, UI.Colors.withAlpha(UI.Colors.Color.First.u32, self.anim.progress), 10)
                    
                    if (imgui.BeginChild("bind-" .. index, bindSize, true, imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoScrollWithMouse)) then
                        imgui.PushFont(UI.Font[15].Bold)
                        
                        local checkboxSize = imgui.GetFontSize() + style.FramePadding.y * 2
                        imgui.SetCursorPosY(bindSize.y / 2 - checkboxSize / 2)
                        if (bind.state ~= nil) then
                            if (imgui.Checkbox("##bind-enable-" .. index, imgui.new.bool(bind.state))) then
                                Binds.list[index].state = not bind.state
                            end
                        end

                        imgui.SetCursorPos(imgui.ImVec2(style.WindowPadding.x * 2 + checkboxSize, bindSize.y / 2 - imgui.CalcTextSize(bind.path, nil, nil, 500).y / 2))
                        -- imgui.TextDisabled(("%s %s %s %s"):format("Персонаж", faicons("CARET_RIGHT"), "Передвижение", faicons("CARET_RIGHT")))
                        imgui.PushTextWrapPos(500)
                        imgui.TextColored(imgui.GetStyle().Colors[bind.state and imgui.Col.Text or imgui.Col.TextDisabled], bind.path)
                        imgui.PopTextWrapPos()
                        imgui.PopFont()
                        
                        imgui.PushFont(UI.Font[15].Bold)

                        -- if (r.target.type == FuncType.Toggle) then
                        --     imgui.SetCursorPos(imgui.ImVec2(515, bindSize.y / 2 - imgui.GetFontSize() / 2 - 10))
                        --     UI.Components.PageNav:Draw("bind-" .. index, imgui.new.int(1), { "Удержание", "Переключение"})
                        -- end

                        local keysText = Binds:GetKeysLabel(bind.keys)
                        local keysTextSize = imgui.CalcTextSize(keysText)
                        local keysButtonSize = style.FramePadding + keysTextSize + style.FramePadding
                        imgui.SetCursorPos(imgui.ImVec2(bindSize.x - keysButtonSize.x - 15, bindSize.y / 2 - keysButtonSize.y / 2))
                        -- UI.Components.Button(keysText .. "##bind-index-keys-" .. index, keysButtonSize)
                        local bindId = Binds.ids[bind.path]
                        if (bindId) then
                            -- Hotkey.Draw(bindId)
                            UI.Components.HotkeyWithWarning(bindId, "Test", keysButtonSize)
                        else
                            imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), "ERROR")
                        end
                        imgui.PopFont()
                        DrawHotkeyWarningPopup()
                    end
                    imgui.EndChild()
                end
                imgui.PopFont()
                -- imgui.PopStyleColor()
                if (imgui.Button("Создать бинд")) then
                    imgui.OpenPopup("new-bind")
                end

                if (imgui.BeginPopupModal("new-bind")) then
                    imgui.EndPopup()
                end
            end
        end
        imgui.EndChild()
        
        imgui.PopFont()


        imgui.EndPopup()
    end
    imgui.PopStyleVar(2)
    imgui.PopStyleColor()
end

return Settings