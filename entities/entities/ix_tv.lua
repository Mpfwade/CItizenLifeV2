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
    Material("scripted/breen_fakemonitor_1"),
    Material("scripted/breen_fakemonitor_1"),
}

ENT.MaterialDuration = 1 -- Duration for each material (in seconds)

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_c17/tv_monitor01.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local physics = self:GetPhysicsObject()

        if physics:IsValid() then
            physics:Wake()
            physics:SetMass(70)
        end

        self:StartMotionController()
        self.IsActivated = false -- Flag to track activation status
        self:SetNWBool("TV_Activated", self.IsActivated) -- Networked variable for activation status
        self:SetNWInt("TV_MaterialIndex", 1) -- Networked variable for current material index
        self.NextMaterialTime = 0 -- Time to change to the next material
    end

    function ENT:SpawnFunction(ply, trace)
        local tv = ents.Create("ix_tv")
        tv:SetPos(trace.HitPos + Vector(0, 0, 48))
        tv:SetAngles(Angle(0, (tv:GetPos() - ply:GetPos()):Angle().y - 180, 0))
        tv:Spawn()

        return tv
    end

    function ENT:ToggleActivation()
        self.IsActivated = not self.IsActivated
        self:SetNWBool("TV_Activated", self.IsActivated)

        if self.IsActivated then
            local curTime = CurTime()

            if self.NextMaterialTime <= curTime then
                local materialIndex = self:GetNWInt("TV_MaterialIndex")
                materialIndex = materialIndex % #self.Materials + 1
                self:SetNWInt("TV_MaterialIndex", materialIndex)

                local material = self.Materials[materialIndex]

                -- Set the material for the screen
                local screen = self:GetNWEntity("TV_Screen")
                if IsValid(screen) then
                    screen:SetMaterial(material)
                end

                if self.Sound then
                    -- Play the sound
                    self:EmitSound(self.Sound)
                end

                self.NextMaterialTime = curTime + self.MaterialDuration
            end
        else
            self:SetNWInt("TV_MaterialIndex", 1) -- Reset the material index to the first material
            self:SetNWEntity("TV_Screen", nil) -- Clear the screen entity
            self.NextMaterialTime = 0 -- Reset the material change time
        end
    end

    function ENT:Use(activator, caller)
        if not IsValid(caller) or not caller:IsPlayer() then return end

        self:EmitSound("buttons/lightswitch2.wav", 75, 100)
        self:ToggleActivation()
    end

    function ENT:Think()
        local curTime = CurTime()
    
        if self.IsActivated and self.NextMaterialTime <= curTime then
            self:ToggleActivation()
        end
    
        -- Refresh 3D2D display if MaterialDuration is over
        if self.IsActivated and self.MaterialDuration > 0 and self.NextMaterialTime <= curTime then
            self:RefreshDisplay()
        end
    
        self:NextThink(curTime)
        return true
    end
    
    function ENT:RefreshDisplay()
        if not self:IsValid() then return end
        self.NextMaterialTime = CurTime() + self.MaterialDuration
    
        -- Force clients to refresh the display by updating the material index
        local materialIndex = self:GetNWInt("TV_MaterialIndex")
        materialIndex = materialIndex % #self.Materials + 1
        self:SetNWInt("TV_MaterialIndex", materialIndex)
    
        local material = self.Materials[materialIndex]
    
        -- Set the material for the screen
        local screen = self:GetNWEntity("TV_Screen")
        if IsValid(screen) then
            screen:SetMaterial(material)
        end
    end
    
    function ENT:OnRemove()
        -- Clear the material on removal
        local screen = self:GetNWEntity("TV_Screen")
        if IsValid(screen) then
            screen:SetMaterial("")
        end
    end
else
    function ENT:Initialize()
        self.IsScreenVisible = false
        self.NextMaterialTime = 0 -- Time to change to the next material
    end


    function ENT:Draw()
        self:DrawModel()

        if not self:GetNWBool("TV_Activated") then return end

        local pos = self:GetPos()
        local ang = self:GetAngles()

        pos = pos + (ang:Up() * 5)
        pos = pos + (ang:Forward() * 6.30)
        pos = pos + (ang:Right() * 9.8)

        ang:RotateAroundAxis(self:GetAngles():Up(), 90)
        ang:RotateAroundAxis(self:GetAngles():Right(), -90)

        cam.Start3D2D(pos, ang, 0.07)
            surface.SetDrawColor(Color(30, 30, 30))

            local materialIndex = self:GetNWInt("TV_MaterialIndex")
            local material = self.Materials[materialIndex]
            surface.SetMaterial(material)
            surface.DrawTexturedRect(10, -11, 215, 145)
        cam.End3D2D()
    end
end
