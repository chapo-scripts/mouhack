### Персонаж
#### Общие
  * **GodMode**
  * **Суицид**
  * **Заспавнится**
  * **NoDrunk**
  * **Сбив анимации**
    * Разморозка
#### Передвижение
  * **Бесконечный бег**
  * **SprintHook**
  * **Изменять скорость анимаций**
    * Множитель скорости
  * **Слап**
    * Вверх
    * Вниз
    * Высота слапа
  * **Фриз**
    * Разморозить персонажа
    * Заморозить персонажа
    * Анти-фриз
  * **Телепорт по карте**
  * **Телепорт**
    * Точка назначения
  * **CoordMaster**: TODO
    * Статус: Не активен
    * Шаг
    * Задержка
    * Отображать информацию о телепорте
    * Точка назначения
    * Запустить
  * **AirBrake**
    * Изменять скорость колесиком мыши
    * Скорость
#### Оружие
  * **Instant Crosshair**
  * **NoCameraRestore (ExtraWS)**
  * **Выдать оружие**
    * Количество патронов
    * Указать ID
    * #0. Fist
    * #1. Brass Knuckles
    * #2. Golf Club
    * #3. Nightstick
    * #4. Knife
    * #5. Baseball Bat
    * #6. Shovel
    * #7. Pool Cue
    * #8. Katana
    * #9. Chainsaw
    * #10. Purple Dildo
    * #11. Dildo
    * #12. Vibrator
    * #13. Silver Vibrator
    * #14. Flowers
    * #15. Cane
    * #16. Grenade
    * #17. Tear Gas
    * #18. Molotov Cocktail
    * #22. 9mm
    * #23. Silenced 9mm
    * #24. Desert Eagle
    * #25. Shotgun
    * #26. Sawnoff Shotgun
    * #27. Combat Shotgun
    * #28. Micro Uzi
    * #29. MP5
    * #30. AK-47
    * #31. M4
    * #32. Tec-9
    * #33. Country Rifle
    * #34. Sniper Rifle
    * #35. RPG
    * #36. HS Rocket
    * #37. Flamethrower
    * #38. Minigun
    * #39. Satchel Charge
    * #40. Detonator
    * #41. Spraycan
    * #42. Fire Extinguisher
    * #43. Camera
    * #44. Night Vis Goggles
    * #45. Thermal Goggles
    * #46. Parachute
  * **Забрать все оружее**
  * **Скиллы на оружие**
### Транспорт
#### Общие
  * **GodMode**
  * **Визуальный GodMode**
  * **TankMode**
    * Отображать индикатор
  * **ForceEngine**
  * **NoLimit**
  * **NoFuckingProps**
  * **NoDoors**
#### Машина
  * **Перевернуть машину**
    * Автоматически переворачивать машину на колеса
  * **Повернуть машину**
    * Назад
    * Влево
    * Вправо
  * **Езда по воде**
#### Вело / Мото
  * **NoBike**
    * Падать в воде
  * **Высокий прыжок для велосипедов**
    * Высота
  * **Автоускорение**
### Сеть
#### Функции
  * **Статус игры (GameState)**
    * GAMESTATE_NONE
    * GAMESTATE_WAIT_CONNECT
    * GAMESTATE_AWAIT_JOIN
    * GAMESTATE_CONNECTED
    * GAMESTATE_RESTARTING
    * GAMESTATE_DISCONNECTED
  * **Подключиться к серверу**
    * Переподключится к текущему
    * Сохраненные сервера:
    * Редактировать список
  * **Отключиться от сервера**
    * Выход (0)
    * Кик / бан (1)
  * **Отправить смерть от игрока**
    * ID убийцы
    * ID оружия
#### Нопы
  * **Поиск по названию**
  * **Выключить все**
  * **RPC (Исходящие)**
    * MenuSelect (ID: 132, SendMenuSelect)
    * Death (ID: 53, SendDeathNotification)
    * ScriptCash (ID: 31, SendMoneyIncreaseNotification)
    * ExitVehicle (ID: 154, SendExitVehicle)
    * Unknown (ID: 177, SendGiveActorDamage)
    * DamageVehicle (ID: 106, SendVehicleDamaged)
    * ClientJoin (ID: 25, SendClientJoin)
    * ClickPlayer (ID: 23, SendClickPlayer)
    * Spawn (ID: 52, SendSpawn)
    * Chat (ID: 101, SendChat)
    * EditAttachedObject (ID: 116, SendEditAttachedObject)
    * Unknown (ID: 168, SendCameraTargetUpdate)
    * WeaponPickupDestroy (ID: 97, SendPickedUpWeapon)
    * SrvNetStats (ID: 102, SendServerStatisticsRequest)
    * EditObject (ID: 117, SendEditObject)
    * MenuQuit (ID: 140, SendQuitMenu)
    * NPCJoin (ID: 54, SendNPCJoin)
    * ClientCheck (ID: 103, SendClientCheckResponse)
    * SetInteriorId (ID: 118, SendInteriorChangeNotification)
    * UpdateScoresPingsIPs (ID: 155, SendUpdateScoresAndPings)
    * EnterVehicle (ID: 26, SendEnterVehicle)
    * DialogResponse (ID: 62, SendDialogResponse)
    * MapMarker (ID: 119, SendMapMarker)
    * VehicleDestroyed (ID: 136, SendVehicleDestroyed)
    * RequestClass (ID: 128, SendRequestClass)
    * ServerCommand (ID: 50, SendCommand)
    * EnterEditObject (ID: 27, SendEnterEditObject)
    * RequestSpawn (ID: 129, SendRequestSpawn)
    * ClickTextDraw (ID: 83, SendClickTextDraw)
    * PickedUpPickup (ID: 131, SendPickedUpPickup)
    * ScmEvent (ID: 96, SendVehicleTuningNotification)
  * **Пакеты (Исходящие)**
    * AIM_SYNC (ID: 203, SendAimSync)
    * VEHICLE_SYNC (ID: 200, SendVehicleSync)
    * PASSENGER_SYNC (ID: 211, SendPassengerSync)
    * RCON_COMMAND (ID: 201, SendRconCommand)
    * TRAILER_SYNC (ID: 210, SendTrailerSync)
    * BULLET_SYNC (ID: 206, SendBulletSync)
    * PLAYER_SYNC (ID: 207, SendPlayerSync)
    * SPECTATOR_SYNC (ID: 212, SendSpectatorSync)
    * WEAPONS_UPDATE (ID: 204, SendWeaponsUpdate)
    * STATS_UPDATE (ID: 205, SendStatsUpdate)
    * AUTH_KEY (ID: 12, SendAuthenticationResponse)
    * UNOCCUPIED_SYNC (ID: 209, SendUnoccupiedSync)
  * **RPC (Входящие)**
    * SetPlayerName (ID: 11, SetPlayerName)
    * SetPlayerPos (ID: 12, SetPlayerPos)
    * SetPlayerPosFindZ (ID: 13, SetPlayerPosFindZ)
    * SetPlayerHealth (ID: 14, SetPlayerHealth)
    * TogglePlayerControllable (ID: 15, TogglePlayerControllable)
    * PlaySound (ID: 16, PlaySound)
    * SetPlayerWorldBounds (ID: 17, SetWorldBounds)
    * GivePlayerMoney (ID: 18, GivePlayerMoney)
    * SetPlayerFacingAngle (ID: 19, SetPlayerFacingAngle)
    * ResetPlayerMoney (ID: 20, ResetPlayerMoney)
    * ResetPlayerWeapons (ID: 21, ResetPlayerWeapons)
    * GivePlayerWeapon (ID: 22, GivePlayerWeapon)
    * SetVehicleParamsEx (ID: 24, SetVehicleParamsEx)
    * EnterVehicle (ID: 26, PlayerEnterVehicle)
    * EnterEditObject (ID: 27, EnterSelectObject)
    * CancelEdit (ID: 28, CancelEdit)
    * SetPlayerTime (ID: 29, SetPlayerTime)
    * ToggleClock (ID: 30, SetToggleClock)
    * WorldPlayerAdd (ID: 32, PlayerStreamIn)
    * SetPlayerShopName (ID: 33, SetShopName)
    * SetPlayerSkillLevel (ID: 34, SetPlayerSkillLevel)
    * SetPlayerDrunkLevel (ID: 35, SetPlayerDrunk)
    * Create3DTextLabel (ID: 36, Create3DText)
    * DisableCheckpoint (ID: 37, DisableCheckpoint)
    * SetRaceCheckpoint (ID: 38, SetRaceCheckpoint)
    * DisableRaceCheckpoint (ID: 39, DisableRaceCheckpoint)
    * GameModeRestart (ID: 40, GamemodeRestart)
    * PlayAudioStream (ID: 41, PlayAudioStream)
    * StopAudioStream (ID: 42, StopAudioStream)
    * RemoveBuildingForPlayer (ID: 43, RemoveBuilding)
    * CreateObject (ID: 44, CreateObject)
    * SetObjectPos (ID: 45, SetObjectPosition)
    * SetObjectRot (ID: 46, SetObjectRotation)
    * DestroyObject (ID: 47, DestroyObject)
    * DeathMessage (ID: 55, PlayerDeathNotification)
    * SetPlayerMapIcon (ID: 56, SetMapIcon)
    * RemoveVehicleComponent (ID: 57, RemoveVehicleComponent)
    * Update3DTextLabel (ID: 58, Remove3DTextLabel)
    * ChatBubble (ID: 59, PlayerChatBubble)
    * UpdateGameTimer (ID: 60, UpdateGlobalTimer)
    * ShowDialog (ID: 61, ShowDialog)
    * DestroyPickup (ID: 63, DestroyPickup)
    * LinkVehicleToInterior (ID: 65, LinkVehicleToInterior)
    * SetPlayerArmour (ID: 66, SetPlayerArmour)
    * SetPlayerArmedWeapon (ID: 67, SetPlayerArmedWeapon)
    * SetSpawnInfo (ID: 68, SetSpawnInfo)
    * SetPlayerTeam (ID: 69, SetPlayerTeam)
    * PutPlayerInVehicle (ID: 70, PutPlayerInVehicle)
    * RemovePlayerFromVehicle (ID: 71, RemovePlayerFromVehicle)
    * SetPlayerColor (ID: 72, SetPlayerColor)
    * DisplayGameText (ID: 73, DisplayGameText)
    * ForceClassSelection (ID: 74, ForceClassSelection)
    * AttachObjectToPlayer (ID: 75, AttachObjectToPlayer)
    * InitMenu (ID: 76, InitMenu)
    * ShowMenu (ID: 77, ShowMenu)
    * HideMenu (ID: 78, HideMenu)
    * CreateExplosion (ID: 79, CreateExplosion)
    * ShowPlayerNameTagForPlayer (ID: 80, ShowPlayerNameTag)
    * AttachCameraToObject (ID: 81, AttachCameraToObject)
    * InterpolateCamera (ID: 82, InterpolateCamera)
    * ClickTextDraw (ID: 83, ToggleSelectTextDraw)
    * GangZoneStopFlash (ID: 85, GangZoneStopFlash)
    * ApplyAnimation (ID: 86, ApplyPlayerAnimation)
    * ClearAnimations (ID: 87, ClearPlayerAnimation)
    * SetPlayerSpecialAction (ID: 88, SetPlayerSpecialAction)
    * SetPlayerFightingStyle (ID: 89, SetPlayerFightingStyle)
    * SetPlayerVelocity (ID: 90, SetPlayerVelocity)
    * SetVehicleVelocity (ID: 91, SetVehicleVelocity)
    * Unknown (ID: 92, SetPlayerDrunkVisuals)
    * ClientMessage (ID: 93, ServerMessage)
    * SetWorldTime (ID: 94, SetWorldTime)
    * CreatePickup (ID: 95, CreatePickup)
    * ScmEvent (ID: 96, VehicleTuningNotification)
    * Unknown (ID: 98, SetVehicleTires)
    * MoveObject (ID: 99, MoveObject)
    * Chat (ID: 101, ChatMessage)
    * SrvNetStats (ID: 102, ServerStatisticsResponse)
    * ClientCheck (ID: 103, ClientCheck)
    * EnableStuntBonusForPlayer (ID: 104, EnableStuntBonus)
    * TextDrawSetString (ID: 105, TextDrawSetString)
    * DamageVehicle (ID: 106, VehicleDamageStatusUpdate)
    * SetCheckpoint (ID: 107, SetCheckpoint)
    * GangZoneCreate (ID: 108, CreateGangZone)
    * Unknown (ID: 111, ToggleWidescreen)
    * PlayCrimeReport (ID: 112, PlayCrimeReport)
    * SetPlayerAttachedObject (ID: 113, SetPlayerAttachedObject)
    * EditAttachedObject (ID: 116, EditAttachedObject)
    * EditObject (ID: 117, EnterEditObject)
    * GangZoneDestroy (ID: 120, GangZoneDestroy)
    * GangZoneFlash (ID: 121, GangZoneFlash)
    * StopObject (ID: 122, StopObject)
    * SetNumberPlate (ID: 123, SetVehicleNumberPlate)
    * TogglePlayerSpectating (ID: 124, TogglePlayerSpectating)
    * PlayerSpectatePlayer (ID: 126, SpectatePlayer)
    * PlayerSpectateVehicle (ID: 127, SpectateVehicle)
    * RequestClass (ID: 128, RequestClassResponse)
    * RequestSpawn (ID: 129, RequestSpawnResponse)
    * Unknown (ID: 130, ConnectionRejected)
    * SetPlayerWantedLevel (ID: 133, SetPlayerWantedLevel)
    * ShowTextDraw (ID: 134, ShowTextDraw)
    * TextDrawHideForPlayer (ID: 135, TextDrawHide)
    * ServerJoin (ID: 137, PlayerJoin)
    * ServerQuit (ID: 138, PlayerQuit)
    * InitGame (ID: 139, InitGame)
    * RemovePlayerMapIcon (ID: 144, RemoveMapIcon)
    * SetPlayerAmmo (ID: 145, SetWeaponAmmo)
    * SetGravity (ID: 146, SetGravity)
    * SetVehicleHealth (ID: 147, SetVehicleHealth)
    * AttachTrailerToVehicle (ID: 148, AttachTrailerToVehicle)
    * DetachTrailerFromVehicle (ID: 149, DetachTrailerFromVehicle)
    * Unknown (ID: 150, SetPlayerDrunkHandling)
    * Unknown (ID: 151, DestroyWeaponPickup)
    * SetWeather (ID: 152, SetWeather)
    * SetPlayerSkin (ID: 153, SetPlayerSkin)
    * ExitVehicle (ID: 154, PlayerExitVehicle)
    * UpdateScoresPingsIPs (ID: 155, UpdateScoresAndPings)
    * SetPlayerInterior (ID: 156, SetInterior)
    * SetPlayerCameraPos (ID: 157, SetCameraPosition)
    * SetPlayerCameraLookAt (ID: 158, SetCameraLookAt)
    * SetVehiclePos (ID: 159, SetVehiclePosition)
    * SetVehicleZAngle (ID: 160, SetVehicleAngle)
    * SetVehicleParamsForPlayer (ID: 161, SetVehicleParams)
    * SetCameraBehindPlayer (ID: 162, SetCameraBehind)
    * WorldPlayerRemove (ID: 163, PlayerStreamOut)
    * WorldVehicleAdd (ID: 164, VehicleStreamIn)
    * WorldVehicleRemove (ID: 165, VehicleStreamOut)
    * WorldPlayerDeath (ID: 166, PlayerDeath)
    * Unknown (ID: 167, DisableVehicleCollisions)
    * Unknown (ID: 169, SetPlayerObjectNoCameraCol)
    * Unknown (ID: 170, ToggleCameraTargetNotifying)
    * Unknown (ID: 171, CreateActor)
    * Unknown (ID: 172, DestroyActor)
    * Unknown (ID: 173, ApplyActorAnimation)
    * Unknown (ID: 174, ClearActorAnimation)
    * Unknown (ID: 175, SetActorFacingAngle)
    * Unknown (ID: 176, SetActorPos)
    * Unknown (ID: 178, SetActorHealth)
  * **Пакеты (Входящие)**
    * AIM_SYNC (ID: 203, AimSync)
    * MARKERS_SYNC (ID: 208, MarkersSync)
    * VEHICLE_SYNC (ID: 200, VehicleSync)
    * PASSENGER_SYNC (ID: 211, PassengerSync)
    * DISCONNECTION_NOTIFICATION (ID: 32, ConnectionClosed)
    * TRAILER_SYNC (ID: 210, TrailerSync)
    * BULLET_SYNC (ID: 206, BulletSync)
    * INVALPASSWORD (ID: 37, ConnectionPasswordInvalid)
    * PLAYER_SYNC (ID: 207, PlayerSync)
    * NO_FREE_INCOMING_CONNECTIONS (ID: 31, ConnectionNoFreeSlot)
    * CONNECTION_ATTEMPT_FAILED (ID: 29, ConnectionAttemptFailed)
    * CONNECTION_BANNED (ID: 36, ConnectionBanned)
    * CONNECTION_LOST (ID: 33, ConnectionLost)
    * CONNECTION_REQUEST_ACCEPTED (ID: 34, ConnectionRequestAccepted)
    * AUTH_KEY (ID: 12, AuthenticationRequest)
    * UNOCCUPIED_SYNC (ID: 209, UnoccupiedSync)
### DevTools
#### Объекты
  * **Рендер объектов**
    * Режим
    * Список моделей
#### Пикапы
  * **Поднять пикап**
    * ID Пикапа
    * Отправить нажатие ALT
    * Поднять пикап
#### 3D Тексты
#### Диалоги
  * **Добавлять ID в заголовок**
  * **Выводить информацию о диалоге в консоль**
  * **Показать диалог**
    * ID
    * Заголовок
    * Текст
    * Кнопка #1
    * Кнопка #2
    * Тип
#### Чат
  * **Очистить чат**
  * **Добавить сообщение**
    * Текст
    * Цвет
    * Добавить сообщение
  * **Выводить сообщения в консоль**
    * Серверные сообщения
    * Отправляемые сообщения
    * Отправляемые команды
#### Текстдравы
  * **Отправить клик по текстдраву**
    * ID Текстдрава
    * Отправить нажатие на текстдрав
  * **Отображать ID текстдравов**
  * **Список текстдравов**
    * Обновить список
    * #0 "HackMySoftware"
    * #1 "version: 4.1"
#### Геймтексты
  * **Выводить в консоль**
  * **Показать GameText**
    * Текст
    * Стиль
    * Время отображения
    * Показать