Hotkey = require("hotkey")
Binds = {
    ---@type table<string, Func[]>
    list = {},
    ids = {}
}

local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

---@param target Listed
function Binds:GetConfigKey(target)
    return ("%s > %s"):format(target.pathString, target.label)
end

---@param target Listed
function Binds:DoesBindExists(target)
    for k, v in ipairs(Config.binds) do
        if (v.path == self:GetConfigKey(target)) then
            return k
        end
    end
end

function Binds:GetBindSettings(path)
    for k, v in ipairs(Config.binds) do
        if (v.path == path) then
            return v
        end
    end
end

local vkeys = require("vkeys")

function Binds:Register()
    for index, params in ipairs(Config.binds) do
        local id = Hotkey.register(params.keys, function(id)
            local cfg = self:GetBindSettings(params.path)
            if (cfg) then
                if (cfg.state) then
                    ---@type Func
                    local func = self.list[params.path]
                    if (func) then
                        if (func.type == FuncType.Toggle) then
                            func.value[0] = not func.value[0]
                            print("SWITCH", func.label, func.value[0])
                        elseif (func.type == FuncType.Button) then
                            if (func.onClick) then
                                func.onClick()
                            end
                        end
                        if (func.onChange) then
                            func.onChange()
                        end
                    end
                else
                    print("Bind disabled!")
                end
            end
        end);
        self.ids[params.path] = id
    end
end

function Binds:Unregister()
    for path, id in pairs(self.ids) do
        Hotkey.unRegister(id)
    end
end



---@param keys number[]
function Binds:GetKeysLabel(keys)
    if (#keys == 0) then
        return "Нет"
    end
    local names = {}
    for k, v in ipairs(keys) do
        table.insert(names, vkeys.id_to_name(v))
    end
    return table.concat(names, " + ")
end

function Binds:Init()
    print("INIT")
    local configChanged = false
    for index, item in ipairs(Core.list) do
        if (item.type == "item" or item.type == "option") then
            local func = item.target
            if (func) then
                if ((func.type == FuncType.Button or func.type == FuncType.Toggle) and not func.notBindable and not func.noIndexInSearch) then
                    local path = self:GetConfigKey(item)
                    if (not self:DoesBindExists(item)) then
                        table.insert(Config.binds, { path = path, state = false, keys = {}, useHold = false })
                        configChanged = true
                    end
                    self.list[path] = func
                    local currentBind = Config.binds[self:DoesBindExists(item)]
                    table.insert(self.list, currentBind)
                end
            end
        end
    end

    if (configChanged) then
        Config()
    end
end
