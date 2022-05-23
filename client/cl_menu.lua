ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

local ServiceAmbulance = false

local MenuF6Ambulance = RageUI.CreateMenu("Ambulance", 'menu ambulance');
local interactioncitoyen = RageUI.CreateSubMenu(MenuF6Ambulance, "Interation citoyen", 'menu interaction')
local demandeassistance = RageUI.CreateSubMenu(MenuF6Ambulance, "Demande d'assist", 'menu assistance')

function RageUI.PoolMenus:F6Ambulance()
    MenuF6Ambulance:IsVisible(function(Items)
    if ServiceAmbulance == false then
        Items:CheckBox("~g~Prendre son service", nil, Checked1, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                TriggerServerEvent("foltone:prisedeservice")
                ServiceAmbulance = false
                Checked1 = IsChecked
            end
            if (IsChecked) then
                ServiceAmbulance = true
            end
        end)
    else
        Items:CheckBox("~r~Quiter son service", nil, Checked1, { Style = 1 }, function(onSelected, IsChecked)
            if (onSelected) then
                TriggerServerEvent("foltone:quitteleservice")
                ServiceAmbulance = false
                Checked1 = IsChecked
            end
            if (IsChecked) then
                ServiceAmbulance = true
            end
        end)
    end
    if ServiceAmbulance == true then
        Items:AddButton("Interation citoyen", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
        end, interactioncitoyen)
        Items:AddButton("Demande d'assist", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
        end, demandeassistance)
    end
         
    end, function(Panels)
    end)

    interactioncitoyen:IsVisible(function(Items)
        Items:AddButton("Réanimer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucune Personne à Proximité')
                else
                    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
                        if qtty > 0 then
                            local closestPlayerPed = GetPlayerPed(closestPlayer)
                            local health = GetEntityHealth(closestPlayerPed)
                            if health == 0 then
                                local playerPed = GetPlayerPed(-1)
                                Citizen.CreateThread(function()
                                    ESX.ShowNotification("Revive en cours")
                                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                    Wait(10000)
                                    ClearPedTasks(playerPed)
                                    if GetEntityHealth(closestPlayerPed) == 0 then
                                        TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                                        TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
                                    else
                                        ESX.ShowNotification("Est mort")
                                    end
                                end)
                            else
                                ESX.ShowNotification("Le joueur n\'est pas inconscient")
                            end
                        else
                            ESX.ShowNotification("Vous n\'avez pas de ~g~kit de soin~s~.")
                        end
                    end, 'medikit')
                end
            end
        end)

        Items:AddButton("Soigner une grande blessure", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 1.0 then
                    ESX.ShowNotification('Aucune Personne à Proximité')
                else
                    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
                        if quantity > 0 then
                            local closestPlayerPed = GetPlayerPed(closestPlayer)
                            local health = GetEntityHealth(closestPlayerPed)

                            if health > 0 then
                                local playerPed = PlayerPedId()

                                IsBusy = true
                                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                Citizen.Wait(10000)
                                ClearPedTasks(playerPed)

                                TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                                TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
                                ESX.ShowNotification('Vous avez soigné ~y~%s~s~', GetPlayerName(closestPlayer))
                                IsBusy = false
                            else
                                ESX.ShowNotification('Cette personne est inconsciente!')
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas de ~g~kit de soin~s~.')
                        end
                    end, 'medikit')
                end
            end
        end)

        Items:AddButton("Soigner une petite blessure", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 1.0 then
                    ESX.ShowNotification('Aucune Personne à Proximité')
                else
                    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
                        if quantity > 0 then
                            local closestPlayerPed = GetPlayerPed(closestPlayer)
                            local health = GetEntityHealth(closestPlayerPed)

                            if health > 0 then
                                local playerPed = PlayerPedId()

                                IsBusy = true
                                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                Citizen.Wait(10000)
                                ClearPedTasks(playerPed)

                                TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                                TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
                                ESX.ShowNotification('vous avez soigné ~y~%s~s~', GetPlayerName(closestPlayer))
                                IsBusy = false
                            else
                                ESX.ShowNotification('Cette personne est inconsciente!')
                            end
                        else
                            ESX.ShowNotification('Vous n\'avez pas de ~g~bandage~s~.')
                        end
                    end, 'bandage')
                end
            end
        end)

        Items:AddButton("Facture", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            local player, distance = ESX.Game.GetClosestPlayer()
            if (onSelected) then
                local raison = ""
                local montant = 0
                AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                while (UpdateOnscreenKeyboard() == 0) do
                    DisableAllControlActions(0)
                    Wait(0)
                end
                if (GetOnscreenKeyboardResult()) then
                    local result = GetOnscreenKeyboardResult()
                    if result then
                        raison = result
                        result = nil
                        AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            result = GetOnscreenKeyboardResult()
                            if result then
                                montant = result
                                result = nil
                                if player ~= -1 and distance <= 3.0 then
                                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', ('Police'), montant)
                                    TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                else
                                    ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                end
                            end
                        end
                    end
                end
            end
        end)
    end, function()
    end)

    demandeassistance:IsVisible(function(Items)
        Items:AddButton("Demande d'ambulance", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local raison = 'ambulance'
                local elements  = {}
                local playerPed = PlayerPedId()
                local coords  = GetEntityCoords(playerPed)
                local name = GetPlayerName(PlayerId())
                TriggerServerEvent('assistance', coords, raison)
            end
        end)
        Items:AddButton("Demande de vehicule rapide", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local raison = 'vehicule'
                local elements  = {}
                local playerPed = PlayerPedId()
                local coords  = GetEntityCoords(playerPed)
                local name = GetPlayerName(PlayerId())
                TriggerServerEvent('assistance', coords, raison)
            end
        end)
        Items:AddButton("Demande d'helicopter", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
            if (onSelected) then
                local raison = 'helicopter'
                local elements  = {}
                local playerPed = PlayerPedId()
                local coords  = GetEntityCoords(playerPed)
                local name = GetPlayerName(PlayerId())
                TriggerServerEvent('assistance', coords, raison)
            end
        end)
    end, function()
    end)
end

Keys.Register("F6", "F6", "Test", function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
        RageUI.Visible(MenuF6Ambulance, not RageUI.Visible(MenuF6Ambulance))
    end
end)

RegisterNetEvent('assistance:setBlip')
AddEventHandler('assistance:setBlip', function(coords, raison)
	if raison == 'ambulance' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowAdvancedNotification('INFORMATIONS EMS', '~b~Demande d\'assistance', 'Demande d\'assistance demandé.\nAssistance : ~g~AMBULANCE', 'CHAR_CALL911', 0)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		style = 67
		color = 2
	elseif raison == 'vehicule' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowAdvancedNotification('INFORMATIONS EMS', '~b~Demande d\'assistance', 'Demande d\'assistance demandé.\nAssistance : ~b~VEHICULE RAPIDE', 'CHAR_CALL911', 0)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		style = 56
		color = 3
	elseif raison == 'helicopter' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
		ESX.ShowAdvancedNotification('INFORMATIONS EMS', '~b~Demande d\'assistance', 'Demande d\'assistance demandé.\nAssistance : ~r~HELICOPTER', 'CHAR_CALL911', 0)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
		style = 43
		color = 1
	end
	local blipId = AddBlipForCoord(coords)
	SetBlipSprite(blipId, 161)
	SetBlipScale(blipId, 1.2)
	SetBlipColour(blipId, color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Demande renfort')
	EndTextCommandSetBlipName(blipId)

    local blipINFO = AddBlipForCoord(coords)
	SetBlipSprite(blipINFO, style)
	SetBlipScale(blipINFO, 0.8)
	SetBlipColour(blipINFO, color)


	Wait(40 * 1000)
	RemoveBlip(blipId)
	RemoveBlip(blipINFO)

end)


