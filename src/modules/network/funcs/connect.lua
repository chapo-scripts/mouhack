return function(page)
    ---@type {name: string, address: string}[]
    local savedServers = {
        {name = "localhost (8881)", address = "127.0.0.1:8881"}
    }
    local f = Funcs:new(FuncType.NoAction, {
        label = "Подключиться к серверу",
        options = {
            Funcs:new(FuncType.Button, {
                label = "Переподключится к текущему",
                text = "Подключиться",
                onClick = function() sampConnectToServer(sampGetCurrentServerAddress()) end,
                isOption = true
            }),
            Funcs:new(FuncType.NoAction, {
                label = "Сохраненные сервера:",
                isOption = true
            })
        }
    })
    local function update()
        for k, v in ipairs(savedServers) do
            table.insert(f.options, Funcs:new(FuncType.Button, {
                label = v.name,
                hint = v.address,
                text = "Подключиться",
                onClick = function()
                    local ip, port = v.name:match("(.+):(%d+)")
                    sampConnectToServer(ip, tonumber(port) or 7777)
                end
            }))
        end
        table.insert(f.options, Funcs:new(FuncType.Button, {
            label = "",
            text = "Редактировать список",
            onClick = function() imgui.OpenPopup("network-saved-servers") end,
            isOption = true,
            onFrame = function()
                if (imgui.BeginPopupModal("network-saved-servers", nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration)) then
                    local size = imgui.GetWindowSize()
                    imgui.PushFont(UI.Font[20].Bold)
                    imgui.TextDisabled("Сохраненные сервера")
                    imgui.PopFont()

                    if (imgui.BeginChild("serverslist", imgui.ImVec2(250, 400), true)) then
                        
                        imgui.EndChild()
                    end

                    imgui.EndPopup()
                end
            end
        }))
    end
    update()

    return f
end