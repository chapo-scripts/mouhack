return function(page)
    local death = { playerId = imgui.new.char[16]("0"), reason = imgui.new.char[16]("0") }
    return Funcs:new(FuncType.Button, {
        label = "Отправить смерть от игрока",
        hint = "Отправить серверу информацию о смерти от рук игрока",
        text = "Выполнить",
        onClick = function()
            local playerId = tonumber(ffi.string(death.playerId))
            local reason = tonumber(ffi.string(death.reason))
            sampSendDeathByPlayer(playerId or 0, reason or 0)
        end,
        options = {
            Funcs:new(FuncType.Input, {
                label = "ID убийцы",
                value = death.playerId,
                flags = imgui.InputTextFlags.CharsDecimal,
                isOption = true
            }),
            Funcs:new(FuncType.Input, {
                label = "ID оружия",
                value = death.reason,
                flags = imgui.InputTextFlags.CharsDecimal,
                isOption = true
            })
        }
    })
end