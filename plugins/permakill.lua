PLUGIN.name = "Permakill"
PLUGIN.author = "Thadah Denyse"
PLUGIN.description = "Adds permanent death in the server options."

ix.config.Add("permakill", false, "Whether or not permakill is activated on the server.", nil, {
    category = "Permakill"
})

ix.config.Add("permakillWorld", false, "Whether or not world and self damage produce permanent death.", nil, {
    category = "Permakill"
})

local deathTimes = 0
local lastDeathTime = 0
local decreaseInterval = 3600

function PLUGIN:PlayerDeath(client, inflictor, attacker)
    local character = client:GetCharacter()

    if ix.config.Get("permakill") and character then
        if (hook.Run("ShouldPermakillCharacter", client, character, inflictor, attacker) == false) or ply:IsCombine() or deathTimes < 3 then return end
        if ix.config.Get("permakillWorld") and (client == attacker or inflictor:IsWorld()) then return end
        character:SetData("permakilled", true)
    end
end

function PLUGIN:DoPlayerDeath(ply, attacker, dmginfo)
    if (dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_BLAST) or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_BUCKSHOT)) and not ply:IsCombine() then
        deathTimes = deathTimes + 1
        print("[DEATHPERMA " .. deathTimes .. " ]")
        lastDeathTime = CurTime()

        timer.Create("DeathTimeDecrease", decreaseInterval, 0, function()
            for _, ply in ipairs(player.GetAll()) do
                if not ply:IsCombine() then
                    if CurTime() - lastDeathTime >= decreaseInterval then
                        deathTimes = math.max(deathTimes - 1, 0)
                    end
                end
            end
        end)
    end
end

function PLUGIN:PlayerSpawn(client)
    local character = client:GetCharacter()

    if not client:IsCombine() then
        if deathTimes == 1 then
            -- Add debuffs for the first death
            character:SetData("hunger", 65) -- Reduced hunger value (60 instead of 100)
        elseif deathTimes == 2 then
            -- Add debuffs for the second death
            character:SetData("hunger", 45) -- Further reduced hunger value (45 instead of 100)
            client:SetHealth(75) -- Reduced health value (75 instead of 100)
        end

        if ix.config.Get("permakill") and character and character:GetData("permakilled") then
            character:Ban()
            character:SetData("permakilled")
        end
    end
end