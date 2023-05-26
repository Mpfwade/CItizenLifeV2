RECIPE.name = "Brown Jacket"
RECIPE.description = "Craft a Brown Jacket."
RECIPE.model = "models/willardnetworks/clothingitems/torso_alyxcoat8.mdl"
RECIPE.category = "Clothing"

RECIPE.base = "recipe_base"

RECIPE.requirements = {
	["cloth"] = 10,
}
RECIPE.results = {
	["alyxcoat4"] = 1,
}

RECIPE.craftStartSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"
RECIPE.craftTime = 10
RECIPE.craftEndSound = "physics/body/body_medium_impact_soft"..math.random(1,7)..".wav"