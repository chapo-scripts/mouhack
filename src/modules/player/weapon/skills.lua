local ev = require("samp.events")
local defaultSkillsLevel = {}

local function setPlayerSKillLevel(skill, level)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    raknetBitStreamWriteInt32(bs, skill)
    raknetBitStreamWriteInt16(bs, level)
    raknetEmulRpcReceiveBitStream(34, bs)
    raknetDeleteBitStream(bs)
end

return function(page)
    page.config.maxSkills = imgui.new.bool(true)
    ev.onSetPlayerSkillLevel = function(playerId, skill, level)
        if (playerId == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
            defaultSkillsLevel[skill] = level
            if (page.config.maxSkills[0]) then
                return false
            end
        end
    end

    local function apply()
        for i = 0, 10 do
            setPlayerSKillLevel(i, page.config.maxSkills[0] and 999 or (defaultSkillsLevel[i] or 0))
        end
    end
    page:On("sampLoaded", apply)
    return Funcs:new(FuncType.Toggle, {
        label = "Скиллы на оружие",
        value = page.config.maxSkills,
        onChange = apply
    })
end