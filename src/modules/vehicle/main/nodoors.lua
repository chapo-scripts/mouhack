return function(page)
    page.config.noDoors = imgui.new.bool(false)
    page:On("loop", function()
        if (page.config.noDoors[0]) then
            for _, handle in ipairs(getAllVehicles()) do
                popCarDoor(handle, 2, false)
                popCarDoor(handle, 3, false)
            end
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "NoDoors",
        description = "Удаляет двери у всего транспорта",
        value = page.config.noDoors
    })
end