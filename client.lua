local Keys = {
    ["ESC"] = 322,    ["F1"] = 288,    ["F2"] = 289,    ["F3"] = 170,    ["F5"] = 166,    ["F6"] = 167,    ["F7"] = 168,    ["F8"] = 169,    ["F9"] = 56,    ["F10"] = 57,    ["~"] = 243,    ["1"] = 157,    ["2"] = 158,    ["3"] = 160,    ["4"] = 164,    ["5"] = 165,    ["6"] = 159,    ["7"] = 161,    ["8"] = 162,    ["9"] = 163,    ["-"] = 84,    ["="] = 83,    ["BACKSPACE"] = 177,    ["TAB"] = 37,    ["Q"] = 44,    ["W"] = 32,    ["E"] = 38,    ["R"] = 45,    ["T"] = 245,    ["Y"] = 246,    ["U"] = 303,    ["P"] = 199,    ["["] = 39,    ["]"] = 40,    ["ENTER"] = 18,    ["CAPS"] = 137,    ["A"] = 34,    ["S"] = 8,    ["D"] = 9,    ["F"] = 23,    ["G"] = 47,    ["H"] = 74,    ["K"] = 311,    ["L"] = 182,    ["LEFTSHIFT"] = 21,    ["Z"] = 20,    ["X"] = 73,    ["C"] = 26,    ["V"] = 0,    ["B"] = 29,    ["N"] = 249,    ["M"] = 244,    [","] = 82,     ["."] = 81,   ["LEFTCTRL"] = 36,    ["LEFTALT"] = 19,    ["SPACE"] = 22,    ["RIGHTCTRL"] = 70,    ["HOME"] = 213,    ["PAGEUP"] = 10,    ["PAGEDOWN"] = 11,    ["DELETE"] = 178,    ["LEFT"] = 174,    ["RIGHT"] = 175,    ["TOP"] = 27,    ["DOWN"] = 173,    ["NENTER"] = 201,    ["N4"] = 108,    ["N5"] = 60,    ["N6"] = 107,    ["N+"] = 96,    ["N-"] = 97,    ["N7"] = 117,    ["N8"] = 61,    ["N9"] = 118
}

ESX 				= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject",function(obj)
			ESX = obj
		end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('ferramentas_reparar:reparar')
AddEventHandler('ferramentas_reparar:reparar', function()
		
			if dentrodocarro() then
				exports['mythic_progbar']:Progress({
					name = "unique_action_name",
					duration = 3500,
					label = 'Unlocking Hood',
					useWhileDead = true,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
				})
				Citizen.CreateThread(function()
					while true do
						Wait(0)
							local xPlayer = GetPlayerPed(-1)
							local coords = GetEntityCoords(xPlayer)
							local veiculo = GetVehiclePedIsIn(xPlayer,false)	
							local pqp = GetClosestVehicle(coords.x , coords.y , coords.z, 3.0, 0 , 70)
							local coordscapo = GetWorldPositionOfEntityBone(pqp, GetEntityBoneIndexByName(pqp, "overheat"))
							local cenas = coordscapo
							if (GetDistanceBetweenCoords(coords, cenas.x, cenas.y, cenas.z, true) < 2.0) then
								DrawText3D(cenas.x, cenas.y, cenas.z, '~g~[E]~w~ Repair', 0.4)
									if (GetDistanceBetweenCoords(coords, cenas.x, cenas.y, cenas.z, true) < 1.5) then
										if IsControlJustReleased(0, Keys['E']) then
											abrecapo()
											break
										end
									end
							end		
					end
				end)
			else
				exports['mythic_notify']:SendAlert('error', 'You have to be in the car in the driver seat!')
			end
end)	

function dentrodocarro()
	local xPlayer = GetPlayerPed(-1)
	if IsPedInAnyVehicle(xPlayer, true) and GetPedInVehicleSeat(GetVehiclePedIsIn(xPlayer,false), -1) == xPlayer then
		return true
	else
		return false
	end
end

function abrecapo()
	local xPlayer = GetPlayerPed(-1)
	local coords = GetEntityCoords(xPlayer)
	local pqp = GetClosestVehicle(coords.x , coords.y , coords.z, 3.0, 0 , 70)
	local percentagem = math.random(100)
	ExecuteCommand("e cpr2")
	Wait(500)
	SetVehicleDoorOpen(pqp, 4, true ,true)
	ClearPedTasksImmediately(xPlayer)
	ExecuteCommand("e mecanico")
	Display(source, 'Repairing the ~g~ ENGINE ~w~...', 1.25)
	Wait(10000)
	if percentagem >= 30 then
		SetVehicleEngineHealth(pqp, 1000.0)
		exports['mythic_notify']:SendAlert('success', 'Engine Repaired!')
	else
		exports['mythic_notify']:SendAlert('error', 'Couldnt Repair!')
	end
	TriggerServerEvent('ferramentas_reparar:tirarkit')
	SetVehicleDoorShut(pqp, 4, true ,true)
	ClearPedTasksImmediately(xPlayer)
	
end

function Display(mePlayer, text, offset)
    local displaying = true
    Citizen.CreateThread(function()
        Wait(9700)
        displaying = false
    end)
    Citizen.CreateThread(function()
        while displaying do
            Wait(0)
            local ped = PlayerPedId()
            local pedcoord = GetEntityCoords(ped)
                DrawText3Ds(pedcoord['x'], pedcoord['y'], pedcoord['z'] , text)    
        end  
    end)
end

function DrawText3D(x, y, z, text, scale)
local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.001 + factor, 0.03, 5, 5, 5, 99)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.001 + factor, 0.03, 5, 5, 5, 99)
end