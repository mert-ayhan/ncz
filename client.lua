ESX = nil

local nczZones = {}
local isPlayerInNCZ = false
local NCZName = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    for _, location in pairs(locations) do
        if location.enable == true then
			table.insert(nczZones, {name = location.data.options.name, zone = PolyZone:Create(location.data.points, location.data.options)})
        end
    end
end)


Citizen.CreateThread(function()
	while true do
		for _, zone in pairs(nczZones) do
			if zone.zone:isPointInside(GetEntityCoords(PlayerPedId())) then
				isPlayerInNCZ, NCZName = true, zone.name
				goto skip
			end
		end
		isPlayerInNCZ = false
		::skip::
		Citizen.Wait(500)
	end
end)


exports('isPlayerInNCZ', function()
	return { isPlayerInNCZ, NCZName }
end)