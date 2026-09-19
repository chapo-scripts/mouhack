local function togglePlayerControllable(frozen)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, frozen and 1 or 0)
    raknetEmulRpcReceiveBitStream(15, bs)
    raknetDeleteBitStream(bs)
end

---@param page Page
return function(page)
    page.config.antifreeze = imgui.new.bool(false)
    
    Events:on("onTogglePlayerControllable", function(c)
        if (page.config.antifreeze[0] and not c) then
            return false
        end
    end)

    return Funcs:new(FuncType.NoAction, {
        label = "Фриз",
        options = {
            Funcs:new(FuncType.Button, {
                label = "Разморозить персонажа",
                text = "Разморозить",
                onClick = function()
                    togglePlayerControllable(true)
                end,
                isOption = true
            }),
            Funcs:new(FuncType.Button, {
                label = "Заморозить персонажа",
                text = "Заморозить",
                onClick = function()
                    togglePlayerControllable(false)
                end,
                isOption = true
            }),
            Funcs:new(FuncType.Toggle, {
                label = "Анти-фриз",
                description = "Не позволяет серверу заморозить вас",
                value = page.config.antifreeze,
                isOption = true
            })
        }
    })
end