local memory = require("memory")
return Funcs:new(FuncType.Button, {
    label = "Очистить чат",
    text = "Очистить",
    onClick = function()
        memory.fill(sampGetChatInfoPtr() + 306, 0x0, 25200, false)
        memory.write(sampGetChatInfoPtr() + 306, 25562, 4, false)
        memory.write(sampGetChatInfoPtr() + 0x63DA, 1, 1, false)
    end
})