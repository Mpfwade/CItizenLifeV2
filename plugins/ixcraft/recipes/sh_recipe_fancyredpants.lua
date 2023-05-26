RECIPE.name = "Fancy Red Pants"
RECIPE.description = "Craft Fancy Red Pants."
RECIPE.model = "models/willardnetworks/clothingitems/legs_ca_6.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 20,
}
RECIPE.results = {
	["fpants2"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"