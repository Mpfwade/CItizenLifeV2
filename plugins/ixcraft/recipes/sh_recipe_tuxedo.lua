RECIPE.name = "Black Tuxedo"
RECIPE.description = "Craft a Black Tuxedo."
RECIPE.model = "models/willardnetworks/clothingitems/torso_ca_2.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 15,
}
RECIPE.results = {
	["tuxedo1"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"