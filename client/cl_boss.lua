ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)

local societyambulancemoney = nil
FoltoneBoss = {}

function RefreshambulanceMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyambulanceMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietyambulanceMoney(money)
    societyambulancemoney = ESX.Math.GroupDigits(money)
end

function UpdateListEmploiee(society)
    FoltoneBoss.ListEmploiee = {}
    ESX.TriggerServerCallback('esx_ambulancejob:getEmployees', function(employees)
        for i=1, #employees, 1 do
            table.insert(FoltoneBoss.ListEmploiee,  employees[i])
        end
    end, society)
end

function UpdateListGrades(society)
    FoltoneBoss.JobList = {}
    ESX.TriggerServerCallback('esx_society:getJob', function(job)
        for i=1, #job.grades, 1 do
            local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)
            table.insert(FoltoneBoss.JobList, job.grades[i])
        end
    end, society)
end


function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local MenuBoss = RageUI.CreateMenu("Boss", 'menu boss');
local listeemployes = RageUI.CreateSubMenu(MenuBoss, "Liste employés", 'menu boss')
local gestionemployes = RageUI.CreateSubMenu(listeemployes, "Gestion employés", 'menu boss')

local gestionsalaires = RageUI.CreateSubMenu(MenuBoss, "Gestion salaires", 'menu boss')

function RageUI.PoolMenus:Boss()
    MenuBoss:IsVisible(function(Items)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' then
            if societyambulancemoney ~= nil then
                Items:AddSeparator("Argent société : ~g~"..societyambulancemoney.."$", nil, {}, true, function()
                end)
            end
            Items:AddButton("Déposer argent de société", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        ESX.ShowNotification("Montant invalide")
                    else
                        TriggerServerEvent('esx_society:depositMoney', 'ambulance', amount)
                        RefreshambulanceMoney()
                    end
                end
            end)
            Items:AddButton("Retirer argent de société", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        ESX.ShowNotification("Montant invalide")
                    else
                        TriggerServerEvent('esx_society:withdrawMoney', 'ambulance', amount)
                        RefreshambulanceMoney()
                    end
                end
            end)
            Items:AddButton("Gestion des employés", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    UpdateListEmploiee('ambulance')
                    filterstring = ""
                end
            end, listeemployes)
            Items:AddButton("Gestion des salaires", nil, {RightLabel = ">", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    UpdateListGrades('ambulance')
                end
            end, gestionsalaires)
        end
    end, function(Panels)
    end)
    
    listeemployes:IsVisible(function(Items)
        for i=1, #FoltoneBoss.ListEmploiee do
            local ply = FoltoneBoss.ListEmploiee[i]
            if filterstring == nil or string.find(ply.name, filterstring) or string.find(ply.job.grade_label, filterstring) then
                Items:AddButton(ply.name, nil, {RightLabel = "~g~"..ply.job.grade_label.."~s~ →", IsDisabled = false }, function(onSelected)
                    if (onSelected) then
                        UpdateListGrades('ambulance')
                        SelectedEmployee = ply
                    end
                end, gestionemployes)
            end
        end

	end, function()
	end)
    gestionemployes:IsVisible(function(Items)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' then
            for i=1, #FoltoneBoss.JobList, 1 do
                local jb = FoltoneBoss.JobList[i]
                if SelectedEmployee.job.grade ~= jb.grade then
                    Items:AddButton(jb.label, nil, {RightLabel = "~g~Choisir~s~ →", IsDisabled = false }, function(onSelected)
                        if (onSelected) then
                            ESX.TriggerServerCallback('esx_ambulancejob:setJob', function(data)
                                if data ~= false then
                                    SelectedEmployee.job.grade = jb.grade
                                end
                            end, SelectedEmployee.identifier, 'ambulance', jb.grade)
                        end
                    end)
                else
                    Items:AddButton(jb.label, nil, {RightLabel = "~g~Choisir~s~ →", IsDisabled = false }, function(onSelected)
                    end)
                end
            end
            Items:AddButton("Virrer", nil, {RightLabel = "~g~Choisir~s~ →", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    ESX.TriggerServerCallback('esx_ambulancejob:setJob', function()
                        RageUI.GoBack()
                    end, SelectedEmployee.identifier, 'unemployed', 0)
                end
            end)
        end
    end, function()
	end)


    gestionsalaires:IsVisible(function(Items)
        for i=1, #FoltoneBoss.JobList, 1 do
            local jb = FoltoneBoss.JobList[i]
            Items:AddButton("Salaire : "..jb.label, nil, {RightLabel = "~g~"..jb.salary.."$", IsDisabled = false }, function(onSelected)
                if (onSelected) then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = ESX.Math.Round(tonumber(amount))
                    if amount >= 0 then
                        ESX.TriggerServerCallback('esx_society:setJobSalary', function()
                            SetTimeout(100, function()
                            UpdateListGrades('ambulance')
                            end)
                        end, 'ambulance', jb.grade, amount)
                    else
                        ESX.ShowNotification("Montant invalide")
                    end
                end
            end)
        end
    end, function()
    end)
end

Citizen.CreateThread(function()
	while true do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' then
            wait = 500
            local playerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(ConfigAmbulanceJob.Boss) do
                local distanceboss = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
                if distanceboss <= 5.0 then
                    wait = 0
                    DrawMarker(6, v.x, v.y, v.z-1, 0.0, 0.0, 9.0, 0.0, 0.0, 0.0, 0.5, 1.0, 0.5, 114, 204, 114, 250, false, false, 2, false, false, false, false)
                end
                if distanceboss <= 1.0 then
                    wait = 0
                    ESX.ShowHelpNotification("Appuyer sur ~g~[E]~s~ pour acceder au ~g~actions patron", 1) 
                    if IsControlJustPressed(1, 51) then
                        RefreshambulanceMoney()
                        RageUI.Visible(MenuBoss, not RageUI.Visible(MenuBoss))
                    end
                end
            end
        end
        Citizen.Wait(wait)
	end
end)
