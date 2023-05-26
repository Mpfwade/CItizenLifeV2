local PLUGIN = PLUGIN
PLUGIN.name = "Dying too many times"
PLUGIN.author = "ChatGPT"
PLUGIN.description = "Kicks you if you die way too many times in a few mins."


local deaths = {}


hook.Add("PlayerDeath", "TrackPlayerDeaths", function(victim, inflictor, attacker)
    local ply = victim
    local steamID = ply:SteamID()

    -- If the player is not already in the deaths table, add them
    if not deaths[steamID] then
        deaths[steamID] = {
            count = 1,
            lastDeathTime = CurTime()
        }
    else
        -- If the player has died within the last 2 minutes, increment their death count
        if CurTime() - deaths[steamID].lastDeathTime <= 120 then
            deaths[steamID].count = deaths[steamID].count + 1

            -- If the player has died 5 times within 2 minutes, kick them
            if deaths[steamID].count >= 5 then
                ply:Kick("You have died too many times within 2 minutes.")
            end
        else
            -- If the player has not died within the last 2 minutes, reset their death count and time
            deaths[steamID].count = 1
            deaths[steamID].lastDeathTime = CurTime()
        end
    end
end)
