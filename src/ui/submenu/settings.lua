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
        imgui.SetWindowFocus()
        
        imgui.PushFont(UI.Font[24].Bold)
        imgui.TextDisabled("Настройки")
        imgui.PopFont()

        imgui.PushFont(UI.Font[15].Bold)
        UI.Components.PageNav("script:settings", tab, {
            "Модулиaaaaaaaaaaaaaaaaa",
            "Бинды",
            "Скрипт",
            "Авторы"
        }, 150)
        imgui.Text(tostring(UI.Components.PageNav:GetAnimationState("script:settings")))
        imgui.PopFont()

        if (imgui.Button("test")) then
            UI.SubMenu.Search:ShowSelectedItem({ type = "category", categoryIndex = 3})
        end

        imgui.EndPopup()
    end
    imgui.PopStyleVar(2)
    imgui.PopStyleColor()
end

return Settings