-- Item Statistics

ITEM.name = "Rocket Propelled Grenade"
ITEM.description = "A home-made crossbow that uses energy heated metal rods."
ITEM.category = "Weapons"
ITEM.bDropOnDeath = true
-- Item Configuration

ITEM.model = "models/weapons/w_rocket_launcher.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.class = "weapon_rpg"
ITEM.weaponCategory = "primary"
ITEM.functions.use = {
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    OnRun = function(itemTable)
        local ply = itemTable.player

        ply:Give("weapon_rpg")
        ply:SelectWeapon( "weapon_rpg" )
        ply:SetAmmo(0, ply:GetActiveWeapon():GetPrimaryAmmoType())
    end
}

