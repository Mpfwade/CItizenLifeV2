RECIPE.name = "Formal Shoes"
RECIPE.description = "Craft Formal Shoes."
RECIPE.model = "models/willardnetworks/clothingitems/shoes_formal.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 10,
	["plastic"] = 25,
}
RECIPE.results = {
	["formalshoes"] = 1,
}

RECIPE.station = "ix_station_workbench"
RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"