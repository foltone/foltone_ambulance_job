ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

all_items = {}

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end     
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

local MenuCoffre = RageUI.CreateMenu("Coffre", 'menu coffre');
local deposer = RageUI.CreateSubMenu(MenuCoffre, "Déposer", 'menu coffre')
local retirer = RageUI.CreateSubMenu(MenuCoffre, "Retirer", 'menu coffre')

    function RageUI.PoolMenus:Coffre()
        MenuCoffre:IsVisible(function(Items)
            Items:AddButton("Déposer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    getInventory()
                end
            end, deposer)
            Items:AddButton("Retirer", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    getStock()
                end
            end, retirer)
        end, function(Panels)
        end)

    deposer:IsVisible(function(Items)
        for k,v in pairs(all_items) do
            Items:AddButton(v.label, nil, {RightLabel = v.nb, IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                    count = tonumber(count)
                    TriggerServerEvent("ambulance:putStockItems",v.item, count)
                    getInventory()
                end
            end)
        end
    end, function()
    end)

    retirer:IsVisible(function(Items)
        for k,v in pairs(all_items) do
            Items:AddButton(v.label, nil, {RightLabel = v.nb, IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    local count = KeyboardInput("Combien voulez vous en déposer",nil,4)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("ambulance:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStock()
                end
            end)
        end
    end, function()
    end)
end

Citizen.CreateThread(function()
	while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
            wait = 500
            local playerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(ConfigAmbulanceJob.Coffre) do
                local distancevestiaire = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
                if distancevestiaire <= 5.0 then
                    wait = 0
                    DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 114, 204, 114, 250, false, false, 2, false, false, false, false)
                end
                if distancevestiaire <= 1.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour acceder au ~g~coffre", 1) 
                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(MenuCoffre, not RageUI.Visible(MenuCoffre))
                    end
                end
            end
        end
        Citizen.Wait(wait)
	end
end)

function getInventory()
    ESX.TriggerServerCallback('ambulance:playerinventory', function(inventory)                   
        all_items = inventory
    end)
end

function getStock()
    ESX.TriggerServerCallback('ambulance:getStockItems', function(inventory)               
                
        all_items = inventory
        
    end)
end