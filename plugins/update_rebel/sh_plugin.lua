

local PLUGIN = PLUGIN

PLUGIN.name = "Resistance Update"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "Adds Features and improvements to the Resistance in Lite Network."

if SERVER then
    return -- This script should only run on the client
end

local waterMaterials = {
    "nature/toxicslime002a",
    "nature/toxicslime002a_dx70",
    "nature/toxicslime002a_dx70_beneath"
} -- List of desired water materials

local damageAmount = 5 -- Amount of damage to apply per tick

function PLUGIN:Tick()
    local ply = LocalPlayer()
    local water = ply:WaterLevel()
    local waterMaterial = ply:GetMaterial()

    for _, material in ipairs(waterMaterials) do
        if water > 0 and waterMaterial == material then
            -- Apply damage when player touches water with the specified material
            ply:TakeDamage(damageAmount, nil, nil) -- Adjust the damage type and attacker as needed
            break -- Exit the loop if the material is found
        end
    end
end
