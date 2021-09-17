currentLocation = 0
currentBlip = nil
isWorking = false
HaveDoor = false
HaveGarbrge = false
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if inJail and currentJob ~= nil then 
            if currentLocation ~= 0 then
                if not DoesBlipExist(currentBlip) then
                    CreateJobBlip()
                end
                local pos = GetEntityCoords(PlayerPedId())
                if #(pos - vector3(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z)) < 10.0 and not isWorking then
                    DrawMarker(2, Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 150, 200, 50, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z)) < 1 and not isWorking then
                        if currentJob == 'electrician' then
                            isWorking = true
                            QBCore.Functions.Progressbar("work_electric", "Working on electricity", math.random(5000, 10000), false, true, {
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
                                QBCore.Functions.Notify("Cancelled..", "error")
                            end)
                        elseif currentJob == 'workercantina' then
                            isWorking = true
                            SetEntityCoords(PlayerPedId(),Config.Locations.jobs[currentJob][currentLocation].coords.x, Config.Locations.jobs[currentJob][currentLocation].coords.y, Config.Locations.jobs[currentJob][currentLocation].coords.z)
                            SetEntityHeading(PlayerPedId(),Config.Locations.jobs[currentJob][currentLocation].coords.h)
                            TriggerEvent('animations:client:EmoteCommandStart', {"clean"})
                            QBCore.Functions.Progressbar("work_electric", "You are cleaning", math.random(5000, 10000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                            }, {}, {}, function() -- Done
                                isWorking = false
                               TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                                JobDone()
                            end, function() -- Cancel
                                isWorking = false
                                ClearPedTasks(PlayerPedId())
                                QBCore.Functions.Notify("Cancelled..", "error")
                            end) 
                        elseif currentJob == 'mech' then
                            if HaveDoor == false then
                            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                            isWorking = true
                            QBCore.Functions.Progressbar("work_electric", "Collect scrap", math.random(5000, 10000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                            }, {}, {}, function() -- Done
                                ClearPedTasks(PlayerPedId())
                                HaveDoor = true
                              PickupPackage()
                            end, function() -- Cancel
                                isWorking = false
                                HaveDoor = false
                                ClearPedTasks(PlayerPedId())
                                QBCore.Functions.Notify("Cancelled..", "error")
                            end) 
                            end
                        elseif currentJob == 'garbage' then
                            if HaveGarbrge == false then
                            TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                            isWorking = true
                            QBCore.Functions.Progressbar("work_electric", "Collect the trash", math.random(5000, 10000), false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {}, {}, {}, function() -- Done
                                ClearPedTasks(PlayerPedId())
                                HaveGarbrge = true
                                TakeAnim()
                            end, function() -- Cancel
                                isWorking = false
                                HaveGarbrge = false
                                ClearPedTasks(PlayerPedId())
                                QBCore.Functions.Notify("Cancelled..", "error")
                            end) 
                            end
                        end
                    end
               
            end
            else
                currentLocation = math.random(1, #Config.Locations.jobs[currentJob])
                CreateJobBlip()
            end
        else
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function ()
      while true do
          Citizen.Wait(7)
          if inJail then
            if HaveDoor == true then
                local pos = GetEntityCoords(PlayerPedId())
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["delivery"].coords.x, Config.Locations["delivery"].coords.y, Config.Locations["delivery"].coords.z, true) < 2.0 then
                    DrawText3D(Config.Locations["delivery"].coords.x, Config.Locations["delivery"].coords.y, Config.Locations["delivery"].coords.z, "~g~E~w~ - scrap dismantling")
                    if IsControlJustReleased(0, Keys["E"]) then
                        DropPackage()
                        ScrapAnim()
                        QBCore.Functions.Progressbar("deliver_reycle_package", "Items being placed", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                            JobDone()
                            HaveDoor = false
                            isWorking = false
                        end)
                    end
                else
                    DrawText3D(Config.Locations["delivery"].coords.x, Config.Locations["delivery"].coords.y, Config.Locations["delivery"].coords.z, "dismantling")
                end
            end

            if HaveGarbrge == true then
                local pos = GetEntityCoords(PlayerPedId())
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Config.Locations["deliverygarabage"].coords.x, Config.Locations["deliverygarabage"].coords.y, Config.Locations["deliverygarabage"].coords.z, true) < 2.0 then
                    DrawText3D(Config.Locations["deliverygarabage"].coords.x, Config.Locations["deliverygarabage"].coords.y, Config.Locations["deliverygarabage"].coords.z, "~g~E~w~ -throw out the trash")
                    if IsControlJustReleased(0, Keys["E"]) then
                        DeliverAnim()
                        QBCore.Functions.Progressbar("deliver_reycle_package", "Items being placed", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            JobDone()
                            HaveGarbrge = false
                            isWorking = false
                        end)
                    end
                else
                    DrawText3D(Config.Locations["deliverygarabage"].coords.x, Config.Locations["deliverygarabage"].coords.y, Config.Locations["deliverygarabage"].coords.z, "throw out the trash")
                end
            end

          end
      end
  end)

function JobDone()
    if math.random(1, 100) <= 50 then
        QBCore.Functions.Notify("You've worked some time off your sentence")
        jailTime = jailTime - math.random(1, 2)
    end
    HaveDoor = false
    local newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    while (newLocation == currentLocation) do
        Citizen.Wait(100)
        newLocation = math.random(1, #Config.Locations.jobs[currentJob])
    end
    currentLocation = newLocation
    CreateJobBlip() 
end

function CreateJobBlip()
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
            QBCore.Functions.Notify("You found a phone..", "success")
        end
    end
end

function PickupPackage()
    local pos = GetEntityCoords(PlayerPedId(), true)
    RequestAnimDict("anim@heists@box_carry@")
    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
    local model = GetHashKey("prop_car_door_04")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local object = CreateObject(model, pos.x, pos.y, pos.z, true, true, true)
    
    AttachEntityToEntity(object, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.05, 0.1, -0.3, 300.0, 250.0, 20.0, true, true, false, true, 1, true)
    carryPackage = object
end

function DropPackage()
    ClearPedTasks(PlayerPedId())
    DetachEntity(carryPackage, true, true)
    DeleteObject(carryPackage)
    carryPackage = nil
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function ScrapAnim()
    local time = 5
    loadAnimDict("mp_car_bomb")
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(1000)
            time = time - 1
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
            end
        end
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function LoadAnimation(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

function TakeAnim()
    local ped = PlayerPedId()

    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    GarbageObject = CreateObject(GetHashKey("prop_cs_rub_binbag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(GarbageObject, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)

    AnimCheck()
end


function AnimCheck()
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()

            if hasZak then
                if not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                    ClearPedTasksImmediately(ped)
                    LoadAnimation('missfbi4prepp1')
                    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                break
            end

            Citizen.Wait(200)
        end
    end)
end

function DeliverAnim()
    local ped = PlayerPedId()
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    CanTakeBag = false
    SetTimeout(1250, function()
        DetachEntity(GarbageObject, 1, false)
        DeleteObject(GarbageObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        GarbageObject = nil
        CanTakeBag = true
    end)
end
