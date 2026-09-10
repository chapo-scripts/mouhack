local Network = ModuleCore.Category:new("raknet", "Сеть")
Network:AddPage("nops", require("modules.network.nops"))
Network:AddPage("functions", require("modules.network.functions"))