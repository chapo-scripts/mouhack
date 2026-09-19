local AnimState = {
    None = 0,
    FadeIn = 1,
    Wait = 2,
    FadeOut = 3,
    WaitForDestroy = 4
}

---@class Notification
---@field strId? string
---@field text string
---@field duration number
---@field shownAt number

local Notf = {
    list = {},
    ---@type {state: number, updatedAt: number, progress: number}[]
    anim = {}
}

function Notf:Push(text, duration, strId)
    table.insert(self.list, {
        strId = strId,
        text = text,
        duration = duration,
        shownAt = os.clock()
    })
end

function Notf:Edit(strId, newText, newDuration)
    for k, v in ipairs(self.list) do
        if (v.strId == strId) then
            self.list[k].text = newText
            if (newDuration) then
                self.list[k].duration = newDuration
            end
            break
        end
    end
end

function Notf:Draw()
    local dl = imgui.GetBackgroundDrawList()
    for index, notf in ipairs(self.list) do
        if (not self.anim[index]) then
            self.anim[index] = {
                state = AnimState.FadeIn,
                progress = 0,
                updatedAt = os.clock()
            }
        end

        local finishValue = {
            [AnimState.FadeIn] = 1,
            [AnimState.FadeOut] = 0,
            [AnimState.Wait] = 4,
        }
        self.anim[index].progress = Utils.bringFloatTo(self.anim[index].progress, finishValue[self.anim[index].state], self.anim[index].updatedAt, 1)
        -- dl:AddTextFontPtr(UI.Font[20].Bold, 20, imgui.ImVec2(100, 100 * index), 0xFF0000ff, notf.text .. ": " .. tostring(self.anim[index].progress))

        local displaySize = imgui.GetIO().DisplaySize
        imgui.SetNextWindowPos(imgui.ImVec2(displaySize.x / 2, 500), imgui.Cond.Always, imgui.ImVec2(0.5, 0))
        imgui.PushFont(UI.Font[20].Bold)
        local style = imgui.GetStyle()
        local maxWindowSize = imgui.CalcTextSize(notf.text) + style.WindowPadding + style.WindowPadding
        

        imgui.PopFont()
    end
end

imgui.OnFrame(
    function()
        return #Notf.list > 0
    end,
    function(frame)
        frame.HideCursor = true
        Notf:Draw()
    end
)

return Notf