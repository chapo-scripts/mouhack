local lastEditedParam;

local function keysIdsToLabel(keys)
    if (#keys == 0) then
        return u8'Нет';
    end
    local list = {};
    for k, v in ipairs(keys or {}) do
        table.insert(list, vkeys.id_to_name(v));
    end
    return table.concat(list, ' + ');
end

local function getBindsWithKeys(keys, ignoreId)
    local result = {};
    local currentBindStr = keysIdsToLabel(keys);
    for index, bind in pairs(Hotkey) do
        if (type(index) == 'number') then
            -- Utils.debug('Hotkeu->', index, tostring(bind.keys), keysIdsToLabel(bind.keys));    
            -- Utils.debug(bind.name or 'no name', index, currentBindStr, keysIdsToLabel(bind.keys))
            local bindKeysStr = keysIdsToLabel(bind.keys);
            -- Utils.debug('', index, u8:decode(bind.name), 'ignore:', ignoreId, 'keys:', #bindKeysStr, keysIdsToLabel(bind.keys), '|', #currentBindStr, currentBindStr);
            if ((ignoreId == nil or index ~= ignoreId) and currentBindStr == bindKeysStr and #bindKeysStr > 0) then
                -- Utils.debug('CONFLICT', index, u8:decode(bind.name), 'ignore:', ignoreId, 'keys:', #bindKeysStr, bindKeysStr, '|', #currentBindStr, currentBindStr);
                table.insert(result, index);
            end
        end
    end
    -- local ids = Hotkey.getAllMatches(Hotkey[lastEditedParam].keys);
    -- if (not ids) then return result end
    
    
    -- for k, v in ipairs(ids) do
    --     Utils.debug(currentBindStr, keysIdsToLabel(Hotkey[v].keys))
    --     if (currentBindStr == keysIdsToLabel(Hotkey[v].keys)) then
    --         table.insert(result, v);
    --     end
    -- end
    -- local currentKeysStr = table.concat(Hotkey[lastEditedParam].keys, ' + ');
    -- for k, v in ipairs(ids) do
    --     local keysStr = table.concat(Hotkey[v].keys, ' + ');
    --     if (keysStr == currentKeysStr) then
    --         table.insert(result, v);
    --     end
    -- end
    -- Utils.debug('#conflict = ' .. #result);
    return result;
end

local function getBindLabelStr(bindId)
    local bind = Hotkey[bindId];
    return bind and (#bind.keys > 0 and u8'Нет' or keysIdsToLabel(bind.keys)) or u8'Нет';
end

function DrawHotkeyWarningPopup(specialStrId)
    if imgui.BeginPopupModal('hotkey-warning', nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration) then
        local newKeysLabel = keysIdsToLabel(Hotkey[lastEditedParam].newKeys);
        imgui.Spacing();
        imgui.PushFont(UI.Font[20].Bold);
        imgui.TextDisabled(u8('Бинд "%s" уже используется в:'):format(newKeysLabel));
        imgui.PopFont();
        -- UI.Components.centerText(u8'Это сочетание клавиш уже ив:');
        -- local ids = Hotkey.getAllMatches(Hotkey[lastEditedParam].newKeys)
        -- if ids then
        --     for _,id in ipairs(ids) do
        --         if id ~= specialStrId then
        --             imgui.BulletText(tostring(Hotkey[id].name or u8'Неизвестная функция'));
        --         end
        --     end
        -- end
        local conflicts = getBindsWithKeys(Hotkey[lastEditedParam].newKeys, lastEditedParam);
        -- imgui.Text(tostring(#conflicts))
        local bindActionReplace = false;
        for index, id in ipairs(conflicts) do
            imgui.BulletText(tostring(Hotkey[id].name or u8'Неизвестная функция'));
            imgui.SameLine();
            if (imgui.Text('удалить')) then
                if (#conflicts == 1) then
                    imgui.OpenPopup('hotkey-warning-confirm-deletion-from-other-action-' .. id);
                elseif (#conflicts > 1) then
                    Hotkey.clear(Hotkey[id].keys);
                end
            end

            if (imgui.BeginPopupModal('hotkey-warning-confirm-deletion-from-other-action', nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration)) then
                imgui.PushFont(UI.font[20].Bold);
                imgui.TextDisabled(u8'Подтверждение');
                imgui.PopFont();

                imgui.PushFont(UI.font[20].Bold);
                imgui.TextWrapped(u8('После снятия бинда "%s" с функции "%s" бинд автоматически будет установлен на функцию "%s"'):format(newKeysLabel, Hotkey[id].name, Hotkey[lastEditedParam].name));
                imgui.PopFont();

                local width = imgui.GetWindowWidth();
                if (UI.Components.button(u8'Подтвердить##hotkey-warning-confirm-deletion-from-other-action', imgui.ImVec2(width / 2, 26), true)) then
                    bindActionReplace = true;
                    imgui.CloseCurrentPopup();
                end
                if (UI.Components.button(u8'Отмена##hotkey-warning-cancel-deletion-from-other-action', imgui.ImVec2(width / 2, 26), true)) then
                    imgui.CloseCurrentPopup();
                end
                imgui.EndPopup();
            end
        end

        -- imgui.SetCursorPosY(imgui.GetCursorPosY() + 10)
        -- imgui.BeginGroup()
        --     imgui.Text(u8('В некоторых функциях уже используется такое же сочетание клавиш.\nХотите продолжить?'))
        -- imgui.EndGroup()
        -- imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
        if (bindActionReplace or UI.Components.Button(u8'Заменить##hotkey-confirm', imgui.ImVec2(150, 26), true)) then
            local ids = Hotkey.getAllMatches(Hotkey[specialStrId].newKeys)
            if ids then
                for _,id in ipairs(ids) do
                    if id ~= specialStrId then
                        Hotkey.clear(Hotkey[id].keys)
                    end
                end
            end
            Hotkey.copy(Hotkey[specialStrId].keys, Hotkey[specialStrId].newKeys)
            imgui.CloseCurrentPopup();
        end
        imgui.SameLine()
        -- imgui.PushStyleColor(imgui.Col.Button, Colors.second.vec4);
        if (UI.Components.Button(u8'Оставить везде##hotkey-all-allow', imgui.ImVec2(150, 26), true)) then
            Hotkey.copy(Hotkey[specialStrId].keys, Hotkey[specialStrId].newKeys)
            imgui.CloseCurrentPopup();
        end
        imgui.SameLine()
        if (UI.Components.Button(u8'Отмена##hotkey-cancel', imgui.ImVec2(150, 26), true)) then
            imgui.CloseCurrentPopup();
        end
        -- imgui.PopStyleColor();
        imgui.EndPopup()
    end
end

return function(id, name, size, ignoreConflicts)
    local response = Hotkey.Draw(id, name, size);
    if (response and not ignoreConflicts) then
        lastEditedParam = id
        -- Circle:initialize();
        local isBusy = false
        local ids = Hotkey.getAllMatches(Hotkey[id].keys)
        if ids and #ids > 1 then
            for _, oid in ipairs(ids) do
                if oid ~= id then
                    isBusy = true
                    break
                end
            end
        end
        -- print('isBusy', isBusy)
        -- Utils.debug('hotkey edited. isBusy: '..tostring(isBusy));
        if #getBindsWithKeys(Hotkey[id].keys, lastEditedParam) > 0 then
            if not Hotkey[id].newKeys then
                Hotkey[id].newKeys = {}
            end
            Hotkey.copy(Hotkey[id].newKeys, Hotkey[id].keys)
            Hotkey.copy(Hotkey[id].keys, Hotkey[id].lastKeys)
            imgui.OpenPopup('hotkey-warning')
        else
            print("SAVE CONFIG")
        end
    end
    return response;
end