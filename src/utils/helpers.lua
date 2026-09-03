function Utils.msg(...)
    local args = {}
    for k, v in ipairs({ args }) do
        table.insert(args, tostring(v))
    end
    return print(table.concat(args, " "))
end

function Utils.bringFloatTo(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return from + (count * (to - from) / 100), true
    end
    return (timer > duration) and to or from, false
end