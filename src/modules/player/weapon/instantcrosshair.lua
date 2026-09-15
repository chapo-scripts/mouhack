local memory = require("memory")
local function showCrosshairInstantlyPatch(enable)
	if enable then
		if not patch_showCrosshairInstantly then
			patch_showCrosshairInstantly = memory.read(0x0058E1D9, 1, true)
		end
		memory.write(0x0058E1D9, 0xEB, 1, true)
	elseif patch_showCrosshairInstantly ~= nil then
		memory.write(0x0058E1D9, patch_showCrosshairInstantly, 1, true)
		patch_showCrosshairInstantly = nil
	end
end

---@param page Page
return function(page)
    page.config.instantCrosshair = imgui.new.bool(false)
    page:On("loop", function()
        showCrosshairInstantlyPatch(page.config.instantCrosshair[0])
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "Instant Crosshair",
        value = page.config.instantCrosshair,
        description = "Удаляет задержку отображения прицела при прицеливании\nАвтор: @FYP"
    })
end