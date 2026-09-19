local memory = require("memory")
function MyID()
    return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
end

local infoCallbacks = {
    ["ping"] = { name = "Ping", fn = function() return sampGetPlayerPing(MyID()) end },
    ["id"] = { name = "ID", fn = function() return MyID() end },
    ["name"] = { name = "Nickname", fn = function() return sampGetPlayerNickname(MyID()) end },
    ["players_streamed"] = { name = "Players in stream", fn = function() return sampGetPlayerCount(true) end },
    ["players_total"] = { name = "Players on server", fn = function() return sampGetPlayerCount(false) end },
    ["server_name"] = { name = "Server Name", fn = function() return sampGetCurrentServerName() end },
    ["server_address"] = { name = "Server Address", fn = function() return table.concat({ sampGetCurrentServerAddress() }, ":") end },
    ["ped_position"] = { name = "Player position (XYZ)", fn = function() return ("X: %0.0f Y: %0.0f Z: %0.0f"):format(getCharCoordinates(PLAYER_PED)) end },
    ["ped_heading"] = { name = "Player headnig angle", fn = function() return getCharHeading(PLAYER_PED) end },
    ["ped_animation"] = { name = "Player animation (IFP:NAME)", fn = function() return ("%s:%s"):format(sampGetAnimationNameAndFile(sampGetPlayerAnimationId(MyID()))) end },
    ["ped_animation_id"] = { name = "Player animation ID", fn = function() return sampGetPlayerAnimationId(MyID()) end },
    ["system_date"] = { name = "System date", fn = function() return os.date("%d.%m.%y") end },
    ["system_time"] = { name = "System time", fn = function() return os.date("%H:%M:%S") end },
    ["fps"] = { name = "FPS", fn = function()
        if (not _G.FPS) then
            _G.FPS = { value = -1, updatedAt = os.clock() }
        else
            if (os.clock() - _G.FPS.updatedAt > 0.5) then
                _G.FPS.value = ("%.0f"):format(memory.getfloat(0xB7CB50, true))
                _G.FPS.updatedAt = os.clock()
            end
        end
        return _G.FPS.value
    end },
}

local function getLabelData(item)
    if (not item:find(":")) then
        return item, item
    end
    local type, payload = item:match("(%w+):(.+)")
    if (type == "text") then
        return type, payload
    elseif (type == "icon") then
        return type, faicons(payload)
    elseif (type == "data") then
        local data = infoCallbacks[payload]
        return type, data and tostring(data.fn()) or "NULL"
    elseif (type == "spacing") then
        return type, payload, "Spacing: " .. payload
    end
    return "NULL", "UNK:" .. item
end

local editMode = {
    type = nil,
    index = nil
}

local spacingSizes = {}
for i = 5, 100, 5 do
    table.insert(spacingSizes, i)
end

return function(page, dl, pos, size)
    page.config.infobar = imgui.new.bool(true)
    page.config.infobarScale = imgui.new.float(1)
    page.config.infobarBgColor = imgui.new.float[4](0, 0, 0, 0.25)
    page.config.dataset =  {
        "newline", "icon:USER", "spacing:5", "data:name", "spacing:5", "text:(", "data:id", "text:)",
        "newline", "icon:PERSON_WALKING", "spacing:5", "data:ped_animation", "spacing:5", "text:(", "data:ped_animation_id", "text:)",
        "newline", "icon:CLOCK", "spacing:5", "data:system_time", "spacing:15", "icon:CALENDAR", "spacing:5", "data:system_date",
        "newline", "icon:SIGNAL", "spacing:5", "data:ping", "spacing:15", "icon:IMAGES", "spacing:5", "data:fps"
    }
    imgui.OnFrame(
        function() return page and page.config.infobar[0] end,
        function(frame)
            frame.HideCursor = true
            imgui.PushStyleVarVec2(imgui.StyleVar.WindowPadding, imgui.ImVec2(10 * page.config.infobarScale[0], 10 * page.config.infobarScale[0]))
            imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(page.config.infobarBgColor[0], page.config.infobarBgColor[1], page.config.infobarBgColor[2], page.config.infobarBgColor[3]))
            if (imgui.Begin("mouhack:widgets:infobar", nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration)) then
                imgui.SetWindowFontScale(page.config.infobarScale[0])
                imgui.PushFont(UI.Font[15].Bold)
                for index, item in ipairs(page.config.dataset) do
                    local nextItem = page.config.dataset[index + 1]
                    local itemType, itemString = getLabelData(item)
                    local color, outlineSize, outlineColor = UI.Colors.Color.Text.vec4, 2, UI.Colors.Color.TextOutline.vec4
                    
                    if (itemType == "text" or itemType == "data" or itemType == "icon") then
                        imgui.Text(itemString)
                    elseif (itemType == "spacing") then
                        imgui.SameLine(nil, tonumber(itemString) or 5)
                    elseif (itemType == "newline") then
                        imgui.Text("")
                    end

                    if ((nextItem or "newline") ~= "newline" and itemType ~= "spacing") then
                        imgui.SameLine(nil, 5)
                    end
                end
                imgui.PopFont()
            end
            imgui.End()
            imgui.PopStyleColor()
            imgui.PopStyleVar()
        end
    )
    return function()
        -- imgui.Text("ASD")
        UI.Components.TggleButton("Включить InfoBar", page.config.infobar, imgui.ImVec2(40, 20))
        imgui.SliderFloat("##page.config.infobarScale", page.config.infobarScale, 0.1, 4, "Размер: %0.1f")
        imgui.ColorEdit4("##page.color.infobarBgColor", page.config.infobarBgColor, imgui.ColorEditFlags.NoInputs + imgui.ColorEditFlags.AlphaBar + imgui.ColorEditFlags.AlphaPreview)
    end
end