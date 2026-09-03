local event_module = require("eventbus.event")
local errors = require("eventbus.errors")

local channel = {}

local function validate_type(value, expected_type)
    if expected_type == "number" then return type(value) == "number"
    elseif expected_type == "string" then return type(value) == "string"
    elseif expected_type == "boolean" then return type(value) == "boolean"
    elseif expected_type == "table" then return type(value) == "table"
    elseif expected_type == "function" then return type(value) == "function"
    end
    return true
end

local function validate_data(data, schema)
    if schema.required then
        for _, field in ipairs(schema.required) do
            if data[field] == nil then
                return false, string.format("Missing required field '%s'", field)
            end
        end
    end
    if schema.types then
        for field, expected_type in pairs(schema.types) do
            if data[field] ~= nil and not validate_type(data[field], expected_type) then
                return false, string.format("Field '%s' expected %s, got %s",
                    field, expected_type, type(data[field]))
            end
        end
    end
    return true
end

local function sort_subscriptions(subs)
    table.sort(subs, function(a, b)
        if a.priority ~= b.priority then
            return a.priority < b.priority
        end
        return a.id < b.id
    end)
end

function channel.create(name)
    local ch = {
        name = name,
        subscriptions = {},
        definitions = {},
        next_id = 1,
        tracing = false,
        stats_data = {
            total_emits = 0,
            total_duration = 0,
            events = {}
        }
    }

    function ch:on(event_name, fn, opts)
        opts = opts or {}
        if type(fn) ~= "function" then
            error("Handler must be a function")
        end
        local sub = {
            id = self.next_id,
            fn = fn,
            priority = opts.priority or 0,
            once = opts.once or false,
            calls = 0,
            event = event_name
        }
        self.next_id = self.next_id + 1
        if not self.subscriptions[event_name] then
            self.subscriptions[event_name] = {}
        end
        table.insert(self.subscriptions[event_name], sub)
        sort_subscriptions(self.subscriptions[event_name])
        return sub
    end

    function ch:once(event_name, fn, opts)
        opts = opts or {}
        opts.once = true
        return self:on(event_name, fn, opts)
    end

    function ch:off(event_name_or_sub, sub_id)
        if type(event_name_or_sub) == "table" then
            local sub = event_name_or_sub
            local subs = self.subscriptions[sub.event]
            if subs then
                for i, s in ipairs(subs) do
                    if s.id == sub.id then
                        table.remove(subs, i)
                        return true
                    end
                end
            end
            return false
        else
            local event_name = event_name_or_sub
            local subs = self.subscriptions[event_name]
            if subs and sub_id then
                for i, s in ipairs(subs) do
                    if s.id == sub_id then
                        table.remove(subs, i)
                        return true
                    end
                end
            end
            return false
        end
    end

    function ch:off_all(event_name)
        if event_name then
            self.subscriptions[event_name] = nil
        else
            self.subscriptions = {}
        end
    end

    function ch:emit(event_name, data)
        if self.definitions[event_name] then
            local ok, err = validate_data(data or {}, self.definitions[event_name])
            if not ok then
                return nil, errors.create(errors.ERROR_TYPES.VALIDATION_ERROR, err, {
                    event = event_name,
                    channel = self.name
                })
            end
        end

        local ev = event_module.create(event_name, data, self.name)
        local subs = self.subscriptions[event_name]
        local wildcard_subs = self.subscriptions["*"]

        local all_subs = {}
        if subs then
            for _, s in ipairs(subs) do
                table.insert(all_subs, s)
            end
        end
        if wildcard_subs then
            for _, s in ipairs(wildcard_subs) do
                table.insert(all_subs, s)
            end
        end

        if #all_subs == 0 then
            return ev.results
        end

        sort_subscriptions(all_subs)

        local start_time = os.clock()

        for i, sub in ipairs(all_subs) do
            if not ev.propagate then
                break
            end

            ev.priority = sub.priority
            ev.index = i

            local result, err = errors.safe_call(function()
                return sub.fn(ev)
            end, errors.ERROR_TYPES.UNKNOWN_ERROR, {
                event = event_name,
                channel = self.name,
                handler_id = sub.id
            })

            if err then
                ev.results[i] = nil
            else
                ev.results[i] = result
            end

            sub.calls = sub.calls + 1

            if sub.once then
                local target_subs = self.subscriptions[sub.event]
                if target_subs then
                    for j, s in ipairs(target_subs) do
                        if s.id == sub.id then
                            table.remove(target_subs, j)
                            break
                        end
                    end
                end
                if wildcard_subs and sub.event == "*" then
                    for j, s in ipairs(wildcard_subs) do
                        if s.id == sub.id then
                            table.remove(wildcard_subs, j)
                            break
                        end
                    end
                end
            end
        end

        local duration = os.clock() - start_time
        self.stats_data.total_emits = self.stats_data.total_emits + 1
        self.stats_data.total_duration = self.stats_data.total_duration + duration

        if not self.stats_data.events[event_name] then
            self.stats_data.events[event_name] = {
                count = 0,
                last_time = os.time(),
                total_duration = 0,
                avg_duration = 0
            }
        end
        local event_stats = self.stats_data.events[event_name]
        event_stats.count = event_stats.count + 1
        event_stats.last_time = os.time()
        event_stats.total_duration = event_stats.total_duration + duration
        event_stats.avg_duration = event_stats.total_duration / event_stats.count

        if self.tracing then
            print(string.format("[eventbus:%s] %s | handlers=%d | duration=%.4f | canceled=%s",
                self.name, event_name, #all_subs, duration, tostring(ev.canceled)))
        end

        return ev.results
    end

    function ch:emit_async(event_name, data, callback)
        local lua_thread = lua_thread
        if not lua_thread or not lua_thread.create then
            local results = self:emit(event_name, data)
            if callback then callback(results) end
            return
        end
        lua_thread.create(function()
            local results = self:emit(event_name, data)
            if callback then callback(results) end
        end)
    end

    function ch:define(event_name, schema)
        self.definitions[event_name] = schema
    end

    function ch:trace(enabled)
        self.tracing = enabled
    end

    function ch:stats()
        return {
            total_emits = self.stats_data.total_emits,
            total_duration = self.stats_data.total_duration,
            events = self.stats_data.events,
            subscribers = (function()
                local count = 0
                for _, subs in pairs(self.subscriptions) do
                    count = count + #subs
                end
                return count
            end)()
        }
    end

    function ch:list()
        local result = {}
        for event_name, subs in pairs(self.subscriptions) do
            for _, sub in ipairs(subs) do
                table.insert(result, {
                    event = event_name,
                    id = sub.id,
                    priority = sub.priority,
                    once = sub.once,
                    calls = sub.calls
                })
            end
        end
        return result
    end

    function ch:clear()
        self.subscriptions = {}
        self.definitions = {}
        self.stats_data = {
            total_emits = 0,
            total_duration = 0,
            events = {}
        }
    end

    return ch
end

return channel
