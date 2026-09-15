local props = { 
	[0716] = true, [0733] = true, [0737] = true, [0792] = true, [1211] = true, [1216] = true, [1220] = true,
	[1223] = true, [1224] = true, [1226] = true, [1229] = true, [1230] = true, [1231] = true, [1232] = true,
	[1233] = true, [1257] = true, [1258] = true, [1280] = true, [1283] = true, [1284] = true, [1285] = true,
	[1286] = true, [1287] = true, [1288] = true, [1289] = true, [1290] = true, [1291] = true, [1293] = true,
	[1294] = true, [1297] = true, [1300] = true, [1315] = true, [1350] = true, [1351] = true, [1352] = true,
	[1373] = true, [1374] = true, [1375] = true, [1408] = true, [1411] = true, [1412] = true, [1413] = true,
	[1418] = true, [1438] = true, [1440] = true, [1447] = true, [1460] = true, [1461] = true, [1468] = true,
	[1478] = true, [1568] = true, [3276] = true, [3460] = true, [3516] = true, [3853] = true, [3855] = true
}

return function(page)
    page.config.noFuckingProps = imgui.new.bool(false)
    page:On("loop", function()
        if (isCharInAnyCar(PLAYER_PED) and page.config.noFuckingProps[0]) then
            local veh = storeCarCharIsInNoSave(PLAYER_PED)
            if (getCarSpeed(veh)) >= 10 then
                for _, object in ipairs(getAllObjects()) do
                    local model = getObjectModel(object)
                    if (props[model] == true) then
                        sortOutObjectCollisionWithCar(object, veh)
                        if (isVehicleTouchingObject(veh, object)) then
                            breakObject(object, 0)
                            break
                        end
                    end
                end
            end
        end
    end)
    return Funcs:new(FuncType.Toggle, {
        label = "NoFuckingProps",
        description = "Моментально ломает разрушаемые объекты при столкновениях\nАвтор: @Cosmo",
        value = page.config.noFuckingProps
    })
end