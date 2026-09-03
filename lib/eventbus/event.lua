local event = {}

function event.create(name, data, channel_name)
    local obj = {
        name = name,
        data = data or {},
        canceled = false,
        priority = 0,
        index = 0,
        results = {},
        channel = channel_name or "default",
        timestamp = os.clock(),
        propagate = true
    }

    function obj:cancel()
        self.canceled = true
        self.propagate = false
    end

    function obj:stop_propagation()
        self.propagate = false
    end

    function obj:set_result(value)
        self.results[self.index] = value
    end

    function obj:get_result(index)
        return self.results[index]
    end

    function obj:is_canceled()
        return self.canceled
    end

    return obj
end

return event
