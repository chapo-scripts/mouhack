return function(label, size, duration)
    if type(duration) ~= "table" then
        duration = { 1.0, 0.3 }
    end

    local cols = {
        default = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.Button]),  ---@diagnostic disable-line
        hovered = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]),  ---@diagnostic disable-line
        active  = imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])  ---@diagnostic disable-line
    }

    if UI_ANIMBUT == nil then
        UI_ANIMBUT = {}
    end
    if not UI_ANIMBUT[label] then
        UI_ANIMBUT[label] = {
            color = cols.default,
            clicked = { nil, nil },
            hovered = {
                cur = false,
                old = false,
                clock = nil,
            }
        }
    end
    local pool = UI_ANIMBUT[label]

    if pool["clicked"][1] and pool["clicked"][2] then
        if os.clock() - pool["clicked"][1] <= duration[2] then
            pool["color"] = Utils.bringVec4To(
                pool["color"],
                cols.active,
                pool["clicked"][1],
                duration[2]
            )
            goto no_hovered
        end

        if os.clock() - pool["clicked"][2] <= duration[2] then
            pool["color"] = Utils.bringVec4To(
                pool["color"],
                pool["hovered"]["cur"] and cols.hovered or cols.default,
                pool["clicked"][2],
                duration[2]
            )
            goto no_hovered
        end
    end

    if pool["hovered"]["clock"] ~= nil then
        if os.clock() - pool["hovered"]["clock"] <= duration[1] then
            pool["color"] = Utils.bringVec4To(
                pool["color"],
                pool["hovered"]["cur"] and cols.hovered or cols.default,
                pool["hovered"]["clock"],
                duration[1]
            )
        else
            pool["color"] = pool["hovered"]["cur"] and cols.hovered or cols.default
        end
    end

    ::no_hovered::

    imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(pool["color"]))  ---@diagnostic disable-line
    imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(pool["color"]))  ---@diagnostic disable-line
    imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(pool["color"]))  ---@diagnostic disable-line
    local result = imgui.Button(label, size or imgui.ImVec2(0, 0))
    imgui.PopStyleColor(3)

    if result then
        pool["clicked"] = {
            os.clock(),
            os.clock() + duration[2]
        }
    end

    pool["hovered"]["cur"] = imgui.IsItemHovered()
    if pool["hovered"]["old"] ~= pool["hovered"]["cur"] then
        pool["hovered"]["old"] = pool["hovered"]["cur"]
        pool["hovered"]["clock"] = os.clock()
    end

    return result
end