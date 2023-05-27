local PLUGIN = PLUGIN

function PLUGIN:PlayerLoadedCharacter(client, character)
    if client:Team() == FACTION_CCA then
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
            local character = attacker:GetCharacter()
            character:SetData("quota", 0)
            character:SetData("quotamax", 3)
            character:GiveMoney(5)
            attacker:ChatNotify("Your beating quota has been completed. You've been rewarded one rank point.")
             local timerqou = math.random(70, 480)
            timer.Create("ResetQuotaTimer", timerqou, 1, function()
                attacker:SetData("quota", 0)
                attacker:ChatPrint("You've recived a new beating quota.")
            end)
        else
            attacker:Notify("You have gained a point on your beating quota.")
        end
    end
end

local function ResetQuota(client)
    local character = client:GetCharacter()
    character:SetData("quota", 0)
    character:SetData("quotamax", 3)
end