RECIPE.name = "Boots"
RECIPE.description = "Craft a Pair of Boots."
RECIPE.model = "models/willardnetworks/clothingitems/shoes_boots.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 3,
	["glue"] = 5,
	["plastic"] = 10,
}
RECIPE.results = {
	["boots"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"