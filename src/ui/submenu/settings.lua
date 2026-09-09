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
            
        end
        imgui.EndChild()
        
        imgui.PopFont()


        imgui.EndPopup()
    end
    imgui.PopStyleVar(2)
    imgui.PopStyleColor()
end

return Settings