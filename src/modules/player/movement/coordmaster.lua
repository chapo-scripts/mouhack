function SearchMarker()
    local ret_posX = 0.0
    local ret_posY = 0.0
    local ret_posZ = 0.0
    local isFind = false
    for id = 0, 31 do
        local MarkerStruct = 0
        MarkerStruct = 0xC7F168 + id * 56
        local MarkerPosX = representIntAsFloat(readMemory(MarkerStruct + 0, 4, false))
        local MarkerPosY = representIntAsFloat(readMemory(MarkerStruct + 4, 4, false))
        local MarkerPosZ = representIntAsFloat(readMemory(MarkerStruct + 8, 4, false))
        if MarkerPosX ~= 0.0 or MarkerPosY ~= 0.0 or MarkerPosZ ~= 0.0 then
            ret_posX = MarkerPosX
            ret_posY = MarkerPosY
            ret_posZ = MarkerPosZ
            isFind = true
        end
    end
    return isFind, ret_posX, ret_posY, ret_posZ
end

local coordmaster = {
    active = false,
    from = {0, 0, 0},
    to = {0, 0, 0},
    moveSpeed = {imgui.new.float(0.1), imgui.new.float(0.1), imgui.new.float(0.1)}
}

function coordmaster:start()
    self.active = true
end

function coordmaster:process()
    
end

function coordmaster:stop()
    self.active = false
end

return function(page)
    page.config.cmStep = imgui.new.float(0)
    page.config.cmDelay = imgui.new.float(0)
    page.config.cmDest = imgui.new.int(0)
    page.config.cmDrawInfo = imgui.new.bool(true)
    local f = Funcs:new(FuncType.NoAction, {
        label = "CoordMaster",
        description = "TODO",
        options = {}
    })

    page:On("loop", function()
        if (coordmaster.active) then
            if (page.config.cmDrawInfo[0]) then
                local info = {
                    "~p~Teleporing...",
                    "100% (10 / 100 m.)"
                }
                printStringNow(table.concat(info, "~n~"), 100)
            end
            coordmaster:process()
        end
    end)

    local function updateComponents()
        f.options = {
            Funcs:new(FuncType.NoAction, {
                label = "Статус: " .. (coordmaster.active and "АКТИВЕН" or "Не активен")
            }),
            Funcs:new(FuncType.SliderFloat, {
                label = "Шаг",
                value = page.config.cmStep,
                min = 0.1,
                max = 500,
                format = "%0.1f м.",
                isOption = true
            }),
            Funcs:new(FuncType.SliderFloat, {
                label = "Задержка",
                value = page.config.cmDelay,
                min = 0.1,
                max = 500,
                format = "%0.1f мс.",
                isOption = true
            }),
            Funcs:new(FuncType.Toggle, {
                label = "Отображать информацию о телепорте",
                value = page.config.cmDrawInfo,
                isOption = true
            }),
            Funcs:new(FuncType.Combo, {
                label = "Точка назначения",
                value = page.config.cmDest,
                items = {"Метка", "Чекпоинт"},
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "",
                text = coordmaster.active and "Остановить" or "Запустить",
                noIndexInSearch = true,
                onClick = function()
                    if (coordmaster.active) then
                        coordmaster:stop()
                    else
                        coordmaster.from = { getCharCoordinates(PLAYER_PED) }
                        local fn = page.config.cmDest[0] == 0 and getTargetBlipCoordinates or SearchMarker
                        local result, x, y, z = fn()
                        if (result) then
                            coordmaster.to = {x, y, z}
                        else
                            print("Teleport error: no coords")
                        end
                        coordmaster:start()
                    end
                    updateComponents()
                end,
                isOption = true
            })
        }
    end

    updateComponents()

    return f
end