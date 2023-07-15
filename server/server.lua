ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', 'alerte ambulance', true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then
			print(('esx_ambulancejob: %s attempted combat logging!'):format(identifier))
		end

		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	if type(isDead) ~= 'boolean' then
		print(('esx_ambulancejob: %s attempted to parse something else than a boolean to setDeathStatus!'):format(identifier))
		return
	end

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)


ESX.RegisterServerCallback('esx_ambulancejob:getEmployees', function(source, cb, society)
	local employees = {}
	local xPlayers = ESX.GetExtendedPlayers('job', society)
	for _, xPlayer in pairs(xPlayers) do
		local name = xPlayer.name
		if name == GetPlayerName(xPlayer.source) then
			name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
		end
		table.insert(employees, {
			name = name,
			identifier = xPlayer.identifier,
			job = {
				name = society,
				label = xPlayer.job.label,
				grade = xPlayer.job.grade,
				grade_name = xPlayer.job.grade_name,
				grade_label = xPlayer.job.grade_label
			}
		})
	end
	local query = "SELECT identifier, job_grade FROM `users` WHERE `job`=@job ORDER BY job_grade DESC"
	query = "SELECT identifier, job_grade, firstname, lastname FROM `users` WHERE `job`=@job ORDER BY job_grade DESC"
	MySQL.Async.fetchAll(query, {
		['@job'] = society
	}, function(result)
		for k, row in pairs(result) do
			local alreadyInTable
			local identifier = row.identifier

			for k, v in pairs(employees) do
				if v.identifier == identifier then
					alreadyInTable = true
				end
			end
			if not alreadyInTable then
				local name = "Name not found." -- maybe this should be a locale instead ¯\_(ツ)_/¯
				name = row.firstname .. ' ' .. row.lastname 
				
				table.insert(employees, {
					name = name,
					identifier = identifier,
					job = {
						name = society,
						label = Jobs[society].label,
						grade = row.job_grade,
						grade_name = Jobs[society].grades[tostring(row.job_grade)].name,
						grade_label = Jobs[society].grades[tostring(row.job_grade)].label
					}
				})
			end
		end
		cb(employees)
	end)
end)

ESX.RegisterServerCallback('esx_ambulancejob:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)

	if xTarget then
		xTarget.setJob(job, grade)

		if type == 'hire' then
			xTarget.showNotification(_U('you_have_been_hired', job))
		elseif type == 'promote' then
			xTarget.showNotification(_U('you_have_been_promoted'))
		elseif type == 'fire' then
			xTarget.showNotification(_U('you_have_been_fired', xTarget.getJob().label))
		end

		cb()
	else
		MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
			['@job']        = job,
			['@job_grade']  = grade,
			['@identifier'] = identifier
		}, function(rowsChanged)
			cb()
		end)
	end
end)

RegisterServerEvent('foltone_ambulance_job:GiveItem')
AddEventHandler('foltone_ambulance_job:GiveItem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item.Label, item.Index)
    TriggerClientEvent('esx:showNotification', source, 'Vous avez reçu : '..item.Index.." "..item.Name)
end)

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(item, 1)
	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, "Vous avez utilisé un bandage")
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, "Vous avez utilisé un medikit")
	end
end)


--coffre
ESX.RegisterServerCallback('ambulance:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end

	cb(all_items)
end)

ESX.RegisterServerCallback('ambulance:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end
	end)
	cb(all_items)
end)

RegisterServerEvent('ambulance:putStockItems')
AddEventHandler('ambulance:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposé ".. count.." : "..itemName)
			sendToDiscordWithSpecialURL("Name", "Action coffre : ", xPlayer.getName().." à déposé "..count.." : "..itemName)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'en avez pas assez sur vous")
		end
	end)
end)

RegisterServerEvent('ambulance:takeStockItems')
AddEventHandler('ambulance:takeStockItems', function(itemName, count)
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
		xPlayer.addInventoryItem(itemName, count)
		inventory.removeItem(itemName, count)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retiré "..count.." : "..itemName)
		sendToDiscordWithSpecialURL("Name", "Action coffre : ", xPlayer.getName().." à retiré "..count.." : "..itemName)

	end)
end)


-- prise de service

RegisterNetEvent('foltone:prisedeservice')
AddEventHandler('foltone:prisedeservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Name", "Prise de service : ", xPlayer.getName().." à prise son service")
end)

RegisterNetEvent('foltone:quitteleservice')
AddEventHandler('foltone:quitteleservice', function()
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
	sendToDiscordWithSpecialURL("Name", "Fin de service : ", xPlayer.getName().." à quitter son service")
end)

-- revive player

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.job.name == 'ambulance' then
        TriggerClientEvent('esx_ambulancejob:revive', target)
    else
        print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
    end
end)

-- demande d'assistance

RegisterServerEvent('assistance')
AddEventHandler('assistance', function(coords, raison)
	local _source = source
	local _raison = raison
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'ambulance' then
			TriggerClientEvent('assistance:setBlip', xPlayers[i], coords, _raison)
		end
	end
end)


function sendToDiscordWithSpecialURL(name, title, message)
    local DiscordWebHook = "https://discord.com/api/webhooks/"
	local embeds = {
		{
            ["type"] = "rich",
            ["color"] = 7523698,

            ["author"] = {
                ["name"] = "Foltone Logs",
                ["icon_url"] = "https://cdn.discordapp.com/attachments/818882670502084638/942004428624498738/unknown.png",
            },

            ["title"] = title,
            ["description"] = message,
		}
	}
    if title == nil or title == '' then return FALSE end PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end
