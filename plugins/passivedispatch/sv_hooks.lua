function PLUGIN:EmitRandomChatter(player, position)
    local randomSounds = {"npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav", "dispatch/disp_civilized.wav"}
    local randomSound = randomSounds[math.random(1, #randomSounds)]

    -- Play the sound at the specified position and sound level
    EmitSound(randomSound, position, player:EntIndex(), 90)
end

-- Color(128, 218, 235)
function PLUGIN:Tick()
    for k, v in ipairs(player.GetAll()) do
        local curTime = CurTime()

        if not self.nextChatterEmit then
            self.nextChatterEmit = curTime + math.random(5, 10)
        end

        if curTime >= self.nextChatterEmit then
            self.nextChatterEmit = nil

            local positions = {
                Vector(-3630, -1989, -538),
                Vector(-3065, -136, -366),
                Vector(-5686, -1464, -659)
            }
            local position = positions[math.random(1, #positions)]

            -- Pass the player's position to EmitRandomChatter
            self:EmitRandomChatter(v, position)
        end
    end
end
