local currentLocation = 0
currentBlip = nil
local isWorking = false

-- Functions

function CreateJobBlip(first) -- Used globally
    if currentLocation ~= 0 then
        if DoesBlipExist(currentBlip) then
            RemoveBlip(currentBlip)
        end
        currentBlip = AddBlipForCoord(Config.Locations.jobs[currentJob][currentLocation].coords.xyz)
        SetBlipSprite(currentBlip, 402)
        SetBlipDisplay(currentBlip, 4)
        SetBlipScale(currentBlip, 0.8)
        SetBlipAsShortRange(currentBlip, true)
        SetBlipColour(currentBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Prison Work")
        EndTextCommandSetBlipName(currentBlip)
        if first then return end
        local Chance = math.random(100)
        local Odd = math.random(100)
        if Chance ~= Odd then return end
        TriggerServerEvent('QBCore:Server:AddItem', 'phone', 1)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["phone"], "add")
        QBCore.Functions.Notify(Lang:t("success.found_phone"), "success")
    end
end

local function CheckAllLocations()
    local amount = 0
    for i = 1, #Config.Locations.jobs["electrician"] do
        local current = Config.Locations.jobs["electrician"][i]
        if current.done then
            amount += 1
        end
    end
    return amount == #Config.Locations.jobs["electrician"]
end

local function ResetLocations()
    for i = 1, #Config.Locations.jobs["electrician"] do
        Config.Locations.jobs["electrician"][i].done = false
    end
end

local function JobDone()
    if not Config.Locations.jobs["electrician"][currentLocation].done then return end
    if math.random(1, 100) <= 50 then
        QBCore.Functions.Notify(Lang:t("success.time_cut"))
        jailTime -= math.random(1, 2)
    end
    local newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    while (newLocation == currentLocation) do
        Wait(100)
        newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    end
    currentLocation = newLocation
    CreateJobBlip()
    if CheckAllLocations() then ResetLocations() end
end

local function StartWork()
    isWorking = true
    Config.Locations.jobs["electrician"][currentLocation].done = true
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
end

-- Threads

CreateThread(function()
    local isInside = false
    for k in pairs(Config.Locations.jobs) do
        for i = 1, #Config.Locations.jobs[k] do
            local current = Config.Locations.jobs[k][i]
            if Config.UseTarget then
                exports['qb-target']:AddBoxZone("electricianwork", current.coords.xyz, 1.5, 1.6, {
                    name = "electricianwork",
                    heading = 12.0,
                    debugPoly = false,
                    minZ = 19,
                    maxZ = 219
                }, {
                    options = {
                        {
                            icon = 'fas fa-swords-laser',
                            label = 'Do Electrician Work',
                            canInteract = function()
                                return inJail and currentJob and not Config.Locations.jobs[k][i].done and not isWorking
                            end,
                            action = function()
                                currentLocation = i
                                StartWork()
                            end
                        }
                    },
                    distance = 2.5
                })
            else
                local electricityzone = BoxZone:Create(current.coords.xyz, 3.0, 5.0, {
                    name="electricity",
                    debugPoly=false,
                })
                electricityzone:onPlayerInOut(function(isPointInside)
                    isInside = isPointInside and inJail and currentJob and not Config.Locations.jobs[k][i].done and not isWorking
                    if isInside then
                        currentLocation = i
                        exports['qb-core']:DrawText(Lang:t("info.job_interaction"), 'left')
                    else
                        exports['qb-core']:HideText()
                    end
                end)
            end
        end
    end
    if not Config.UseTarget then
        while true do
            local sleep = 1000
            if isInside then
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    StartWork()
                    sleep = 1000
                end
            end
            Wait(sleep)
        end
    end
end)
