ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterUsableItem('ferramentas', function(source)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local kits = xPlayer.getInventoryItem('ferramentas').count
	if kits >= 1 then
		TriggerClientEvent('ferramentas_reparar:reparar', _source)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Não tens Kits de Reparação!'})
	end
end)

RegisterServerEvent('ferramentas_reparar:tirarkit') 
AddEventHandler('ferramentas_reparar:tirarkit', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local kits = xPlayer.getInventoryItem('ferramentas').count
	if kits >= 1 then
		xPlayer.removeInventoryItem('ferramentas', 1)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Não tens Kits de Reparação!'})
	end
	
end)
