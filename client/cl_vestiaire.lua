ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

local MenuVestiaire = RageUI.CreateMenu("Vestiaire", 'menu vestiaire');
local open = false
function MenuVestiaire.Closed()
	open = false
end

function RageUI.PoolMenus:Vestiaire()
    MenuVestiaire:IsVisible(function(Items)
        Items:AddSeparator("↓ Civil ↓")
        Items:AddButton("Remettre sa tenue civil", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                MettreTenueCivil()
            end
        end)
        Items:AddSeparator("↓ Job ↓")
        Items:AddButton("Mettre sa tenue : ~g~"..ESX.PlayerData.job.grade_label, nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                MettreTenueJob()
            end
        end)
        Items:AddButton("Mettre un sac", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                MettreSac()
            end
        end)
    end, function(Panels)
    end)
end

function MettreTenueJob()
    Citizen.CreateThread(function()
	    RequestAnimDict('clothingtie')
	    while not HasAnimDictLoaded('clothingtie') do
	      Citizen.Wait(1)
	    end
	    TaskPlayAnim(PlayerPedId(), 'clothingtie', 'try_tie_neutral_a', 1.0, -1.0, 2667, 0, 1, true, true, true)
    end)
    Citizen.Wait(2667)
    TriggerEvent('skinchanger:getSkin', function(skin)
        local grade = ESX.PlayerData.job.grade_name
        local uniformObject
        if skin.sex == 0 then
            uniformObject = ConfigAmbulanceJob.Uniforms[grade].male
        else
            uniformObject = ConfigAmbulanceJob.Uniforms.boss.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

function MettreTenueCivil()
    Citizen.CreateThread(function()
	    RequestAnimDict('clothingtie')
	    while not HasAnimDictLoaded('clothingtie') do
	      Citizen.Wait(1)
	    end
	    TaskPlayAnim(PlayerPedId(), 'clothingtie', 'try_tie_neutral_a', 1.0, -1.0, 2667, 0, 1, true, true, true)
    end)
    Citizen.Wait(2667)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
    TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

function MettreSac()
    Citizen.CreateThread(function()
	    RequestAnimDict('clothingtie')
	    while not HasAnimDictLoaded('clothingtie') do
	      Citizen.Wait(1)
	    end
	    TaskPlayAnim(PlayerPedId(), 'clothingtie', 'try_tie_neutral_a', 1.0, -1.0, 2667, 0, 1, true, true, true)
    end)
    Citizen.Wait(2667)
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject
        if skin.sex == 0 then
            uniformObject = ConfigAmbulanceJob.Uniforms.sac.male
        else
            uniformObject = ConfigAmbulanceJob.Uniforms.sac.female
        end
        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end
    end)
end

Citizen.CreateThread(function()
	while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            wait = 500
            local playerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(ConfigAmbulanceJob.Vestiaire) do
                local distancevestiaire = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
                if distancevestiaire <= 5.0 then
                    wait = 0
                    DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 114, 204, 114, 250, false, false, 2, false, false, false, false)
                end
                if distancevestiaire <= 1.0 then
                    wait = 0
                    if not open then
                        ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour acceder au ~g~vestiaire", 1)
                    end
                    if IsControlJustPressed(1, 51) then
                        open = true
                        RageUI.Visible(MenuVestiaire, not RageUI.Visible(MenuVestiaire))
                    end
                end
            end
        end
        Citizen.Wait(wait)
	end
end)