local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character)
    if client:Team() == FACTION_CCA then
        local newQuotaMax = math.random(3, 10)
        client:SetData("quota", 0)
        character:SetData("quotamax", newQuotaMax)
        character:SetData("quota", 0)
        if character:GetData("quota") == nil then
            character:SetData("quota", 0)
            print(client:Nick() .. " has no quota data, setting quota data for them.")
        end

        if character:GetData("quotamax") == nil then
            character:SetData("quotamax", 3)
            print(client:Nick() .. " has no (MAX) quota data, setting (MAX) quota data for them.")
        end
    end
end

function PLUGIN:EntityTakeDamage(target, dmginfo)
    if not target:IsPlayer() then return end
    local attacker = dmginfo:GetAttacker()
    if not attacker:IsPlayer() or attacker:Team() ~= FACTION_CCA then return end

    local quotaamount = attacker:GetData("quota") or 0
    local quotamax = attacker:GetData("quotamax") or 3

    if quotaamount >= quotamax then return end

    if target:Team() == FACTION_CITIZEN and (attacker:GetActiveWeapon():GetClass() == "ix_hands" or attacker:GetActiveWeapon():GetClass() == "ix_stunstick") then
        attacker:SetData("quota", quotaamount + 1)

        if quotaamount + 1 >= quotamax then
            attacker:Notify("You have completed your Beating Quota!")
            local character = attacker:GetCharacter()
            character:SetData("quota", 0)

            -- Generate a random number within the range of 3 to 6 as the new quota maximum
            local newQuotaMax = math.random(3, 10)
            character:SetData("quotamax", newQuotaMax)
            attacker:SetRP(1 + attacker:GetNWInt("ixRP"))
            attacker:Notify("Your Beating Quota is done.")

            timer.Create("ResetQuotaTimer", 900, 1, function()
                attacker:SetData("quota", 0)
                attacker:Notify("Your Beating Quota has been reset.")
            end)
        else
            attacker:Notify("You have gained a point on your Beating Quota, you are now at (" .. (quotaamount + 1) .. "/" .. quotamax .. ")")
        end
    end
end

