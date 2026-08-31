function Utils.msg(...)
    local args = {}
    for k, v in ipairs({ args }) do
        table.insert(args, tostring(v))
    end
    return print(table.concat(args, " "))
end