lib.registerContext({
    id = 'ProcessMenuButcher',
    title = 'Cluckin\' Bell Butchers',
    options = {
      {
        title = 'Get A Butchers Knife',
        onSelect = function()
            TriggerServerEvent('Error420_Butcher:server:GiveItems', 1)
        end,
        icon = ItemImage('butcherknife'),
        image = ItemImage('butcherknife'),
        arrow = true,
      },
      {
        title = 'Process Chicken Breast',
        event = 'Error420_Butcher:client:ProcessChickenBreast',
        icon = ItemImage('chickenbreast'),
        image = ItemImage('chickenbreast'),
        arrow = true,
      },
      {
        title = 'Process Chicken Thighs',
        icon = ItemImage('chickenthighs'),
        image = ItemImage('chickenthighs'),
        event = 'Error420_Butcher:client:ProcessChickenThighs',
        arrow = true,
      },
      {
        title = 'Process Chicken Wings',
        icon = ItemImage('chickenwings'),
        image = ItemImage('chickenwings'),
        event = 'Error420_Butcher:client:ProcessChickenWings',
        arrow = true,
      },
      {
        title = 'Process Chicken Drumsticks',
        icon = ItemImage('chickendrumsticks'),
        image = ItemImage('chickendrumsticks'),
        event = 'Error420_Butcher:client:ProcessChickenDrumSticks',
        arrow = true,
      },
      {
        title = 'Process Chicken Legs',
        icon = ItemImage('chickenlegs'),
        image = ItemImage('chickenlegs'),
        event = 'Error420_Butcher:client:ProcessChickenLegs',
        arrow = true,
      }
    }
})

lib.registerContext({
    id = 'PackMenuButcher',
    title = 'Cluckin\' Bell Butchers',
    options = {
      {
        title = 'Get Food Packaging',
        icon = ItemImage('foodpackaging'),
        image = ItemImage('foodpackaging'),
        event = 'Error420_Butcher:client:GiveItems',
        arrow = true,
      },
      {
        title = 'Pack Chicken Breast',
        icon = ItemImage('chickenbreastpack'),
        image = ItemImage('chickenbreastpack'),
        event = 'Error420_Butcher:client:PackChickenBreast',
        arrow = true,
      },
      {
        title = 'Pack Chicken Thighs',
        icon = ItemImage('chickenthighspack'),
        image = ItemImage('chickenthighspack'),
        event = 'Error420_Butcher:client:PackChickenThighs',
        arrow = true,
      },
      {
        title = 'Pack Chicken Wings',
        icon = ItemImage('chickenwingspack'),
        image = ItemImage('chickenwingspack'),
        event = 'Error420_Butcher:client:PackChickenWings',
        arrow = true,
      },
      {
        title = 'Pack Chicken Drumsticks',
        icon = ItemImage('chickendrumstickspack'),
        image = ItemImage('chickendrumstickspack'),
        event = 'Error420_Butcher:client:PackChickenDrumSticks',
        arrow = true,
      },
      {
        title = 'Pack Chicken Legs',
        icon = ItemImage('chickenlegspack'),
        image = ItemImage('chickenlegspack'),
        event = 'Error420_Butcher:client:PackChickenLegs',
        arrow = true,
      }
    }
})


local cashSymbol = Config.Selling.CashSymbol

lib.registerContext({
    id = 'SellMenuButcher',
    title = 'Butcher Sales',
    options = {
      {
        title = 'Sell Chicken Breast Pack',
        description = cashSymbol..Config.Selling.Items.ChickenBreast.Price..' each',
        icon = ItemImage('chickenbreastpack'),
        image = ItemImage('chickenbreastpack'),
        event = 'Error420_Butcher:client:SellItems',
        args = 1,
        arrow = true,
      },
      {
        title = 'Sell Chicken Thighs Pack',
        description = cashSymbol..Config.Selling.Items.ChickenThighs.Price..' each',
        icon = ItemImage('chickenthighspack'),
        image = ItemImage('chickenthighspack'),
        event = 'Error420_Butcher:client:SellItems',
        args = 2,
        arrow = true,
      },
      {
        title = 'Sell Chicken Wings Pack',
        description = cashSymbol..Config.Selling.Items.ChickenWings.Price..' each',
        icon = ItemImage('chickenwingspack'),
        image = ItemImage('chickenwingspack'),
        event = 'Error420_Butcher:client:SellItems',
        args = 3,
        arrow = true,
      },
      {
        title = 'Sell Chicken Drumsticks Pack',
        description = cashSymbol..Config.Selling.Items.ChickenDrumsticks.Price..' each',
        icon = ItemImage('chickendrumstickspack'),
        image = ItemImage('chickendrumstickspack'),
        event = 'Error420_Butcher:client:SellItems',
        args = 4,
        arrow = true,
      },
      {
        title = 'Sell Chicken Legs Pack',
        description = cashSymbol..Config.Selling.Items.ChickenLegs.Price..' each',
        icon = ItemImage('chickenlegspack'),
        image = ItemImage('chickenlegspack'),
        event = 'Error420_Butcher:client:SellItems',
        args = 5,
        arrow = true,
      }
    }
})

RegisterNetEvent('Error420_Butcher:client:ProcessChickenMenu', function()
    lib.showContext('ProcessMenuButcher')
end)

RegisterNetEvent('Error420_Butcher:client:PackChickenMenu', function()
    lib.showContext('PackMenuButcher')
end)

RegisterNetEvent('Error420_Butcher:client:SellChickenMenu', function()
    lib.showContext('SellMenuButcher')
end)