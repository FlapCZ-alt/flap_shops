--------------------------------------------------
------------- JOIN OUR DISCORD SERVER ------------
--------- https://discord.gg/7gbCD9Fzct ----------
--------------------------------------------------
--------------- DEVELOPED BY FLAP ----------------
-------------------- WITH 💜 ---------------------
--------------------------------------------------

ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('onResourceStart', function(resourceName)

	if resourceName == GetCurrentResourceName() then

		while FLAP_SHOPS == nil do
			Wait(10)
		end

		print('^6[flap_shops] ^2resource flap_shops successfully loaded ^6[developed by Flap]^7 ^6[our discord - discord.gg/7gbCD9Fzct ]^0')
	end

end)

ESX.RegisterServerCallback('flap_shops:getConfigData', function(source, cb) 

	while FLAP_SHOPS == nil do
		Wait(10)
	end

	cb(FLAP_SHOPS)

end)

RegisterServerEvent('flap_shops:buyItems')
AddEventHandler('flap_shops:buyItems', function(item, DataPrice, count)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local price = DataPrice * count

	if xPlayer.canCarryItem(item, count) then
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, count)
			TriggerClientEvent("flap_shops:succesedBuy", source, item, price)
		else
			TriggerClientEvent("flap_shops:MoneyError", source, item, price)
		end
	else
		TriggerClientEvent("flap_shops:WeightError", source, item, price)
	end

end)

RegisterServerEvent('flap_shops:sellItems')
AddEventHandler('flap_shops:sellItems', function(item, DataPrice, count, count2)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local price = DataPrice * count

	local itemName = xPlayer.getInventoryItem(item)

	if itemName.count < count2 then
		TriggerClientEvent("flap_shops:ItemCountError", source, item, price, count)
		return
	end

	xPlayer.removeInventoryItem(item, count)
	xPlayer.addAccountMoney('money', price)
	TriggerClientEvent("flap_shops:succesedSell", source, item, price, count)

end)