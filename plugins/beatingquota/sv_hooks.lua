local PLUGIN = PLUGIN

local QUOTA_RESET_TIME = 60 -- 60 seconds (1 minute) for the quota reset timer
local QUOTA_MAX = 20 -- Initial quota maximum value
local QUOTA_INCREASE_TIME = 600 -- 600 seconds (10 minutes) for the quota increase timer
local QUOTA_INCREASE_AMOUNT = 1 -- Amount to increase quotamax by

function PLUGIN:PlayerLoadedCharacter(client, character)
    if client:Team() == FACTION_CCA then
        if character:GetData("quota") == nil then
            character:SetData("quota", 0)
            print(client:Nick() .. " has no quota data, setting quota data for them.")
        end

        if character:GetData("quotamax") == nil then
            character:SetData("quotamax", QUOTA_MAX)
            print(client:Nick() .. " has no (MAX) quota data, setting (MAX) quota data for them.")
        end
    end
end

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
            character:GiveMoney(5)
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
            attacker:ChatPrint("You have gained a point on your quota.")
        end
    end
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    if client:Team() ~= FACTION_CCA then return end
    local timerName = "QuotaIncreaseTimer_" .. client:SteamID()

    if timer.Exists(timerName) then
        timer.Remove(timerName)
    end

    timer.Create(timerName, QUOTA_INCREASE_TIME, 0, function()
        local character = client:GetCharacter()
        local quotamax = character:GetData("quotamax") or QUOTA_MAX

        if quotamax < 20 then
            character:SetData("quotamax", quotamax + QUOTA_INCREASE_AMOUNT)
            client:ChatPrint("Your quota maximum has been increased to " .. (quotamax + QUOTA_INCREASE_AMOUNT))
        end
    end)
end
