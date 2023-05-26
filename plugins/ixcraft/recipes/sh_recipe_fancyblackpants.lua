RECIPE.name = "Fancy Black Pants"
RECIPE.description = "Craft Fancy Black Pants."
RECIPE.model = "models/willardnetworks/clothingitems/legs_ca_1.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 25,
}
RECIPE.results = {
	["fpants1"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"