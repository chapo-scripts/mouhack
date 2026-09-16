local logFunc = [[
const sendToScript = (status, ...args) => {
    cef.sendMessage(`mouhack_tool_execution_${status ? "success" : "error"}|${...args}`)
}
try {
    %s
} catch (e) {

}
]]

local function eval(text)

end

return function(category)
    local page = category:AddPage("js", "JavaScript")
    page.config.showExecutionResult = imgui.new.bool(true)
    page.config.jsCode = imgui.new.char[4096]("console.log(\"Hello\")")
    -- TODO: Add outgoing 220 packet handler, hook & nop "mouhack_tool_execution_(%w+)|(.+)" if page.config.showExecutionResult[0] is true
    page:AddFunc(Funcs:new(FuncType.TextArea, {
        label = "Выполнить JavaScript",
        value = page.config.jsCode,
        options = {
            Funcs:new(FuncType.Button, {
                label = "",
                text = "Выполнить",
                onClick = function()
                    print("Running...")
                    eval(ffi.string(page.config.showExecutionResult))
                end
            }),
            Funcs:new(FuncType.Toggle, {
                label = "Отобразить результат выполнения в консоли",
                value = page.config.showExecutionResult
            })
        }
    }))
end