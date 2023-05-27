local PLUGIN = PLUGIN
PLUGIN.name = "Area-Based=Stuff"
PLUGIN.author = "Wade"
PLUGIN.description = "Plays music in some areas."

ix.config.Add("area-music", true, "Should the music be on?", nil, {
    category = PLUGIN.name
})

ix.option.Add("area-music", ix.type.bool, true, {
    category = PLUGIN.name
})

local MUSIC_INFO = {
    ["Nexus Entrance"] = {name = "music/hl2_song25_teleporter.mp3", volume = 37},
    ["PATH TO THE OUTLANDS"] = {name = "music/hl1_song9.mp3", volume = 37},
    ["Residential Block 2"] = {name = "ambient/a1_intro_apt_radio.wav", volume = 37},
    ["Intake-Hub 1"] = {name = "music/hl2_intro.mp3", volume = 37},
    ["Sector-1"] = {name = "music/a1_intro_world_2.mp3", volume = 37},
    ["Sector-2"] = {name = "music/hl2_song1.mp3", volume = 37},
    ["Sector-3"] = {name = "music/hl2_song33.mp3", volume = 37},
    ["RB-1 Storage"] = {name = "music/a3_rooftop_crab_hotel_dark.mp3", volume = 37},
    ["Rebel Hideout"] = {name = "music/vlvx_song20.mp3", volume = 37},
    ["Under Hideout"] = {name = "music/vlvx_song3.mp3", volume = 37},
    ["PRISONER TRANSPORT 2491"] = {name = "music/stingers/hl1_stinger_song27.mp3", volume = 37},
    ["PRISONER INSERT"] = {name = "music/hl2_song0.mp3", volume = 37},
    ["Terminal Restriction Zone"] = {name = "music/stingers/hl1_stinger_song7.mp3", volume = 37},
    ["Prison"] = {name = "music/hl2_song19.mp3", volume = 37},
    ["404 Zone"] = {name = "ambient/atmosphere/tone_quiet.wav", volume = 3},
    ["Restricted-Block"] = {name = "dispatch/disp_restrictedblock3.wav", volume = 27},
}

if SERVER then
    util.AddNetworkString("AreaMusic")

    function PLUGIN:OnPlayerAreaChanged(client, old, new)
        if not ix.config.Get("area-music", true) then return end
        if not ix.option.Get(client, "area-music", false) then return end

        local musicInfo = MUSIC_INFO[new]

        if new and musicInfo then
            net.Start("AreaMusic")
            net.WriteString(musicInfo.name)
            net.WriteFloat(musicInfo.volume)
            net.Send(client)
        else
            net.Start("AreaMusic")
            net.Send(client)
        end
    end
else -- CLIENT
    net.Receive("AreaMusic", function()
        local musicName = net.ReadString()

        if musicName and musicName ~= "" then
            local volume = net.ReadFloat()
            surface.PlaySound(musicName)
        else
            surface.PlaySound("")
        end
    end)
end