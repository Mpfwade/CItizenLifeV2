AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ai"
ENT.PrintName = "CITIZENLIFE-TV"
ENT.Author = "Wade"
ENT.Category = "IX:HL2RP"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

ENT.Materials = {
    Material("halflife/lab1_cmpm3000"),
    Material("scripted/breen_fakemonitor_1"),
    Material("effects/breenscreen_static01_")
}

ENT.MaterialDuration = 10 -- Duration for each material (in seconds)
ENT.SpecialMaterialIndex = 2 -- Index of the material to play for a longer duration
ENT.SpecialMaterialDuration = 100 -- Duration for the special material (in seconds)
ENT.Sound = Sound("misc/doom_short.wav")
ENT.ScreenSize = Vector(32, 18, 0) -- Size of the TV screen
ENT.MaxRenderDistance = math.pow(256, 2)

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_c17/tv_monitor01.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local physics = self:GetPhysicsObject()
        physics:EnableMotion(false)
        physics:Sleep()
    end

    function ENT:SpawnFunction(ply, trace)
        local tv = ents.Create("ix_tv")
        tv:SetPos(trace.HitPos + Vector(0, 0, 48))
        tv:SetAngles(Angle(0, (tv:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        tv:Spawn()
        tv:Activate()

        return tv
    end

    function ENT:Use(activator, caller)
        if not IsValid(caller) or not caller:IsPlayer() then return end
        local curTime = CurTime()

        if not self.NextMaterialTime or self.NextMaterialTime <= curTime then
            -- Play the next material
            local materialIndex = 1
            if self.Sound then
                -- Play the sound
                self:EmitSound(self.Sound)
            end

            self.NextMaterialTime = curTime + self.MaterialDuration
        end
    end

    function ENT:Think()
        local curTime = CurTime()

        if self.NextMaterialTime and self.NextMaterialTime <= curTime then
            -- Play the next material
            local materialIndex = self.SpecialMaterialIndex or 1
            if self.Sound then
                -- Play the sound
                self:EmitSound(self.Sound)
            end

            self.SpecialMaterialIndex = (materialIndex % #self.Materials) + 1
            self.NextMaterialTime = curTime + self.SpecialMaterialDuration
        end

        self:NextThink(curTime)

        return true
    end
else
    surface.CreateFont("ixVendingMachine2", {
        font = "Default",
        size = 13,
        weight = 800,
        antialias = false
    })

    local color_red = Color(100, 20, 20, 255)
    local color_blue = Color(0, 50, 100, 255)
    local color_black = Color(60, 60, 60, 255)

    function ENT:Draw()
        self:DrawModel()

        local pos = self:GetPos()
        local ang = self:GetAngles()

        pos = pos + (ang:Up() * 5)
        pos = pos + (ang:Forward() * 6.30)
        pos = pos + (ang:Right() * 9.8)

        ang:RotateAroundAxis(self:GetAngles():Up(), 90)
        ang:RotateAroundAxis(self:GetAngles():Right(), -90)

        cam.Start3D2D(pos, ang, 0.07)
            surface.SetDrawColor(Color(30, 30, 30))
            surface.SetMaterial(self.Materials[1])
            surface.DrawTexturedRect(10, -11, 215, 145)

        cam.End3D2D()
    end
end
