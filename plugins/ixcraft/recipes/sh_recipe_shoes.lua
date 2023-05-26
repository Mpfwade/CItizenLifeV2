RECIPE.name = "Black Shoes"
RECIPE.description = "Craft Black Shoes."
RECIPE.model = "models/willardnetworks/clothingitems/shoes_black.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 3,
	["plastic"] = 5,
	["glue"] = 2,
}
RECIPE.results = {
	["shoes"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 6
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"