    local PLUGIN = PLUGIN or {}
    PLUGIN.name = "Zombie Screen Shake"
    PLUGIN.description = "Causes the player's screen to shake when they see a zombie."
    PLUGIN.author = "ChatGPT"


   --[[ if SERVER then

    local function ShakeScreen(ply)
        if IsValid(ply) and ply:Alive() and ply:IsPlayer() and not ply:IsCombine() then
            local pos = ply:GetPos()
            local entsInRange = ents.FindInSphere(pos, 355)
            for _, ent in ipairs(entsInRange) do
                if ent:IsNPC() and (ent:GetClass() == "npc_zombie" or ent:GetClass() == "npc_fastzombie" or ent:GetClass() == "npc_poisonzombie" or ent:GetClass() == "npc_zombine" or ent:GetClass() == "npc_zombie_torso" or ent:GetClass() == "npc_fastzombie_torso") then
                    ply:ViewPunch(Angle(math.Rand(-0.2, 0.2), math.Rand(-0.2, 0.2), math.Rand(-0.2, 0.2)))

                end
            end
        end
    end

    function PLUGIN:PlayerTick(ply)
        ShakeScreen(ply)
    end

    function PLUGIN:PlayerSpawn(ply)
        ShakeScreen(ply)
    end
end
--]]