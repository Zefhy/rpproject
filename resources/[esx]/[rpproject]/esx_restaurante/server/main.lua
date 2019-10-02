ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'restaurante', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'restaurante', 'Restaurante', 'society_restaurante', 'society_restaurante', 'society_restaurante', {type = 'public'})

RegisterServerEvent('esx_restaurantejob:taser')
AddEventHandler('esx_restaurantejob:taser', function(work, weapon)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if work == 'security_outfit' then

        xPlayer.addWeapon(weapon, 1)
    else
        xPlayer.removeWeapon(weapon)
    end
end)


RegisterServerEvent('esx_restaurantejob:getStockItem')
AddEventHandler('esx_restaurantejob:getStockItem', function(itemName, count)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante', function(inventory)

		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('you_removed') .. count .. ' ' .. item.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_society'))
		end
	end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_restaurantejob:putStockItems')
AddEventHandler('esx_restaurantejob:putStockItems', function(itemName, count)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante', function(inventory)

		local item = inventory.getItem(itemName)
		local playerItemCount = xPlayer.getInventoryItem(itemName).count

		if item.count >= 0 and count <= playerItemCount then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

	end)

end)


RegisterServerEvent('esx_restaurantejob:getFridgeStockItem')
AddEventHandler('esx_restaurantejob:getFridgeStockItem', function(itemName, count)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante_fridge', function(inventory)

		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('you_removed') .. count .. ' ' .. item.label)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_society'))
		end
	end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_restaurantejob:putFridgeStockItems')
AddEventHandler('esx_restaurantejob:putFridgeStockItems', function(itemName, count)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_restaurante_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_restaurantejob:buyItem')
AddEventHandler('esx_restaurantejob:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local limit = xPlayer.getInventoryItem(itemName).limit
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_restaurante', function(account)
        societyAccount = account
      end)
    
    if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < limit then
            societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
        else
            TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
        end
    else
        TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
    end

end)

RegisterServerEvent('esx_restaurantejob:craftingCoktails')
AddEventHandler('esx_restaurantejob:craftingCoktails', function(itemValue)

    local _source = source
    local _itemValue = itemValue
 -- TriggerClientEvent('esx_restaurantejob:timer', _source)
   -- TriggerClientEvent('esx:showNotification', _source, _U('assembling_cocktail'))

    if _itemValue == 'jagerbomb' then
        SetTimeout(1, function()
            local xPlayer           = ESX.GetPlayerFromId(_source)
            local alephQuantity     = xPlayer.getInventoryItem('energy').count
            local bethQuantity      = xPlayer.getInventoryItem('jager').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('energy') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jager') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('jager', 2)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('jagerbomb') .. ' ~w~!')
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('jager', 2)
                    xPlayer.addInventoryItem('jagerbomb', 1)
                end
            end

        end)
    end

    if _itemValue == 'golem' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('limonade').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('golem') .. ' ~w~!')
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('golem', 1)
                end
            end

        end)
    end
    
    if _itemValue == 'whiskycoca' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)
            local alephQuantity     = xPlayer.getInventoryItem('cocacola').count
            local bethQuantity      = xPlayer.getInventoryItem('whisky').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('cocacola') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('cocacola', 1)
                    xPlayer.removeInventoryItem('whisky', 1)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('whiskycoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('cocacola', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                    xPlayer.addInventoryItem('whiskycoca', 1)
                end
            end

        end)
    end

    if _itemValue == 'rhumcoca' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('cocacola').count
            local bethQuantity      = xPlayer.getInventoryItem('rhum').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('cocacola') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('cocacola', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('rhumcoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('cocacola', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.addInventoryItem('rhumcoca', 1)
                end
            end

        end)
    end

    if _itemValue == 'vodkaenergy' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('energy').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('energy') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('vodkaenergy') .. ' ~w~!')
                    xPlayer.removeInventoryItem('energy', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('vodkaenergy', 1)
                end
            end

        end)
    end

    if _itemValue == 'vodkafruit' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jusfruit').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('vodkafruit') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('vodkafruit', 1) 
                end
            end

        end)
    end

    if _itemValue == 'rhumfruit' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jusfruit').count
            local bethQuantity      = xPlayer.getInventoryItem('rhum').count
            local gimelQuantity     = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jusfruit') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
            elseif gimelQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('rhumfruit') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jusfruit', 2)
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('rhumfruit', 1)
                end
            end

        end)
    end

    if _itemValue == 'teqpaf' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('limonade').count
            local bethQuantity      = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('teqpaf') .. ' ~w~!')
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.addInventoryItem('teqpaf', 1)
                end
            end

        end)
    end

    if _itemValue == 'mojito' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('rhum').count
            local bethQuantity      = xPlayer.getInventoryItem('limonade').count
            local gimelQuantity     = xPlayer.getInventoryItem('menthe').count
            local daletQuantity      = xPlayer.getInventoryItem('ice').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('rhum') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('limonade') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('menthe') .. '~w~')
            elseif daletQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('menthe', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('mojito') .. ' ~w~!')
                    xPlayer.removeInventoryItem('rhum', 2)
                    xPlayer.removeInventoryItem('limonade', 2)
                    xPlayer.removeInventoryItem('menthe', 2)
                    xPlayer.removeInventoryItem('ice', 1)
                    xPlayer.addInventoryItem('mojito', 1)
                end
            end

        end)
    end


    if _itemValue == 'metreshooter' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jager').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('whisky').count
            local daletQuantity     = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jager') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('whisky') .. '~w~')
            elseif daletQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('jager', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('metreshooter') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jager', 2)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('whisky', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.addInventoryItem('metreshooter', 1)
                end
            end

        end)
    end

    if _itemValue == 'jagercerbere' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('jagerbomb').count
            local bethQuantity      = xPlayer.getInventoryItem('vodka').count
            local gimelQuantity     = xPlayer.getInventoryItem('tequila').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('jagerbomb') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('vodka') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tequila') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('jagerbomb', 1)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('jagercerbere') .. ' ~w~!')
                    xPlayer.removeInventoryItem('jagerbomb', 1)
                    xPlayer.removeInventoryItem('vodka', 2)
                    xPlayer.removeInventoryItem('tequila', 2)
                    xPlayer.addInventoryItem('jagercerbere', 1)
                end
            end

        end)
    end
    if _itemValue == 'fernetcoca' then
        SetTimeout(1, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('cocacola').count
            local bethQuantity      = xPlayer.getInventoryItem('ice').count
            local gimelQuantity     = xPlayer.getInventoryItem('fernet').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('cocacola') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('ice') .. '~w~')
            elseif gimelQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('fernet') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_cocktail'))
                    xPlayer.removeInventoryItem('cocacola', 1)
                    xPlayer.removeInventoryItem('ice', 2)
                    xPlayer.removeInventoryItem('fernet', 2)
                else
                    TriggerClientEvent('esx_restaurante:sirviendo', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_cocktail') .. _U('fernetcoca') .. ' ~w~!')
                    xPlayer.removeInventoryItem('cocacola', 1)
                    xPlayer.removeInventoryItem('ice', 2)
                    xPlayer.removeInventoryItem('fernet', 2)
                    xPlayer.addInventoryItem('fernetcoca', 1)
                end
            end

        end)
    end

end)

RegisterServerEvent('esx_restaurantejob:craftingFood')
AddEventHandler('esx_restaurantejob:craftingFood', function(itemValue)

    local _source = source
    local _itemValue = itemValue

    if _itemValue == 'pizza' then
        SetTimeout(25000, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('tomate').count
            local bethQuantity      = xPlayer.getInventoryItem('harina').count
            local thirdQuantity     = xPlayer.getInventoryItem('levadura').count
            local fourthQuantity    = xPlayer.getInventoryItem('mozarella').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tomate') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('harina') .. '~w~')
            elseif thirdQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('levadura') .. '~w~')
            elseif fourthQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('mozarella') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_food'))
                    xPlayer.removeInventoryItem('tomate', 2)
                    xPlayer.removeInventoryItem('harina', 2)
                    xPlayer.removeInventoryItem('levadura', 2)
                    xPlayer.removeInventoryItem('mozarella', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_food') .. _U('pizza') .. ' ~w~!')
                    xPlayer.removeInventoryItem('tomate', 2)
                    xPlayer.removeInventoryItem('harina', 2)
                    xPlayer.removeInventoryItem('levadura', 2)
                    xPlayer.removeInventoryItem('mozarella', 2)
                    xPlayer.addInventoryItem('pizza', 1)
                end
            end

        end)
    end



    if _itemValue == 'lasagna' then
        SetTimeout(25000, function()

            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('tomate').count
            local bethQuantity      = xPlayer.getInventoryItem('harina').count
            local thirdQuantity     = xPlayer.getInventoryItem('picada').count
            local fourthQuantity    = xPlayer.getInventoryItem('acelga').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('tomate') .. '~w~')
            elseif bethQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('harina') .. '~w~')
            elseif thirdQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('picada') .. '~w~')
            elseif fourthQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('not_enough') .. _U('acelga') .. '~w~')
            else
                local chanceToMiss = math.random(100)
                if chanceToMiss <= Config.MissCraft then
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_miss_food'))
                    xPlayer.removeInventoryItem('tomate', 2)
                    xPlayer.removeInventoryItem('harina', 2)
                    xPlayer.removeInventoryItem('picada', 2)
                    xPlayer.removeInventoryItem('acelga', 2)
                else
                    TriggerClientEvent('esx:showNotification', _source, _U('craft_food') .. _U('lasagna') .. ' ~w~!')
                    xPlayer.removeInventoryItem('tomate', 2)
                    xPlayer.removeInventoryItem('harina', 2)
                    xPlayer.removeInventoryItem('picada', 2)
                    xPlayer.removeInventoryItem('acelga', 2)
                    xPlayer.addInventoryItem('lasagna', 1)
                end
            end

        end)
    end

end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('fernetcoca', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('fernetcoca', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_fernet'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('limonade', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('limonade', 1)
        TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
        TriggerClientEvent('esx:showNotification', source, _U('used_limonade'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('energy', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('energy', 1)
        TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
        TriggerClientEvent('esx:showNotification', source, _U('used_energy'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('jusfruit', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('jusfruit', 1)
        TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
        TriggerClientEvent('esx:showNotification', source, _U('used_jusfruit'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('golem', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('golem', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_golem'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)

ESX.RegisterUsableItem('jagercerbere', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('jagercerbere', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_jagercerbere'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)

ESX.RegisterUsableItem('mojito', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('mojito', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_mojito'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)

ESX.RegisterUsableItem('vodkaenergy', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('vodkaenergy', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_vodkaenergy'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)
ESX.RegisterUsableItem('vodkafruit', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('vodkafruit', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_vodkafruit'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)
ESX.RegisterUsableItem('jagerbomb', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('jagerbomb', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_jagerbomb'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)

ESX.RegisterUsableItem('metreshooter', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('metreshooter', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_metreshooter'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)
ESX.RegisterUsableItem('rhumcoca', function(source)
    SetTimeout(4000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('rhumcoca', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_rhumcoca'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)
ESX.RegisterUsableItem('whiskycoca', function(source)
    SetTimeout(3500, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('whiskycoca', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_whiskycoca'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)


ESX.RegisterUsableItem('rhumfruit', function(source)
    SetTimeout(3500, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('rhumfruit', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_rhumfruit'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)
end)

ESX.RegisterUsableItem('rhum', function(source)
    SetTimeout(3500, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('rhum', 1)
        TriggerClientEvent('esx_restaurante:drunk', source)
        TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
        TriggerClientEvent('esx:showNotification', source, _U('used_rhum'))
    end)
    TriggerClientEvent('esx_restaurante:tomando', source)

end)




ESX.RegisterUsableItem('pizza', function(source)
    SetTimeout(30000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('pizza', 1)
        TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
        TriggerClientEvent('esx:showNotification', source, _U('used_pizza'))
    end)
    TriggerClientEvent('esx_restaurante:comiendo', source, "v_res_tt_pizzaplate")

end)
ESX.RegisterUsableItem('lasagna', function(source)
    SetTimeout(30000, function()
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('lasagna', 1)
        TriggerClientEvent('esx_status:add', source, 'hunger', 1000000)
        TriggerClientEvent('esx:showNotification', source, _U('used_lasagna'))
    end)
    TriggerClientEvent('esx_restaurante:comiendo', source, "prop_cs_plate_01")

end)

ESX.RegisterServerCallback('esx_restaurantejob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_restaurante', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:addVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_restaurante', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:removeVaultWeapon', function(source, cb, weaponName)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_restaurante', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_restaurantejob:getPlayerInventory', function(source, cb)

  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)

RegisterServerEvent('esx_restaurante:confiscatePlayerItem')
AddEventHandler('esx_restaurante:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)


	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)


RegisterServerEvent('esx_restaurante:handcuff')
AddEventHandler('esx_restaurante:handcuff', function(target)
	TriggerClientEvent('esx_restaurante:handcuff', target)
end)

RegisterServerEvent('esx_restaurante:drag')
AddEventHandler('esx_restaurante:drag', function(target)
	TriggerClientEvent('esx_restaurante:drag', target, source)
end)

RegisterServerEvent('esx_restaurante:message')
AddEventHandler('esx_restaurante:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)


ESX.RegisterServerCallback('esx_restaurante:getOtherPlayerData', function(source, cb, target)
	if Config.EnableESXIdentity then
		local xPlayer = ESX.GetPlayerFromId(target)
		local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})

		local firstname = result[1].firstname
		local lastname  = result[1].lastname
		local sex       = result[1].sex
		local dob       = result[1].dateofbirth
		local height    = result[1].height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			weapons   = xPlayer.loadout,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status ~= nil then
				data.drunk = math.floor(status.percent)
			end
		end)

		if Config.EnableLicenses then
			TriggerEvent('esx_license:getLicenses', target, function(licenses)
				data.licenses = licenses
				cb(data)
			end)
		else
			cb(data)
		end
    else
		local xPlayer = ESX.GetPlayerFromId(target)

		local data = {
			name       = GetPlayerName(target),
			job        = xPlayer.job,
			inventory  = xPlayer.inventory,
			accounts   = xPlayer.accounts,
			weapons    = xPlayer.loadout
		}

		TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
			if status then
				data.drunk = math.floor(status.percent)
			end
		end)

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
		end)

		cb(data)
	end
end)