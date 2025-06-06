AddCSLuaFile()

SWEP.PrintName = "Lockpick"
SWEP.Author = "Akulla"
SWEP.Purpose = "Opens doors."
SWEP.Category = "IX:HL2RP"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "normal"

SWEP.UseHands = true
SWEP.ShowWorldModel = true
SWEP.ShowViewModel = true

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Lockpicktiming = 20

-- Custom Functions
if SERVER then
	function SWEP:Initialize() -- init variables
		self.Lockpicking = false
	end

	function SWEP:Deploy() -- let's reset everything
		self:SetHoldType("normal")
		self.Lockpicking = false
	end

	function SWEP:ValidCheck() -- check if every condition are good
		local owner = self:GetOwner()
		local ent = owner:GetEyeTrace().Entity
		local wep = owner:GetActiveWeapon()
		return (owner and owner:IsValid() and ent:IsValid() and IsValid(wep) and wep:GetClass() == "lockpick" and ent:IsDoor())
	end

	function SWEP:Holster()
		self:GetOwner():SetAction(nil)
	end

	function SWEP:GoodUse(owner, ent)
		if self:ValidCheck() and self.Lockpicking then
			local ent = self:GetOwner():GetEyeTrace().Entity
			ent:Fire("Unlock")
			ent:Fire("Open")
			ix.util.Notify("You have successfully unlocked the door!", self:GetOwner())
		else
			ix.util.Notify("You failed to open the door.", self:GetOwner())
		end
		self:GetOwner():SetAction(nil)
		self:Deploy()
	end
	
	function SWEP:BadUse(owner)
		self:Deploy()
		owner:SetAction(nil)
		ix.util.Notify("You failed to open the door.", owner)
	end

	function SWEP:StartLockpick()
		local owner = self:GetOwner()
		local ent = owner:GetEyeTrace().Entity

		if not self.Lockpicking and self:ValidCheck() then
			self:SetHoldType("pistol")
			self.Lockpicking = true

			owner:SetAction("Opening...", self.Lockpicktiming)
			owner:DoStaredAction(ent, self:GoodUse(owner, ent), self.Lockpicktiming, self:BadUse(owner))
		end
	end

	function SWEP:Think() 
		-- doing cool kidz sounds
		if self.Lockpicking then
			self.LastSoundTime = self.LastSoundTime or CurTime() - 1

			if self.LastSoundTime < CurTime() then
				self.LastSoundTime = CurTime() + 1
				self:EmitSound("weapons/357/357_reload4.wav", 50, 100)
			end
		end
	end

	function SWEP:PrimaryAttack() 
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:StartLockpick()
	end

	function SWEP:SecondaryAttack()
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		self:StartLockpick()
	end

	function SWEP:Reload() 
		if self.Lockpicking then
			self:Deploy()
			self:GetOwner():SetAction(nil)
			ix.util.Notify("You canceled the picklocking.", self:GetOwner())
		end
	end
end