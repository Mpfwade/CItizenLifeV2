RECIPE.name = "Green Coat"
RECIPE.description = "Craft a Green Coat."
RECIPE.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 15,
}
RECIPE.results = {
	["alyxcoat3"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"