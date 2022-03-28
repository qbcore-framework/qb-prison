local currentLocation = 0
currentBlip = nil
local isWorking = false

-- Functions

local function CreateJobBlip()
    if currentLocation ~= 0 then
        if DoesBlipExist(currentBlip) then
            RemoveBlip(currentBlip)
        end
        currentBlip = AddBlipForCoord(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z)

        SetBlipSprite (currentBlip, 402)
        SetBlipDisplay(currentBlip, 4)
        SetBlipScale  (currentBlip, 0.8)
        SetBlipAsShortRange(currentBlip, true)
        SetBlipColour(currentBlip, 1)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Jobs[currentJob])
        EndTextCommandSetBlipName(currentBlip)

        local Chance = math.random(100)
        local Odd = math.random(100)
        if Chance == Odd then
            TriggerServerEvent('QBCore:Server:AddItem', 'phone', 1)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["phone"], "add")
            QBCore.Functions.Notify(Lang:t("success.found_phone"), "success")
        end
    end
end

local function JobDone()
    if math.random(1, 100) <= 50 then
        QBCore.Functions.Notify(Lang:t("success.time_cut"))
        jailTime = jailTime - math.random(1, 2)
    end
    local newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    while (newLocation == currentLocation) do
        Wait(100)
        newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    end
    currentLocation = newLocation
    CreateJobBlip()
end

local function jobstart(currentJob, currentLocation)
    if Config.UseTarget then
        exports['qb-target']:AddBoxZone("electricianwork", vector3(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z), 1.5, 1.6, {
            name = "electricianwork",
            heading = 12.0,
            debugPoly = false,
            minZ = 19,
            maxZ = 219,
        }, {
            options = {
            {
                type = "client",
                event = "qb-prison:electrician:work",
                icon = 'fas fa-swords-laser',
                label = 'Do Electrician Work',
            }
            },
            distance = 2.5,
        })
    else
        CreateThread(function()
            local electricityzone = BoxZone:Create(vector3(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z), 3.0, 5.0, {
                name="electricity",
                debugPoly=false,
            })
            electricityzone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['qb-drawtext']:DrawText('[E] Electricity Work', 'left')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("qb-prison:electrician:work")
                        electricityzone:destroy()
                    end
                else
                    exports['qb-drawtext']:HideText()
                end
            end)
        end)
    end
end

-- Threads

RegisterNetEvent('qb-prison:electrician:work')
AddEventHandler('qb-prison:electrician:work', function()
    isWorking = true
    QBCore.Functions.Progressbar("work_electric", "Working on electricity..", math.random(5000, 10000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        isWorking = false
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
        JobDone()
    end, function() -- Cancel
        isWorking = false
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
        QBCore.Functions.Notify(Lang:t("error.cancelled"), "error")
    end)
end)

CreateThread(function()
    while true do
        Wait(0)
        if inJail and currentJob ~= nil then
            if currentLocation ~= 0 then
                if not DoesBlipExist(currentBlip) then
                    CreateJobBlip()
                end
                jobstart(currentJob, currentLocation)
            else
                currentLocation = math.random(1, #Config.Locations.jobs[currentJob])
                CreateJobBlip()
            end
        else
            Wait(5000)
        end
    end
end)