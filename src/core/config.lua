PageConfig = {}

function PageConfig.new()
    return setmetatable({}, { __index = PageConfig })
end