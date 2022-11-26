MySQL.Async.execute("CREATE TABLE IF NOT EXISTS fv_dimension( id int AUTO_INCREMENT, dimension_id int(11) NOT NULL, name varchar(255) NOT NULL, passwd varchar(255) NOT NULL, owner varchar(255) NOT NULL, identifier varchar(255) NOT NULL, players int(11) NOT NULL DEFAULT 1, create_time timestamp NOT NULL DEFAULT current_timestamp(), PRIMARY KEY(id) )", {}, function() end)

if Config.UseItem then
    ESX.RegisterUsableItem(Config.Item, function(source)
        TriggerClientEvent('fv_dimension:menu', source)
    end)
else
    RegisterCommand(Config.Command, function(source, args, rawCommand)
        TriggerClientEvent('fv_dimension:menu', source)
    end, false)
end

RegisterCommand(Config.CommandCheck, function(source, args, rawCommand)
    local check = GetPlayerRoutingBucket(source)
    if check == 0 then 
        if Config.ESXnotify then
            TriggerClientEvent('esx:showNotification', source, _U('check_dimension')..' Default')
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('check_dimension')..' Default'})
        end
    else
        if Config.ESXnotify then
            TriggerClientEvent('esx:showNotification', source, _U('check_dimension')..' '..check)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = _U('check_dimension')..' '..check})
        end
    end
end, false)

AddEventHandler("playerDropped", function()
    local _source = source 
    local leaveID = GetPlayerRoutingBucket(_source)
    if leaveID > 0 then
        print('^3['..GetCurrentResourceName()..'] - Player ID '.. source..' disconnected from dimension ID '..leaveID..'^0')
        MySQL.query('SELECT * FROM fv_dimension WHERE dimension_id = @id ', {
            ['@id'] = leaveID,
        }, function(result)   
            for _,v in pairs(result) do
                players = v.players
            end
            if players > 0 then
                MySQL.Async.transaction({'UPDATE fv_dimension SET players = @players - 1 WHERE dimension_id = @connectId'},
                    {['@connectId'] = leaveID, ['@players'] = players},
                function() end)
            end
            local checkPlayers = players - 1
            if checkPlayers == 0 then
                Wait(5000)
                TriggerEvent("fv_dimension:remove-dimension", leaveID)
            end 
        end)
    end
end)

RegisterServerEvent("fv_dimension:create-dimension")
AddEventHandler("fv_dimension:create-dimension", function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local playername = GetPlayerName(_source)
    local dataID = tonumber(data.id)
    MySQL.query('SELECT * FROM fv_dimension', {
    }, function(result) 
        for _,v in pairs(result) do
            identifier = v.identifier
        end
        if dataID >= 1 and dataID <= 1000 then
            if identifier ~= xPlayer.identifier then  
                if #result == 0 then
                    if xPlayer.getAccount('bank').money >= Config.CreatePrice then
                        xPlayer.removeAccountMoney('bank',Config.CreatePrice)
                        MySQL.Async.insert("INSERT INTO fv_dimension (`dimension_id`, `name`, `passwd`, `owner`, `identifier` ) VALUES(@dimension_id, @name, @passwd, @owner, @identifier);", {
                            ['@dimension_id'] = dataID,
                            ['@name'] = data.name,
                            ['@passwd'] = data.password,
                            ['@owner'] = playername,
                            ['@identifier'] = xPlayer.identifier,
                        })
                        print('^5['..GetCurrentResourceName()..'] - Player ID '.._source..' create dimension ID '..dataID..'^0')
                        SetPlayerRoutingBucket(_source, dataID)
                        TriggerClientEvent('fv_dimension:showhud', _source, dataID)
                        if Config.ESXnotify then
                            TriggerClientEvent('esx:showNotification', _source, _U('dim_create'))
                        else
                            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = _U('dim_create')})
                        end
                    else
                        if Config.ESXnotify then
                            TriggerClientEvent('esx:showNotification', _source, _U('no_money'))
                        else
                            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = _U('no_money')})
                        end
                    end
                else
                    if Config.ESXnotify then
                        TriggerClientEvent('esx:showNotification', _source, _U('id_exist'))
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'warn', text = _U('id_exist')})
                    end
                end  
            else
                if Config.ESXnotify then
                    TriggerClientEvent('esx:showNotification', _source, _U('dimension_owned'))
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'warn', text = _U('dimension_owned')})
                end 
            end  
        else
            if Config.ESXnotify then
                TriggerClientEvent('esx:showNotification', _source, _U('dimension_null'))
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = _U('dimension_null')})
            end 
        end  
    end)
end)

RegisterServerEvent("fv_dimension:remove-dimension")
AddEventHandler("fv_dimension:remove-dimension", function(remove_id)
    local remove_id = remove_id
    MySQL.query('SELECT dimension_id FROM fv_dimension WHERE dimension_id = @id', {
        ['@id'] = remove_id,
	}, function(result)      
        if #result == 1 then
            MySQL.Async.execute('DELETE FROM fv_dimension WHERE dimension_id = @id', {
                ['@id'] = remove_id
            })
            print('^2['..GetCurrentResourceName()..'] - Delete dimension ID '..remove_id..'^0')
        end      
	end)
end)

RegisterServerEvent("fv_dimension:connect-dimension")
AddEventHandler("fv_dimension:connect-dimension", function(data)
    local _source = source 
    local connectID = tonumber(data.id_connect)
    local connectPASSWD = data.passwd_connect
    local PlayerD = GetPlayerRoutingBucket(_source)
    if PlayerD == 0 then
        MySQL.query('SELECT * FROM fv_dimension WHERE dimension_id = @id ', {
            ['@id'] = connectID,
        }, function(result)   
            for _,v in pairs(result) do
                passwd = v.passwd
                players = v.players
                mysqlID = v.dimension_id
            end
            if #result == 1 then
                if passwd == nil or passwd == connectPASSWD then
                    MySQL.Async.transaction({'UPDATE fv_dimension SET players = @players + 1 WHERE dimension_id = @connectId'},
                        {['@connectId'] = connectID, ['@players'] = players},
                    function() end)
                    if Config.ESXnotify then
                        TriggerClientEvent('esx:showNotification', _source, _U('dim_connect'))
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = _U('dim_connect')})
                    end
                    print('^2['..GetCurrentResourceName()..'] - Player ID '.._source..' connected in the dimension ID '..connectID..'.^0')
                    SetPlayerRoutingBucket(_source, connectID)
                    TriggerClientEvent('fv_dimension:showhud', _source, connectID)
                else
                    if Config.ESXnotify then
                        TriggerClientEvent('esx:showNotification', _source, _U('wrong_pass'))
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'warn', text = _U('wrong_pass')})
                    end
                end
            else
                if Config.ESXnotify then
                    TriggerClientEvent('esx:showNotification', _source, _U('wrong_id'))
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'warn', text = _U('wrong_id')})
                end
            end      
        end)
    else
        if Config.ESXnotify then
            TriggerClientEvent('esx:showNotification', _source, _U('in_dimension'))
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'warn', text = _U('in_dimension')})
        end
    end
end)

RegisterServerEvent("fv_dimension:leave-dimension")
AddEventHandler("fv_dimension:leave-dimension", function()
    local _source = source 
    local leaveID = GetPlayerRoutingBucket(_source)
    if leaveID > 0 then
        MySQL.query('SELECT * FROM fv_dimension WHERE dimension_id = @id ', {
            ['@id'] = leaveID,
        }, function(result)   
            for _,v in pairs(result) do
                players = v.players
            end
            if players > 0 then
                MySQL.Async.transaction({'UPDATE fv_dimension SET players = @players - 1 WHERE dimension_id = @connectId'},
                    {['@connectId'] = leaveID, ['@players'] = players},
                function() end)
                print('^3['..GetCurrentResourceName()..'] - Player ID '.._source..' disconnected from dimension ID '..leaveID..'.^0')
                SetPlayerRoutingBucket(_source, 0)
                TriggerClientEvent('fv_dimension:showhud', _source, 0)
                if Config.ESXnotify then
                    TriggerClientEvent('esx:showNotification', _source, _U('dim_leave'))
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'warn', text = _U('dim_leave')})
                end
            end
            local checkPlayers = players - 1
            if checkPlayers == 0 then
                Wait(5000)
                TriggerEvent("fv_dimension:remove-dimension", leaveID)
            end 
        end)
    else
        if Config.ESXnotify then
            TriggerClientEvent('esx:showNotification', _source, _U('standard_dim'))
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'warn', text = _U('standard_dim')})
        end
    end
end)

RegisterServerEvent("fv_dimension:moveVehicle")
AddEventHandler("fv_dimension:moveVehicle", function(vehicle, id)
    local entityId = NetworkGetEntityFromNetworkId(tonumber(vehicle))
    SetEntityRoutingBucket(entityId, id)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
        print('\n-------------------------------------------------\n^5['..GetCurrentResourceName()..'] - 🚀 Starting resource... \n^3['..GetCurrentResourceName()..'] - 💾 Resetting MySQL data.^0\n-------------------------------------------------')
        Wait(1000)
        MySQL.Async.execute('DELETE FROM fv_dimension')
        TriggerClientEvent('fv_dimension:resetDataCL', -1)
        print('^2['..GetCurrentResourceName()..'] - ✅ Resource ready.^0\n-------------------------------------------------\n')
  end)

RegisterServerEvent("fv_dimension:resetDataSV")
AddEventHandler("fv_dimension:resetDataSV", function()
    local dimension = GetPlayerRoutingBucket(source)
    if dimension >= 1 and dimension <= 1000 then
        SetPlayerRoutingBucket(source, 0)
        TriggerClientEvent('fv_dimension:showhud', source, 0)
        if Config.ESXnotify then
            TriggerClientEvent('esx:showNotification', source, '['..GetCurrentResourceName()..'] - '.._U('restart'))
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'warn', text = '['..GetCurrentResourceName()..'] - '.._U('restart')})
        end
    end
end)