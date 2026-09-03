local errors = {}

local ERROR_TYPES = {
    INVALID_EVENT = 'INVALID_EVENT',
    INVALID_HANDLER = 'INVALID_HANDLER',
    VALIDATION_ERROR = 'VALIDATION_ERROR',
    CHANNEL_ERROR = 'CHANNEL_ERROR',
    UNKNOWN_ERROR = 'UNKNOWN_ERROR'
}

errors.ERROR_TYPES = ERROR_TYPES

function errors.create(type, message, context)
    return {
        type = type,
        message = message,
        context = context or {},
        timestamp = os.time(),
        stack = debug.traceback()
    }
end

function errors.format(error, detailed)
    local parts = {
        string.format("[%s] %s", error.type, error.message)
    }
    if detailed and error.context then
        table.insert(parts, "Context:")
        for key, value in pairs(error.context) do
            table.insert(parts, string.format("  %s: %s", key, tostring(value)))
        end
    end
    return table.concat(parts, "\n")
end

function errors.safe_call(func, error_type, context)
    local success, result = pcall(func)
    if success then
        return result, nil
    else
        local error = errors.create(error_type or ERROR_TYPES.UNKNOWN_ERROR,
                                  tostring(result), context)
        return nil, error
    end
end

return errors
