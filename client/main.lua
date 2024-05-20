QBCore = exports['qb-core']:GetCoreObject() -- Used Globally
inJail = false
jailTime = 0
currentJob = nil
CellsBlip = nil
TimeBlip = nil
ShopBlip = nil
local insidecanteen = false
local insidefreedom = false
local canteen_ped = 0
local freedom_ped = 0
local freedom
local canteen

-- Functions

--- This will create the blips for the cells, time check and shop
--- @return nil
local function CreateCellsBlip()
	if CellsBlip then
		RemoveBlip(CellsBlip)
	end
	CellsBlip = AddBlipForCoord(Config.Locations['yard'].x, Config.Locations['yard'].y, Config.Locations['yard'].z)

	SetBlipSprite(CellsBlip, 238)
	SetBlipDisplay(CellsBlip, 4)
	SetBlipScale(CellsBlip, 0.8)
	SetBlipAsShortRange(CellsBlip, true)
	SetBlipColour(CellsBlip, 4)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(Lang:t('info.cells_blip'))
	EndTextCommandSetBlipName(CellsBlip)

	if TimeBlip then
		RemoveBlip(TimeBlip)
	end
	TimeBlip = AddBlipForCoord(Config.Locations['freedom'].x, Config.Locations['freedom'].y, Config.Locations['freedom'].z)

	SetBlipSprite(TimeBlip, 466)
	SetBlipDisplay(TimeBlip, 4)
	SetBlipScale(TimeBlip, 0.8)
	SetBlipAsShortRange(TimeBlip, true)
	SetBlipColour(TimeBlip, 4)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(Lang:t('info.freedom_blip'))
	EndTextCommandSetBlipName(TimeBlip)
end

-- Add clothes to prisioner

local function ApplyClothes()
	local playerPed = PlayerPedId()
	if DoesEntityExist(playerPed) then
		Citizen.CreateThread(function()
			SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
			ResetPedMovementClipset(playerPed, 0)
			local gender = QBCore.Functions.GetPlayerData().charinfo.gender
			if gender == 0 then
				TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.male)
			else
				TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.female)
			end
		end)
	end
end


-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata['injail'] > 0 then
			TriggerEvent('prison:client:Enter', PlayerData.metadata['injail'])
		end
	end)

	QBCore.Functions.TriggerCallback('prison:server:IsAlarmActive', function(active)
		if active then
			TriggerEvent('prison:client:JailAlarm', true)
		end
	end)

	if DoesEntityExist(canteen_ped) or DoesEntityExist(freedom_ped) then return end

	local pedModel = `s_m_m_armoured_01`

	RequestModel(pedModel)
	while not HasModelLoaded(pedModel) do
		Wait(0)
	end

	freedom_ped = CreatePed(0, pedModel, Config.Locations['freedom'].x, Config.Locations['freedom'].y, Config.Locations['freedom'].z, Config.Locations['freedom'].w, false, true)
	FreezeEntityPosition(freedom_ped, true)
	SetEntityInvincible(freedom_ped, true)
	SetBlockingOfNonTemporaryEvents(freedom_ped, true)
	TaskStartScenarioInPlace(freedom_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

	if not Config.UseTarget then return end

	exports['qb-target']:AddTargetEntity(freedom_ped, {
		options = {
			{
				type = 'client',
				event = 'prison:client:Leave',
				icon = 'fas fa-clipboard',
				label = Lang:t('info.target_freedom_option'),
				canInteract = function()
					return inJail
				end
			}
		},
		distance = 2.5,
	})
end)

AddEventHandler('onResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then return end
	Wait(100)
	if LocalPlayer.state['isLoggedIn'] then
		QBCore.Functions.GetPlayerData(function(PlayerData)
			if PlayerData.metadata['injail'] > 0 then
				TriggerEvent('prison:client:Enter', PlayerData.metadata['injail'])
			end
		end)
	end

	QBCore.Functions.TriggerCallback('prison:server:IsAlarmActive', function(active)
		if not active then return end
		TriggerEvent('prison:client:JailAlarm', true)
	end)

	if DoesEntityExist(canteen_ped) or DoesEntityExist(freedom_ped) then return end

	local pedModel = `s_m_m_armoured_01`

	RequestModel(pedModel)
	while not HasModelLoaded(pedModel) do
		Wait(0)
	end

	freedom_ped = CreatePed(0, pedModel, Config.Locations['freedom'].x, Config.Locations['freedom'].y, Config.Locations['freedom'].z, Config.Locations['freedom'].w, false, true)
	FreezeEntityPosition(freedom_ped, true)
	SetEntityInvincible(freedom_ped, true)
	SetBlockingOfNonTemporaryEvents(freedom_ped, true)
	TaskStartScenarioInPlace(freedom_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

	if not Config.UseTarget then return end

	exports['qb-target']:AddTargetEntity(freedom_ped, {
		options = {
			{
				type = 'client',
				event = 'prison:client:Leave',
				icon = 'fas fa-clipboard',
				label = Lang:t('info.target_freedom_option'),
				canInteract = function()
					return inJail
				end
			}
		},
		distance = 2.5,
	})
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	inJail = false
	currentJob = nil
	RemoveBlip(currentBlip)
end)

RegisterNetEvent('prison:client:Enter', function(time)
	local invokingResource = GetInvokingResource()
	if invokingResource and invokingResource ~= 'qb-policejob' and invokingResource ~= 'qb-ambulancejob' and invokingResource ~= GetCurrentResourceName() then
		-- Use QBCore.Debug here for a quick and easy way to print to the console to grab your attention with this message
		QBCore.Debug({ ('Player with source %s tried to execute prison:client:Enter manually or from another resource which is not authorized to call this, invokedResource: %s'):format(GetPlayerServerId(PlayerId()), invokingResource) })
		return
	end

	QBCore.Functions.Notify(Lang:t('error.injail', { Time = time }), 'error')

	TriggerEvent('chat:addMessage', {
		color = { 3, 132, 252 },
		multiline = true,
		args = { 'SYSTEM', Lang:t('info.seized_property') }
	})
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	local RandomStartPosition = Config.Locations.spawns[math.random(1, #Config.Locations.spawns)]
	SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.9, 0, 0, 0, false)
	SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.w)
	Wait(500)

	inJail = true
	jailTime = time
	local tempJobs = {}
	local i = 1
	for k in pairs(Config.Locations.jobs) do
		tempJobs[i] = k
		i += 1
	end
	currentJob = tempJobs[math.random(1, #tempJobs)]
	CreateJobBlip(true)
	ApplyClothes()
	TriggerServerEvent('prison:server:SetJailStatus', jailTime)
	TriggerServerEvent('prison:server:SaveJailItems', jailTime)
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'jail', 0.5)
	CreateCellsBlip()
	Wait(2000)
	DoScreenFadeIn(1000)
	QBCore.Functions.Notify(Lang:t('error.do_some_work', { currentjob = Config.Jobs[currentJob] }), 'error')
end)

RegisterNetEvent('prison:client:Leave', function()
	if jailTime > 0 then
		QBCore.Functions.Notify(Lang:t('info.timeleft', { JAILTIME = jailTime }))
	else
		jailTime = 0
		TriggerServerEvent('prison:server:SetJailStatus', 0)
		TriggerServerEvent('prison:server:GiveJailItems')
		TriggerEvent('chat:addMessage', {
			color = { 3, 132, 252 },
			multiline = true,
			args = { 'SYSTEM', Lang:t('info.received_property') }
		})
		inJail = false
		RemoveBlip(currentBlip)
		RemoveBlip(CellsBlip)
		CellsBlip = nil
		RemoveBlip(TimeBlip)
		TimeBlip = nil
		RemoveBlip(ShopBlip)
		ShopBlip = nil
		QBCore.Functions.Notify(Lang:t('success.free_'))
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		TriggerServerEvent('qb-clothes:loadPlayerSkin')
		SetEntityCoords(PlayerPedId(), Config.Locations['outside'].x, Config.Locations['outside'].y, Config.Locations['outside'].z, false, false, false, false)
		SetEntityHeading(PlayerPedId(), Config.Locations['outside'].w)
		Wait(500)
		DoScreenFadeIn(1000)
	end
end)

RegisterNetEvent('prison:client:UnjailPerson', function()
	if jailTime > 0 then
		TriggerServerEvent('prison:server:SetJailStatus', 0)
		TriggerServerEvent('prison:server:GiveJailItems')
		TriggerEvent('chat:addMessage', {
			color = { 3, 132, 252 },
			multiline = true,
			args = { 'SYSTEM', Lang:t('info.received_property') }
		})
		inJail = false
		RemoveBlip(currentBlip)
		RemoveBlip(CellsBlip)
		CellsBlip = nil
		RemoveBlip(TimeBlip)
		TimeBlip = nil
		RemoveBlip(ShopBlip)
		ShopBlip = nil
		QBCore.Functions.Notify(Lang:t('success.free_'))
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		TriggerServerEvent('qb-clothes:loadPlayerSkin')
		SetEntityCoords(PlayerPedId(), Config.Locations['outside'].x, Config.Locations['outside'].y, Config.Locations['outside'].z, false, false, false, false)
		SetEntityHeading(PlayerPedId(), Config.Locations['outside'].w)
		Wait(500)
		DoScreenFadeIn(1000)
	end
end)

-- Threads

CreateThread(function()
	TriggerEvent('prison:client:JailAlarm', false)
	while true do
		local sleep = 1000
		if jailTime > 0 and inJail then
			Wait(1000 * 60)
			sleep = 0
			if jailTime > 0 and inJail then
				jailTime -= 1
				if jailTime <= 0 then
					jailTime = 0
					QBCore.Functions.Notify(Lang:t('success.timesup'), 'success', 10000)
				end
				TriggerServerEvent('prison:server:SetJailStatus', jailTime)
			end
		end
		Wait(sleep)
	end
end)

CreateThread(function()
	if not Config.UseTarget then
		freedom = BoxZone:Create(vector3(Config.Locations['freedom'].x, Config.Locations['freedom'].y, Config.Locations['freedom'].z), 2.75, 2.75, {
			name = 'freedom',
			debugPoly = false,
		})
		freedom:onPlayerInOut(function(isPointInside)
			insidefreedom = isPointInside
			if isPointInside then
				CreateThread(function()
					while insidefreedom do
						if IsControlJustReleased(0, 38) then
							exports['qb-core']:KeyPressed()
							exports['qb-core']:HideText()
							TriggerEvent('prison:client:Leave')
							break
						end
						Wait(0)
					end
				end)
				exports['qb-core']:DrawText('[E] Check Time', 'left')
			else
				exports['qb-core']:HideText()
			end
		end)
	end
end)
