return function(page)
    local id = imgui.new.char[64]("")
    local sendAlt = imgui.new.bool(true)
    return Funcs:new(FuncType.NoAction, {
        label = "Отправить клик по текстдраву",
        options = {
            Funcs:new(FuncType.Input, {
                label = "ID Текстдрава",
                hint = "ID",
                value = id,
                flags = imgui.InputTextFlags.CharsDecimal,
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "",
                text = "Отправить нажатие на текстдрав",
                onClick = function()
                    local pupId = tonumber(ffi.string(id))
                    if (not pupId) then
                        return imgui.StrCopy(id, "")
                    end
                    sampSendClickTextdraw(id)
                end
            })
        }
    })
end