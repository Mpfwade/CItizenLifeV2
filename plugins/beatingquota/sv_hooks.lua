local PLUGIN = PLUGIN
local QUOTA_RESET_TIME = 60 -- 60 seconds (1 minute) for the quota reset timer
local QUOTA_MAX = 20 -- Initial quota maximum value
local RANK_PENALTY_TIME = 2700 -- 2700 seconds (45 minutes) for the rank penalty timer
local RANK_PENALTY_AMOUNT = 1 -- Amount to decrease rank by

function PLUGIN:EntityTakeDamage(target, dmginfo)
    if not target:IsPlayer() then return end
    local attacker = dmginfo:GetAttacker()
    if not attacker:IsPlayer() or attacker:Team() ~= FACTION_CCA then return end
    local quotaamount = attacker:GetData("quota") or 0
    local quotamax = attacker:GetData("quotamax") or QUOTA_MAX
    if quotaamount >= quotamax then return end

    if target:Team() == FACTION_CITIZEN and (attacker:GetActiveWeapon():GetClass() == "ix_hands" or attacker:GetActiveWeapon():GetClass() == "ix_stunstick") then
        attacker:SetData("quota", quotaamount + 1)

        if quotaamount + 1 >= quotamax then
            attacker:ChatPrint("You have completed your quota!")
            local character = attacker:GetCharacter()
            character:SetData("quota", 0)
            character:SetData("quotamax", quotamax)
            attacker:SetRP(1 + attacker:GetNWInt("ixRP"))
            attacker:ChatPrint("You've done your quota. You've been rewarded one rank point")

            if timer.Exists("ResetQuotaTimer") then
                timer.Remove("ResetQuotaTimer")
            end

            timer.Create("ResetQuotaTimer", QUOTA_RESET_TIME, 1, function()
                character:SetData("quota", 0)
                character:SetData("quotamax", quotamax)
                attacker:ChatPrint("You've received a new quota.")
            end)
        else
            attacker:SetData("quota", quotaamount + 1) -- Increase the quota amount
            attacker:ChatPrint("You have gained a point on your quota.")
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    if not client:Team() == FACTION_CCA then return end

    if client:Team() == FACTION_CCA then
        if client:GetData("quota") == nil then
            client:SetData("quota", 0)
            print(client:Nick() .. " has no quota data, setting quota data for them.")
        end

        if client:GetData("quotamax") == nil then
            client:SetData("quotamax", QUOTA_MAX)
            print(client:Nick() .. " has no (MAX) quota data, setting (MAX) quota data for them.")
        end
    end
end