local QBCore = exports['qb-core']:GetCoreObject({ 'Functions' })
local sharedItems = exports['qb-core']:GetShared('Items')
local GotItems = {}
local AlarmActivated = false

RegisterNetEvent('prison:server:SetJailStatus', function(jailTime)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    Player.SetMetaData('injail', jailTime)
    if jailTime > 0 then
        if Player.PlayerData.job.name ~= 'unemployed' then
            Player.SetJob('unemployed')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('info.lost_job'))
        end
    else
        GotItems[source] = nil
    end
end)

RegisterNetEvent('prison:server:SaveJailItems', function()
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    if not Player.PlayerData.metadata['jailitems'] or table.type(Player.PlayerData.metadata['jailitems']) == 'empty' then
        Player.SetMetaData('jailitems', Player.PlayerData.items)
        Player.AddMoney('cash', 80, 'jail money')
        Wait(2000)
        Player.ClearInventory()
    end
end)

RegisterNetEvent('prison:server:GiveJailItems', function(escaped)
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    if escaped then
        Player.SetMetaData('jailitems', {})
        return
    end
    for _, v in pairs(Player.PlayerData.metadata['jailitems']) do
        exports['qb-inventory']:AddItem(src, v.name, v.amount, false, v.info, 'prison:server:GiveJailItems')
    end
    Player.SetMetaData('jailitems', {})
end)

RegisterNetEvent('prison:server:ResetJailItems', function()
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    Player.SetMetaData('jailitems', {})
end)

RegisterNetEvent('prison:server:SecurityLockdown', function()
    TriggerClientEvent('prison:client:SetLockDown', -1, true)
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = exports['qb-core']:GetPlayer(v)
        if Player then
            if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
                TriggerClientEvent('prison:client:PrisonBreakAlert', v)
            end
        end
    end
end)

RegisterNetEvent('prison:server:SetGateHit', function(key)
    TriggerClientEvent('prison:client:SetGateHit', -1, key, true)
    if math.random(1, 100) <= 50 then
        for _, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = exports['qb-core']:GetPlayer(v)
            if Player then
                if Player.PlayerData.job.name == 'police' and Player.PlayerData.job.onduty then
                    TriggerClientEvent('prison:client:PrisonBreakAlert', v)
                end
            end
        end
    end
end)

RegisterNetEvent('prison:server:CheckRecordStatus', function()
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player then return end
    local CriminalRecord = Player.PlayerData.metadata['criminalrecord']
    local currentDate = os.date('*t')

    if (CriminalRecord['date'].month + 1) == 13 then
        CriminalRecord['date'].month = 0
    end

    if CriminalRecord['hasRecord'] then
        if currentDate.month == (CriminalRecord['date'].month + 1) or currentDate.day == (CriminalRecord['date'].day - 1) then
            CriminalRecord['hasRecord'] = false
            CriminalRecord['date'] = nil
        end
    end
end)

RegisterNetEvent('prison:server:JailAlarm', function()
    if AlarmActivated then return end
    local playerPed = GetPlayerPed(source)
    local coords = GetEntityCoords(playerPed)
    local middle = vec2(Config.Locations['middle'].x, Config.Locations['middle'].y)
    if #(coords.xy - middle) < 200 then return error('"prison:server:JailAlarm" triggered whilst the player was too close to the prison, cancelled event') end
    TriggerClientEvent('prison:client:JailAlarm', -1, true)
    SetTimeout(5 * 60000, function()
        TriggerClientEvent('prison:client:JailAlarm', -1, false)
    end)
end)

RegisterNetEvent('prison:server:CheckChance', function()
    local src = source
    local Player = exports['qb-core']:GetPlayer(src)
    if not Player or Player.PlayerData.metadata.injail == 0 or GotItems[src] then return end
    local chance = math.random(100)
    local odd = math.random(100)
    if chance ~= odd then return end
    if not exports['qb-inventory']:AddItem(src, 'phone', 1, false, false, 'prison:server:CheckChance') then return end
    TriggerClientEvent('qb-inventory:client:ItemBox', src, sharedItems['phone'], 'add')
    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.found_phone'), 'success')
    GotItems[src] = true
end)

QBCore.Functions.CreateCallback('prison:server:IsAlarmActive', function(_, cb)
    cb(AlarmActivated)
end)
