local gameText = {
    style = imgui.new.int(0),
    time = imgui.new.char[16]("2.5"),
    text = imgui.new.char[64]("Your~n~~y~Text~n~~r~Here")
}

function gameText:show()
    local text = ffi.string(self.text)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt32(bs, gameText.style[0])
    raknetBitStreamWriteInt32(bs, tonumber(self.time) or 2000)
    raknetBitStreamWriteInt32(bs, #text)
    raknetBitStreamWriteString(bs, text)
    raknetEmulRpcReceiveBitStream(73, bs)
    raknetDeleteBitStream(bs)
end

return function(page)
    return Funcs:new(FuncType.NoAction, {
        label = "Показать GameText",
        options = {
            Funcs:new(FuncType.Input, {
                label = "Текст",
                value = gameText.text,
                description = table.concat({
                    "Цвета:",
                    "~n~ New line",
                    "~r~ Red",
                    "~g~ Green",
                    "~b~ Blue",
                    "~w~ or ~s~ White",
                    "~y~ Yellow",
                    "~p~ Purple",
                    "~l~ Black (lower case L)",
                    "~h~ Turn text color lighter (used too much will make your text white, doesn't work on black)",
                    "",
                    "Специальные значения:",
                    "~u~ up arrow (gray)",
                    "~d~ down arrow (gray)",
                    "~<~ left arrow (gray)",
                    "~>~ right arrow (gray)",
                    "] displays a * symbol (Only in text styles 3, 4 and 5)",
                    "~k~ keyboard key mapping (e.g. ~k~~VEHICLE_TURRETLEFT~ and ~k~~PED_FIREWEAPON~). Look here for a list of keys",
                }, "\n")
            }),
            Funcs:new(FuncType.SliderInt, {
                label = "Стиль",
                min = 0,
                max = 6,
                value = gameText.style,
                description = table.concat({
                    "#0 - отображается в течение 9 секунд независимо от настроек времени. Скрывает текстовые элементы и любой другой игровой текст на экране.",
                    "#1 - Затухание происходит через 8 секунд, независимо от установленного времени. Если вы установили время больше, оно снова появится после затухания и будет повторяться до истечения заданного времени.",
                    "#2 - не исчезает до тех пор, пока игрок не возродится",
                    "#5 - отображается в течение 3 секунд, независимо от установленного вами времени. Отключится при «спаме»"
                }, "\n"),
                format = "#%d"
            }),
            Funcs:new(FuncType.Input, {
                label = "Время отображения",
                value = gameText.time,
                onChange = function()
                    if (not tonumber(ffi.string(gameText.time))) then
                        imgui.StrCopy(gameText.time, "2.5")
                    end
                end
            }),
            Funcs:new(FuncType.Button, {
                label = "",
                text = "Показать",
                onClick = gameText.show,
                isOption = true
            })
        }
    })
end