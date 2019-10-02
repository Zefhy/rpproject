-- Script Created By: MrDaGree
-- If you wish to use this, dont claim it as your own.
-- This is a client.lua script. This must be ran BY the client.

local showPlayerBlips = false
local ignorePlayerNameDistance = false
local disPlayerNames = 5
local playerSource = 0

local enInstancia = false

function DrawText3D(x,y,z, text, r,g,b,a) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, a)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do
        
        for id = 0, 256 do
            if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
                ped = GetPlayerPed( id )
 
                   if enInstancia == false then
                        x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                        x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                        distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

                        
                        if(ignorePlayerNameDistance) then
                            DrawText3D(x2, y2, z2+1, GetPlayerServerId(id))
                            -- For just the player's source id use this or use the line above for name and source id | DrawText3D(x2, y2, z2+1, GetPlayerServerId(id))
                        end

                        if ((distance < disPlayerNames)) then
                            if not (ignorePlayerNameDistance) then

                                if NetworkIsPlayerTalking(id) then
                                    DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 41, 128, 185, 255)

                                elseif not NetworkIsPlayerTalking(id) then
                                    DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 185, 185, 185, 255)
                                end
                            end
                        end  
                    end
                   -- print("Callback Results: " .. results.type)
            else
                N_0x31698aa80e0223f8(id)
            end
        end
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        TriggerEvent("instance:get", function(results)
            --print(json.encode(results))
            if results.type == nil then
                enInstancia = false
            else
                enInstancia = true
            end     
        end)  
    end
end)