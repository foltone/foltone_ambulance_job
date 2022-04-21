ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

local MenuPharmacie = RageUI.CreateMenu("Pharmacie", 'menu pharamcie');

function RageUI.PoolMenus:Pharmacie()
    MenuPharmacie:IsVisible(function(Items)
        for k, v in pairs(ConfigAmbulanceJob.PharmacieItem) do
            Items:AddList(v.Name, {1,2,3,4,5,6,7,8,9,10}, v["Index"], nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
                if (onListChange) then
                    v["Index"] = Index;
                end
                if (Index) == Index then
                    if (onSelected) then
                        TriggerServerEvent('foltone_ambulance_job:GiveItem', v)
                    end
                end
            end)
        end
    end, function(Panels)
    end)
end

Citizen.CreateThread(function()
	while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            wait = 500
            local playerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(ConfigAmbulanceJob.Pharmacie) do
                local distancevestiaire = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
                if distancevestiaire <= 5.0 then
                    wait = 0
                    DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 114, 204, 114, 250, false, false, 2, false, false, false, false)
                end
                if distancevestiaire <= 1.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour acceder au action ~g~patron", 1) 
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(MenuPharmacie, not RageUI.Visible(MenuPharmacie))
                    end
                end
            end
        end
        Citizen.Wait(wait)
	end
end)