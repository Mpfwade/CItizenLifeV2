local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character)
    if client:Team() == FACTION_CCA then
        if character:GetData("quota") == nil then
            character:SetData("quota", 99)
            print(client:Nick() .. " has no quota data, setting quota data for them.")
        end

        if character:GetData("quotamax") == nil then
            character:SetData("quotamax", 99)
            print(client:Nick() .. " has no (MAX) quota data, setting (MAX) quota data for them.")
        end
    end
end

function PLUGIN:EntityTakeDamage(target, dmginfo)
    if not target:IsPlayer() then return end
    local attacker = dmginfo:GetAttacker()
    if not attacker:IsPlayer() or attacker:Team() ~= FACTION_CCA then return end
    local quotaamount = attacker:GetData("quota") or 0
    local quotamax = attacker:GetData("quotamax") or 0
    if quotaamount >= 99 or quotamax >= 99 then return end

    if target:Team() == FACTION_CITIZEN and (attacker:GetActiveWeapon():GetClass() == "ix_hands" or attacker:GetActiveWeapon():GetClass() == "ix_stunstick") then
        if quotaamount < quotamax then
            attacker:SetData("quota", quotaamount + 1)
            attacker:Notify("You have gained a point on your Beating Quota, you are now at (" .. (quotaamount + 1) .. "/" .. quotamax .. ")")
            --We query Quota Data again, as opposed to using "quotaamount" because the tick does not update fast enough for the print, resulting in the first hit showing at 0/3
        end
    end
end

function PLUGIN:PlayerTick(ply)
    for k, v in pairs(player.GetAll()) do
        if v:IsCombine() then
            local quotaamount = v:GetData("quota") or 0
            local quotamax = v:GetData("quotamax") or 0
            local character = v:GetCharacter()

            if quotaamount >= quotamax and quotamax ~= 99 and quotaamount ~= 99 then
                character:GetData("quota", 0) -- set the quota to 0
                character:GetData("quotamax", 99)
                character:GiveMoney(5)
                v:Notify("You've met your Beating Quota, you'll be assigned a new one when the time comes.")
            end
        end
    end
end