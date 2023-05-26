RECIPE.name = "Gray Jacket"
RECIPE.description = "Craft a Gray Jacket."
RECIPE.model = "models/willardnetworks/clothingitems/torso_alyxcoat1.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 10,
}
RECIPE.results = {
	["alyxcoat1"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"