imgui = require("mimgui")
for _, data in ipairs({
    {
        strId = "ped",
        name = "Персонаж",
        pages = {
            {
                strId = "main",
                name = "Общие",
                modules = {
                    require("modules.player.main.gm"),
                    require("modules.player.main.suicide"),
                    require("modules.player.main.spawn"),
                    require("modules.player.main.nodrunk"),
                    require("modules.player.main.clearanim"),
                }
            },
            {
                strId = "movement",
                name = "Передвижение",
                modules = {
                    require("modules.player.movement.infrun"),
                    require("modules.player.movement.sprinthook"),
                    require("modules.player.movement.animspeed"),
                    require("modules.player.movement.slap"),
                    require("modules.player.movement.freeze"),
                    require("modules.player.movement.teleport"),
                    require("modules.player.movement.airbrake"),
                }
            },
            {
                strId = "weapon",
                name = "Оружие",
                modules = {
                    require("modules.player.weapon.instantcrosshair"),
                    require("modules.player.weapon.nocamrestore"),
                    require("modules.player.weapon.give"),
                    require("modules.player.weapon.skills"),
                }
            }
        }
    },
    {
        strId = "vehicle",
        name = "Транспорт",
        pages = {
            {
                strId = "main",
                name = "Общие",
                modules = {
                    require("modules.vehicle.main.gm"),
                    require("modules.vehicle.main.visualgm"),
                    require("modules.vehicle.main.tankmode"),
                    require("modules.vehicle.main.engine"),
                    require("modules.vehicle.main.nolimit"),
                    require("modules.vehicle.main.nofuckingprops"),
                    require("modules.vehicle.main.nodoors"),
                }
            },
            {
                strId = "car",
                name = "Машина",
                modules = { require("modules.vehicle.car.flip"), require("modules.vehicle.car.rotate"), require("modules.vehicle.car.water") }
            },
            {
                strId = "cycle",
                name = "Вело / Мото",
                modules = {
                    require("modules.vehicle.moto.nobike"),
                    require("modules.vehicle.moto.jumpheight"),
                    require("modules.vehicle.moto.autoboost"),
                }
            }
        }
    },
    {
        strId = "raknet",
        name = "Сеть",
        pages = {
            {
                strId = "funcs",
                name = "Функции",
                modules = {
                    require("modules.network.funcs.gamestate"),
                    require("modules.network.funcs.connect"),
                    require("modules.network.funcs.disconnect"),
                    require("modules.network.funcs.death"),
                }
            },
            {
                strId = "nops",
                name = "Нопы",
                modules = { require("modules.network.nops.nops") }
            }
        }
    },
    {
        strId = "devtools",
        name = "DevTools",
        pages = {
            {
                strId = "objects",
                name = "Объекты",
                modules = {
                    require("modules.devtools.objects.render")
                }
            },
            {
                strId = "pickups",
                name = "Пикапы",
                modules = { require("modules.devtools.pickups.take") }
            },
            {
                strId = "text3d",
                name = "3D Тексты",
                modules = {}
            },
            {
                strId = "dialogs",
                name = "Диалоги",
                modules = { require("modules.devtools.dialog.info"), require("modules.devtools.dialog.show") }
            },
            {
                strId = "chat",
                name = "Чат",
                modules = { require("modules.devtools.chat.clear"), require("modules.devtools.chat.addmessage"), require("modules.devtools.chat.print") }
            },
            {
                strId = "textdraws",
                name = "Текстдравы",
                modules = { require("modules.devtools.textdraws.click"), require("modules.devtools.textdraws.id") }
            }
        }
    }
}) do
    local category = Categories:new(data.strId, data.name)
    for _, pageData in ipairs(data.pages) do
        local page = category:AddPage(pageData.strId, pageData.name)
        for _, module in ipairs(pageData.modules) do
            page:AddFunc(module)
        end
    end
end