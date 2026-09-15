local sampev = require('lib.samp.events')
return function(page)
    page.config.noLimit = imgui.new.bool(false)
    sampev.onSetVehicleVelocity = function()
        if (page.config.noLimit[0]) then
            return false
        end
    end
    return Funcs:new(FuncType.Toggle, {
        label = "NoLimit",
        description = "Не позволяет серверу менять скорость вашего т/с",
        value = page.config.noLimit
    })
end