local channel = require("eventbus.channel")

local core = {}

local channels = {}
local default_channel

function core.channel(name)
    if not name or name == "" then
        name = "default"
    end
    if channels[name] then
        return channels[name]
    end
    channels[name] = channel.create(name)
    return channels[name]
end

function core.default()
    if not default_channel then
        default_channel = channel.create("default")
        channels["default"] = default_channel
    end
    return default_channel
end

function core.channels()
    local result = {}
    for name, ch in pairs(channels) do
        table.insert(result, name)
    end
    return result
end

function core.clear_all()
    channels = {}
    default_channel = nil
end

function core.get(name)
    return channels[name]
end

return core
