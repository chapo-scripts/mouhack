---@param table table
---@param value unknown
---@return boolean
function table.includes(table, value)
    assert(type(table) == "table")
    for k, v in pairs(table) do
        if (v == value) then
            return true
        end
    end
    return false
end

---@param tbl table
---@param indent? number
---@return string
function table.toString(tbl, indent)
    local function formatTableKey(k)
        local defaultType = type(k)
        if (defaultType ~= "string") then
            k = tostring(k)
        end
        local useSquareBrackets = k:find("^(%d+)") or k:find("(%p)") or k:find("\\") or k:find("%-")
        return useSquareBrackets == nil and k or ("[%s]"):format(defaultType == "string" and "\"" .. k .. "\"" or k)
    end
    local str = { "{" }
    local indent = indent or 0
    for k, v in pairs(tbl) do
        table.insert(
            str,
            ("%s%s = %s,"):format(
                string.rep("    ", indent + 1),
                formatTableKey(k),
                type(v) == "table" and table.toString(v, indent + 1) or (type(v) == "string" and "\"" .. v .. "\"" or tostring(v))
            )
        )
    end
    table.insert(str, string.rep("    ", indent) .. "}")
    return table.concat(str, "\n")
end