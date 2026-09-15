local ev = require("samp.events")

---@param page Page
return function(page)
    page.config.titleId = imgui.new.bool(true)
    page.config.print = imgui.new.bool(false)

    ev.onShowDialog = function(id, style, title, button1, button2, text)
        if (page.config.print[0]) then
            print(("Dialog\nID: %d\nStyle: %d\nTitle: %s\nText: [[\n%s\n]]\nButtons: \"%s\" / \"%s\""):format(id, style, title, text, button1, button2))
        end
        if (page.config.titleId[0]) then
            return { id, style, ("[%d] %s"):format(id, title), button1, button2, text }
        end
    end

    page:AddFunc(Funcs:new(FuncType.Toggle, {
        label = "Добавлять ID в заголовок",
        value = page.config.titleId
    }))
    return Funcs:new(FuncType.Toggle, {
        label = "Выводить информацию о диалоге в консоль",
        value = page.config.print
    })
end