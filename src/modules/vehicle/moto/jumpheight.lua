local memory = require("memory")
return function(page)
    page.config.bikeJumpEnabled = imgui.new.bool(false)
    page.config.bikeJumpHeight = imgui.new.float(0.1)
    page:On("loop", function()
        memory.setfloat(memory.getuint32(0x6C0449 + 2, true), page.config.bikeJumpEnabled[0] and page.config.bikeJumpHeight[0] or 0.0599, true)
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "Высокий прыжок для велосипедов",
        value = page.config.bikeJumpEnabled,
        description = "Изменяет высоту прыжка на велосипедах (стандартная: 0.06)\nАвтор: @",
        options = {
            Funcs:new(FuncType.SliderFloat, {
                value = page.config.bikeJumpHeight,
                min = 0.001,
                max = 0.5,
                label = "Высота",
                format = "%0.3f",
                isOption = true
            })
        }
    })
end