RECIPE.name = "Bright Jeans"
RECIPE.description = "Craft Bright Jeans."
RECIPE.model = "models/willardnetworks/clothingitems/legs_citizen2.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 10,
}
RECIPE.results = {
	["pants1"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"