if SERVER then
    local deathTimes = 0
    local lastDeathTime = 0
    local decreaseInterval = 3600 -- Decrease deathTimes every 1 hour (adjust the interval as needed)

    hook.Add("DoPlayerDeath", "PERMADEATH", function(ply, attacker, dmg)
        if dmg:IsDamageType(DMG_BULLET + DMG_BLAST + DMG_CLUB + DMG_BUCKSHOT) and not ply:IsAttacker() or ply:IsCombine() then
            deathTimes = deathTimes + 1
            lastDeathTime = CurTime()
        end
    end)

    hook.Add("PlayerLoadout", "PERMADEATH", function(ply)
        if not ply:IsCombine() then
            if deathTimes == 1 then
                -- Add debuffs for the first death
                char:SetData("hunger", 65) -- Reduced hunger value (60 instead of 100)
            elseif deathTimes == 2 then
                -- Add debuffs for the second death
                char:SetData("hunger", 45) -- Further reduced hunger value (45 instead of 100)
                char:SetData("health", 75) -- Reduced health value (75 instead of 100)
            elseif deathTimes > 3 then
                char:SetData("permakilled", true)
            end
        end
    end)

    -- Decrease deathTimes if player hasn't died for a while
    timer.Create("DeathTimeDecrease", decreaseInterval, 0, function()
        if not ply:IsCombine() then
            if CurTime() - lastDeathTime >= decreaseInterval then
                deathTimes = math.max(deathTimes - 1, 0)
            end
        end
    end)
end