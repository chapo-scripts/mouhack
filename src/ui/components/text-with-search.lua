---@param dl ImDrawList DrawList
---@param text string Строка
---@param searchPattern string Че ищем
---@param ignoreCase? boolean Игнорировать регистр символов
---@param plain? boolean Поиск по шаблоу
---@param color? ImVec4 Цвет текста
---@param hightlightColorVec4? ImVec4 Цвет выделения
return function(dl, text, searchPattern, ignoreCase, plain, color, hightlightColorVec4)
    local p = imgui.GetCursorScreenPos();
    if (type(searchPattern) == "string" and #searchPattern > 0) then
        local lowerFunction = string.rlower or string.lower;
        local textStr, searchStr = ignoreCase and lowerFunction(text) or text, ignoreCase and lowerFunction(searchPattern) or searchPattern;

        local positions, searchIndex = {}, 1;
        while true do
            local s, e = string.find(textStr, searchStr, searchIndex, plain);
            if (not s) then
                break;
            end
            table.insert(positions, {s, e});
            searchIndex = s + 1;
        end

        local highlightColor = hightlightColorVec4 and imgui.GetColorU32Vec4(hightlightColorVec4) or imgui.GetColorU32(imgui.Col.TextSelectedBg);
        for _, pos in ipairs(positions) do
            local size = imgui.CalcTextSize(searchPattern);
            local sizeBefore = imgui.CalcTextSize(text:sub(0, pos[1] - 1));
            local startPos = p + imgui.ImVec2(sizeBefore.x, 0);
            dl:AddRectFilled(startPos, startPos + size, highlightColor);
        end
    end
    imgui.TextColored(color or imgui.GetStyleColorVec4(imgui.Col.Text), text);
end