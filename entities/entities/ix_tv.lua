ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "TV"
ENT.Author = "Your Name"
ENT.Category = "Your Category"

ENT.Materials = {
    "halflife/lab1_cmpm3000",
    "scripted/breen_fakemonitor_1",
    "effects/breenscreen_static01_"
}

ENT.MaterialDuration = 10 -- Duration for each material (in seconds)
ENT.SpecialMaterialIndex = 2 -- Index of the material to play for a longer duration
ENT.SpecialMaterialDuration = 100 -- Duration for the special material (in seconds)
ENT.Sound = Sound("misc/doom_short.wav")

function ENT:Initialize()
    self:SetModel("models/props/de_inferno/tv_monitor01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
	
		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
	
		self.nextUseTime = 0
		self:SetNetVar("stock", {})
end

function ENT:Use(activator, caller)
    if not IsValid(caller) or not caller:IsPlayer() then return end

    local curTime = CurTime()

    if not self.NextMaterialTime or self.NextMaterialTime <= curTime then
        -- Play the next material
        local materialIndex = 1
        self:SetMaterial(self.Materials[materialIndex])

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
        self:SetMaterial(self.Materials[materialIndex])

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
