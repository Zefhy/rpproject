-- Register a network event 
RegisterNetEvent( 'wk:deleteVehicle' )

-- The distance to check in front of the player for a vehicle
-- Distance is in GTA units, which are quite big  
local distanceToCheck = 5.0

-- Add an event handler for the deleteVehicle event. 
-- Gets called when a user types in /dv in chat (see server.lua)
AddEventHandler( 'wk:deleteVehicle', function()
    local ped = GetPlayerPed( -1 )

        
        
    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 

        local vehicle = GetVehiclePedIsIn(ped, false)
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        local idn = VehToNet(vehicle)


        print(netId)
        print(idn)
        NetworkRequestControlOfEntity(vehicle)

        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetNetworkIdExistsOnAllMachines(idn, true)
        SetNetworkIdCanMigrate(idn, true)
        SetEntityAsMissionEntity(vehicle,true,true)
                

        local pos = GetEntityCoords( ped )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped ) then 
                SetEntityAsNoLongerNeeded(vehicle)
	            SetEntityAsMissionEntity(vehicle,true,true)
                DeleteEntity(netId)
                deleteCar( vehicle )

                if ( DoesEntityExist( vehicle ) ) then 
                	ShowNotification( "~r~Unable to delete vehicle, try again." )
                else 
                	ShowNotification( "Vehicle deleted." )
                end 
            else 
                ShowNotification( "You must be in the driver's seat!" )
            end 
        else
            local playerPos = GetEntityCoords( ped, 1 )
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( ped, 0.0, distanceToCheck, 0.0 )
            local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )

            if ( DoesEntityExist( vehicle ) ) then 
                SetEntityAsNoLongerNeeded(vehicle)
                SetEntityAsMissionEntity( vehicle, true, true )
                DeleteEntity(netId)
                deleteCar( vehicle )

                if ( DoesEntityExist( vehicle ) ) then 
                	ShowNotification( "~r~Unable to delete vehicle, try again." )
                else 
                	ShowNotification( "Vehicle deleted." )
                end 
            else 
                ShowNotification( "You must be in or near a vehicle to delete it." )
            end 
        end 
    end 
end )

-- Delete car function borrowed frtom Mr.Scammer's model blacklist, thanks to him!
function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

-- Gets a vehicle in a certain direction
-- Credit to Konijima
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetRaycastResult( rayHandle )
    return vehicle
end

-- Shows a notification on the player's screen 
function ShowNotification( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end