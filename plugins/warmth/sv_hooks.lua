function PLUGIN:SetupTimer(client, character)
    local steamID = client:SteamID64()

    timer.Create("ixWarmth" .. steamID, ix.config.Get("warmthTickTime", 5), 0, function()
        if IsValid(client) and character then
            self:WarmthTick(client, character, ix.config.Get("warmthTickTime", 5))
        else
            timer.Remove("ixWarmth" .. steamID)
        end
    end)
end

function PLUGIN:SetupAllTimers()
    for _, v in ipairs(player.GetAll()) do
        local character = v:GetCharacter()

        if character then
            self:SetupTimer(v, character)
        end
    end
end

function PLUGIN:RemoveAllTimers()
    for _, v in ipairs(player.GetAll()) do
        timer.Remove("ixWarmth" .. v:SteamID64())
    end
end

function PLUGIN:WarmthEnabled()
    self:SetupAllTimers()
end

function PLUGIN:WarmthDisabled()
    self:RemoveAllTimers()
end

function PLUGIN:PlayerLoadedCharacter(client, character, lastCharacter)
    if ix.config.Get("warmthEnabled", false) then
        self:SetupTimer(client, character)
    end
end

function PLUGIN:PlayerDeath(client)
    local character = client:GetCharacter()

    if character then
        character:SetWarmth(100)
    end
end

function PLUGIN:WarmthTick(client, character, delta)
    if not client:Alive() or client:GetMoveType() == MOVETYPE_NOCLIP or hook.Run("ShouldTickWarmth", client) == false or self:GetTemperature() > ix.config.Get("warmthMinTemp", 5) then
        return
    end

    local scale = 1

    if self:IsRaining() then
        local rainScaleIncrease = ix.config.Get("warmthRainScale", 2)
        scale = scale + rainScaleIncrease
    end

    if self:PlayerIsInside(client) then
        scale = -ix.config.Get("warmthRecoverScale", 0.5)
    end

    -- Check the current temperature against the player's clothing requirements
    local requiredTemperature = ix.config.Get("warmthRequiredTemp", 5)

    if self:GetTemperature() < requiredTemperature then
        -- Adjust the scale based on the temperature difference
        local temperatureDifference = requiredTemperature - self:GetTemperature()
        scale = scale + temperatureDifference * ix.config.Get("warmthTempScale", 0.1)
    end

    -- Check to see if the player is near any warmth-generating entities
    local entities = ents.FindInSphere(client:GetPos(), self.warmthEntityDistance)

    for _, v in ipairs(entities) do
        if self.warmthEntities[v:GetClass()] then
            scale = -ix.config.Get("warmthFireScale", 2)
        end
    end

    -- Calculate the counteracting scale based on equipped items
    local equippedItems = {
        ["coat"] = 1.95,
        ["bluebeanie"] = 0.55,
        ["greenbeanie"] = 0.55,
        ["gloves"] = 0.50,
    }

    local counteractingScale = 0

    for itemID, itemScale in pairs(equippedItems) do
        local item = character:GetInventory():GetItemsByUniqueID(itemID)[1]

        if item and item:GetData("equip") == true then
            counteractingScale = counteractingScale + itemScale
        end
    end

    -- Apply the counteracting scale to reduce the overall scale
    scale = scale - counteractingScale

    -- Update character warmth
    local health = client:Health()
    local warmth = character:GetWarmth()
    local newWarmth = math.Clamp(warmth - scale * (delta / ix.config.Get("warmthLossTime", 5)), 0, 100)

    -- Increase the warmth value by 1 if it exceeds 99
    if newWarmth > 0.99 and warmth <= 99 then
        newWarmth = newWarmth + 1
    end

    character:SetWarmth(newWarmth)

    if newWarmth == 0 then
        local damage = ix.config.Get("warmthDamage", 2)

        if damage > 0 and health > 5 then
            -- Damage the player if we've run out of warmth
            client:SetHealth(math.max(5, client:Health() - damage))
        elseif newWarmth == 0 and ix.config.Get("warmthKill", false) then
            -- Kill the player if necessary
            client:NotifyLocalized("warmthDied")
            client:Kill()
        end
    end
end

function PLUGIN:IsRaining()
    local conVarValue = GetConVar("sw_rain", "0"):GetInt() or GetConVar("sw_thunderstorm", "0"):GetInt() or GetConVar("sw_heavystorm", "0"):GetInt()
    return conVarValue == 1
end
