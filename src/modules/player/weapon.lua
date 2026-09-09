local imgui = require("mimgui")
local Page = ModuleCore.Page:new("Оружие")


Page.config.noSpread = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noSpread,
    label = "No Spread"
})

Page.config.skills = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.skills,
    label = "Скиллы"
})

Page.config.noCamRestore = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noCamRestore,
    label = "NoCameraRestore",
    description = "Убирает восстановление камеры при закрытии прицела.\nАвтор: @g305noobo"
})

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

Page.config.instantCrosshair = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.instantCrosshair,
    label = "Instant Crosshair",
    description = "Моментально отображает прицел.\nАвтор: @FYP"
})


Page.config.rapidFire = { enabled = imgui.new.bool(false), multiplier = imgui.new.float(2) }
Page:AddItem(PageItemType.Toggle, {
    label = "RapidFire",
    description = "Увеличивает скорострельность оружия",
    unsafe = true,
    value = Page.config.rapidFire.enabled,
    options = {
        Page:AddItem(PageItemType.SliderFloat, {
            label = "Множитель скорости",
            value = Page.config.rapidFire.multiplier,
            min = 0.1,
            max = 10,
            format = "x%0.1f",
            width = 150
        }, true)
    }
})

Page.config.noReload = imgui.new.bool(false)
Page:AddItem(PageItemType.Toggle, {
    value = Page.config.noReload,
    label = "No Reload"
})

Page:on("loop", function()
    showCrosshairInstantlyPatch(Page.config.instantCrosshair[0])
    writeMemory(0x5231A6, 1, Page.config.noCamRestore[0] and 0x90 or 0x75)
end)

return Page