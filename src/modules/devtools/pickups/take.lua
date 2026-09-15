local function sendSyncKey(key)
    local data = allocateMemory(68)
    sampStorePlayerOnfootData(select(2,sampGetPlayerIdByCharHandle(PLAYER_PED)), data)
    setStructElement(data, 4, 2, key, true)
    sampSendOnfootData(data)
    freeMemory(data)
end

return function(page)
    local id = imgui.new.char[64]("")
    local sendAlt = imgui.new.bool(true)
    return Funcs:new(FuncType.NoAction, {
        label = "Поднять пикап",
        options = {
            Funcs:new(FuncType.Input, {
                label = "ID Пикапа",
                hint = "ID",
                value = id,
                flags = imgui.InputTextFlags.CharsDecimal,
                isOption = true
            }),
            Funcs:new(FuncType.Toggle, {
                label = "Отправить нажатие ALT",
                value = sendAlt,
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "",
                text = "Поднять пикап",
                onClick = function()
                    local pupId = tonumber(ffi.string(id))
                    if (not pupId) then
                        return imgui.StrCopy(id, "")
                    end
                    if (sendAlt[0]) then
                        sendSyncKey(1024)
                    end
                    sampSendPickedUpPickup(id)
                end
            })
        }
    })
end