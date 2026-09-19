local packetTypeInfo = {
    OUTCOMING_RPCS = { event = "onSendRpc", label = "RPC (Исходящие)" },
    OUTCOMING_PACKETS = { event = "onSendPacket", label = "Пакеты (Исходящие)" },
    INCOMING_RPCS = { event = "onReceiveRpc", label = "RPC (Входящие)" },
    INCOMING_PACKETS = { event = "onReceivePacket", label = "Пакеты (Входящие)" },
}

local search = imgui.new.char[128]("")

---@param page Page
return function(page)
    local function clear()
        for _ = 1, #page.funcs - 1 do
            table.remove(page.funcs, 2)
        end
    end

    local function init()
        for packetType, packetTypeData in pairs(packetTypeInfo) do
            addEventHandler(packetTypeData.event, function(id)
                local thisEventStates = page.config[packetType]
                if (thisEventStates) then
                    if (thisEventStates.state[0]) then
                        local thisPacketState = thisEventStates.events[id]
                        if (thisPacketState and thisPacketState[0]) then
                            return false
                        end
                    end
                end
            end)
        end
    end


    local function build(query)
        page:AddFunc(Funcs:new(FuncType.Button, {
            label = "Выключить все",
            text = "Выключить",
            onClick = function()
                for packetType in pairs(page.config) do
                    page.config[packetType].state[0] = false
                    for packetId in pairs(page.config[packetType].events) do
                        page.config[packetType].events[packetId][0] = false
                    end
                end
            end
        }))
        
        local queryLower = query:lower()

        for packetTypeIndex, packetType in ipairs({ "OUTCOMING_RPCS", "OUTCOMING_PACKETS", "INCOMING_RPCS", "INCOMING_PACKETS" }) do
            page.config[packetType] = { state = imgui.new.bool(false), events = {} }

            local options = {}
            for id, packetData in pairs(SampEventsCore.INTERFACE[packetType]) do
                local eventName = packetData[1]
                if (type(eventName) == "string" and eventName:match("^on.+")) then
                    eventName = eventName:sub(3, #eventName)
                    page.config[packetType].events[id] = imgui.new.bool(false)

                    local isRpc = packetTypeIndex == 1 or packetTypeIndex == 3
                    local label = ("%s (ID: %d, %s)"):format((isRpc and raknetGetRpcName(id) or raknetGetPacketName(id)) or "Unknown", id, eventName)
                    if (#query == 0 or eventName:lower():find(queryLower)) then
                        table.insert(
                            options,
                            Funcs:new(FuncType.Toggle,{
                                noIndexInSearch = true,
                                label = label,
                                value = page.config[packetType].events[id],
                                isOption = true
                            })
                        )
                    end
                end
            end
            if (#options > 0) then
                page:AddFunc(Funcs:new(FuncType.Toggle, {
                    label = packetTypeInfo[packetType].label,
                    value = page.config[packetType].state,
                    options = options
                }))
            end
        end
    end
   
    page:AddFunc(Funcs:new(FuncType.Input, {
        label = "Поиск по названию",
        hint = "Введите запрос",
        width = 150,
        value = search,
        onChange = function()
            clear()
            build(ffi.string(search))
        end
    }))

    build("")
    init()
end