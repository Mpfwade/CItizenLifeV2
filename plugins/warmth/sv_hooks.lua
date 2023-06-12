
function PLUGIN:SetupTimer(client, character)
	local steamID = client:SteamID64()

	timer.Create("ixWarmth" .. steamID, ix.config.Get("warmthTickTime", 5), 0, function()
		if (IsValid(client) and character) then
			self:WarmthTick(client, character, ix.config.Get("warmthTickTime", 5))
		else
			timer.Remove("ixWarmth" .. steamID)
		end
	end)
end

function PLUGIN:SetupAllTimers()
	for _, v in ipairs(player.GetAll()) do
		local character = v:GetCharacter()

		if (character) then
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
	if (ix.config.Get("warmthEnabled", false)) then
		self:SetupTimer(client, character)
	end
end

function PLUGIN:PlayerDeath(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetWarmth(100)
	end
end

local currentTemperature = ix.config.Get("warmthDefaultTemp", 20)

function PLUGIN:WarmthTick(client, character, delta)
	if (!client:Alive() or
		client:GetMoveType() == MOVETYPE_NOCLIP or
		hook.Run("ShouldTickWarmth", client) == false or
		self:GetTemperature() > ix.config.Get("warmthMinTemp", 5)) then
		return
	end

	local scale = 1

	if self:IsRaining() then
		local rainTemperatureDecrease = ix.config.Get("warmthRainTempDecrease", 5)
		currentTemperature = currentTemperature - rainTemperatureDecrease
	end

	-- Check the current temperature against the player's clothing requirements
	local requiredTemperature = ix.config.Get("warmthRequiredTemp", 5)

	if currentTemperature < requiredTemperature then
		-- Adjust the scale based on the temperature difference
		local temperatureDifference = requiredTemperature - currentTemperature
		scale = scale - temperatureDifference * ix.config.Get("warmthTempScale", 0.1)
	end


	if (self:PlayerIsInside(client)) then
		scale = -ix.config.Get("warmthRecoverScale", 0.5)
	end

	-- check to see if the player is near any warmth-generating entities
	local entities = ents.FindInSphere(client:GetPos(), self.warmthEntityDistance)

	for _, v in ipairs(entities) do
		if (self.warmthEntities[v:GetClass()]) then
			scale = -ix.config.Get("warmthFireScale", 2)
		end
	end

	local equippedItems = {
		["coat"] = -1,
		["bluebeanie"] = -0.55,
		["greenbeanie"] = -0.55,
		["gloves"] = -0.50,
		-- Add more items and their corresponding scale values here
	}
	
	if currentTemperature < requiredTemperature then
		for itemID, itemScale in pairs(equippedItems) do
			local item = character:GetInventory():GetItemsByUniqueID(itemID)[1]
			if item and item:GetData("equip") == true then
				-- Decrease the time it takes for the player to get cold based on the number of equipped items
				scale = scale * itemScale
			end
		end
	end
	

	-- update character warmth
	local health = client:Health()
	local warmth = character:GetWarmth()
	local newWarmth = math.Clamp(warmth - scale * (delta / ix.config.Get("warmthLossTime", 5)), 0, 100)

	-- Increase the warmth value by 1 if it exceeds 99
	if newWarmth > 0.99 and warmth <= 99 then
		newWarmth = newWarmth + 1
	end

	character:SetWarmth(newWarmth)

	if (newWarmth == 0) then
		local damage = ix.config.Get("warmthDamage", 2)

		if (damage > 0 and health > 5) then
			-- damage the player if we've run out of warmth
			client:SetHealth(math.max(5, client:Health() - damage))
		elseif (newWarmth == 0 and ix.config.Get("warmthKill", false)) then
			-- kill the player if necessary
			client:NotifyLocalized("warmthDied")
			client:Kill()
		end
	end
end

function PLUGIN:IsRaining()
    local conVarValue = GetConVar("sw_rain", "Rain") or GetConVar("sw_thunderstorm", "Thunderstorm") or GetConVar("sw_heavystorm", "Heavy Storm") -- Get the value of the ConVar "sw_rain"

    return conVarValue == 1 -- Return true if the value is 1 (indicating rain), false otherwise
end

