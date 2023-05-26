-- Item Statistics

ITEM.name = "Spas-12 Shotgun"
ITEM.description = "A powerful pump-action shotgun. (Uses Shotgun Shells)"
ITEM.category = "Weapons"
ITEM.bDropOnDeath = true
-- Item Configuration
 
ITEM.model = "models/weapons/w_shotgun.mdl" 
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 6
ITEM.height = 1

-- Item Custom Configuration

ITEM.class = "ls_spas12"
ITEM.weaponCategory = "primary"

ITEM.exRender = true
ITEM.iconCam = {
	pos = Vector(0, 200, 0),
	ang = Angle(0, 270, 0),
	fov = 9.62
}