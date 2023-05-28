local PLUGIN = PLUGIN

local QUOTA_RESET_TIME = 60 -- 60 seconds (1 minute) for the quota reset timer
local QUOTA_MAX = 20 -- Initial quota maximum value
local QUOTA_INCREASE_TIME = 600 -- 600 seconds (10 minutes) for the quota increase timer
local QUOTA_INCREASE_AMOUNT = 1 -- Amount to increase quotamax by
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
            ply:SetRP(1 + ply:GetNWInt("ixRP"))
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
    if client:Team() == FACTION_CCA then
        if client:GetData("quota") == nil then
            client:SetData("quota", 0)
            print(client:Nick() .. " has no quota data, setting quota data for them.")
        end

        if client:GetData("quotamax") == nil then
            client:SetData("quotamax", QUOTA_MAX)
            print(client:Nick() .. " has no (MAX) quota data, setting (MAX) quota data for them.")
        end

        if client:GetData("lastQuotaIncreaseTime") == nil then
            client:SetData("lastQuotaIncreaseTime", os.time()) -- Initialize lastQuotaIncreaseTime
        end

        if timer.Exists("QuotaIncreaseTimer_" .. client:SteamID()) then
            timer.Remove("QuotaIncreaseTimer_" .. client:SteamID())
        end

        timer.Create("QuotaIncreaseTimer_" .. client:SteamID(), QUOTA_INCREASE_TIME, 0, function()
            local currentTime = os.time()
            local lastIncreaseTime = client:GetData("lastQuotaIncreaseTime") or currentTime
            local timeDiff = currentTime - lastIncreaseTime

            if timeDiff >= QUOTA_INCREASE_TIME then
                local quotaamount = client:GetData("quota") or 0
                local quotamax = client:GetData("quotamax") or QUOTA_MAX

                if quotaamount < quotamax then
                    client:SetData("quota", quotaamount + QUOTA_INCREASE_AMOUNT)
                    client:SetData("lastQuotaIncreaseTime", currentTime)
                    client:ChatPrint("Your quota has increased to " .. (quotaamount + QUOTA_INCREASE_AMOUNT))
                end
            end
        end)
    end
end

function PLUGIN:PlayerDisconnected(client)
    if timer.Exists("QuotaIncreaseTimer_" .. client:SteamID()) then
        timer.Remove("QuotaIncreaseTimer_" .. client:SteamID())
    end
end

function PLUGIN:PlayerTick(player)
    if player:Team() == FACTION_CCA then
        local lastIncreaseTime = player:GetData("lastQuotaIncreaseTime") or 0
        local currentTime = os.time()
        local timeDiff = currentTime - lastIncreaseTime

        if timeDiff >= RANK_PENALTY_TIME then
            local rank = player:GetNWInt("ixRP")

            if rank > 0 then
                ply:SetRP(RANK_PENALTY_AMOUNT - ply:GetNWInt("ixRP"))
                player:ChatPrint("You lost one rank point due to not completing your quota in time.")
            end

            player:SetData("lastQuotaIncreaseTime", currentTime)
        end
    end
end