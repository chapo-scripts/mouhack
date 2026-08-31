MainWindowState = imgui.new.bool(false)

local newItem, items, errorText = imgui.new.char[128](""), { "first", "second" }, nil

imgui.OnFrame(
    function() return MainWindowState[0] end,
    function(frame)
        frame.HideCursor = false
        local res, size = imgui.GetIO().DisplaySize, imgui.ImVec2(500, 250)
        
        imgui.SetNextWindowPos(imgui.ImVec2(res.x / 2, res.y / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(size, imgui.Cond.Once)
        if (imgui.Begin('Main Window', MainWindowState, imgui.WindowFlags.NoCollapse)) then
            UI.Components.CenterText("This is template!")
            imgui.Text("Now you can edit code!")
            UI.Components.Link(getWorkingDirectory(), "Open project path")

            do
                imgui.NewLine()
                imgui.Text("List")
                for index, item in ipairs(items) do
                    imgui.Text(("%d. %s"):format(index, item))
                    imgui.SameLine(imgui.GetWindowWidth() - 10 - 24)
                    if (imgui.Button("X##remove-item-" .. index)) then
                        table.remove(items, index)
                    end
                end
                local input = imgui.InputText("##newItem", newItem, ffi.sizeof(newItem), imgui.InputTextFlags.EnterReturnsTrue)
                imgui.SameLine()
                local button = imgui.Button("Add")

                if (errorText) then
                    imgui.TextColored(imgui.ImVec4(1, 0, 0, 1), errorText)
                end
                if (input or button) then
                    errorText = nil
                    local itemStr = ffi.string(newItem)
                    if (table.includes(items, itemStr)) then
                        errorText = "Item alreay in list!"
                    else
                        table.insert(items, itemStr)
                        imgui.StrCopy(newItem, "")
                    end
                end
            end
            imgui.End()
        end
    end
)