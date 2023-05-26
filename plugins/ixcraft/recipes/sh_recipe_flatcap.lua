RECIPE.name = "Flat Cap"
RECIPE.description = "Craft a Flat Cap."
RECIPE.model = "models/willardnetworks/clothingitems/head_hat2.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 6,
}
RECIPE.results = {
	["flatcap"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 5
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"