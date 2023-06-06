local PLUGIN = PLUGIN or {}
local HumanMalePainSounds = {
    [HITGROUP_GENERIC] = {Sound("vo/npc/male01/pain01.wav"), Sound("vo/npc/male01/pain02.wav"), Sound("vo/npc/male01/pain03.wav"), Sound("vo/npc/male01/pain04.wav"), Sound("vo/npc/male01/pain05.wav"), Sound("vo/npc/male01/pain06.wav")},
    [HITGROUP_HEAD] = {Sound("vo/npc/male01/moan02.wav"), Sound("vo/npc/male01/moan04.wav"), Sound("vo/npc/male01/pain07.wav")},
    [HITGROUP_CHEST] = {Sound("vo/npc/male01/imhurt01.wav"), Sound("vo/npc/male01/imhurt02.wav")},
    [HITGROUP_STOMACH] = {Sound("vo/npc/male01/hitingut01.wav"), Sound("vo/npc/male01/hitingut02.wav"), Sound("vo/npc/male01/mygut02.wav")},
    [HITGROUP_LEFTARM] = {Sound("vo/npc/male01/myarm01.wav"), Sound("vo/npc/male01/myarm02.wav")},
    [HITGROUP_RIGHTARM] = {Sound("vo/npc/male01/myarm01.wav"), Sound("vo/npc/male01/myarm02.wav")},
    [HITGROUP_LEFTLEG] = {Sound("vo/npc/male01/myleg01.wav"), Sound("vo/npc/male01/myleg02.wav")},
    [HITGROUP_RIGHTLEG] = {Sound("vo/npc/male01/myleg01.wav"), Sound("vo/npc/male01/myleg02.wav")}
}

local HumanFemalePainSounds = {
    [HITGROUP_GENERIC] = {Sound("vo/npc/female01/pain01.wav"), Sound("vo/npc/female01/pain02.wav"), Sound("vo/npc/female01/pain03.wav"), Sound("vo/npc/female01/pain04.wav"), Sound("vo/npc/female01/pain05.wav"), Sound("vo/npc/female01/pain06.wav")},
    [HITGROUP_HEAD] = {Sound("vo/npc/female01/moan02.wav"), Sound("vo/npc/female01/moan04.wav"), Sound("vo/npc/female01/pain07.wav")},
    [HITGROUP_CHEST] = {Sound("vo/npc/female01/imhurt01.wav"), Sound("vo/npc/female01/imhurt02.wav")},
    [HITGROUP_STOMACH] = {Sound("vo/npc/female01/hitingut01.wav"), Sound("vo/npc/female01/hitingut02.wav"), Sound("vo/npc/female01/mygut02.wav")},
    [HITGROUP_LEFTARM] = {Sound("vo/npc/female01/myarm01.wav"), Sound("vo/npc/female01/myarm02.wav")},
    [HITGROUP_RIGHTARM] = {Sound("vo/npc/female01/myarm01.wav"), Sound("vo/npc/female01/myarm02.wav")},
    [HITGROUP_LEFTLEG] = {Sound("vo/npc/female01/myleg01.wav"), Sound("vo/npc/female01/myleg02.wav")},
    [HITGROUP_RIGHTLEG] = {Sound("vo/npc/female01/myleg01.wav"), Sound("vo/npc/female01/myleg02.wav")}
}

local CPPainSounds = {
    [HITGROUP_GENERIC] = {Sound("npc/metropolice/pain1.wav"), Sound("npc/metropolice/pain2.wav"), Sound("npc/metropolice/pain3.wav"), Sound("npc/metropolice/pain4.wav")},
    [HITGROUP_GEAR] = {Sound("npc/metropolice/pain1.wav"), Sound("npc/metropolice/pain2.wav"), Sound("npc/metropolice/pain3.wav"), Sound("npc/metropolice/pain4.wav")},
}

function PLUGIN:ScalePlayerDamage(ply, hitgroup, dmginfo)
    local char = ply:GetCharacter()

    if SERVER then
        if ply:Armor() <= 10 and not ply:IsCombine() then
            local hitgroupActions = {
                [HITGROUP_HEAD] = function()
                    local fadeDuration = 5
                    local fadeColor = Color(255, 0, 0, 255)
                    dmginfo:ScaleDamage( 2.5 )
                    ply:ScreenFade(SCREENFADE.IN, fadeColor, fadeDuration, 0)

                    if not ply:IsFemale() then
                        ply:EmitSound(table.Random(HumanMalePainSounds[HITGROUP_HEAD]), 80)
                    elseif ply:IsFemale() then
                        ply:EmitSound(table.Random(HumanFemalePainSounds[HITGROUP_HEAD]), 80)
                    end
                end,
                [HITGROUP_CHEST] = function()
                    if not char:GetData("ixChestHit", false) == true then
                        if not ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanMalePainSounds[HITGROUP_CHEST]), 80)
                        elseif ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanFemalePainSounds[HITGROUP_CHEST]), 80)
                        end

                        char:SetData("ixChestHit", true)

                        timer.Simple(1, function()
                            char:SetData("ixChestHit", false)
                        end)
                    end
                end,
                [HITGROUP_STOMACH] = function()
                    if not char:GetData("ixGutHit", false) == true then
                        if not ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanMalePainSounds[HITGROUP_STOMACH]), 80)
                        elseif ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanFemalePainSounds[HITGROUP_STOMACH]), 80)
                        end

                        char:SetData("ixGutHit", true)

                        timer.Simple(1, function()
                            char:SetData("ixGutHit", false)
                        end)
                    end
                end,
                [HITGROUP_LEFTLEG] = function()
                    if not char:GetData("ixBrokenLegs", false) == true then
                        ply:ChatNotify("I've been shot in my left leg!")

                        if not ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanMalePainSounds[HITGROUP_LEFTLEG]), 80)
                        elseif ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanFemalePainSounds[HITGROUP_LEFTLEG]), 80)
                        end

                        char:SetData("ixBrokenLegs", true)

                        timer.Simple(65, function()
                            char:SetData("ixBrokenLegs", false)
                        end)
                    end
                end,
                [HITGROUP_RIGHTLEG] = function()
                    if not char:GetData("ixBrokenLegs", false) == true then
                        ply:ChatNotify("I've been shot in my right leg!")

                        if not ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanMalePainSounds[HITGROUP_RIGHTLEG]), 80)
                        elseif ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanFemalePainSounds[HITGROUP_RIGHTLEG]), 80)
                        end

                        char:SetData("ixBrokenLegs", true)

                        timer.Simple(65, function()
                            char:SetData("ixBrokenLegs", false)
                        end)
                    end
                end,
                [HITGROUP_LEFTARM] = function()
                    if not char:GetData("ixBrokenLeftArm", false) == true then
                        if not ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanMalePainSounds[HITGROUP_LEFTARM]), 80)
                        elseif ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanFemalePainSounds[HITGROUP_LEFTARM]), 80)
                        end

                        char:SetData("ixBrokenLeftArm", true)

                        if char:GetData("ixBrokenLeftArm", true) == true then
                            ply:ViewPunch(Angle(math.Rand(-10, -5), math.Rand(-10, -5), math.Rand(-10, -5)))
                        end

                        timer.Simple(10, function()
                            char:SetData("ixBrokenLeftArm", false)
                        end)
                    end
                end,
                [HITGROUP_RIGHTARM] = function()
                    if not char:GetData("ixBrokenRightArm", false) == true then
                        if not ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanMalePainSounds[HITGROUP_RIGHTARM]), 80)
                        elseif ply:IsFemale() then
                            ply:EmitSound(table.Random(HumanFemalePainSounds[HITGROUP_RIGHTARM]), 80)
                        end

                        char:SetData("ixBrokenRightArm", true)

                        if char:GetData("ixBrokenRightArm", true) == true then
                            ply:ViewPunch(Angle(math.Rand(10, 5), math.Rand(10, 5), math.Rand(10, 5)))
                        end

                        timer.Simple(10, function()
                            char:SetData("ixBrokenRightArm", false)
                        end)
                    end
                end,
            }

            if hitgroupActions[hitgroup] then
                hitgroupActions[hitgroup]()
            end
        end
    end
end

local humanmaledeathSounds = {Sound("vo/npc/male01/pain07.wav"), Sound("vo/npc/male01/pain08.wav"), Sound("vo/npc/male01/pain09.wav")}

local humanfemaledeathSounds = {Sound("vo/npc/female01/pain07.wav"), Sound("vo/npc/female01/pain08.wav"), Sound("vo/npc/female01/pain09.wav")}

local CPdeathSounds = {Sound("npc/metropolice/die" .. math.random(1, 4) .. ".wav"), Sound("npc/metropolice/fire_scream" .. math.random(1, 3) .. ".wav")}

function PLUGIN:DoPlayerDeath(ply, attacker, dmginfo)
        if ply:GetNWBool("Ragdolled", false) then
            ply:ShouldSetRagdolled(true)
            ply:SetNWBool("Ragdolled", true)
            ply:SetNWBool("Healed", false)

            if not (ply:Team() == FACTION_CA or ply:Team() == FACTION_OTA) then
                ply:EmitSound("npc/vort/foot_hit.wav")
            end

            if ply:Team() == FACTION_CCA then
                ply:EmitSound("npc/metropolice/knockout2.wav")
            elseif ply:Team() == FACTION_OTA then
                ply:EmitSound("npc/combine_soldier/pain2.wav")
            end

            ix.chat.Send(ply, "me", "'s body crumbles to the ground.")

            ply:SetAction("You Are Unconscious...", 35, function()
                ply:SetNWBool("Ragdolled", false)
                ply:ShouldSetRagdolled(false)
                ply:SetHealth(15)
                ply:ChatNotify("I'm dying... I need medical, now.")
                if not ply:GetNWBool("Dying") then
                    ply:SetNWBool("Dying", true)
                    ply:EmitSound("player/heartbeat1.wav")
                end

                timer.Simple(0.95, function()
                    if ply:GetWeapon("gmod_tool") then
                        ply:SelectWeapon("ix_hands")
                    end
                end)

                timer.Simple(120, function()
                    ply:StopSound("player/heartbeat1.wav")

                    if not ply:GetNWBool("Healed", true) and ply:GetNWBool("Dying", true) then
                        ply:Kill()
                    end
                end)
            end)
        end
    end

function PLUGIN:PlayerDeath(ply, inf, attacker)
    if ply:IsPlayer() and (ply:Team() == FACTION_CITIZEN) or (ply:Team() == FACTION_CA) or (ply:Team() == FACTION_VORTIGAUNT) then
        local char = ply:GetCharacter()

        if not ply:IsFemale() then
            ply:EmitSound(humanmaledeathSounds[math.random(1, #humanmaledeathSounds)])
        elseif ply:IsFemale() then
            ply:EmitSound(humanfemaledeathSounds[math.random(1, #humanfemaledeathSounds)])
        end

        ix.chat.Send(ply, "me", "'s body goes limp and looks to be dead.")
        ply:SetAction(false)
        ply:ShouldSetRagdolled(false)
        ply:SetNWBool("Healed", false)
        ply:SetNWBool("Ragdolled", false)
        char:SetData("ixBrokenLegs", false)
        ply:SetNWBool("Dying", false)
        ply:StopSound("player/heartbeat1.wav")

    elseif ply:IsPlayer() and ply:Team() == FACTION_CCA then
        local char = ply:GetCharacter()
        ply:EmitSound(CPdeathSounds[math.random(1, #CPdeathSounds)])
        ix.chat.Send(ply, "me", "'s body goes limp and looks to be dead.")
        ply:SetAction(false)
        ply:ShouldSetRagdolled(false)
        ply:SetNWBool("Healed", false)
        ply:SetNWBool("Ragdolled", false)
        char:SetData("ixBrokenLegs", false)
        ply:SetNWBool("Dying", false)
        ply:StopSound("player/heartbeat1.wav")
    end
end