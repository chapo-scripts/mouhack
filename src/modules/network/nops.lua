require("samp.events")
local imgui = require("mimgui")
local sampEventsCore = require("samp.events.core")

local Page = ModuleCore.Page:new("Нопы")
Page.config = {}
---@type EventBusChannel
-- local Events = require("lib.eventbus").channel("samp_events")

local packetTypeName = {
    OUTCOMING_RPCS = "RPC (Исходящие)",
    OUTCOMING_PACKETS = "Пакеты (Исходящие)",
    INCOMING_RPCS = "RPC (Входящие)",
    INCOMING_PACKETS = "Пакеты (Входящие)",
}

local packetTypeInfo = {
    OUTCOMING_RPCS = { event = "onSendRpc", label = "RPC (Исходящие)" },
    OUTCOMING_PACKETS = { event = "onSendPacket", label = "Пакеты (Исходящие)" },
    INCOMING_RPCS = { event = "onReceiveRpc", label = "RPC (Входящие)" },
    INCOMING_PACKETS = { event = "onReceivePacket", label = "Пакеты (Входящие)" },
}

local function clear()
    for _ = 1, #Page.items - 1 do
        table.remove(Page.items, 2)
    end
end

local function init()
    for packetType, packetTypeData in pairs(packetTypeInfo) do
        addEventHandler(packetTypeData.event, function(id)
            local thisEventStates = Page.config[packetType]
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
    local queryLower = query:lower()

    for packetTypeIndex, packetType in ipairs({ "OUTCOMING_RPCS", "OUTCOMING_PACKETS", "INCOMING_RPCS", "INCOMING_PACKETS" }) do
        Page.config[packetType] = { state = imgui.new.bool(false), events = {} }

        local options = {}
        for id, packetData in pairs(sampEventsCore.INTERFACE[packetType]) do
            local eventName = packetData[1]
            if (type(eventName) == "string" and eventName:match("^on.+")) then
                eventName = eventName:sub(3, #eventName)
                Page.config[packetType].events[id] = imgui.new.bool(false)

                local isRpc = packetTypeIndex == 1 or packetTypeIndex == 3
                local label = ("%s (ID: %d, %s)"):format((isRpc and raknetGetRpcName(id) or raknetGetPacketName(id)) or "Unknown", id, eventName)
                if (#query == 0 or eventName:lower():find(queryLower)) then
                    table.insert(options, Page:AddItem(PageItemType.Toggle, { noIndexInSearch = true, label = label, value = Page.config[packetType].events[id] }, true))
                end
            end
        end
        if (#options > 0) then
            Page:AddItem(PageItemType.Toggle, {
                label = packetTypeInfo[packetType].label,
                value = Page.config[packetType].state,
                options = options
            })
        end
    end
    Page:AddItem(PageItemType.Button, {
        label = "Выключить все",
        text = "Выключить",
        onClick = function()
            for packetType in pairs(Page.config) do
                Page.config[packetType].state[0] = false
                for packetId in pairs(Page.config[packetType].events) do
                    Page.config[packetType].events[packetId][0] = false
                end
            end
        end
    })
end

local search = imgui.new.char[64]("")

Page:AddItem(PageItemType.Input, {
    value = search,
    label = "Поиск по названию",
    hint = "Введите запрос",
    width = 150,
    onChange = function()
        clear()
        build(ffi.string(search))
    end
})

build("")
init()


return Page