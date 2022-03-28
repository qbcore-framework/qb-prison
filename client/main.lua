QBCore = exports['qb-core']:GetCoreObject() -- Used Globally
inJail = false
jailTime = 0
currentJob = "electrician"
CellsBlip = nil
TimeBlip = nil
ShopBlip = nil
insidecanteen = false
insidefreedom = false
PlayerJob = {}

--Function

local function CreateCellsBlip()
	if CellsBlip ~= nil then
		RemoveBlip(CellsBlip)
	end
	CellsBlip = AddBlipForCoord(Config.Locations["yard"].coords.x, Config.Locations["yard"].coords.y, Config.Locations["yard"].coords.z)

	SetBlipSprite (CellsBlip, 238)
	SetBlipDisplay(CellsBlip, 4)
	SetBlipScale  (CellsBlip, 0.8)
	SetBlipAsShortRange(CellsBlip, true)
	SetBlipColour(CellsBlip, 4)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Cellen")
	EndTextCommandSetBlipName(CellsBlip)

	if TimeBlip ~= nil then
		RemoveBlip(TimeBlip)
	end
	TimeBlip = AddBlipForCoord(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z)

	SetBlipSprite (TimeBlip, 466)
	SetBlipDisplay(TimeBlip, 4)
	SetBlipScale  (TimeBlip, 0.8)
	SetBlipAsShortRange(TimeBlip, true)
	SetBlipColour(TimeBlip, 4)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Time check")
	EndTextCommandSetBlipName(TimeBlip)

	if ShopBlip ~= nil then
		RemoveBlip(ShopBlip)
	end
	ShopBlip = AddBlipForCoord(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z)

	SetBlipSprite (ShopBlip, 52)
	SetBlipDisplay(ShopBlip, 4)
	SetBlipScale  (ShopBlip, 0.5)
	SetBlipAsShortRange(ShopBlip, true)
	SetBlipColour(ShopBlip, 0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Canteen")
	EndTextCommandSetBlipName(ShopBlip)
end


-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injail"] > 0 then
			TriggerEvent("prison:client:Enter", PlayerData.metadata["injail"])
		end
	end)

	QBCore.Functions.TriggerCallback('prison:server:IsAlarmActive', function(active)
		if active then
			TriggerEvent('prison:client:JailAlarm', true)
		end
	end)

	PlayerJob = QBCore.Functions.GetPlayerData().job
	RequestModel("s_m_m_armoured_01")
	while not HasModelLoaded('s_m_m_armoured_01') do
		Wait(50)
	end
	canteen_ped = CreatePed(5, GetHashKey('s_m_m_armoured_01') ,1786.19, 2557.77, 44.62, 186.04, false, true)
	FreezeEntityPosition(canteen_ped, true)
	SetEntityInvincible(canteen_ped, true)
	SetBlockingOfNonTemporaryEvents(canteen_ped, true)
	TaskStartScenarioInPlace(canteen_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

	freedom_ped = CreatePed(5, GetHashKey('s_m_m_armoured_01') , 1836.37, 2585.33, 44.88, 78.67, false, true)
	FreezeEntityPosition(freedom_ped, true)
	SetEntityInvincible(freedom_ped, true)
	SetBlockingOfNonTemporaryEvents(freedom_ped, true)
	TaskStartScenarioInPlace(freedom_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
		QBCore.Functions.GetPlayerData(function(PlayerData)
			if PlayerData.metadata["injail"] > 0 then
				TriggerEvent("prison:client:Enter", PlayerData.metadata["injail"])
			end
		end)
	
		QBCore.Functions.TriggerCallback('prison:server:IsAlarmActive', function(active)
			if active then
				TriggerEvent('prison:client:JailAlarm', true)
			end
		end)
	
		PlayerJob = QBCore.Functions.GetPlayerData().job

		RequestModel("s_m_m_armoured_01")
		while not HasModelLoaded('s_m_m_armoured_01') do
			Wait(50)
		end
		canteen_ped = CreatePed(5, GetHashKey('s_m_m_armoured_01') ,1786.19, 2557.77, 44.62, 186.04, false, true)
		FreezeEntityPosition(canteen_ped, true)
		SetEntityInvincible(canteen_ped, true)
		SetBlockingOfNonTemporaryEvents(canteen_ped, true)
		TaskStartScenarioInPlace(canteen_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
	
		freedom_ped = CreatePed(5, GetHashKey('s_m_m_armoured_01') , 1836.37, 2585.33, 44.88, 78.67, false, true)
		FreezeEntityPosition(freedom_ped, true)
		SetEntityInvincible(freedom_ped, true)
		SetBlockingOfNonTemporaryEvents(freedom_ped, true)
		TaskStartScenarioInPlace(freedom_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    end
end)


RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	inJail = false
	currentJob = nil
	RemoveBlip(currentBlip)
end)

RegisterNetEvent('prison:client:Enter', function(time)
	QBCore.Functions.Notify( Lang:t("error.injail", {Time = time}), "error")

	TriggerEvent("chatMessage", "SYSTEM", "warning", "Your property has been seized, you'll get everything back when your time is up..")
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	local RandomStartPosition = Config.Locations.spawns[math.random(1, #Config.Locations.spawns)]
	SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.9, 0, 0, 0, false)
	SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.w)
	Wait(500)
	TriggerEvent('animations:client:EmoteCommandStart', {RandomStartPosition.animation})

	inJail = true
	jailTime = time
	currentJob = "electrician"
	TriggerServerEvent("prison:server:SetJailStatus", jailTime)
	TriggerServerEvent("prison:server:SaveJailItems", jailTime)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "jail", 0.5)
	CreateCellsBlip()
	Wait(2000)
	DoScreenFadeIn(1000)
	QBCore.Functions.Notify( Lang:t("error.do_some_work", {currentjob = Config.Jobs[currentJob] }), "error")
end)

RegisterNetEvent('prison:client:Leave', function()
	if jailTime > 0 then
		QBCore.Functions.Notify( Lang:t("info.timeleft", {JAILTIME = jailTime}))
	else
		jailTime = 0
		TriggerServerEvent("prison:server:SetJailStatus", 0)
		TriggerServerEvent("prison:server:GiveJailItems")
		TriggerEvent("chatMessage", "SYSTEM", "warning", "you've received your property back..")
		inJail = false
		RemoveBlip(currentBlip)
		RemoveBlip(CellsBlip)
		CellsBlip = nil
		RemoveBlip(TimeBlip)
		TimeBlip = nil
		RemoveBlip(ShopBlip)
		ShopBlip = nil
		QBCore.Functions.Notify(Lang:t("success.free_"))
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.w)

		Wait(500)

		DoScreenFadeIn(1000)
	end
end)

RegisterNetEvent('prison:client:UnjailPerson', function()
	if jailTime > 0 then
		TriggerServerEvent("prison:server:SetJailStatus", 0)
		TriggerServerEvent("prison:server:GiveJailItems")
		TriggerEvent("chatMessage", "SYSTEM", "warning", "You got your property back..")
		inJail = false
		RemoveBlip(currentBlip)
		RemoveBlip(CellsBlip)
		CellsBlip = nil
		RemoveBlip(TimeBlip)
		TimeBlip = nil
		RemoveBlip(ShopBlip)
		ShopBlip = nil
		QBCore.Functions.Notify(Lang:t("success.free_"))
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.w)
		Wait(500)
		DoScreenFadeIn(1000)
	end
end)

RegisterNetEvent('prison:client:canteen',function()
	local ShopItems = {}
	ShopItems.label = "Prison Canteen"
	ShopItems.items = Config.CanteenItems
	ShopItems.slots = #Config.CanteenItems
	TriggerServerEvent("inventory:server:OpenInventory", "shop", "Canteenshop_"..math.random(1, 99), ShopItems)
end)

-- Threads

CreateThread(function()
    TriggerEvent('prison:client:JailAlarm', false)
	while true do
		Wait(10)
		if jailTime > 0 and inJail then
			Wait(1000 * 60)
			if jailTime > 0 and inJail then
				jailTime = jailTime - 1
				if jailTime <= 0 then
					jailTime = 0
					QBCore.Functions.Notify(Lang:t("success.timesup"), "success", 10000)
				end
				TriggerServerEvent("prison:server:SetJailStatus", jailTime)
			end
		else
			Wait(5000)
		end
	end
end)

freedom = BoxZone:Create(vector3(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z), 2.75, 2.75, {
	name="freedom",
	debugPoly = false,
})
freedom:onPlayerInOut(function(isPointInside)
	if isPointInside then
		exports['qb-core']:DrawText('[E] Check Time', 'left')
		insidefreedom = true
	else
		insidefreedom = false
		exports['qb-core']:HideText()
	end
end)

canteen = BoxZone:Create(vector3(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z), 2.75, 7.75, {
name="canteen",
debugPoly = false,
})
canteen:onPlayerInOut(function(isPointInside)
	if isPointInside then
		exports['qb-core']:DrawText('[E] Open Canteen', 'left')
		insidecanteen = true
	else
		insidecanteen = false
		exports['qb-core']:HideText()
	end
end)

local function interaction()
	if Config.UseTarget then
			exports['qb-target']:AddTargetEntity(freedom_ped, {
				options = {
				{
					type = "client",
					event = "prison:client:Leave",
					icon = 'fas fa-clipboard',
					label = 'Check time',
				}
				},
				distance = 2.5,
			})
			exports['qb-target']:AddTargetEntity(canteen_ped, {
				options = {
				{
					type = "client",
					event = "prison:client:canteen",
					icon = 'fas fa-clipboard',
					label = 'Get Food',
				}
				},
				distance = 2.5,
			})
	else
		if insidefreedom then
			if IsControlJustReleased(0, 38) then
				TriggerEvent("prison:client:Leave")
			end
		end

		if insidecanteen then
			if IsControlJustReleased(0, 38) then
				TriggerEvent("prison:client:canteen")
			end
		end
	end
end



CreateThread(function()
    while true do
        Wait(3)
		interaction()
    end
end)
