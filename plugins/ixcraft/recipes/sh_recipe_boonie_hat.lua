RECIPE.name = "Boonie Hat"
RECIPE.description = "Craft a Boonie."
RECIPE.model = "models/willardnetworks/clothingitems/head_boonie.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 6,
}
RECIPE.results = {
	["boonie"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"