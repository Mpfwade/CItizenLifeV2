
AddCSLuaFile()

ENT.Base            = "base_ai"
ENT.Type            = "anim"
ENT.PrintName        = "Stove"
ENT.Author            = "Wade"
ENT.Category         = "Stations"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Stove"
ENT.HUDDesc = "A stove used for cooking various of foods and drinks."

if (SERVER) then
    function ENT:Initialize()
        self:SetModel("models/props_c17/furniturestove001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
    end
end

if (CLIENT) then
    function ENT:OnPopulateEntityInfo(tooltip)
        surface.SetFont("ixIconsSmall")
    
        local title = tooltip:AddRow("name")
        title:SetImportant()
        title:SetText("Stove")
        title:SetBackgroundColor(ix.config.Get("color"))
        title:SizeToContents()
    
        local description = tooltip:AddRow("description")
        description:SetText("A stove used for cooking various of foods and drinks.")
        description:SizeToContents()
    
    end
end
