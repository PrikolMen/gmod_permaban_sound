--
local addon_name = "Perma Ban Sound"

if (SERVER) then

    util.AddNetworkString( addon_name )
    -- ULib.addBan( steamid, time, reason, name, admin )
    if (ULib) then
        ULib.addBanOriginal = ULib.addBanOriginal or ULib.addBan

        function ULib.addBan( steamid, ... )
            local ply = player.GetBySteamID( steamid )
            if IsValid( ply ) then
                net.Start( addon_name )
                net.Send( ply )
            end

            timer.Simple( 10, function()
                ULib.addBanOriginal( steamid, ... )
            end)
        end

    end
    -- hook.Add("ULibPlayerBanned", addon_name, function( steamid, ban_data )
    --     -- print( steamid, ban_data )
    --     if istable( ban_data ) then
    --         -- PrintTable( ban_data )
    --     end
    -- end)
end

if (CLIENT) then

    local function play( ch )
        if IsValid( ch ) then
            ch:Play()
        end
    end

    net.Receive(addon_name, function()
        if file.Exists( "", "GAME" ) then
            sound.PlayFile( "", "", play )
        else
            sound.PlayURL( "", "", play )
        end
    end)

end