Citizen.CreateThread(function()
	for k, v in pairs(ConfigAmbulanceJob.BlipAmbulance) do
		local BlipAmbulance = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(BlipAmbulance, 61)
		SetBlipScale (BlipAmbulance, 0.9)
		SetBlipColour(BlipAmbulance, 2)
		SetBlipAsShortRange(BlipAmbulance, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Hopital')
		EndTextCommandSetBlipName(BlipAmbulance)
	end
end)

Citizen.CreateThread(function()
	local blips = {}
	local blipsVisible= false
	while true do
		Citizen.Wait(1000)
		if ESX.PlayerData.job and ESX.PlayerData.job.name =='ambulance' and not blipsVisible then
            for k, v in pairs(ConfigAmbulanceJob.Vestiaire) do
                local BlipAmbulanceVestiaire = AddBlipForCoord(v.x, v.y, v.z)
                SetBlipSprite(BlipAmbulanceVestiaire, 366)
                SetBlipScale (BlipAmbulanceVestiaire, 0.6)
                SetBlipColour(BlipAmbulanceVestiaire, 2)
                SetBlipAsShortRange(BlipAmbulanceVestiaire, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName('[Ambulance] Vestiaire')		
                EndTextCommandSetBlipName(BlipAmbulanceVestiaire)
				table.insert(blips, blip)
			end
            for k, v in pairs(ConfigAmbulanceJob.GarageList) do
                local BlipAmbulanceGarageList = AddBlipForCoord(v.x, v.y, v.z)
                SetBlipSprite(BlipAmbulanceGarageList, 357)
                SetBlipScale (BlipAmbulanceGarageList, 0.6)
                SetBlipColour(BlipAmbulanceGarageList, 2)
                SetBlipAsShortRange(BlipAmbulanceGarageList, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName('[Ambulance] Garage Sortire')		
                EndTextCommandSetBlipName(BlipAmbulanceGarageList)
            end
            for k, v in pairs(ConfigAmbulanceJob.GarageRentrer) do
                local BlipAmbulanceGarageRentrer = AddBlipForCoord(v.x, v.y, v.z)
                SetBlipSprite(BlipAmbulanceGarageRentrer, 357)
                SetBlipScale (BlipAmbulanceGarageRentrer, 0.6)
                SetBlipColour(BlipAmbulanceGarageRentrer, 2)
                SetBlipAsShortRange(BlipAmbulanceGarageRentrer, true)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName('[Ambulance] Garage Rentrer')		
                EndTextCommandSetBlipName(BlipAmbulanceGarageRentrer)
            end
			for k, v in pairs(ConfigAmbulanceJob.Coffre) do
				local BlipAmbulanceCoffre = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(BlipAmbulanceCoffre, 814)
				SetBlipScale (BlipAmbulanceCoffre, 0.6)
				SetBlipColour(BlipAmbulanceCoffre, 2)
				SetBlipAsShortRange(BlipAmbulanceCoffre, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName('[Ambulance] Coffre')		
				EndTextCommandSetBlipName(BlipAmbulanceCoffre)
			end
			for k, v in pairs(ConfigAmbulanceJob.Pharmacie) do
				local BlipAmbulancePharmacie = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(BlipAmbulancePharmacie, 51)
				SetBlipScale (BlipAmbulancePharmacie, 0.6)
				SetBlipColour(BlipAmbulancePharmacie, 2)
				SetBlipAsShortRange(BlipAmbulancePharmacie, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName('[Ambulance] Pharmacie')		
				EndTextCommandSetBlipName(BlipAmbulancePharmacie)
			end
			for k, v in pairs(ConfigAmbulanceJob.GarageHeliList) do
				local BlipAmbulanceGarageHeliList = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(BlipAmbulanceGarageHeliList, 43)
				SetBlipScale (BlipAmbulanceGarageHeliList, 0.6)
				SetBlipColour(BlipAmbulanceGarageHeliList, 2)
				SetBlipAsShortRange(BlipAmbulanceGarageHeliList, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName('[Ambulance] Garage Helico')		
				EndTextCommandSetBlipName(BlipAmbulanceGarageHeliList)
			end
			blipsVisible = true
		end
		if next(blips) ~= nil and ESX.PlayerData.job.name ~='ambulance' then
			for i, blip in pairs(blips) do
				RemoveBlip(blip)
				table.remove(blips, i)
			end
			blipsVisible = false
		end
	end
end)
Citizen.CreateThread(function()
	local blips = {}
	local blipsVisible= false
	while true do
		Citizen.Wait(1000)
		if ESX.PlayerData.job and ESX.PlayerData.job.name =='ambulance' and ESX.PlayerData.job.grade_name == 'boss' and not blipsVisible then
			for k, v in pairs(ConfigAmbulanceJob.Boss) do
				local BlipAmbulanceBoss = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(BlipAmbulanceBoss, 521)
				SetBlipScale (BlipAmbulanceBoss, 0.6)
				SetBlipColour(BlipAmbulanceBoss, 2)
				SetBlipAsShortRange(BlipAmbulanceBoss, true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName('[Ambulance] Action Patron')
				EndTextCommandSetBlipName(BlipAmbulanceBoss)
			end
			blipsVisible = true
		end
		if next(blips) ~= nil and ESX.PlayerData.job.name ~='ambulance' then
			for i, blip in pairs(blips) do
				RemoveBlip(blip)
				table.remove(blips, i)
			end
			blipsVisible = false
		end
	end
end)