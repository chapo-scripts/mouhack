local ev = require("samp.events")

return function(page)
    page.config.print = imgui.new.bool(false)
    ev.onDisplayGameText = function(style, time, text)
        if (page.config.print[0]) then
            print(("[GAMETEXT] Text: \"%s\" Time: %d, Style: %s"):format(text, time, style))
        end
    end
    return Funcs:new(FuncType.Toggle, {
        label = "Выводить в консоль",
        value = page.config.print
    })
end