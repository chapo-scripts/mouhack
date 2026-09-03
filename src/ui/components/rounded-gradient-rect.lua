return function(DL, pos, size, colTL, colTR, colBL, colBR, radius, segments)
    segments = segments or 12
    radius = radius or 0
    radius = math.min(radius, size.x / 2, size.y / 2)

    local function drawCorner(DL, cx, cy, radius, color, quadrant, segments)
        segments = segments or 12
        local startAngle, endAngle

        if quadrant == 1 then
            startAngle, endAngle = math.pi, math.pi * 1.5
        elseif quadrant == 2 then
            startAngle, endAngle = math.pi * 1.5, math.pi * 2
        elseif quadrant == 3 then
            startAngle, endAngle = math.pi * 0.5, math.pi
        elseif quadrant == 4 then
            startAngle, endAngle = 0, math.pi * 0.5
        end

        DL:PathClear()
        DL:PathLineTo(imgui.ImVec2(cx, cy))
        for i = 0, segments do
            local angle = startAngle + (endAngle - startAngle) * (i / segments)
            DL:PathLineTo(imgui.ImVec2(cx + math.cos(angle) * radius, cy + math.sin(angle) * radius))
        end
        DL:PathFillConvex(color)
    end

    local cxTL, cyTL = pos.x + radius, pos.y + radius
    local cxTR, cyTR = pos.x + size.x - radius, pos.y + radius
    local cxBL, cyBL = pos.x + radius, pos.y + size.y - radius
    local cxBR, cyBR = pos.x + size.x - radius, pos.y + size.y - radius

    drawCorner(DL, cxTL, cyTL, radius, colTL, 1, segments)
    drawCorner(DL, cxTR, cyTR, radius, colTR, 2, segments)
    drawCorner(DL, cxBL, cyBL, radius, colBL, 3, segments)
    drawCorner(DL, cxBR, cyBR, radius, colBR, 4, segments)

    DL:AddRectFilledMultiColor(
        imgui.ImVec2(pos.x + radius, pos.y),
        imgui.ImVec2(pos.x + size.x - radius, pos.y + radius),
        colTL, colTR, colTR, colTL
    )

    DL:AddRectFilledMultiColor(
        imgui.ImVec2(pos.x + radius, pos.y + size.y - radius),
        imgui.ImVec2(pos.x + size.x - radius, pos.y + size.y),
        colBL, colBR, colBR, colBL
    )

    DL:AddRectFilledMultiColor(
        imgui.ImVec2(pos.x, pos.y + radius),
        imgui.ImVec2(pos.x + radius, pos.y + size.y - radius),
        colTL, colTL, colBL, colBL
    )

    DL:AddRectFilledMultiColor(
        imgui.ImVec2(pos.x + size.x - radius, pos.y + radius),
        imgui.ImVec2(pos.x + size.x, pos.y + size.y - radius),
        colTR, colTR, colBR, colBR
    )

    DL:AddRectFilledMultiColor(
        imgui.ImVec2(pos.x + radius, pos.y + radius),
        imgui.ImVec2(pos.x + size.x - radius, pos.y + size.y - radius),
        colTL, colTR, colBR, colBL
    )
end