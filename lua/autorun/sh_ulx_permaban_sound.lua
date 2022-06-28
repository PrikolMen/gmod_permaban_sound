local addon_name = "Perma Ban Sound"

if (SERVER) then

    util.AddNetworkString( addon_name )

    if (ULib) then

        ULib.addBanOriginal = ULib.addBanOriginal or ULib.addBan

        local player_GetBySteamID = player.GetBySteamID
        local timer_Simple = timer.Simple
        local net_Start = net.Start
        local net_Send = net.Send
        local IsValid = IsValid
        local unpack = unpack

        function ULib.addBan( steamid, time, ... )
            if (time == 0) then
                local args = {...}
                local ply = player_GetBySteamID( steamid )
                if IsValid( ply ) then
                    net_Start( addon_name )
                    net_Send( ply )
                end

                timer_Simple( 10, function()
                    ULib.addBanOriginal( steamid, time, unpack( args ) )
                end)

                return
            end

            return ULib.addBanOriginal( steamid, time, ... )
        end

    end

end

if (CLIENT) then

    local function play( ch )
        if IsValid( ch ) then
            ch:Play()
        end
    end

    net.Receive(addon_name, function()
        if file.Exists( "sound/premaban/ebanyi_wafler.ogg", "GAME" ) then
            sound.PlayFile( "sound/premaban/ebanyi_wafler.ogg", "", play )
        else
            sound.PlayURL( "https://github.com/PrikolMen/gmod_permaban_sound/blob/main/sound/premaban/ebanyi_wafler.ogg?raw=true", "", play )
        end
    end)

end