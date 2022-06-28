local addon_name = "Perma Ban Sound"

if (SERVER) then

    util.AddNetworkString( addon_name )

    timer.Simple(0, function()
        if (ULib) then

            ULib.addBanOriginal = ULib.addBanOriginal or ULib.addBan

            local player_GetBySteamID = player.GetBySteamID
            local net_WriteEntity = net.WriteEntity
            local net_Broadcast = net.Broadcast
            local timer_Simple = timer.Simple
            local net_Start = net.Start
            local IsValid = IsValid
            local unpack = unpack

            function ULib.addBan( steamid, time, ... )
                if (time == 0) then
                    local args = {...}
                    local ply = player_GetBySteamID( steamid )
                    if IsValid( ply ) then
                        net_Start( addon_name )
                            net_WriteEntity( ply )
                        net_Broadcast()
                    end

                    timer_Simple( 10, function()
                        ULib.addBanOriginal( steamid, time, unpack( args ) )
                    end)

                    return
                end

                return ULib.addBanOriginal( steamid, time, ... )
            end

        end
    end)

end

if (CLIENT) then

    net.Receive(addon_name, function()

        local ply = net.ReadEntity()
        if IsValid( ply ) then
            local imBanned = ply:EntIndex() == LocalPlayer():EntIndex()

            local function play( ch )
                if IsValid( ch ) then
                    ch:Play()

                    if not (imBanned) then
                        local hook_name = addon_name .. " - " .. ply:SteamID()
                        timer.Simple( 10, function()
                            hook.Remove( "Think", hook_name )
                        end)

                        hook.Add("Think", hook_name, function()
                            if IsValid( ply ) then
                                ch:SetPos( ply:EyePos() )
                            end
                        end)
                    end
                end
            end

            if file.Exists( "sound/premaban/ebanyi_wafler.ogg", "GAME" ) then
                sound.PlayFile( "sound/premaban/ebanyi_wafler.ogg", imBanned and "" or "3d", play )
            else
                sound.PlayURL( "https://github.com/PrikolMen/gmod_permaban_sound/blob/main/sound/premaban/ebanyi_wafler.ogg?raw=true", imBanned and "" or "3d", play )
            end

        end
    end)

end