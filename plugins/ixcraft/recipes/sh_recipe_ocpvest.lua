RECIPE.name = "Civil Protection Vest"
RECIPE.description = "Craft a Civil Protection Vest."
RECIPE.model = "models/tnb/items/shirt_rebeloverwatch.mdl"
RECIPE.category = "Armor Items"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["damagedcpvest"] = 1,
	["cloth"] = 3,
	["glue"] = 1,
	["plastic"] = 2,
}
RECIPE.results = {
	["cpvest"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 25
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"