RegisterNetEvent("fv_dimension:menu")
AddEventHandler("fv_dimension:menu", function()
    startAnim()
    SetNuiFocus(true, true)
    SendNUIMessage({action = 'enable', price = Config.CreatePrice})
end)

RegisterNUICallback('action', function(data)
    if data.action == "close-menu" then
        stopAnim()
        SetNuiFocus(false, false)
    elseif data.action == "leave-dimension" then
        stopAnim()
        SetNuiFocus(false, false)
        TriggerServerEvent("fv_dimension:leave-dimension")
    elseif data.action == "create-dimension" then
        stopAnim()
        TriggerServerEvent("fv_dimension:create-dimension", data)
        SetNuiFocus(false, false)
    elseif data.action == "error-create" then
        if Config.ESXnotify then
            ESX.ShowNotification(_U('error'))
        else
            exports['mythic_notify']:SendAlert('error', _U('error'))
        end
    elseif data.action == "connect-dimension" then
        stopAnim()
        SetNuiFocus(false, false)
        TriggerServerEvent("fv_dimension:connect-dimension", data)
    elseif data.action == "error-connect" then
        if Config.ESXnotify then
            ESX.ShowNotification(_U('error'))
        else
            exports['mythic_notify']:SendAlert('error', _U('error'))
        end
    end
end)

RegisterNetEvent("fv_dimension:resetDataCL")
AddEventHandler("fv_dimension:resetDataCL", function()
    TriggerServerEvent('fv_dimension:resetDataSV')
    stopAnim()
end)

RegisterNetEvent("fv_dimension:showhud")
AddEventHandler("fv_dimension:showhud", function(id)
    local playerPed = PlayerPedId()
    local inVeh = IsPedInAnyVehicle(playerPed, false)
    if inVeh then
        local vehicle = GetVehiclePedIsIn(playerPed)
        local entity = ObjToNet(vehicle)
        TriggerServerEvent('fv_dimension:moveVehicle', entity, id)
    end
    if id > 0 then
        SendNUIMessage({action = 'showhud', current_id = id}) 
    else
        SendNUIMessage({action = 'hidehud',}) 
    end
end)

function stopAnim()
    if Config.Animation then
        StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
        DeleteObject(tab)
    end
end

function startAnim()
    if Config.Animation then
        RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")
        while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a") do
            Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
        tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
        AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    end
end