-----------------------------
--  ERROR420 DEVELOPMENTS  --
-----------------------------

Config = {}

Config.DebugPoly = true -- Displays Polyzone Locations

Config.Blips = {
    {title = 'Butchers', colour = 5, id = 310, coords = vector3(-73.59, 6267.08, 31.32), scale = 0.7, useblip = true}, -- Blip For Butchers
}

Config.CoreSettings = {
    Job = {
        Name = 'butcher', -- Name of job in qb-core/shared/jobs.lua
    },
    Target = {
        Type = 'qb', -- target script name support for qb-target & ox_target 
        -- Add Your Own Target Code In targets.lua
        -- Use 'qb' for qb-target
        -- Use 'ox' for ox_target
        -- Use 'custom' for custom target 
    },
    Inventory = {
        Type = 'qb', -- Support for qb-inventory & ox_inventory
        -- Use 'qb' for qb-inventory
        -- Use 'ox' for ox_inventory
    },
    Notify = {
        Type = 'qb', -- Notification type, support for qb-core notify, okokNotify & ox_lib notify
        -- Use 'ox' for ox_lib notify
        -- Use 'qb' for default qb-core notify
        -- Use 'okok' for okokNotify
    }, 
    Clothing = {
        Type = 'qb' -- Clothing type, support for qb-clothing & illenium-appearance
        -- Use 'qb' for qb-clothing
        -- Use 'illenium' for illenium-appearance
        -- Use 'custom' for your own clothing script - edit the following event: 'Error420_Butcher:client:changeClothes' & add your own methods
    },
    Timers = {
        Pick = 5000, -- Time to pick chicken
        Pluck = 10000, -- Time to pluck chicken
        Process = 10000, -- Time to process chicken
        Pack = 10000, -- Time to pack chicken
    },
}

Config.InteractionLocations = {
    -- Name must be unique, size is for ox_target only, job must match job in core & in Cofig.CoreSettings.Job.Name
    JobAreas = {
        { name = 'butcherduty',                 coords = vector3(-70.16, 6256.38, 31.2),    size =  vec3(0.5,0.5,0.5), width = 0.5, height = 0.5, heading = 31.0,   minz = 31.0, maxz = 31.5, icon = 'fa-solid fa-clipboard',         label = 'Toggle Duty',               event = 'Error420_Butcher:client:ToggleDuty',           job = 'butcher', distance = 1.5, },
        { name = 'butcherclothing',             coords = vector3(-75.64, 6250.66, 31.09),   size =  vec3(5.0,1.0,2.0), width = 1.0, height = 5.0, heading = 120.14, minz = 30.0, maxz = 32.0, icon = 'fa-solid fa-shirt',             label = 'Change Clothing',           event = 'Error420_Butcher:client:changeClothes',        job = 'butcher', distance = 1.5, },
        { name = 'butcherpickchicken',          coords = vector3(-69.06, 6249.45, 30.92),   size =  vec3(2.0,2.0,2.0), width = 2.0, height = 2.0, heading = 300.27, minz = 30.0, maxz = 32.0, icon = 'fa-solid fa-h&-point-up',       label = 'Pick Fresh Chicken',        event = 'Error420_Butcher:client:PickChicken',          job = 'butcher', distance = 1.5, },
        { name = 'butcherpluckchicken',         coords = vector3(-89.33, 6234.58, 31.33),   size =  vec3(3.0,1.5,1.0), width = 1.5, height = 3.0, heading = 120.0,  minz = 30.0, maxz = 32.0, icon = 'fa-solid fa-h&-point-up',       label = 'Pluck Fresh Chicken',       event = 'Error420_Butcher:client:PluckChicken',         job = 'butcher', distance = 1.5, },
        { name = 'butcherpreparechicken',       coords = vector3(-79.03, 6228.83, 31.08),   size =  vec3(2.5,2.0,1.0), width = 2.5, height = 2.0, heading = 123.13, minz = 30.0, maxz = 32.0, icon = 'fa-solid fa-h&-point-up',       label = 'Process Plucked Chicken',   event = 'Error420_Butcher:client:ProcessChicken',       job = 'butcher', distance = 1.5, },
        { name = 'butcherprocesschicken',       coords = vector3(-99.79, 6210.99, 31.03),   size =  vec3(2.5,2.0,1.0), width = 2.5, height = 2.0, heading = 43.63,  minz = 30.0, maxz = 32.0, icon = 'fa-solid fa-h&-point-up',       label = 'Prepare Processed Chicken', event = 'Error420_Butcher:client:ProcessChickenMenu',   job = 'butcher', distance = 1.5, },
        { name = 'butcherpackchicken',          coords = vector3(-103.98, 6206.8, 31.03),   size =  vec3(2.5,2.0,1.0), width = 2.5, height = 2.0, heading = 43.63,  minz = 30.0, maxz = 32.0, icon = 'fa-solid fa-h&-point-up',       label = 'Pack Chicken Products',     event = 'Error420_Butcher:client:PackChickenMenu',      job = 'butcher', distance = 1.5, },
    },
}

Config.Selling = {
    CashSymbol = '$',
    Location = vector4(-111.69, 6195.82, 30.03, 310.19),
    PedModel =  's_m_y_factory_01', -- Name of ped model
    Items = { -- Is sell price for each unit of that particular item
        ChickenBreast =      { Price = 14,},
        ChickenThighs =      { Price = 10,},
        ChickenWings =       { Price = 8,},
        ChickenDrumsticks =  { Price = 8,},
        ChickenLegs =        { Price = 5,},
    },
}

Config.Animations = {
    PickChicken = {
        dict = "mini@repair",
        anim = "fixing_a_player",
    },
    PluckChicken = {
        dict = "mini@repair",
        anim = "fixing_a_player",
    },
    ProcessChicken = {
        dict = "amb@prop_human_bbq@male@idle_a",
        anim = "idle_b",
    },
    PackChicken = {
        dict = "mini@repair",
        anim = "fixing_a_player",
    },
}