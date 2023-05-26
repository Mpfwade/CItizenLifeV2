function PLUGIN:EmitRandomChatter(player)
    local randomSounds = {"npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav", "dispatch/disp_civilized.wav"}

    local randomSound = randomSounds[math.random(1, #randomSounds)]

    PlayTimedEventSound(1, randomSound)
end

-- Color(128, 218, 235)
function PLUGIN:Tick()
    for k, v in ipairs(player.GetAll()) do
        local curTime = CurTime()

        if (not self.nextChatterEmit) then
            self.nextChatterEmit = curTime + math.random(750, 965)
        end

        if ((curTime >= self.nextChatterEmit)) then
            self.nextChatterEmit = nil
            self:EmitRandomChatter(v)
        end
    end
end