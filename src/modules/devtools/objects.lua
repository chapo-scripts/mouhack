local imgui = require("mimgui")

local Page = ModuleCore.Page:new("Объекты и пикапы")


Page.config.objects = {
    render = {
        enabled = imgui.new.bool(false),
        showDistance = imgui.new.bool(true),
        showModel = imgui.new.bool(true),
        mode = imgui.new.int(0),
        modeList = { "Все", "Указанные", "Все, кроме указанных" },
        customList = { 312, 123, 221},
        customListAddBuffer = imgui.new.char[64](""),
        maxDist = imgui.new.float(100)
    }
}

Page.config.pickups = {
    render = imgui.new.bool(false)
}
local takePickupId = imgui.new.char[16]("")
Page:AddItem("input", {
    label = "Поднять пикап",
    hint = "Введите ID пикапа и нажмите Enter",
    width = 200,
    value = takePickupId,
    flags = imgui.InputTextFlags.CharsDecimal,
    onChange = function()
        local id = tonumber(ffi.string(takePickupId))
        if (not id) then
            return
        end
        print("Taken")
        sampSendPickedUpPickup(id)
    end
})

local font = renderCreateFont("Trebuchet MS", 8, 5)

Page:on("loop", function()
    if (Page.config.pickups.render[0]) then
        -- draw pickups
    end
    if (Page.config.objects.render.enabled[0]) then
        local x, y, z = getCharCoordinates(PLAYER_PED)
        for _, handle in ipairs(getAllObjects()) do
            local model = getObjectModel(handle)
            if (
                Page.config.objects.render.mode[0] == 0 or
                (Page.config.objects.render.mode[0] == 1 and table.includes(Page.config.objects.render.customList, model)) or
                (Page.config.objects.render.mode[0] == 2 and not table.includes(Page.config.objects.render.customList, model))
            ) then
                local _, ox, oy, oz = getObjectCoordinates(handle)
                local dist = getDistanceBetweenCoords3d(x, y, z, ox, oy, oz)
                if (dist <= Page.config.objects.render.maxDist[0] and isPointOnScreen(ox, oy, oz, 0.1)) then
                    local sx, sy = convert3DCoordsToScreen(ox, oy, oz)
                    renderFontDrawText(font, ("Object (ID: %d, Dist: %0.1f)"):format(model, dist), sx, sy, 0xFFffffff, false)
                end
            end
        end
    end
end)

---@param drawList ImDrawList
local function drawItemModelListPopup(drawList)
    if (imgui.BeginPopupModal("devtools-objects-render-list-popup", nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration)) then
        local size = imgui.GetWindowSize()

        imgui.PushFont(UI.Font[15].Bold)
        imgui.TextDisabled("Список моделей объектов")
        -- for index, 

        if (imgui.BeginChild("devtools-objects-render-list-popup-container", imgui.ImVec2(300, 400), true)) then
            for index, model in ipairs(Page.config.objects.render.customList) do
                imgui.Text(("%d. %d"):format(index, model))
                imgui.SameLine(imgui.GetWindowWidth() - 20)
                imgui.TextColored(UI.Colors.Color.Red.vec4, faicons("XMARK"))
                if (imgui.IsItemClicked(0)) then
                    table.remove(Page.config.objects.render.customList, index)
                end
            end
        end
        imgui.EndChild()
        imgui.PopFont()

        imgui.SetNextItemWidth(size.x - 20)
        if (imgui.InputTextWithHint("##Page.config.objects.render.customListAddBuffer", "Введите ID модели и нажмите Enter", Page.config.objects.render.customListAddBuffer, 64, imgui.InputTextFlags.EnterReturnsTrue + imgui.InputTextFlags.CharsDecimal)) then
            local id = tonumber(ffi.string(Page.config.objects.render.customListAddBuffer))
            if (id) then
                table.insert(Page.config.objects.render.customList, id)
                imgui.StrCopy(Page.config.objects.render.customListAddBuffer, "")
            end
        end
        imgui.NewLine()
        if (UI.Components.Button("Закрыть##devtools-objects-render-list-popup-container-close", imgui.ImVec2(size.x - 20, 30))) then
            imgui.CloseCurrentPopup()
        end
        imgui.EndPopup()
    end
end

Page:AddItem(PageItemType.Toggle, {
    value = Page.config.objects.render.enabled,
    label = "Рендер объектов",
    options = {
        Page:AddItem(PageItemType.Combo, {
            width = 200,
            label = "Режим",
            value = Page.config.objects.render.mode,
            items = Page.config.objects.render.modeList
        }, true),
        Page:AddItem(PageItemType.Button, {
            label = "Список моделей",
            text = "Редактировать",
            onClick = function() imgui.OpenPopup("devtools-objects-render-list-popup") end,
            onFrame = drawItemModelListPopup
        }, true)
    }
})

return Page