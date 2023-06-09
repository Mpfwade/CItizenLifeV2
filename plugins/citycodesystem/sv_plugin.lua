local PLUGIN = PLUGIN

function PLUGIN:CivilUnrestStart()
    SetGlobalBool("ixCUStatus", true)

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/politistablizationmarginal.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end

    PlayEventSound("music/stingers/hl1_stinger_song27.mp3")
    PlayTimedEventSound(9, "alarms/choreo_a1_intro_basement_alarm.mp3")
    EmitTimedShake(9)
    PlayTimedEventSound(13, "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav")

    timer.Create("ixUnrestSiren", 10, 0, function()
        PlayTimedEventSound(3.15, "hlacomvoice/alarms/amb_c17_distant_alarm_02_rs.mp3")
        EmitTimedShake(3.15)
    end)
end

function PLUGIN:CivilUnrestStop()
    SetGlobalBool("ixCUStatus", false)
    timer.Remove("ixUnrestSiren")

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/sociostabilizationrestored.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end
end

--[[---------------------------------------------------------------------------
	City Turmoil
---------------------------------------------------------------------------]]
--
function PLUGIN:CityTurmoilStart()
    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/socialfractureinprogress.wav", "npc/overwatch/radiovoice/allteamsrespondcode3.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end

    SetGlobalBool("ixCTStatus", true)
    PlayEventSound("music/stingers/hl1_stinger_song28.mp3")
    PlayTimedEventSound(5, "dispatch/disp_anticitizen.wav")
    PlayTimedEventSound(6, "music/destabilizing3.wav")
    PlayTimedEventSound(10, "ambient/levels/citadel/citadel_5sirens3.wav")
    PlayTimedEventSound(13, "ambient/levels/citadel/stalk_traindooropen.wav")
    PlayTimedEventSound(15, "ambient/levels/citadel/citadel_5sirens3.wav")
    PlayTimedEventSound(18, "ambient/levels/streetwar/heli_distant1.wav")
    PlayTimedEventSound(20, "music/a1_intro_refuge.mp3")
    PlayTimedEventSound(23, "ambient/levels/streetwar/gunship_distant1.wav")
    PlayTimedEventSound(25, "ambient/levels/streetwar/gunship_distant2.wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")

    for _, v in pairs(player.GetAll()) do
        util.ScreenShake(v:GetPos(), 2, 5, 3, 500)
    end

    timer.Simple(4, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 3, 500)
        end
    end)

    timer.Simple(7, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 3, 500)
        end
    end)

    timer.Simple(7, function()
        timer.Create("ixCityTurmoilAmbience", 10, 0, function()
            local randomChance = math.random(1, 5)

            if randomChance == 2 then
                PlayTimedEventSound(math.random(0.0, 3.0), table.Random({"npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav", "npc/overwatch/cityvoice/f_anticivil1_5_spkr.wav", "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav", "npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav", "npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav", "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav",}))
            end

            PlayEventSound({"ambient/levels/streetwar/marching_distant1.wav", "ambient/levels/streetwar/marching_distant2.wav", "ambient/levels/streetwar/apc_distant1.wav", "ambient/levels/streetwar/city_scream3.wav", "alarms/amb_c17_siren_distant_01_rs.mp3",})
        end)
    end)
end

function PLUGIN:CityTurmoilStop()
    SetGlobalBool("ixCTStatus", false)
    timer.Remove("ixCityTurmoilAmbience")
    timer.Remove("ixTurmoilBuzz")

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/sociostabilizationrestored.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end
end

--[[---------------------------------------------------------------------------
	Judgement Waiver
---------------------------------------------------------------------------]]
--
function PLUGIN:JudgementWaiverStart()
    SetGlobalBool("ixJWStatus", true)
    PlayEventSound("music/a1_intro_strider.mp3")
    PlayEventSound("alarms/alarm.wav")
    EmitShake()
    PlayTimedEventSound(4, "dispatch/disp_assetallocation.wav")
    PlayTimedEventSound(15.9, "ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    EmitTimedShake(16)
    PlayTimedEventSound(20, "ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    EmitTimedShake(20.1)
    PlayTimedEventSound(22, "ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    EmitTimedShake(22.8)

    timer.Create("ixJWBuzz", 16, 0, function()
        PlayEventSound("loudspeaker/jw_horn.wav")
    end)
    --[[
	PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
    PlayEventSound("ambient/atmosphere/hole_hit"..math.random(1,5)..".wav")
    PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

    for _, v in pairs(player.GetAll()) do
        util.ScreenShake(v:GetPos(), 5, 5, 4, 5000)
    end

	for _, v in pairs(ents.FindByName("citadel")) do
		v:Fire("SetAnimation", "open")
	end

	PlayEventSound("npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav")
	PlayEventSound("ambient/alarms/manhack_alert_pass1.wav")
	PlayEventSound("doors/door_metal_large_chamber_close1.wav")
	PlayEventSound("doors/door_metal_large_chamber_close1.wav")

	timer.Simple(1, function()
		PlayEventSound("ambient/alarms/city_siren_loop2.wav")
		PlayEventSound("doors/door_metal_large_chamber_close1.wav")
		PlayEventSound("doors/door_metal_large_chamber_close1.wav")
	end)

	timer.Simple(2, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/atmosphere/hole_hit"..math.random(1,5)..".wav")
        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 5, 5, 3, 5000)
        end

		PlayEventSound("ambient/machines/wall_move1.wav")
	end)

	timer.Simple(5, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
		PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
		PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
		PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
		PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
		PlayEventSound("ambient/atmosphere/hole_hit"..math.random(1,5)..".wav")
		PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

		for _, v in pairs(player.GetAll()) do
			util.ScreenShake(v:GetPos(), 5, 5, 5, 5000)
		end

		PlayEventSound("ambient/machines/wall_crash1.wav")
		PlayEventSound("ambient/levels/streetwar/marching_distant2.wav")
		PlayEventSound("ambient/levels/citadel/drone1lp.wav")
		PlayEventSound("ambient/levels/streetwar/battle_1.wav")
	end)

	timer.Simple(9, function()
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
        PlayEventSound("ambient/atmosphere/hole_hit"..math.random(1,5)..".wav")
        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 5, 5, 3, 5000)
        end

		PlayEventSound("ambient/materials/metal_big_impact_scrape1.wav")
	end)

	timer.Simple(10, function()
		for k, v in pairs(player.GetAll()) do v:StopSound("ambient/alarms/city_siren_loop2.wav") end
		PlayEventSound("ambient/levels/streetwar/marching_distant2.wav")
		PlayEventSound("ambient/levels/streetwar/city_chant1.wav")
		PlayEventSound("ambient/alarms/citadel_alert_loop2.wav")
		timer.Create("ixJudgementWaiverAmbience", 5, 0, function()
			PlayEventSound({
				"ambient/levels/streetwar/city_battle1.wav",
				"ambient/levels/streetwar/city_battle2.wav",
				"ambient/levels/streetwar/city_battle3.wav",
				"ambient/levels/streetwar/city_battle4.wav",
				"ambient/levels/streetwar/city_battle5.wav",
				"ambient/levels/streetwar/city_battle6.wav",
				"ambient/levels/streetwar/city_battle7.wav",
				"ambient/levels/streetwar/city_battle8.wav",
				"ambient/levels/streetwar/city_battle9.wav",
				"ambient/levels/streetwar/city_battle10.wav",
				"ambient/levels/streetwar/city_battle11.wav",
				"ambient/levels/streetwar/city_battle12.wav",
				"ambient/levels/streetwar/city_battle13.wav",
				"ambient/levels/streetwar/city_battle14.wav",
				"ambient/levels/streetwar/city_battle15.wav",
				"ambient/levels/streetwar/city_battle16.wav",
				"ambient/levels/streetwar/city_battle17.wav",
				"ambient/levels/streetwar/city_battle18.wav",
				"ambient/levels/streetwar/city_battle19.wav",
				"ambient/levels/streetwar/distant_battle_dropship01.wav",
				"ambient/levels/streetwar/distant_battle_dropship02.wav",
				"ambient/levels/streetwar/distant_battle_dropship03.wav",
				"ambient/levels/streetwar/distant_battle_gunfire01.wav",
				"ambient/levels/streetwar/distant_battle_gunfire02.wav",
				"ambient/levels/streetwar/distant_battle_gunfire03.wav",
				"ambient/levels/streetwar/distant_battle_gunfire04.wav",
				"ambient/levels/streetwar/distant_battle_gunfire05.wav",
				"ambient/levels/streetwar/distant_battle_gunfire06.wav",
				"ambient/levels/streetwar/distant_battle_gunfire07.wav",
				"ambient/levels/streetwar/distant_battle_shotgun01.wav",
				"ambient/levels/streetwar/distant_battle_soldier01.wav",
				"ambient/levels/streetwar/strider_1.wav",
				"ambient/levels/streetwar/strider_2.wav",
				"ambient/levels/streetwar/strider_3.wav",
				"LiteNetwork/hl2rp/event/overhead/helicopter01.ogg",
				"LiteNetwork/hl2rp/event/overhead/helicopter02.ogg",
				"LiteNetwork/hl2rp/event/overhead/helicopter03.ogg",
				"LiteNetwork/hl2rp/event/overhead/helicopter04.ogg",
				"LiteNetwork/hl2rp/event/overhead/helicopter05.ogg",
				"LiteNetwork/hl2rp/event/overhead/helicopter06.ogg",
				"LiteNetwork/hl2rp/event/overhead/helicopter07.ogg",
				"LiteNetwork/hl2rp/event/overhead/helicopter08.ogg",
				"LiteNetwork/hl2rp/event/overhead/jet01.mp3",
				"LiteNetwork/hl2rp/event/overhead/jet02.mp3",
				"LiteNetwork/hl2rp/event/overhead/jet03.mp3",
				"LiteNetwork/hl2rp/event/overhead/jet04.mp3",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_01.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_02.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_03.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_04.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_05.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_06.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_07.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_08.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_09.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_10.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_11.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_12.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_13.ogg",
				"LiteNetwork/hl2rp/event/scary/idle_moan_wet_14.ogg",
			})
		end)

		timer.Create("ixJudgementWaiverAlarm", 45, 0, function()
			PlayEventSound("ambient/alarms/citadel_alert_loop2.wav")

            PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav")
            PlayEventSound("ambient/atmosphere/hole_hit"..math.random(1,5)..".wav")
            for _, v in pairs(player.GetAll()) do
                util.ScreenShake(v:GetPos(), 5, 5, 3, 5000)
            end
		end)

		timer.Create("ixJudgementWaiverReminder", 300, 0, function()
			PlayEventSound("npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav")
		end)
	end)

	timer.Simple(14, function()
		PlayEventSound("ambient/levels/streetwar/marching_distant2.wav")
	end)]]
end

function PLUGIN:JudgementWaiverStopSilent()
    SetGlobalBool("ixJWStatus", false)
    timer.Remove("ixJWBuzz")
    --[[for _, v in pairs(ents.FindByName("citadel")) do
		v:Fire("SetAnimation", "idle")
	end

	for _, v in ipairs(player.GetAll()) do
		v:StopSound("ambient/levels/citadel/drone1lp.wav")
		v:StopSound("ambient/levels/streetwar/battle_1.wav")
	end

	SetGlobalBool("ixJWStatus", false)
	timer.Destroy("ixJudgementWaiverAlarm")
	timer.Destroy("ixJudgementWaiverAmbience")
	timer.Destroy("ixJudgementWaiverReminder")]]
end

function PLUGIN:JudgementWaiverStop()
    SetGlobalBool("ixJWStatus", false)
    timer.Remove("ixJWBuzz")

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/sociostabilizationrestored.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end
end

--[[---------------------------------------------------------------------------
	Autonomous Judgement
---------------------------------------------------------------------------]]
--
function PLUGIN:AutonomousJudgementStart()
    for k, v in pairs(player.GetAll()) do
        net.Start("ixEventMessage")
        net.WriteString("Prepare yourselves..")
        net.Send(v)
    end

    PlayEventSound("music/hallway_long.wav")
    PlayTimedEventSound(1, "ambient/levels/citadel/citadel_5sirens3.wav")
    PlayTimedEventSound(3, "ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
    PlayTimedEventSound(6, "ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
    PlayTimedEventSound(10, "ambient/levels/citadel/portal_open1_adpcm.wav")
    PlayTimedEventSound(12, "dispatch/disp_void.wav")
    PlayTimedEventSound(12, "ambient/levels/citadel/core_partialcontain_loop1.wav")
    PlayTimedEventSound(12, "ambient/levels/citadel/citadel_drone_loop1.wav")
    PlayTimedEventSound(30, "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav")

    timer.Simple(12, function()
        SetGlobalBool("ixAJStatus", true)
        local portalStormClouds = ents.Create("prop_dynamic")
        portalStormClouds:SetPos(Vector(-14115.766602, -13259.793945, 13184.562500))
        portalStormClouds:SetModel("models/props_combine/combine_citadelcloud001c.mdl")
        portalStormClouds:SetModelScale(0.75)
        portalStormClouds:Spawn()
        local portalStorm = ents.Create("prop_dynamic")
        portalStorm:SetPos(Vector(-14115.766602, -13259.793945, -13454.562500))
        portalStorm:SetModel("models/props_combine/combine_citadelcloudcenter.mdl")
        portalStorm:SetModelScale(0.75)
        portalStorm:Spawn()
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
        end

        PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
        PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

        for _, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
        end

        timer.Create("ixAJAmbiencePortal", 7, 0, function()
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
            PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")

            for _, ply in pairs(player.GetAll()) do
                util.ScreenShake(ply:GetPos(), 2, 5, 2, 5000)
            end

            PlayEventSound({"ambient/levels/city/citadel_cloudhit1.wav", "ambient/levels/city/citadel_cloudhit2.wav", "ambient/levels/city/citadel_cloudhit3.wav", "ambient/levels/city/citadel_cloudhit4.wav", "ambient/levels/city/citadel_cloudhit5.wav",})
        end)

        timer.Create("ixAJAmbience", 3, 0, function()
            PlayEventSound({"ambient/levels/streetwar/city_battle1.wav", "ambient/levels/streetwar/city_battle2.wav", "ambient/levels/streetwar/city_battle3.wav", "ambient/levels/streetwar/city_battle4.wav", "ambient/levels/streetwar/city_battle5.wav", "ambient/levels/streetwar/city_battle6.wav", "ambient/levels/streetwar/city_battle7.wav", "ambient/levels/streetwar/city_battle8.wav", "ambient/levels/streetwar/city_battle9.wav", "ambient/levels/streetwar/city_battle10.wav", "ambient/levels/streetwar/city_battle11.wav", "ambient/levels/streetwar/city_battle12.wav", "ambient/levels/streetwar/city_battle13.wav", "ambient/levels/streetwar/city_battle14.wav", "ambient/levels/streetwar/city_battle15.wav", "ambient/levels/streetwar/city_battle16.wav", "ambient/levels/streetwar/city_battle17.wav", "ambient/levels/streetwar/city_battle18.wav", "ambient/levels/streetwar/city_battle19.wav", "ambient/levels/streetwar/distant_battle_dropship01.wav", "ambient/levels/streetwar/distant_battle_dropship02.wav", "ambient/levels/streetwar/distant_battle_dropship03.wav", "ambient/levels/streetwar/distant_battle_gunfire01.wav", "ambient/levels/streetwar/distant_battle_gunfire02.wav", "ambient/levels/streetwar/distant_battle_gunfire03.wav", "ambient/levels/streetwar/distant_battle_gunfire04.wav", "ambient/levels/streetwar/distant_battle_gunfire05.wav", "ambient/levels/streetwar/distant_battle_gunfire06.wav", "ambient/levels/streetwar/distant_battle_gunfire07.wav", "ambient/levels/streetwar/distant_battle_shotgun01.wav", "ambient/levels/streetwar/distant_battle_soldier01.wav", "ambient/levels/streetwar/strider_1.wav", "ambient/levels/streetwar/strider_2.wav", "ambient/levels/streetwar/strider_3.wav",})
        end)
    end)

    timer.Create("ixAJFlasher", 60, 0, function()
        PlayEventSound("ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
        PlayEventSound("ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
        PlayEventSound("ambient/levels/citadel/strange_talk" .. math.random(1, 11) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
        PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

        for _, v in pairs(player.GetAll()) do
            util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
        end

        PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
        PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

        for _, v in pairs(player.GetAll()) do
            v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
        end
    end)
end

function PLUGIN:AutonomousJudgementStop()
    timer.Remove("ixAJFlasher")
    timer.Remove("ixAJAmbiencePortal")
    timer.Remove("ixAJAmbience")

    local sounds = {"npc/overwatch/radiovoice/on3.wav", "npc/overwatch/radiovoice/attention.wav", "npc/overwatch/radiovoice/sociostabilizationrestored.wav", "npc/overwatch/radiovoice/off2.wav"}

    for k, v in ipairs(player.GetAll()) do
        if v:IsCombine() then
            ix.util.EmitQueuedSounds(v, sounds, 0, 0.2, 150)
        end
    end
end

PlayEventSound("ambient/levels/citadel/citadel_flyer1.wav")
PlayTimedEventSound(3, "ambient/levels/citadel/citadel_5sirens.wav")
PlayTimedEventSound(4, "ambient/levels/citadel/stalk_traindooropen.wav")
PlayTimedEventSound(6, "ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
PlayTimedEventSound(8, "ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
PlayTimedEventSound(9, "ambient/levels/labs/teleport_mechanism_windup5.wav")

timer.Simple(17, function()
    PlayEventSound("ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
    PlayEventSound("ambient/levels/citadel/portal_beam_shoot" .. math.random(1, 6) .. ".wav")
    PlayTimedEventSound(1, "ambient/levels/labs/teleport_winddown1.wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

    for _, v in pairs(player.GetAll()) do
        util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
    end

    PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
    PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

    for _, v in pairs(player.GetAll()) do
        v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
    end

    SetGlobalBool("ixAJStatus", false)

    for _, v in ipairs(player.GetAll()) do
        v:StopSound("ambient/levels/citadel/core_partialcontain_loop1.wav")
        v:StopSound("ambient/levels/citadel/citadel_drone_loop1.wav")
    end

    for _, v in pairs(ents.FindByClass("prop_dynamic")) do
        if (v:GetModel() == "models/props_combine/combine_citadelcloudcenter.mdl") or (v:GetModel() == "models/props_combine/combine_citadelcloud001c.mdl") then
            SafeRemoveEntity(v)
        end
    end
end)

timer.Simple(6, function()
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

    for _, v in pairs(player.GetAll()) do
        util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
    end

    PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
    PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

    for _, v in pairs(player.GetAll()) do
        v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
    end
end)

timer.Simple(8, function()
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/levels/streetwar/building_rubble" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/atmosphere/hole_hit" .. math.random(1, 5) .. ".wav")
    PlayEventSound("ambient/atmosphere/terrain_rumble1.wav")

    for _, v in pairs(player.GetAll()) do
        util.ScreenShake(v:GetPos(), 2, 5, 5, 5000)
    end

    PlayEventSound("ambient/levels/labs/teleport_weird_voices" .. math.random(1, 2) .. ".wav")
    PlayEventSound("ambient/levels/labs/teleport_postblast_thunder1.wav")

    for _, v in pairs(player.GetAll()) do
        v:ScreenFade(SCREENFADE.IN, color_white, 5, 0)
    end
end)