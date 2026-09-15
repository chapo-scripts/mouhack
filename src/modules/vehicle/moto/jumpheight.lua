local memory = require("memory")
return function(page)
    page.config.bikeJump = { enabled = imgui.new.bool(false), power = imgui.new.float(0.1) }
    page:On("loop", function()
        memory.setfloat(memory.getuint32(0x6C0449 + 2, true), page.config.bikeJump.enabled[0] and page.config.bikeJump.power[0] or 0.0599, true)
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "Высокий прыжок для велосипедов",
        value = page.config.bikeJump,
        description = "Изменяет высоту прыжка на велосипедах (стандартная: 0.06)\nАвтор: @",
        options = {
            Funcs:new(FuncType.SliderFloat, {
                value = page.config.bikeJump.power,
                min = 0.001,
                max = 0.5,
                label = "Высота",
                format = "%0.3f",
                isOption = true
            })
        }
    })
end