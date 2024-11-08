---------------------- Locals ----------------------
local QBCore = exports['qb-core']:GetCoreObject()

local NotifyType = Config.CoreSettings.Notify.Type
local TargetType = Config.CoreSettings.Target.Type
local InvType = Config.CoreSettings.Inventory.Type
local ClothingType = Config.CoreSettings.Clothing.Type
local onDuty, busy = true, false

PlayerJob = {}

---------------------- Notification Function ----------------------
local function SendNotify(msg,type,time,title)
    if NotifyType == nil then print("Error420_Butcher: NotifyType Not Set!") return end
    if not title then title = "Butcher" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then print("Error420_Butcher: Notification Sent With No Message.") return end
    if NotifyType == 'ox' then
        lib.notify({ title = title, description = msg, type = type, duration = time})
    elseif NotifyType == 'qb' then
        QBCore.Functions.Notify(msg, type, time)
    elseif NotifyType == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, true)
    end
end

---------------------- Blip Thread ----------------------
CreateThread(function()
    for k, v in pairs(Config.Blips) do
        if v.useblip then
            v.blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
            SetBlipSprite(v.blip, v.id)
            SetBlipDisplay(v.blip, 4)
            SetBlipScale(v.blip, v.scale)
            SetBlipColour(v.blip, v.colour)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.title)
            EndTextCommandSetBlipName(v.blip)
        end
    end
end)

---------------------- Selling Ped Thread ----------------------
CreateThread(function()
    lib.requestModel(Config.Selling.PedModel, 5000)
    butcherPed = CreatePed(0, Config.Selling.PedModel, Config.Selling.Location.x, Config.Selling.Location.y, Config.Selling.Location.z, false, false)
    SetEntityHeading(butcherPed, Config.Selling.Location.w)
    FreezeEntityPosition(butcherPed, true)
    SetEntityInvincible(butcherPed, true)
    SetBlockingOfNonTemporaryEvents(butcherPed, true)
    TaskStartScenarioInPlace(butcherPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    if TargetType == 'qb' then
        exports['qb-target']:AddTargetEntity(butcherPed, {  options = { { icon = 'fa-solid fa-bars', label = 'Sell Chicken Products', event = 'Error420_Butcher:client:SellChickenMenu', job = Config.CoreSettings.Job.Name,} }, distance = 1.0, })
    elseif TargetType == 'ox' then
        exports.ox_target:addLocalEntity(butcherPed, { { name = 'butcherPed', icon = 'fa-solid fa-bars', label = 'Sell Chicken Products', event = 'Error420_Butcher:client:SellChickenMenu', groups = Config.CoreSettings.Job.Name, distance = 1.0} })
    end
end)

---------------------- Picking Chicken ----------------------
RegisterNetEvent('Error420_Butcher:client:PickChicken', function()
    local playerPed = PlayerPedId()
    if onDuty then
        if busy then
            SendNotify("You are already doing something.", 'error', 2000)
        else
            if IsEntityAttached(chickenPed) then
                SendNotify("You have a chicken already.", 'error', 2000)
            else
                busy = true
                LockInventory(true)
                if lib.progressCircle({ 
                    duration = Config.CoreSettings.Timers.Pick, 
                    label = 'Picking chicken...',
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    disable = { car = true, move = true, },
                    anim = { dict = Config.Animations.PickChicken.dict, clip = Config.Animations.PickChicken.anim,},
                }) then
                    local playerCoords = GetEntityCoords(playerPed)
                    local chickenModel = 'a_c_hen'
                    lib.requestModel(chickenModel, 5000)         
                    chickenPed = CreatePed(0, chickenModel, playerCoords.x, playerCoords.y, playerCoords.z, 0, true, true)
                    AttachEntityToEntity(chickenPed, playerPed, GetPedBoneIndex(playerPed, 57005), 0.12, 0.0, 0.0, 0.0, 255.0, 30.0, true, true, false, true, 1, true)
                    local dict = 'move_weapon@jerrycan@generic'
                    local anim = 'idle'
                    RequestAnimDict(dict)
                    while not HasAnimDictLoaded(dict) do
                        Wait(1000)
                    end
                    TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 1.0, 51, 11, 0, 0, 0)
                    busy = false
                    LockInventory(false)
                    SendNotify("You picked a chicken, now go and pluck it.", 'success', 2000) 
                else 
                    busy = false
                    LockInventory(false)
                    ClearPedTasks(playerPed)
                    SendNotify('Action cancelled.', 'error', 2000)
                end
            end
        end
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

---------------------- Pluck Chicken ----------------------
RegisterNetEvent('Error420_Butcher:client:PluckChicken', function()
    if onDuty then
        if busy then
            SendNotify("You are already doing something.", 'error', 2000)
        else
            if IsEntityAttached(chickenPed) then
                local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                if success then
                    busy = true
                    LockInventory(true)
                    if lib.progressCircle({ 
                        duration = Config.CoreSettings.Timers.Pluck, 
                        label = 'Plucking chicken...',
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = { car = true, move = true, },
                        anim = { dict = Config.Animations.PluckChicken.dict, clip = Config.Animations.PluckChicken.anim},
                    }) then
                        busy = false
                        LockInventory(false)
                        DeleteEntity(chickenPed)
                        TriggerServerEvent('Error420_Butcher:server:PluckChicken')
                        SendNotify("You plucked a chicken now go process it.", 'success', 2000)
                    else 
                        busy = false
                        LockInventory(false)
                        SendNotify('Action cancelled.', 'error', 2000)
                    end
                else
                    SendNotify("Action failed.", 'error', 2000)
                end
            else
                SendNotify("You dont have a chicken.", 'error', 2000)
            end
        end
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

---------------------- Process Chicken ----------------------
RegisterNetEvent('Error420_Butcher:client:ProcessChicken', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:PluckedChicken', function(HasItems)
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({
                            duration = Config.CoreSettings.Timers.Process, 
                            label = 'Processing chicken...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.ProcessChicken.dict, clip = Config.Animations.ProcessChicken.anim},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:ProcessChicken')
                            SendNotify("You processed a chicken.", 'success', 2000)
                        else 
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing a plucked chicken.", 'error', 2000)
            end
        end) 
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

RegisterNetEvent('Error420_Butcher:client:ProcessChickenBreast', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ProcessedChicken', function(HasItems) 
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Process, 
                            label = 'Processing chicken...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.ProcessChicken.dict, clip = Config.Animations.ProcessChicken.anim},
                            prop = { model = 'v_ind_cfknife', bone = 57005, pos = vec3(0.2, 0.14, -0.01), rot = vec3(1.0, 4.0, 57.0)},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:ProcessChickenBreast')
                            SendNotify("You processed a chicken into breasts.", 'success', 2000)
                        else 
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end)
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

RegisterNetEvent('Error420_Butcher:client:ProcessChickenThighs', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ProcessedChicken', function(HasItems)  
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Process, 
                            label = 'Processing chicken...', 
                            position = 'bottom', 
                            useWhileDead = false, 
                            canCancel = true, 
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.ProcessChicken.dict, clip = Config.Animations.ProcessChicken.anim},
                            prop = { model = 'v_ind_cfknife', bone = 57005, pos = vec3(0.2, 0.14, -0.01), rot = vec3(1.0, 4.0, 57.0)},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:ProcessChickenThighs')
                            SendNotify("You processed a chicken into thighs.", 'success', 2000)
                        else
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end)
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

RegisterNetEvent('Error420_Butcher:client:ProcessChickenWings', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ProcessedChicken', function(HasItems) 
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Process, 
                            label = 'Processing chicken...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { car = true, move = true },
                            anim = { dict = Config.Animations.ProcessChicken.dict, clip = Config.Animations.ProcessChicken.anim},
                            prop = { model = 'v_ind_cfknife', bone = 57005, pos = vec3(0.2, 0.14, -0.01), rot = vec3(1.0, 4.0, 57.0)},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:ProcessChickenWings')
                            SendNotify("You processed a chicken into wings.", 'success', 2000)
                        else
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end)
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

RegisterNetEvent('Error420_Butcher:client:ProcessChickenDrumSticks', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ProcessedChicken', function(HasItems)  
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Process, 
                            label = 'Processing chicken...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.ProcessChicken.dict, clip = Config.Animations.ProcessChicken.anim},
                            prop = { model = 'v_ind_cfknife', bone = 57005, pos = vec3(0.2, 0.14, -0.01), rot = vec3(1.0, 4.0, 57.0)},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:ProcessChickenDrumSticks')
                            SendNotify("You processed a chicken into drum sticks.", 'success', 2000)
                        else
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end)
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

RegisterNetEvent('Error420_Butcher:client:ProcessChickenLegs', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ProcessedChicken', function(HasItems)  
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true) 
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Process,
                            label = 'Processing chicken...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.ProcessChicken.dict, clip = Config.Animations.ProcessChicken.anim},
                            prop = { model = 'v_ind_cfknife', bone = 57005, pos = vec3(0.2, 0.14, -0.01), rot = vec3(1.0, 4.0, 57.0)},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:ProcessChickenLegs')
                            SendNotify("You processed a chicken into legs.", 'success', 2000)
                        else
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end)
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

---------------------- Pack Chicken ----------------------
RegisterNetEvent('Error420_Butcher:client:PackChickenBreast', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ChickenBreast', function(HasItems) 
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Pack,
                            label = 'Packing chicken...',
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = { car = true, move = true },
                            anim = { dict = Config.Animations.PackChicken.dict, clip = Config.Animations.PackChicken.anim},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:PackChickenBreast')
                            SendNotify("You packed chicken breast.", 'success', 2000)
                        else 
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end) 
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

RegisterNetEvent('Error420_Butcher:client:PackChickenThighs', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ChickenThighs', function(HasItems)  
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Pack, 
                            label = 'Packing chicken...', 
                            position = 'bottom', 
                            useWhileDead = false, 
                            canCancel = true, 
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.PackChicken.dict, clip = Config.Animations.PackChicken.anim,},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:PackChickenThighs')
                            SendNotify("You packed chicken thighs.", 'success', 2000)
                        else 
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end) 
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end   
end)

RegisterNetEvent('Error420_Butcher:client:PackChickenWings', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ChickenWings', function(HasItems)  
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Pack, 
                            label = 'Packing chicken...', 
                            position = 'bottom', 
                            useWhileDead = false, 
                            canCancel = true, 
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.PackChicken.dict, clip = Config.Animations.PackChicken.anim,},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:PackChickenWings')
                            SendNotify("You packed chicken wings.", 'success', 2000)
                        else 
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end) 
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end    
end)

RegisterNetEvent('Error420_Butcher:client:PackChickenDrumSticks', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ChickenDrumsticks', function(HasItems)  
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Pack, 
                            label = 'Packing chicken...', 
                            position = 'bottom', 
                            useWhileDead = false, 
                            canCancel = true, 
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.PackChicken.dict, clip = Config.Animations.PackChicken.anim,},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:PackChickenDrumSticks')
                            SendNotify("You packed chicken drum sticks.", 'success', 2000)
                        else 
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end) 
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end  
end)

RegisterNetEvent('Error420_Butcher:client:PackChickenLegs', function()
    if onDuty then
        QBCore.Functions.TriggerCallback('Error420_Butcher:get:ChickenLegs', function(HasItems)  
            if HasItems then
                if busy then
                    SendNotify("You are already doing something.", 'error', 2000)
                else
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                    if success then
                        busy = true
                        LockInventory(true)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.Pack, 
                            label = 'Packing chicken...', 
                            position = 'bottom', 
                            useWhileDead = false, 
                            canCancel = true, 
                            disable = { car = true, move = true, },
                            anim = { dict = Config.Animations.PackChicken.dict, clip = Config.Animations.PackChicken.anim,},
                        }) then
                            busy = false
                            LockInventory(false)
                            TriggerServerEvent('Error420_Butcher:server:PackChickenLegs')
                            SendNotify("You packed chicken legs.", 'success', 2000)
                        else 
                            busy = false
                            LockInventory(false)
                            SendNotify('Action cancelled.', 'error', 2000)
                        end
                    else
                        SendNotify("Action failed.", 'error', 2000)
                    end
                end
            else
                SendNotify("You are missing items.", 'error', 2000)
            end
        end) 
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end   
end)

---------------------- Giving Items ----------------------
RegisterNetEvent('Error420_Butcher:client:GiveItems', function()
    if onDuty then
        local input = lib.inputDialog('Butcher Supplies', {
            {type = 'number', label = 'Food Packaging', description = 'How much do you need?', icon = 'arrow-right'},
            })
        if input then
            TriggerServerEvent('Error420_Butcher:server:GiveItems', 2, tonumber(input[1]))
        end
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

---------------------- Display Image Function ----------------------
function ItemImage(img)
	if InvType == 'ox' then
		return "nui://ox_inventory/web/images/".. img.. '.png'
	elseif InvType == 'qb' then
		return "nui://qb-inventory/html/images/".. QBCore.Shared.Items[img].image
	end
end

---------------------- Exlpoit Prevention ----------------------
function LockInventory(toggle)
	if toggle then
        LocalPlayer.state:set("inv_busy", true, true) -- qb, ps and ox
    else
        LocalPlayer.state:set("inv_busy", false, true) -- qb, ps and ox
    end
end

---------------------- Sell Packaged Chicken ----------------------
RegisterNetEvent('Error420_Butcher:client:SellItems', function(args)
    local args = tonumber(args)
    if onDuty then
        if busy then
            SendNotify("You Are Already Doing Something!", 'error', 2000)
        else
            busy = true
            LockInventory(true)
            if args == 1 then
                TriggerServerEvent('Error420_Butcher:server:SellItems', 1)
                LockInventory(false)
                busy = false
            elseif args == 2 then
                TriggerServerEvent('Error420_Butcher:server:SellItems', 2)
                LockInventory(false)
                busy = false
            elseif args == 3 then
                TriggerServerEvent('Error420_Butcher:server:SellItems', 3)
                LockInventory(false)
                busy = false
            elseif args == 4 then
                TriggerServerEvent('Error420_Butcher:server:SellItems', 4)
                LockInventory(false)
                busy = false
            elseif args == 5 then
                TriggerServerEvent('Error420_Butcher:server:SellItems', 5)
                LockInventory(false)
                busy = false
            end
            LockInventory(false)
        end
    else
        SendNotify("You must be on duty to proceed.", 'error', 2000)
    end
end)

---------------------- Management ----------------------
RegisterNetEvent("Error420_Butcher:client:ToggleDuty", function()
    TriggerServerEvent("QBCore:ToggleDuty")
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then
            if PlayerJob.type == Config.CoreSettings.Job.Name then
                TriggerServerEvent("QBCore:ToggleDuty")
            end
        end
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('Error420_Butcher:client:changeClothes', function()
    if ClothingType == 'qb' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif ClothingType == 'illenium' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif ClothingType == 'custom' then
        -- Insert Your Own Code
    end
end)

---------------------- DO NOT TOUCH ----------------------
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        busy = false
        if TargetType == 'qb' then exports['qb-target']:RemoveTargetEntity(butcherPed, 'butcherPed') elseif TargetType == 'ox' then exports.ox_target:removeLocalEntity(butcherPed, 'butcherPed') end
        DeletePed(butcherPed)
        for k, v in pairs(Config.InteractionLocations.JobAreas) do if TargetType == 'qb' then exports['qb-target']:RemoveZone(v.name) elseif TargetType == 'ox' then exports.ox_target:removeZone(v.name) end end
        if IsEntityAttached(chickenPed) then
            DeletePed(chickenPed)
        end
    end
end)