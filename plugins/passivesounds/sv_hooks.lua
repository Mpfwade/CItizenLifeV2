function PLUGIN:EmitRandomChatter(player)
    local randomSounds = {"ambient/machines/heli_pass_distant1.wav", "ambient/wind/wind_moan4.wav", "ambient/wind/wind_moan2.wav", "ambient/wind/wind_moan1.wav", "ambient/alarms/manhack_alert_pass1.wav", "ambient/alarms/apc_alarm_pass1.wav", "ambient/levels/labs/teleport_postblast_thunder1.wav", "ambient/levels/streetwar/city_battle16.wav", "ambient/levels/streetwar/gunship_distant2.wav", "ambient/levels/streetwar/city_chant1.wav"}

    local randomSound = randomSounds[math.random(1, #randomSounds)]

    PlayEventSound(randomSound)
end

-- Color(128, 218, 235)
function PLUGIN:Tick()
    for k, v in ipairs(player.GetAll()) do
        local curTime = CurTime()

        if not self.nextChatterEmit then
            self.nextChatterEmit = curTime + math.random(100, 300)
        end

        if curTime >= self.nextChatterEmit then
            self.nextChatterEmit = nil
            self:EmitRandomChatter(v)
        end
    end
end