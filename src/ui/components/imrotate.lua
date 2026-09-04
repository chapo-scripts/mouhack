local ImRotate1 = {}

local rotation_start_index
function ImMin(lhs, rhs) return imgui.ImVec2(math.min(lhs.x, rhs.x), math.min(lhs.y, rhs.y)); end
function ImMax(lhs, rhs) return imgui.ImVec2(math.max(lhs.x, rhs.x), math.max(lhs.y, rhs.y)); end
function ImRotate(v, cos_a, sin_a) return imgui.ImVec2(v.x * cos_a - v.y * sin_a, v.x * sin_a + v.y * cos_a); end
function ImRotate1.Start()
   rotation_start_index = imgui.GetWindowDrawList().VtxBuffer.Size;
end

function ImRotationCenter()
   local l, u = imgui.ImVec2(imgui.FLT_MAX, imgui.FLT_MAX), imgui.ImVec2(-imgui.FLT_MAX, -imgui.FLT_MAX); -- bounds
   local buf = imgui.GetWindowDrawList().VtxBuffer
   for i = rotation_start_index, buf.Size - 1 do
      l, u = ImMin(l, buf.Data[i].pos), ImMax(u, buf.Data[i].pos);
   end
   return imgui.ImVec2((l.x+u.x)/2, (l.y+u.y)/2); -- or use _ClipRectStack?
end

function calcImVec2(l, r) return { x = l.x - r.x, y = l.y - r.y } end

function ImRotate1.End(rad, center)
   if center == nil then
      center = ImRotationCenter()
   end
   local s, c = math.sin(rad), math.cos(rad);
   center = calcImVec2(ImRotate(center, s, c), center);
   local buf = imgui.GetWindowDrawList().VtxBuffer;
   for i = rotation_start_index, buf.Size - 1 do
      buf.Data[i].pos = calcImVec2(ImRotate(buf.Data[i].pos, s, c), center);
   end
end

return ImRotate1