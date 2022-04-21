ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

local MenuAscenseur = RageUI.CreateMenu("Ascenseur", 'menu ascenseur');

function RageUI.PoolMenus:Ascenseur()
    MenuAscenseur:IsVisible(function(Items)
        Items:AddButton("Heliport [~g~Toit~s~]", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                for k, v in pairs(ConfigAmbulanceJob.AscenseurHeliport) do
                    SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z)
                end
            end
        end)
        Items:AddButton("Accueil [~g~RDC~s~]", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                for k, v in pairs(ConfigAmbulanceJob.AscenseurAccueil) do
                    SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z)
                end
            end
        end)
        Items:AddButton("Garage [~g~-1~s~]", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                for k, v in pairs(ConfigAmbulanceJob.AscenseurGarage) do
                    SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z)
                end
            end
        end)
    end, function(Panels)
    end)
end

Citizen.CreateThread(function()
	while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            wait = 500
            local playerCoords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(ConfigAmbulanceJob.AscenseurHeliport) do
                local distancevestiaire = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
                if distancevestiaire <= 5.0 then
                    wait = 0
                    DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 114, 204, 114, 250, false, false, 2, false, false, false, false)
                end
                if distancevestiaire <= 1.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour acceder à ~g~l'ascenseur", 1) 
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(MenuAscenseur, not RageUI.Visible(MenuAscenseur))
                    end
                end
            end
            
            for k, v in pairs(ConfigAmbulanceJob.AscenseurAccueil) do
                local distancevestiaire = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
                if distancevestiaire <= 5.0 then
                    wait = 0
                    DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 114, 204, 114, 250, false, false, 2, false, false, false, false)
                end
                if distancevestiaire <= 1.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour acceder à ~g~l'ascenseur", 1) 
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(MenuAscenseur, not RageUI.Visible(MenuAscenseur))
                    end
                end
            end

            for k, v in pairs(ConfigAmbulanceJob.AscenseurGarage) do
                local distancevestiaire = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
                if distancevestiaire <= 5.0 then
                    wait = 0
                    DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 114, 204, 114, 250, false, false, 2, false, false, false, false)
                end
                if distancevestiaire <= 1.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour acceder à ~g~l'ascenseur", 1) 
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(MenuAscenseur, not RageUI.Visible(MenuAscenseur))
                    end
                end
            end
        end
        Citizen.Wait(wait)
	end
end)