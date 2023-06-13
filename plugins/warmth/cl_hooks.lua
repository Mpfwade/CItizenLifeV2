local PLUGIN = PLUGIN

function PLUGIN:GetWarmthText(amount)
    if amount > 75 then
        return L("warmthWarm")
    elseif amount > 50 then
        return L("warmthChilly")
    elseif amount > 25 then
        return L("warmthCold")
    else
        return L("warmthFreezing")
    end
end

function PLUGIN:WarmthEnabled()
    ix.bar.Add(function()
        local character = LocalPlayer():GetCharacter()

        if character then
			local warmth = character:GetWarmth()

			if warmth <= 45 then
                -- Display a chat notification
                    LocalPlayer():ChatNotify("I'm getting cold!")

                -- Shake the screen for 3 seconds
                util.ScreenShake(LocalPlayer():GetPos(), 3, 5, 1, 1)
			end

            return warmth / 100, self:GetWarmthText(warmth)
        end

        return false
    end, Color(200, 50, 40), nil, "warmth")
end

function PLUGIN:WarmthDisabled()
    ix.bar.Remove("warmth")
end