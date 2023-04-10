--------------------------------------------------
------------- JOIN OUR DISCORD SERVER ------------
--------- https://discord.gg/7gbCD9Fzct ----------
--------------------------------------------------
--------------- DEVELOPED BY FLAP ----------------
-------------------- WITH 💜 ---------------------
--------------------------------------------------

ESX                 = exports["es_extended"]:getSharedObject()
sConfig             = nil
local PlayerData    = {}
local near          = false
local inMenu        = false

CreateThread(function()

    print('^6[flap_shops] ^2resource flap_shops successfully loaded ^6[developed by Flap]^7 ^6[our discord - discord.gg/7gbCD9Fzct ]^0')

    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end

    while sConfig == nil do
        Wait(150)
        ESX.TriggerServerCallback('flap_shops:getConfigData', function(config)
            sConfig = config
        end)
        Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
	loadShopNPCs()
	loadShopBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	loadShopBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

------------------------------------------------------
---------- MARKER AND NEAR MARKER SECTION ------------
------------------------------------------------------

CreateThread(function()
    while true do
        if sConfig ~= nil then
            Wait(700)

            if nearMarker() then
                near = true
            else
                near = false
            end
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(5)

        if near then
            for k,v in pairs(sConfig) do
                if v.GENERAL_SETTINGS.ENABLE_SHOPS then
                    if PlayerData.job ~= nil then
                        local playerPed      = PlayerPedId()
                        local coords         = GetEntityCoords(playerPed)

                        for i=1, #v.INTERACTION_SETTINGS.SHOPS, 1 do
                            if #(coords - v.INTERACTION_SETTINGS.SHOPS[i].coords) < v.GENERAL_SETTINGS.FLOATING_TEXT_DISTANCE then

								if v.ACCESS_SETTINGS.ENABLE_JOB then
									if PlayerData.job.name == v.ACCESS_SETTINGS.ENABLE_JOB_NAME and v.ACCESS_SETTINGS.ENABLE_JOB_NAME_GRADE[PlayerData.job.grade_name] then
										if inMenu ~= true then
											floatNotif(v.GENERAL_SETTINGS.NOTIFY_TEXT, v.INTERACTION_SETTINGS.SHOPS[i].coords.x, v.INTERACTION_SETTINGS.SHOPS[i].coords.y, v.INTERACTION_SETTINGS.SHOPS[i].coords.z + 1.8)
										end
																			
										if IsControlJustReleased(0, 38) then
											openMainMenu()
											loadCamera(v.INTERACTION_SETTINGS.SHOPS[i].camX, v.INTERACTION_SETTINGS.SHOPS[i].camY, v.INTERACTION_SETTINGS.SHOPS[i].camZ, v.INTERACTION_SETTINGS.SHOPS[i].CamRotateX, v.INTERACTION_SETTINGS.SHOPS[i].CamRotateY, v.INTERACTION_SETTINGS.SHOPS[i].CamRotateZ, v.INTERACTION_SETTINGS.SHOPS[i].PlayerX, v.INTERACTION_SETTINGS.SHOPS[i].PlayerY, v.INTERACTION_SETTINGS.SHOPS[i].PlayerZ, v.INTERACTION_SETTINGS.SHOPS[i].PlayerHeading, playerPed)
											inMenu = true
										end
									else
										Wait(500)
									end
								else
									if inMenu ~= true then
										floatNotif(v.GENERAL_SETTINGS.NOTIFY_TEXT, v.INTERACTION_SETTINGS.SHOPS[i].coords.x, v.INTERACTION_SETTINGS.SHOPS[i].coords.y, v.INTERACTION_SETTINGS.SHOPS[i].coords.z + 1.8)
									end
									
                                    if IsControlJustReleased(0, 38) then
										openMainMenu()
										loadCamera(v.INTERACTION_SETTINGS.SHOPS[i].camX, v.INTERACTION_SETTINGS.SHOPS[i].camY, v.INTERACTION_SETTINGS.SHOPS[i].camZ, v.INTERACTION_SETTINGS.SHOPS[i].CamRotateX, v.INTERACTION_SETTINGS.SHOPS[i].CamRotateY, v.INTERACTION_SETTINGS.SHOPS[i].CamRotateZ, v.INTERACTION_SETTINGS.SHOPS[i].PlayerX, v.INTERACTION_SETTINGS.SHOPS[i].PlayerY, v.INTERACTION_SETTINGS.SHOPS[i].PlayerZ, v.INTERACTION_SETTINGS.SHOPS[i].PlayerHeading, playerPed)
										inMenu = true
                                    end
								end


                            end
                        end


                    end
				else
					Wait(500)
                end
            end
        else
            Wait(500)
        end
    end
end)

------------------------------------------------------
---------------- FUNCTIONS SECTION -------------------
------------------------------------------------------

function floatNotif(msg, x, y, z)
    AddTextEntry('flap_shops', msg)
    SetFloatingHelpTextWorldPosition(1, x, y, z)
    SetFloatingHelpTextStyle(1, 1, 25, -1, 3, 0)
    BeginTextCommandDisplayHelp('flap_shops')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function nearMarker()
    local playerPed      = PlayerPedId()
    local coords         = GetEntityCoords(playerPed)

    for k,v in pairs(sConfig) do
        if v.GENERAL_SETTINGS.ENABLE_SHOPS then

			if v.ACCESS_SETTINGS.ENABLE_JOB then

				if PlayerData.job.name == v.ACCESS_SETTINGS.ENABLE_JOB_NAME and v.ACCESS_SETTINGS.ENABLE_JOB_NAME_GRADE[PlayerData.job.grade_name] then
					for i=1, #v.INTERACTION_SETTINGS.SHOPS, 1 do
						local shop_distance = #(coords - v.INTERACTION_SETTINGS.SHOPS[i].coords)
						if shop_distance <= 3 then
							return true
						end
					end
				end

			else

				for i=1, #v.INTERACTION_SETTINGS.SHOPS, 1 do
					local shop_distance = #(coords - v.INTERACTION_SETTINGS.SHOPS[i].coords)
					if shop_distance <= 3 then
						return true
					end
				end

			end

        end
    end
end

function loadShopNPCs()
	for k,v in pairs(sConfig) do
		for i=1, #v.INTERACTION_SETTINGS.SHOPS, 1 do
			RequestModel(v.INTERACTION_SETTINGS.SHOPS[i].model)

			while not HasModelLoaded(v.INTERACTION_SETTINGS.SHOPS[i].model) do
				Wait(1)
			end

			local shopNPC = CreatePed(4, v.INTERACTION_SETTINGS.SHOPS[i].model, v.INTERACTION_SETTINGS.SHOPS[i].coords.x, v.INTERACTION_SETTINGS.SHOPS[i].coords.y, v.INTERACTION_SETTINGS.SHOPS[i].coords.z, v.INTERACTION_SETTINGS.SHOPS[i].heading, false, true)

			FreezeEntityPosition(shopNPC, true)	
			SetEntityHeading(shopNPC, v.INTERACTION_SETTINGS.SHOPS[i].heading)
			SetEntityInvincible(shopNPC, true)
			SetBlockingOfNonTemporaryEvents(shopNPC, true)
			RequestAnimDict(v.INTERACTION_SETTINGS.SHOPS[i].animDict)
			while not HasAnimDictLoaded(v.INTERACTION_SETTINGS.SHOPS[i].animDict) do
				Citizen.Wait(1000)
			end

			Citizen.Wait(200)	
			TaskPlayAnim(shopNPC, v.INTERACTION_SETTINGS.SHOPS[i].animDict, v.INTERACTION_SETTINGS.SHOPS[i].animName, 2.0, 2.0, -1, v.INTERACTION_SETTINGS.SHOPS[i].flag, 0.0, false, false, false)
		end
	end
end

function loadShopBlips()
	for k,v in pairs(sConfig) do
		for i=1, #v.INTERACTION_SETTINGS.SHOPS, 1 do

			if v.BLIPS_SETTINGS.TURN_ON_BLIPS then

				if v.ACCESS_SETTINGS.ENABLE_JOB then
					if PlayerData.job.name == v.ACCESS_SETTINGS.ENABLE_JOB_NAME and v.ACCESS_SETTINGS.ENABLE_JOB_NAME_GRADE[PlayerData.job.grade_name] then
						local blip = AddBlipForCoord(v.INTERACTION_SETTINGS.SHOPS[i].coords)
						SetBlipSprite (blip, v.BLIPS_SETTINGS.SPRITE)
						SetBlipDisplay(blip, v.BLIPS_SETTINGS.DISPLAY)
						SetBlipScale  (blip, v.BLIPS_SETTINGS.SCALE)
						SetBlipColour (blip, v.BLIPS_SETTINGS.COLOR)
						SetBlipAsShortRange(blip, true)
		
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(v.BLIPS_SETTINGS.NAME)
						EndTextCommandSetBlipName(blip)
					end
				else
					local blip = AddBlipForCoord(v.INTERACTION_SETTINGS.SHOPS[i].coords)
					SetBlipSprite (blip, v.BLIPS_SETTINGS.SPRITE)
					SetBlipDisplay(blip, v.BLIPS_SETTINGS.DISPLAY)
					SetBlipScale  (blip, v.BLIPS_SETTINGS.SCALE)
					SetBlipColour (blip, v.BLIPS_SETTINGS.COLOR)
					SetBlipAsShortRange(blip, true)
	
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(v.BLIPS_SETTINGS.NAME)
					EndTextCommandSetBlipName(blip)
				end
			end

		end
	end
end


----------

function openMainMenu()
	SendNUIMessage({
		flap_mainMenu = true
	})
    SetNuiFocus(true, true)
end

function closeNUI()
	SendNUIMessage({
		flap_mainMenu = false
	})
    SetNuiFocus(false, false)

	DeleteSkinCam()
	inMenu = false
end

function SuccCloseBuyMenu(item, price)
	SendNUIMessage({
		flap_SuccCloseBuyMenu = true,
		item = item,
		price = price
	})

	PlayAnim()
	
end

function SuccCloseSellMenu(item, price, count)
	SendNUIMessage({
		flap_SuccCloseSellMenu = true,
		item = item,
		price = price,
		count = count
	})

	PlayAnim()
	
end

function ErrorItemCountSell(item, price, count)
	SendNUIMessage({
		flap_itemCountError = true,
		item = item,
		price = price,
		count = count
	})
end

function WeiErrCloseBuyMenu(item, price)
	SendNUIMessage({
		flap_WeigErrorCloseBuyMenu = true,
		item = item,
		price = price
	})
end

function MoneyErrCloseBuyMenu(item, price)
	SendNUIMessage({
		flap_MoneyErrorCloseBuyMenu = true,
		item = item,
		price = price
	})
end



------------------------------------------------------
------------------------------------------------------
----------------- SFM - Development ------------------
------------------------------------------------------
-------------------- NUI CALLBACKS -------------------
------------------------------------------------------
------------------ Developed by Flap -----------------
------------------------------------------------------
------------------------------------------------------ 



RegisterNetEvent('flap_shops:succesedBuy')
AddEventHandler('flap_shops:succesedBuy', function(item, price)
	SuccCloseBuyMenu(item, price)
end)

RegisterNetEvent('flap_shops:WeightError')
AddEventHandler('flap_shops:WeightError', function(item, price)
	WeiErrCloseBuyMenu(item, price)
end)

RegisterNetEvent('flap_shops:MoneyError')
AddEventHandler('flap_shops:MoneyError', function(item, price)
	MoneyErrCloseBuyMenu(item, price)
end)

RegisterNetEvent('flap_shops:succesedSell')
AddEventHandler('flap_shops:succesedSell', function(item, price, count)
	SuccCloseSellMenu(item, price, count)
end)

RegisterNetEvent('flap_shops:ItemCountError')
AddEventHandler('flap_shops:ItemCountError', function(item, price, count)

	ErrorItemCountSell(item, price, count)

end)

RegisterNUICallback('close', function(data, cb)
	closeNUI()
end)

RegisterNUICallback('GetShopItems', function(data, cb)

	for k,v in pairs(sConfig) do
		for i=1, #v.ITEMS_SETTINGS.BUY_ITEMS, 1 do

			local ShopItems = v.ITEMS_SETTINGS.BUY_ITEMS

			SendNUIMessage({
				item = ShopItems[i].item,
				label = ShopItems[i].label,
				price = ShopItems[i].price,
				usable = ShopItems[i].usable,
				header = ShopItems[i].header,
				description = ShopItems[i].description
			})

		end
	end
	
end)

RegisterNUICallback('GetSellItems', function(data, cb)

	for k,v in pairs(sConfig) do
		for i=1, #v.ITEMS_SETTINGS.SELL_ITEMS, 1 do

			local ShopItems = v.ITEMS_SETTINGS.SELL_ITEMS

			SendNUIMessage({
				item = ShopItems[i].item,
				label = ShopItems[i].label,
				earn = ShopItems[i].earn,
				header = ShopItems[i].header,
				description = ShopItems[i].description
			})
		end
	end
	
end)

RegisterNUICallback('Notification', function(data, cb)
    ESX.ShowNotification(data.text)
end)

RegisterNUICallback('buyItems', function(data, cb)
	TriggerServerEvent("flap_shops:buyItems", data.item, data.price, data.count)
end)

RegisterNUICallback('sellItems', function(data, cb)
	TriggerServerEvent("flap_shops:sellItems", data.item, data.earn, data.count, tonumber(data.count))
end)


------------------------------------------------------
------------------------------------------------------
----------------- SFM - Development ------------------
------------------------------------------------------
-------------------- SCRIPTED CAM --------------------
------------------------------------------------------
------------------ Developed by Flap -----------------
------------------------------------------------------
------------------------------------------------------ 

function PlayAnim()
	local ped      = PlayerPedId()

	RequestAnimDict("mp_arresting")
	while not HasAnimDictLoaded("mp_arresting") do
		Citizen.Wait(1000)
	end
		
	TaskPlayAnim(ped,"mp_arresting","a_uncuff",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)

	local pCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, 0.0)
	local modelSpawn = CreateObject(GetHashKey("prop_cs_cardbox_01"), pCoords.x, pCoords.y, pCoords.z, true, true, true)
	local netid = ObjToNet(modelSpawn)
	prop_net = netid

	Wait(500)
	AttachEntityToEntity(modelSpawn, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)

	Wait(2500)
	ClearPedTasks(ped)
	DetachEntity(NetToObj(prop_net), 1, 1)
    DeleteEntity(NetToObj(prop_net))
    prop_net = nil

end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end

function loadCamera(CamX, CamY, CamZ, CamRotateX, CamRotateY, CamRotateZ, PlayerX, PlayerY, PlayerZ, PlayerHeading, ped)

	DoScreenFadeOut(400)
	Wait(400)

	SetEntityCoords(ped, PlayerX, PlayerY, PlayerZ, false, false, false, true)
	SetEntityHeading(ped, PlayerHeading)
	cam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", vector3(CamX, CamY, CamZ), CamRotateX, CamRotateY, CamRotateZ, 80.0, false, false)
    SetCamActive(cam, true)
	RenderScriptCams(true)
	DoScreenFadeIn(400)

end

RegisterCommand("odbug", function()
	closeNUI()
end)
