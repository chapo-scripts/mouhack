--[[

v.1.1

Encoding: UTF-8

За основу биндера был взят скрипт https://github.com/AnWuPP/rkeys

Обозначения:
	Hotkey — название модуля.
	Слово 'хоткей' — визуальная часть хоткея.
	Слово 'бинд' — программная часть хоткея

Импорт модуля:
	При импорте вызываем функцию init() из модуля Hotkey и передаем в параметры:
		[1] vkeys:
			Для работы с новыми кодами для колеса мыши.
			Будут добавлены дополнительные коды vkeys.VK_WHEELDOWN и vkeys.VK_WHEELUP.
		[2] imgui:
			Для работы с mimgui и для отрисовки кнопки хоткея

	Параметр imgui можно опустить, если нужно использовать этот модуль только в качестве биндера

	При локальном определении модулей:
	-- local vkeys = require 'vkeys'
	-- local imgui = require 'mimgui'
	-- local Hotkey = require 'hotkey'
	-- Hotkey.init(vkeys, imgui)

	При глобальном определении модулей:
	-- vkeys = require 'vkeys'
	-- imgui = require 'mimgui'
	-- local Hotkey = require 'hotkey'
	-- -- не надо писать Hotkey.init()

При редактировании хоткея:
	- Привязка учитывается после отпускания любой клавиши/кнопки;
	- Не допускается комбинация только из кнопки VK_LBUTTON (ЛКМ);
	- Не допускается комбинация только из клавиш модификации (VK_MENU, VK_SHIFT, VK_CONTROL и его подверсии)

Клавиши управления при редактировании хоткея:
	VK_BACK (Backspace):
		Убрать комбинации клавиш хоткея (оставить пустую таблицу)
	{VK_RETURN (Enter), VK_TAB, VK_F6, VK_F7, VK_F8, VK_T, VK_OEM_3 (знак ~)} и VK_ESCAPE:
		Клавиши для отмены редактирования (и оставить все как было)

Свойства модуля и их изначальные значения:
	Hotkey._status: boolean = true
		Определяет, будут ли выполняться действия биндов при нажатии на комбинации клавиш

	Hotkey.click_delay: integer = 375
		Задержка между быстрыми нажатиями (в миллисекундах)

	Hotkey.ignore_cancel_keys: boolean = false
		Определяет, игнорировать ли клавиши для отмены при редактировании хоткея (кроме VK_ESCAPE)

	Hotkey.empty_key_names: string = ""
		Текст хоткея при пустой таблице комб. клавиш

	Hotkey.nonexistent_hotkey: string = "Hotkey with ID [%d] does not exist!"
		Текст для форматированного вывода несуществующего бинда.
		Передается лишь проверяемый ID через string.format

	Hotkey: table = {}
		Сам модуль также является списком, где хранятся свойства всех текущих биндов.
		Получить или изменить свойство бинда:
			Hotkey[*id*].*свойство* = *значение*

Свойства биндов и их изначальные значения:
	keys: table
		Комбинация клавиш

	action: function (id: integer)
		Действие, выполняемое при нажатии на комб. клавиш.
		В параметры функции передается ID бинда, действие которого выполняется в данный момент.
		Лучше не менять это свойство в процессе его выполнения

	pressed: boolean = false [только для чтения]
		Состояние нажатия на комб. клавиш

	clicks: integer = 0
		Количество быстрых нажатий на комб. клавиш
	
	consume_last_key: integer = Hotkey.CONSUME_KEY_FLAG.NONE
		Флаг чтобы не передавать последнюю нажатую клавишу/кнопку после себя.
		Может иметь несколько режимов, включенные в таблицу Hotkey.CONSUME_KEY_FLAG:
			CONSUME_KEY_FLAG.NONE 									- передавать всегда;
			CONSUME_KEY_FLAG.FOR_GAME								- не передавать только для игры;
			CONSUME_KEY_FLAG.FOR_SCRIPT								- не передавать только для скриптов;
			CONSUME_KEY_FLAG.FOR_GAME + CONSUME_KEY_FLAG.FOR_SCRIPT	- не передавать и для игры и для скриптов.
	
	consume_all_keys: boolean = false
		Если not nil and not false, отключать уже нажатые клавиши/кнопки в комб. клавиш `keys` и не пропускать последнюю нажатую клавишу/кнопку только для игры, если не задан `consume_last_key`

Далее, параметры функций выделенные как [параметр] можно опустить

Основные функции модуля:
	Hotkey.register(keys, action [, consume_last_key] [, consume_all_keys]) -> id: integer
		Забиндить новую комбинацию клавиш.
		Если параметром `action` передать функцию `Hotkey.OnSetStatus`,
		то бинд будет играть роль переключателя состояния биндов (Hotkey._status),
		и будет выполняться независимо от `Hotkey._status`.
		`consume_last_key` и `consume_all_keys` описаны в свойствах бинда таблицы.
		Возвращает ID нового бинда

	Hotkey.unRegister(id)
		Убрать бинд по ID
	Примечание:
		При удалении бинда в списке Hotkey бинд приравняется к nil,
		создавая пустое место в списке.
		Так что если нужно пройтись по всем биндам, то рекомендуется использовать функцию Hotkey.getIds()

	Hotkey.Draw(id [, name] [, size]) -> boolean
		!!! Использовать строго внутри `imgui.OnFrame` !!!
		Отображение хоткея в виде кнопки `imgui.Button`.
		При нажатии на кнопку начинается редактирование комб. клавиш хоткея.
		Параметр `name` определяет текст выводимый справа от хоткея.
		Параметр `size` определяет размеры кнопки хоткея.
		По-умолчанию размеры подстраиваются по содержанию комб. клавиш.
		Возвращает true, если хоткей только что был отредактирован
	Примечание:
		После редактирования хоткея новые комб. клавиш будут сохранены в свойстве `keys` бинда,
		которого можно получить и/или изменить:
			Hotkey[*id*].keys = {*комб. клавиш*}

	Hotkey.getEditing() -> id: integer|nil
		Возвращает ID бинда который редактируется на данный момент.
		В ином случае вернет nil
	
	Hotkey.getIds(comp) -> id_list: table
		Возвращает отсортированный таблицу-список ID всех зарегистрированных биндов на данный момент.
		Если не указать функцию сортировки `comp`, то по-умолчанию сортирует по условию a < b

Дополнительные функции модуля:
	Hotkey.getAllMatches(keys) -> table|nil
		Возвращает список ID всех биндов, у которых совпадает комб. клавиш с таблицой `keys`.
		Порядок расположения клавиш неважен.
		Вернет nil если не нашлось ни одного

	Hotkey.getDownKeys([asList]) -> table
		Возвращает таблицу текущих нажатых клавиш/кнопок в виде:
			{..., [KEY_CODE] = true|nil, ...}
		Если `asList` == true, то вернет в виде списка:
			{..., *key_code*, ...}

	Hotkey.isOnlyKeyDown(key) -> boolean
		Возвращает true, если нажата ТОЛЬКО клавиша/кнопка `key`

	Hotkey.getKeyNames(keys [, separator]) -> string|table
		Получить название клавиш/кнопок `keys` разделенным через `separator` в виде строки.
		Если `separator` не указан, то вернет названия в виде списка

	@Override
	Hotkey.OnDrawButton = function (keyNames: string, size: ImVec2)
		[Пере]Определяет функцию отрисовки кнопки хоткея.
		Будет использован последний отрисованный объект для проверки на нажатие
	
	@Override
	Hotkey.OnSetStatus = function (status: boolean)
		[Пере]Определяет функцию вызываемую при переключении состояния биндов
]]

local vkeys = _G.vkeys or require 'vkeys'
local bitex = require 'bitex'
local bit = bit or require 'bit'
local ffi = require 'ffi'
local wm = require 'windows.message'
local imgui = _G.imgui

local M = {}

local messages = {
	[wm.WM_KEYDOWN] = true,
	[wm.WM_SYSKEYDOWN] = true,
	[wm.WM_KEYUP] = true,
	[wm.WM_SYSKEYUP] = true,
	[wm.WM_LBUTTONDOWN] = true,
	[wm.WM_LBUTTONDBLCLK] = true,
	[wm.WM_LBUTTONUP] = true,
	[wm.WM_RBUTTONDOWN] = true,
	[wm.WM_RBUTTONDBLCLK] = true,
	[wm.WM_RBUTTONUP] = true,
	[wm.WM_MBUTTONDOWN] = true,
	[wm.WM_MBUTTONDBLCLK] = true,
	[wm.WM_MBUTTONUP] = true,
	[wm.WM_XBUTTONDOWN] = true,
	[wm.WM_XBUTTONDBLCLK] = true,
	[wm.WM_XBUTTONUP] = true,
	[wm.WM_MOUSEWHEEL] = true,
}
local mouseLRMVK = {
	[wm.WM_LBUTTONDOWN] = vkeys.VK_LBUTTON,
	[wm.WM_LBUTTONUP] = vkeys.VK_LBUTTON,
	[wm.WM_RBUTTONDOWN] = vkeys.VK_RBUTTON,
	[wm.WM_RBUTTONUP] = vkeys.VK_RBUTTON,
	[wm.WM_MBUTTONDOWN] = vkeys.VK_MBUTTON,
	[wm.WM_MBUTTONUP] = vkeys.VK_MBUTTON,
}
local mouseXMessages = {
	[wm.WM_XBUTTONUP] = true,
	[wm.WM_XBUTTONDOWN] = true,
	[wm.WM_XBUTTONDBLCLK] = true,
}
local mouseXVKList = {
	vkeys.VK_XBUTTON1,
	vkeys.VK_XBUTTON2,
}
local downMessages = {
	[wm.WM_KEYDOWN] = true,
	[wm.WM_SYSKEYDOWN] = true,
	[wm.WM_LBUTTONDOWN] = true,
	[wm.WM_RBUTTONDOWN] = true,
	[wm.WM_MBUTTONDOWN] = true,
	[wm.WM_XBUTTONDOWN] = true,
	[wm.WM_LBUTTONDBLCLK] = true,
	[wm.WM_RBUTTONDBLCLK] = true,
	[wm.WM_MBUTTONDBLCLK] = true,
	[wm.WM_XBUTTONDBLCLK] = true,
	[wm.WM_MOUSEWHEEL] = true,
}
local exitKeys = {
	[vkeys.VK_RETURN] = true,
	[vkeys.VK_TAB] = true,
	[vkeys.VK_F6] = true,
	[vkeys.VK_F7] = true,
	[vkeys.VK_F8] = true,
	-- [vkeys.VK_T] = true,
	[vkeys.VK_OEM_3] = true,
}
local modKeys = {
	[vkeys.VK_SHIFT] = true,
	[vkeys.VK_LSHIFT] = true,
	[vkeys.VK_RSHIFT] = true,
	[vkeys.VK_MENU] = true,
	[vkeys.VK_LMENU] = true,
	[vkeys.VK_RMENU] = true,
	[vkeys.VK_CONTROL] = true,
	[vkeys.VK_LCONTROL] = true,
	[vkeys.VK_RCONTROL] = true,
}

local keysDown = {}
local clickThreads = {}
local consumingKey = nil

-- local M.editHotkey = nil
M.editHotkey = nil
local endKeys = nil
local editStart = false

local function tcopy(t)
	local r = {}
	for k,v in pairs(t) do
		r[k] = v
	end
	return r
end

local function tconcat(t1, ...)
	local ts = {...}
	for _,t2 in ipairs(ts) do
		for i = 1, #t2 do
			t1[#t1 + 1] = t2[i]
		end
	end
	return t1
end

local function tcontains(t, value)
	for _,v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

local function isExitKeyDown()
	for k,_ in pairs(exitKeys) do
		if keysDown[k] then
			return true
		end
	end
	return false
end

local function otzhatModKeyExtendKeys(key)
	if key == vkeys.VK_SHIFT then
		keysDown[vkeys.VK_LSHIFT] = nil
		keysDown[vkeys.VK_RSHIFT] = nil
	elseif key == vkeys.VK_MENU then
		keysDown[vkeys.VK_LMENU] = nil
		keysDown[vkeys.VK_RMENU] = nil
	elseif key == vkeys.VK_CONTROL then
		keysDown[vkeys.VK_LCONTROL] = nil
		keysDown[vkeys.VK_RCONTROL] = nil
	end
end

local function otzhat()
	for k,_ in pairs(keysDown) do
		if not isKeyDown(k) then
			keysDown[k] = nil
		end
	end
end

local function isOnlyModKeysDown()
	local empty = true
	for k,_ in pairs(keysDown) do
		empty = false
		if not modKeys[k] then
			return false
		end
	end
	return not empty
end

-- Инициализация нужных модулей:
---@param _vkeys? vkeys
---@param _imgui? imgui
function M.init(_vkeys, _imgui)
	imgui = _imgui or imgui

	vkeys = _vkeys or vkeys
	vkeys.VK_WHEELDOWN = 0x100
	vkeys.VK_WHEELUP = 0x101
	vkeys.key_names[vkeys.VK_WHEELDOWN] = "Mouse Wheel Down"
	vkeys.key_names[vkeys.VK_WHEELUP] = "Mouse Wheel Up"
end
M.init()

local conflicts = {};

function M.CheckConflict(strId, lastEditedParam)
	conflicts[strId or 'none'] = lastEditedParam;
end

function M.BeginConflictPopup(strId)
	local lastEditedParam = conflicts[strId];
	if imgui.BeginPopupModal(strId or 'hotkey-warning', nil, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoDecoration) then
        imgui.Spacing();
        imgui.PushFont(UI.font[20].Bold);
        imgui.TextDisabled(u8('Это сочетание клавиш уже используется!'));
        imgui.PopFont();
        imgui.SetCursorPosY(imgui.GetCursorPosY() + 10)
        imgui.BeginGroup()
            imgui.Text(u8('В некоторых функциях уже используется такое же сочетание клавиш.\nХотите продолжить?'))
        imgui.EndGroup()
        imgui.SetCursorPosY(imgui.GetCursorPosY() + 5)
        if (UI.Components.button(u8'Заменить##hotkey-confirm', imgui.ImVec2(150, 26), false)) then
            local ids = Hotkey.getAllMatches(Hotkey[lastEditedParam.hotkeyId].newKeys)
            if ids then
                for _,id in ipairs(ids) do
                    if id ~= lastEditedParam.hotkeyId then
                        Hotkey.clear(Hotkey[id].keys)
                    end
                end
            end
            Hotkey.copy(Hotkey[lastEditedParam.hotkeyId].keys, Hotkey[lastEditedParam.hotkeyId].newKeys)
            SaveConfig()
            imgui.CloseCurrentPopup();
        end
        imgui.SameLine()
        if (UI.Components.button(u8'Оставить везде##hotkey-all-allow', imgui.ImVec2(150, 26), false)) then
            Hotkey.copy(Hotkey[lastEditedParam.hotkeyId].keys, Hotkey[lastEditedParam.hotkeyId].newKeys)
            SaveConfig()
            imgui.CloseCurrentPopup();
        end
        imgui.SameLine()
        if (UI.Components.button(u8'Отмена##hotkey-cancel', imgui.ImVec2(150, 26), false)) then
            imgui.CloseCurrentPopup();
        end
        imgui.EndPopup()
    end
end

-- Определяет состояние биндов. Если not nil and not false, то действия биндов будут выполнены
M._status = true

-- Определяет задержку между быстрыми нажатиями (в миллисекундах)
M.click_delay = 375

-- Определяет игнорирование клавиш для отмены при редактировании хоткея (кроме `VK_ESCAPE`)
M.ignore_cancel_keys = false

-- Определяет текст хоткея при пустой таблице комб. клавиш
M.empty_key_names = u8"нет"

-- Текст для форматированного вывода несуществующего бинда. Передается лишь проверяемый ID
M.nonexistent_hotkey = "Hotkey with ID [%d] does not exist!"

-- Флаги для свойcтва бинда `consume_last_key`
---@enum CONSUME_KEY_FLAG
M.CONSUME_KEY_FLAG = {
	NONE = 0,			--	передавать всегда
	FOR_GAME = 1,		--	не передавать только для игры
	FOR_SCRIPT = 2,		--	не передавать только для скриптов
--	FOR_GAME + FOR_SCRIPT	не передавать и для игры и для скриптов
}

-- Забиндить новую комбинацию клавиш. Если параметром `action` передать таблицу `Hotkey`, то бинд будет играть роль переключателя состояния биндов (`Hotkey._status`)
---@param keys table							Комбинация клавиш
---@param action function					Функция-действие
---@param consume_last_key? CONSUME_KEY_FLAG	Флаг чтобы не передавать последнюю нажатую клавишу/кнопку после себя. Может быть одним или объединением из `Hotkey.CONSUME_KEY_FLAG`
---@param consume_all_keys? boolean 			Если not nil and not false, отключать уже нажатые клавиши комб. клавиш `keys` и не пропускать последнюю нажатую клавишу/кнопку только для игры, если не задан `consume_last_key`
---@return integer|nil id						Возвращает ID нового бинда
function M.register(keys, action, consume_last_key, consume_all_keys, name)
	print('Hotkey register:', keys, action, consume_last_key, consume_all_keys)
	if keys and action then
		local id = #M + 1
		local bind = {
			keys = keys,
			action = action,
			pressed = false,
			clicks = 0,
			consume_last_key = consume_last_key or M.CONSUME_KEY_FLAG.NONE,
			consume_all_keys = consume_all_keys or false,
			name = name
		}
		M[id] = bind

		clickThreads[id] = lua_thread.create_suspended(function ()
			wait(M.click_delay)
			bind.clicks = 0
		end)

		return id
	end
	return 0
end

-- Убрать бинд по ID
---@param id integer
function M.unRegister (id)
	if type(id) == "number" and M[id] then
		clickThreads[id]:terminate()
		clickThreads[id] = nil
		M[id] = nil
	end
end

function M.clear(t)
	if t then
		for k, v in pairs(t) do
			t[k] = nil
		end
	end
end

function M.copy(t1, t2)
	if t1 and t2 then
		M.clear(t1)
		for k, v in ipairs(t2) do
			table.insert(t1, v)
		end
	end
end

-- Отобразить хоткей в виде кнопки `imgui.Button`. Использовать строго внутри `imgui.OnDrawFrame`!
---@param id integer
---@param name? string			Если не nil, отобразить хоткей с названием `name`
---@param size? ImVec2			Размер кнопки хоткея
---@return boolean|nil edited	Возвращает true, если хоткей только что был отредактирован
function M.Draw(id, name, size)
	if type(id) == "number" and M[id] then
		local width = 40
		name = tostring(name)
		local keyNames = nil
		local edited = false

		if M.editHotkey == id then
			if keysDown[vkeys.VK_BACK] then
				edited = true
				M.clear(M[id].keys)
				M.editHotkey = nil
			elseif (not M.ignore_cancel_keys and isExitKeyDown()) or keysDown[vkeys.VK_ESCAPE] then
				M.editHotkey = nil
			elseif endKeys then
				endKeys[vkeys.VK_SHIFT] = nil
				endKeys[vkeys.VK_MENU] = nil
				endKeys[vkeys.VK_CONTROL] = nil

				local keys1, keys2, keys3 = {}, {}, {}
				if (#endKeys >= 3) then
					endKeys = {endKeys[1], endKeys[2]};
				end
				local index = 0;
				for k,_ in pairs(endKeys) do
					index = index + 1;
					-- sampAddChatMessage((index < 3 and 'insert ' or 'skip') .. tostring(k), -1);						
					if index < 3 then -- ALLOW ONLY 2 KEYS
						if modKeys[k] then
							table.insert(keys1, k)
						elseif k == vkeys.VK_WHEELDOWN or k == vkeys.VK_WHEELUP then
							table.insert(keys3, k)
						else
							table.insert(keys2, k)
						end
					end
				end
				table.sort(keys2, function (a, b)
					return #tostring(vkeys.id_to_name(a)) > #tostring(vkeys.id_to_name(b))
				end)

				tconcat(keys1, keys2, keys3)

				if not (#keys1 == 1 and keys1[1] == vkeys.VK_LBUTTON) then
					if not M[id].lastKeys then
						M[id].lastKeys = {}
					end
					M.copy(M[id].lastKeys, M[id].keys)
					M.copy(M[id].keys, keys1)
					edited = true
				end

				endKeys = nil
				M.editHotkey = nil
			else
				keyNames = "..."
			end
		end
		keyNames = keyNames or #M[id].keys > 0 and M.getKeyNames(M[id].keys, " + ") or M.empty_key_names
		local height = imgui.CalcTextSize(keyNames).y + imgui.GetStyle().FramePadding.y * 2;
		
		local calcWidth = imgui.CalcTextSize(keyNames).x + 4
		if not size and calcWidth > width then width = 0 end

		local p = imgui.GetCursorScreenPos();
		local textSize = imgui.CalcTextSize(keyNames);
		M.OnDrawButton(keyNames, size or imgui.ImVec2(width, height))
		UI.Components.Hint('hint-hotkey-' .. id, u8'Чтобы убрать клавишу, используйте Backspace')
		-- imgui.GetWindowDrawList():AddText(p + imgui.ImVec2(width / 2 - textSize.x / 2, height / 2 - textSize.y / 2), 0xFFffffff, keyNames)
		
		if imgui.IsItemHovered() and imgui.IsItemClicked() and not M.editHotkey then
			M.editHotkey = id
			editStart = true
			for i,_ in pairs(M) do if type(i) == "number" then
				M[i].pressed = false
			end end
		end

		if name and name ~= "" then
			imgui.SameLine()
			imgui.Text(name)
		end

		return edited
	else
		imgui.Text(M.nonexistent_hotkey:format(id))

		return nil
	end
end

-- Возвращает ID бинда который редактируется на данный момент
---@return integer|nil
function M.getEditing()
	return M.editHotkey
end

---Возвращает отсортированный таблицу-список, содержащий ID всех зарегистрированных биндов на данный момент
---@generic T
---@param comp? fun(a: T, b: T):boolean Функция сортировки. По-умолчанию вернет `a < b`
---@return T[] id_list
function M.getIds(comp)
	comp = comp or function (a, b)
		return a < b
	end
	local id_list = {}
	for id,_ in pairs(M) do
		if type(id) == "number" then
			table.insert(id_list, id)
		end
	end
	table.sort(id_list, comp)
	return id_list
end

--- Возвращает список ID всех биндов, у которых совпадает комб. клавиш с таблицой `keys`. Порядок клавиш/кнопок неважен
---@param keys table
---@return table|nil binds	Если не нашлось ни одного, то вернет nil
function M.getAllMatches(keys)
	local binds = {}
	if #keys > 0 then
		for id,_ in pairs(M) do 
			if type(id) == "number" then
				local bool = true
				for _,vk in ipairs(keys) do
					if not tcontains(M[id].keys, vk) then
						bool = false
						break
					end
				end
				if bool then
					table.insert(binds, id)
				end
			end
		end
	end

	return #binds > 0 and binds or nil
end

-- Получить таблицу нажатых клавиш/кнопок. Проверить нажата ли клавиша/кнопка можно через: Hotkey.getDownKeys[*key_code*] == true|nil
---@param asList? boolean	Если true, то вернет значение в виде списка: {..., *key_code*, ...}
---@return table keysDown
function M.getDownKeys (asList)
	local res = {}
	-- sampAddChatMessage('getDownKeys', -1);
	if asList then
		for k,_ in pairs(keysDown) do
			table.insert(res, k)
		end
	else
		res = tcopy(keysDown)
	end
	
    return res
end

--- Возвращает true, если нажата ТОЛЬКО клавиша/кнопка `key`
---@param key integer
---@return boolean
function M.isOnlyKeyDown(key)
	local len = 0
	for _,_ in pairs(keysDown) do
		len = len + 1
	end
	return len > 0 and keysDown[key] and (len == 1 or modKeys[key] and len == 2) or false
end

-- Получить название клавиш/кнопок `keys` разделенным через `separator` в виде строки. Если `separator` == nil, то вернет названия в виде списка
---@param keys table
---@param separator? string
---@return string|table keyNames
function M.getKeyNames(keys, separator)
	local keyNames = ""
	local nameList = {}
	for _,vk in ipairs(keys) do
		table.insert(nameList, tostring(vkeys.id_to_name(vk)))
		keyNames = keyNames ..(keyNames ~= "" and separator or "").. tostring(vkeys.id_to_name(vk))
	end
	return separator and keyNames or nameList
end

-- `@Override` функция для переопределения функции отрисовки кнопки. Будет использован последний отрисованный объект для проверки на нажатие
---@param keyNames string	Название комб. клавиш
---@param size ImVec2		Размер кнопки
function M.OnDrawButton(keyNames, size)
	imgui.PushStyleVarVec2(imgui.StyleVar.ButtonTextAlign, imgui.ImVec2(0.5, 0.5))
	imgui.Button(keyNames, size)
	imgui.PopStyleVar()
end

-- `@Override` функция для переопределения функции вызываемую при переключении состояния биндов
---@param status boolean текущее состояние биндов
function M.OnSetStatus(status)
	print(("Hotkeys %s"):format(status and "{00ff00}enabled" or "{ff0000}disabled"))
end

local function isAdditionalKeyPressed()
	for _, key in ipairs({ VK_MENU, VK_RMENU, VK_LMENU,	VK_SHIFT, VK_LSHIFT, VK_RSHIFT,	VK_CONTROL, VK_RCONTROL, VK_LCONTROL }) do
		if (isKeyDown(key)) then
			return true;
		end
	end
end

addEventHandler("onWindowMessage", function (msg, key, lparam)
	if messages[msg] then
		local scancode = bitex.bextract(lparam, 16, 8)
		local keystate = bitex.bextract(lparam, 30, 1)
		local extend = bitex.bextract(lparam, 24, 1)
		local exkey = (key == vkeys.VK_MENU and (extend == 1 and vkeys.VK_RMENU or vkeys.VK_LMENU))
		or (key == vkeys.VK_SHIFT and (scancode == 42 and vkeys.VK_LSHIFT or scancode == 54 and vkeys.VK_RSHIFT))
		or (key == vkeys.VK_CONTROL and (extend == 1 and vkeys.VK_RCONTROL or vkeys.VK_LCONTROL))
		or nil
		-- Utils.debug('hotkey-handler exkey = ' .. tostring(exkey));
		key = mouseLRMVK[msg] or key
		if mouseXMessages[msg] then
			key = mouseXVKList[bit.rshift(bit.band(key, 0xffff0000), 16)]
		elseif msg == wm.WM_MOUSEWHEEL then
			local delta = bit.rshift(tonumber(ffi.cast('int32_t', key)), 16)
			if delta >= 0x8000 then delta = delta-0xffff end
			if delta < 0 then
				key = vkeys.VK_WHEELDOWN
			elseif delta > 0 then
				key = vkeys.VK_WHEELUP
			end
		end

		if downMessages[msg] then
			if not keysDown[key] and keystate == 0 then
				keysDown[key] = true
				if exkey then
					keysDown[exkey] = true
				end
				if editStart then
					editStart = false
				end
			end

			if not M.editHotkey then
				if consumingKey and key == consumingKey.key then
					consumeWindowMessage(consumingKey.for_game, consumingKey.for_script)
				else
					consumingKey = nil
				end
				local statusChanged = false
				for id,_ in pairs(M) do if type(id) == "number" then
					if M._status or ((not statusChanged) and M[id].action == M.OnSetStatus) then
						if #M[id].keys > 0 then
							local down = true

							for _,vk in ipairs(M[id].keys) do
								if not keysDown[vk] then
									down = false
									break
								end
							end

							if down then
								if not M[id].pressed then
									M[id].pressed = msg ~= wm.WM_MOUSEWHEEL
									if M[id].action == M.OnSetStatus then
										statusChanged = true
										break
									else
										if (#M[id].keys > 1 or not isAdditionalKeyPressed()) then
											clickThreads[id]:terminate()
											M[id].clicks = M[id].clicks + 1
											clickThreads[id]:run()
											lua_thread.create(M[id].action, id)
										end
									end
								end

								local flag = M[id].consume_last_key
								if flag ~= M.CONSUME_KEY_FLAG.NONE then
									local for_game = bit.band(flag, M.CONSUME_KEY_FLAG.FOR_GAME) ~= 0
									local for_script = bit.band(flag, M.CONSUME_KEY_FLAG.FOR_SCRIPT) ~= 0
									consumingKey = {key=key, for_game=for_game, for_script=for_script}
									consumeWindowMessage(for_game, for_script)
								end
								if M[id].consume_all_keys then
									for _,vk in ipairs(M[id].keys) do
										if vk ~= key then
											setVirtualKeyDown(vk, false)
										elseif flag == M.CONSUME_KEY_FLAG.NONE then
											consumingKey = {key=key, for_game=true, for_script=false}
											consumeWindowMessage(true, false)
										end
									end
								end
							end
						end
					end
				end end
				if statusChanged then
					M._status = not M._status
					M.OnSetStatus(M._status)
				end
			end

			if msg == wm.WM_MOUSEWHEEL then
				if M.editHotkey then
					endKeys = tcopy(keysDown)
				end

				keysDown[key] = nil
			end

			if ((not consumingKey) or consumingKey.key ~= key) and M.editHotkey and (exitKeys[key] or key == vkeys.VK_ESCAPE) then
				consumeWindowMessage(true, M.ignore_cancel_keys and exitKeys[key] or false)
			end
		else
			if keysDown[key] then
				if editStart and key == vkeys.VK_LBUTTON then
					editStart = false
				elseif (key ~= vkeys.VK_LBUTTON or ((not editStart) and (not M.isOnlyKeyDown(vkeys.VK_LBUTTON))))
				and M.editHotkey and (M.ignore_cancel_keys or not exitKeys[key]) and key ~= vkeys.VK_ESCAPE
				and not isOnlyModKeysDown()
				then
					endKeys = tcopy(keysDown)
				end

				keysDown[key] = nil
				otzhatModKeyExtendKeys(key)
			end
			if consumingKey and key == consumingKey.key then
				consumeWindowMessage(consumingKey.for_game, consumingKey.for_script)
				consumingKey = nil
			end
			local statusChangerFound = false
			for id,_ in pairs(M) do if type(id) == "number" then
				if M[id].pressed then
					if M.editHotkey or (not M._status) and (M[id].action ~= M.OnSetStatus or statusChangerFound) then
						M[id].pressed = false
					else
						if M[id].action == M.OnSetStatus then
							statusChangerFound = true
						end
						for _,vk in ipairs(M[id].keys) do
							if vk == key then
								M[id].pressed = false
								break
							end
						end
					end
				end
			end end
			otzhat()
		end
	elseif msg == wm.WM_KILLFOCUS then
		keysDown = {}
	end
end)

return M