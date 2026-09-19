EventsCore = {}
Events = EventBus.channel("samp_events")

-- Events:on("onServerMessage", function(c, t)
--     sampAddChatMessage("text:" .. t, -1)
-- end)

Events:trace(true)
function EventsCore:Init()
    for _, packetType in ipairs({ "OUTCOMING_RPCS", "OUTCOMING_PACKETS", "INCOMING_RPCS", "INCOMING_PACKETS" }) do
        print("Registering type", packetType)
        for _, packetData in pairs(SampEvents.INTERFACE[packetType]) do
            print("setup eventbus for", packetData[1])
            local eventName = packetData[1]
            SampEvents[eventName] = function(...)
                local namedArgs, argsArray = {}, { ... }
                -- print(eventName, table.toString(packetData))
                for argIndex, arg in pairs(packetData) do
                    if (argIndex > 1 and type(arg) == "table") then
                        for fieldName in pairs(arg) do
                            namedArgs[fieldName] = argsArray[argIndex-1]
                        end
                    end
                end
                local result = Events:emit(eventName, namedArgs)
                print("EVENT RESULT", table.toString(result))
            end
        end
    end
end

return EventsCore