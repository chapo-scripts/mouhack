local ev = require("samp.events")
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

---@param page Page
return function(page)
    page.config.teleport = {
        destination = imgui.new.int(0),
        coords = { imgui.new.float(1), imgui.new.float(1), imgui.new.float(1) },
        click = imgui.new.bool(false)
    }

    ev.onSendMapMarker = function(position)
        if (page.config.teleport.click[0]) then
            setCharCoordinates(PLAYER_PED, position.x, position.y, position.z)
        end
    end


    page:AddFunc(Funcs:new(FuncType.Toggle, {
        value = page.config.teleport.click,
        label = "Телепорт по карте",
        description = "Телепорт на метку по клику (ESC->Карта)",
        unsafe = Const.UNSAFE_ITEM_LABEL_GRANTED_KICK,
    }))
    return Funcs:new(FuncType.Button, {
        label = "Телепорт",
        text = "Телепортироваться",
        onClick = function()
            local fn = page.config.teleport.destination[0] == 0 and getTargetBlipCoordinates or SearchMarker
            local result, x, y, z = fn()
            if (result) then
                setCharCoordinates(PLAYER_PED, x, y, z)
            else
                print("Teleport error: no coords")
            end
        end,
        unsafe = Const.UNSAFE_ITEM_LABEL_GRANTED_KICK,
        options = {
            Funcs:new(FuncType.Combo, {
                label = "Точка назначения",
                value = page.config.teleport.destination,
                items = {"Метка", "Чекпоинт"},
                isOption = true
            })
        }
    })
end