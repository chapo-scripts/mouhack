local EventGenerator = {
    file = PROJECT_PATH .. "\\api\\types\\events.lua"
}

local types = {
    uint8 = "number",
    uint16 = "number",
    int32 = "number",
    float = "number",
    
    bool = "boolean",
    bool8 = "boolean",
    bool32 = "boolean",
    
    string8 = "string",
    string16 = "string",
    string32 = "string",
    fixedString32 = "string",
    encodedString4096 = "string",
    
    vector2d = "{x: number, y: number}",
    vector3d = "{x: number, y: number, z: number}",
    Int32Array3 = "number[][]",
}

function EventGenerator:Generate()
    local lines = {
        "---@meta",
        "---@class Events"
    }
    for _, packetType in ipairs({ "OUTCOMING_RPCS", "OUTCOMING_PACKETS", "INCOMING_RPCS", "INCOMING_PACKETS" }) do
        for _, packetData in pairs(SampEventsCore.INTERFACE[packetType]) do
            local eventName = packetData[1]
            local paramsData = table.copy(packetData)
            table.remove(paramsData, 1)

            if (type(eventName) == "string" and not eventName:find("^_")) then
                local params = {}
                for _, arg in ipairs(paramsData) do
                    if (type(arg) == "table") then
                        for field, type in pairs(arg) do
                            table.insert(params, ("%s: %s"):format(tostring(field), types[tostring(type)] or "unknown"))
                            break
                        end
                    end
                end
                table.insert(lines, ("---@field on fun(self: Events, event: \"%s\", callback: fun(%s): (table|boolean)?)"):format(eventName, table.concat(params, ", ")))
            end
        end
    end
    local result = table.concat(lines, "\n")
    local file, err = io.open(self.file, "w")
    assert(file, err)
    file:write(result)
    file:close()
    print("[TYPEGEN] Events saved to", self.file)
end

return EventGenerator