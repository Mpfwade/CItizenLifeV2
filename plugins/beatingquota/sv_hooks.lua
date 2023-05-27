local PLUGIN = PLUGIN

local QUOTA_RESET_TIME = 10 * 60 -- 10 minutes in seconds

function PLUGIN:PlayerLoadedCharacter(client, character)
    if client:Team() == FACTION_CCA then
        if character:GetData("quota") == nil then
            character:SetData("quota", 0)
            print(client:Nick() .. " has no quota data, setting quota data for them.")
        end

        if character:GetData("quotamax") == nil then
            character:SetData("quotamax", math.random(3, 6))
            print(client:Nick() .. " has no (MAX) quota data, setting (MAX) quota data for them.")
        end
    end
end

function PLUGIN:EntityTakeDamage(target, dmginfo)
    if not target:IsPlayer() then return end
    local attacker = dmginfo:GetAttacker()
    if not attacker:IsPlayer() or attacker:Team() ~= FACTION_CCA then return end

    local character = attacker:GetCharacter()
    local quotaamount = character:GetData("quota") or 0
    local quotamax = character:GetData("quotamax") or 3
    local timerName = "QuotaLossTimer_" .. attacker:SteamID()

    if quotaamount >= quotamax then return end

    if target:Team() == FACTION_CITIZEN and (attacker:GetActiveWeapon():GetClass() == "ix_hands" or attacker:GetActiveWeapon():GetClass() == "ix_stunstick") then
        character:SetData("quota", quotaamount + 1)

        if quotaamount + 1 >= quotamax then
            attacker:ChatPrint("You have completed your beating quota.")
            attacker:SetRP(1 + attacker:GetNWInt("ixRP"))
            character:SetData("quota", 0)
            character:SetData("quotamax", math.random(3, 6))

            timer.Create("ResetQuotaTimer", 60, 1, function()
                character:SetData("quota", 0)
                attacker:ChatPrint("You've received a new beating quota.")
            end)
        else
            attacker:ChatPrint("You have gained a point on your beating quota.")
        end
    end
end