RECIPE.name = "Blue Cap"
RECIPE.description = "Craft a Blue Cap."
RECIPE.model = "models/willardnetworks/clothingitems/head_hat.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 7,
}
RECIPE.results = {
	["bluecap"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"