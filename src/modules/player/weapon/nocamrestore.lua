---@param page Page
return function(page)
    page.config.noCamRestore = imgui.new.bool(false)
    page:On("loop", function()
        writeMemory(0x5231A6, 1, page.config.noCamRestore[0] and 0x90 or 0x75, false)
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "NoCameraRestore (ExtraWS)",
        value = page.config.noCamRestore,
        description = "Убирает восстановление камеры при закрытии прицела.\nАвтор: @g305noobo"
    })
end