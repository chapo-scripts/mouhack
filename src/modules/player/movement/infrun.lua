local memory = require("memory")

return function(page)
    page.config.infrun = imgui.new.bool(false)
    page:On("loop", function()
        if (page.config.infrun[0]) then
            memory.setint8(0xB7CEE4, 1) ---@diagnostic disable-line
        end
    end)
    return Funcs:new(FuncType.Toggle, { value = page.config.infrun, label = "Бесконечный бег" })
end