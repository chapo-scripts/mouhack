local imgui = require('mimgui');
imgui.Scroller = {
	_ids = {},
	_version = 1,
	_author = "Double Tap Inside"
}

setmetatable(imgui.Scroller, {__call = function(self, id, step, duration, HoveredFlags)
	if not HoveredFlags then HoveredFlags = imgui.HoveredFlags.ChildWindows end
	if not imgui.Scroller._ids[id] then imgui.Scroller._ids[id] = {} end
	local current_position = imgui.GetScrollY()
	if (imgui.IsWindowHovered(HoveredFlags) and imgui.IsMouseDown(0)) then imgui.Scroller._ids[id].start_clock = nil end
	if imgui.Scroller._ids[id].start_clock then
		if (os.clock() - imgui.Scroller._ids[id].start_clock) * 1000 <= duration then		
			local progress = (os.clock() - imgui.Scroller._ids[id].start_clock) * 1000 / duration			
			local fading_progress = progress * (2 - progress)
			local distance = (imgui.Scroller._ids[id].target_position - imgui.Scroller._ids[id].start_position)
			local new_position = imgui.Scroller._ids[id].start_position + distance * fading_progress
			if new_position < 0 then
				new_position = 0
				imgui.Scroller._ids[id].start_clock = nil
			elseif new_position > imgui.GetScrollMaxY() then
				new_position = imgui.GetScrollMaxY()
				imgui.Scroller._ids[id].start_clock = nil
			end
			imgui.SetScrollY(math.floor(new_position))
		else
			imgui.Scroller._ids[id].start_clock = nil
			imgui.SetScrollY(imgui.Scroller._ids[id].target_position)
		end
	end
	
	local wheel_delta = imgui.GetIO().MouseWheel
	if wheel_delta ~= 0 and imgui.IsWindowHovered(HoveredFlags) then
		local offset = -wheel_delta * step
		if not imgui.Scroller._ids[id].start_clock then
			imgui.Scroller._ids[id].start_clock = os.clock()
			imgui.Scroller._ids[id].start_position = current_position
			imgui.Scroller._ids[id].target_position = current_position + offset
		else
			imgui.Scroller._ids[id].start_clock = os.clock()
			imgui.Scroller._ids[id].start_position = current_position
			if imgui.Scroller._ids[id].start_position < imgui.Scroller._ids[id].target_position and offset > 0 then
				imgui.Scroller._ids[id].target_position = imgui.Scroller._ids[id].target_position + offset
				
			elseif imgui.Scroller._ids[id].start_position > imgui.Scroller._ids[id].target_position and offset < 0 then
				imgui.Scroller._ids[id].target_position = imgui.Scroller._ids[id].target_position + offset
			
			else
				imgui.Scroller._ids[id].target_position = current_position + offset
			end
		end
	end
end});
return imgui.Scroller;