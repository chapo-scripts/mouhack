local gameWeapons = require("game.weapons")

local function giveWeapon(id, ammo)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt32(bs, id)
    raknetBitStreamWriteInt32(bs, ammo)
    raknetEmulRpcReceiveBitStream(22, bs)
    raknetDeleteBitStream(bs)
end

return function(page)
    local ammo = imgui.new.int(100)
    local customId = imgui.new.char[64]("")

    local weaponsListIndex = page:AddFunc(Funcs:new(FuncType.NoAction, {
        label = "Выдать оружие",
        unsafe = Const.UNSAFE_ITEM_LABEL_GRANTED_KICK,
        options = {
            Funcs:new(FuncType.SliderInt, {
                label = "Количество патронов",
                value = ammo,
                min = 1,
                max = 999,
                format = "%d шт.",
                width = 200
            }),
            Funcs:new(FuncType.Input, {
                label = "Указать ID",
                hint = "Введите ID и нажмите Enter",
                width = 200,
                value = customId,
                flags = imgui.InputTextFlags.CharsDecimal + imgui.InputTextFlags.EnterReturnsTrue,
                onChange = function()
                    giveWeapon(tonumber(ffi.string(customId)) or 0, ammo[0])
                    imgui.StrCopy(customId, "")
                end
            })
        }
    }))
    
    local weapons = {}
    for id, name in pairs(gameWeapons.names) do
        if (type(name) == "string") then
            table.insert(weapons, { id = id, name = name })
        end
    end
    table.sort(weapons, function(a, b)
        return a.id < b.id
    end)
    
    for _, weapon in ipairs(weapons) do
        table.insert(page.funcs[weaponsListIndex].options, Funcs:new(FuncType.Button, {
            label = ("#%d. %s"):format(weapon.id, weapon.name),
            text = "Выдать",
            noIndexInSearch = true,
            onClick = function()
                -- print(weapon.id)
                giveWeapon(weapon.id, ammo[0])
            end
        }))
    end
    

    return Funcs:new(FuncType.Button, {
        label = "Забрать все оружее",
        text = "Забрать",
        onClick = function()
            local bs = raknetNewBitStream()
            raknetEmulRpcReceiveBitStream(21, bs)
            raknetDeleteBitStream(bs)
        end
    })
end