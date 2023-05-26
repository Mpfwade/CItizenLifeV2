RECIPE.name = "Bandana"
RECIPE.description = "Craft a Bandana."
RECIPE.model = "models/willardnetworks/clothingitems/head_facewrap.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 4,
}
RECIPE.results = {
	["bandana"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 8
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"