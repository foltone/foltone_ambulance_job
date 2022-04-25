ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

GarageHeli = {
    helilistambulance = {},
}

local MenuGarageHeli = RageUI.CreateMenu("GarageHeli", "GarageHeli Ambulance");

function RageUI.PoolMenus:GarageHeliAmbulance()
	MenuGarageHeli:IsVisible(function(Items)
        Items:AddSeparator("GarageHeli Ambulance")
        for k,v in pairs(ConfigAmbulanceJob.HeliList) do
			Items:AddButton(v.name, nil, {RightLabel =">", IsDisabled = false }, function(onSelected)
				if (onSelected) then
					local newPlate = "EMS"..math.random(10100,90900)
					RequestModel(GetHashKey(v.model))
					while not HasModelLoaded(GetHashKey(v.model)) do Wait(1) end
					veh = CreateVehicle(GetHashKey(v.model), ConfigAmbulanceJob.SortieHeli, 340.00, true, false)
					SetVehicleNumberPlateText(veh, newPlate)
					SetEntityAsMissionEntity(veh, 1, 1)
					TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
					RageUI.CloseAll()
				end
			end)
		end
	end, function(Panels)
	end)
end

-- GarageHeli
CreateThread(function()
    while true do
		local wait = 500

	Wait(wait)
	end
end)


-- Ranger 
Citizen.CreateThread(function()
    while true do
		local wait = 500
		local pPed = GetPlayerPed(-1)
		local pInVeh = IsPedInAnyVehicle(pPed, false)
		if pInVeh then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
				for k, v in pairs(ConfigAmbulanceJob.GarageHeliRentrer) do
					local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
					local pos = ConfigAmbulanceJob.GarageHeliRentrer
					local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
					if dist <= 15.0 then
						wait = 1
						DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 1.5, 1.0, 1.5, 252, 3, 3, 150, false, false, 2, false, false, false, false)
						if dist <= 2.0 then
						wait = 1
							ESX.ShowHelpNotification("Appuyer sur ~r~[E]~s~ pour ~r~ranger votre véhicule ~s~!")
							if IsControlJustPressed(1,51) then
								local veh = ESX.Game.GetClosestVehicle(playerCoords)
								DeleteEntity(veh)
							end
						end
					end
				end
			end
		else
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
				for k, v in pairs(ConfigAmbulanceJob.GarageHeliList) do
					local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
					local pos = ConfigAmbulanceJob.GarageHeliList
					local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.x, v.y, v.z)
					if dist <= 15.0 then
						wait = 0
						DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 1.5, 1.0, 1.5, 3, 252, 65, 150, false, false, 2, false, false, false, false)
						if dist <= 1.0 then
							wait = 0
							ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour ~g~sortir un helicopter ~s~!")
							if IsControlJustPressed(1,51) then
								RageUI.Visible(MenuGarageHeli, not RageUI.Visible(MenuGarageHeli))
							end
						end
					end
				end
			end
		end
	Wait(wait)
	end
end)