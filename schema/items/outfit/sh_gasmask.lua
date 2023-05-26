ITEM.name = "Gas Mask"
ITEM.description = "A mask with a filter, protects you against toxic gas."
ITEM.model = "models/willardnetworks/clothingitems/head_gasmask.mdl"
ITEM.outfitCategory = "Face"
ITEM.noResetBodyGroups = true
ITEM.gasMask = true

ITEM.height = 1
ITEM.width = 1
ITEM.category = "Armor Items"
ITEM.maxArmor = 5

if ( SERVER ) then
	util.AddNetworkString("ixGasmaskEquip")
	util.AddNetworkString("ixGasmaskUnEquip")
	function ITEM:OnEquipped()
		if (self.player) then
			local ply = self.player
			net.Start("ixGasmaskEquip") net.Send(ply)
			ply.ixGasmaskEquipped = true
			ply:EmitSound("npc/combine_soldier/zipline_clothing"..math.random(1,2)..".wav", 60)
			ply:SetArmor(self:GetData("armor", self.maxArmor))
			ply:SetBodygroup(9, 2)
			ply:SetAction("Equipping Gasmask..", 2, function()
				ply:EmitSound("npc/combine_soldier/zipline_clothing"..math.random(1,2)..".wav", 60)
				ply:SetArmor(self:GetData("armor", self.maxArmor))
				ply:SetBodygroup(9, 2)
			end)
		end
	end

	function ITEM:OnUnequipped()
		if (self.player) then
			local ply = self.player
			self:SetData("armor", math.Clamp(ply:Armor(), 0, self.maxArmor))
			net.Start("ixGasmaskUnEquip") net.Send(ply)
			ply.ixGasmaskEquipped = nil
			ply:EmitSound("npc/combine_soldier/zipline_clothing"..math.random(1,2)..".wav", 60)
			ply:SetArmor(0)
			ply:SetBodygroup(1, 0)
			ply:SetBodygroup(2, 1)
			ply:SetBodygroup(3, 1)
			ply:SetAction("Unequipping your Gasmask..", 2, function()
				ply:EmitSound("npc/combine_soldier/zipline_clothing"..math.random(1,2)..".wav", 60)
				ply:SetArmor(0)
				ply:SetBodygroup(1, 0)
				ply:SetBodygroup(2, 1)
				ply:SetBodygroup(3, 1)
			end)
		end
	end
else
	net.Receive("ixGasmaskEquip", function()
		LocalPlayer().ixGasmaskEquipped = true
	end)

	net.Receive("ixGasmaskUnEquip", function()
		LocalPlayer().ixGasmaskEquipped = nil
	end)
end