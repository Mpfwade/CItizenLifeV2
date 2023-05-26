ITEM.name = "Supply crate"
ITEM.description = "A crate that holds multiple loadouts."
-- Item Configuration
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.skin = 0
ITEM.noBusiness = true
ITEM.exRender = true
ITEM.bDropOnDeath = true
ITEM.width = 3
ITEM.height = 3

ITEM.iconCam = {
    pos = Vector(1.96, 5.95, 199.77),
    ang = Angle(86.31, 276.88, 0),
    fov = 6.82
}

ITEM.loadouts = {
    {
        name = "SMG Loadout",
        weapons = { "mp7", "smg1ammo" },
        rarity = 50, -- Higher rarity
    },
    {
        name = "Pistol Loadout",
        weapons = { "usp", "pistolammo" },
        rarity = 1, -- Lower rarity
    },
}

ITEM.functions.Open = {
    icon = "icon16/box.png",
    OnRun = function(itemTable)
        local ply = itemTable.player 

        -- Calculate total rarity points
        local totalRarity = 0
        for _, loadout in ipairs(itemTable.loadouts) do
            totalRarity = totalRarity + loadout.rarity
        end

        -- Generate a random number between 1 and totalRarity
        local randomValue = math.random(totalRarity)

        -- Select a loadout based on the random value and rarity
        local selectedLoadout
        local cumulativeRarity = 0
        for _, loadout in ipairs(itemTable.loadouts) do
            cumulativeRarity = cumulativeRarity + loadout.rarity
            if randomValue <= cumulativeRarity then
                selectedLoadout = loadout
                break
            end
        end

        if not selectedLoadout then
            return false -- No loadout was selected, return false to indicate failure
        end

        -- Give the player the loadout's weapons
        local character = ply:GetCharacter()
        local inventory = character:GetInventory()
        for _, weapon in ipairs(selectedLoadout.weapons) do
            inventory:Add(weapon, 1)
        end

        return true -- Return true to indicate successful execution of the function
    end
}
