local PLUGIN = PLUGIN or {}
PLUGIN.name = "Emote Moods"
PLUGIN.author = "DrodA (Ported from NS)"
PLUGIN.description = "With this plugin, characters can set their mood."
PLUGIN.schema = "Any"
PLUGIN.version = 1.2

MOOD_NONE = 0
MOOD_RELAXED = 1
MOOD_FRUSTRATED = 2
MOOD_MODEST = 3
MOOD_COWER = 4
MOOD_HOLDINGSTUN = 5

PLUGIN.MoodTextTable = {
    [MOOD_NONE] = "Default",
    [MOOD_RELAXED] = "Relaxed",
    [MOOD_FRUSTRATED] = "Frustrated",
    [MOOD_MODEST] = "Modest",
    [MOOD_COWER] = "Cower",
    [MOOD_HOLDINGSTUN] = "Holdingstun"
}

PLUGIN.MoodBadMovetypes = {
    [MOVETYPE_FLY] = true,
    [MOVETYPE_LADDER] = true,
    [MOVETYPE_NOCLIP] = true
}

PLUGIN.MoodAnimTable = {
    [MOOD_RELAXED] = {
        [0] = "LineIdle01",
        [1] = "walk_all_Moderate",
        [2] = "run_all"
    },
    [MOOD_FRUSTRATED] = {
        [0] = "LineIdle02",
        [1] = "pace_all",
        [2] = "run_all"
    },
    [MOOD_MODEST] = {
        [0] = "LineIdle04",
        [1] = "plaza_walk_all",
        [2] = "run_all"
    },
    [MOOD_COWER] = {
        [0] = "cower_Idle",
        [1] = "plaza_walk_all",
        [2] = "ACT_RUN_PROTECTED"
    }
}

local meta = FindMetaTable("Player")

function meta:GetMood()
    return self:GetNWInt("mood", MOOD_NONE)
end

function meta:SetMood(mood)
    mood = mood or MOOD_NONE
    self:SetNWInt("mood", mood)
end

if CLIENT then
    local MOOD_CYCLE_COOLDOWN = 1 -- Cooldown duration in seconds
    local lastMoodChangeTime = 0 -- Variable to store the time of the last mood change

    local function CycleMood(client)
        local currentMood = client:GetMood()
        local nextMood = (currentMood + 1) % (MOOD_COWER + 1)
        client:SetMood(nextMood)
    end

    local function HandleMoodCycle()
        local client = LocalPlayer()
        if not IsValid(client) or not client:Alive() then return end -- Add check for player validity and alive state
        local activeWeapon = client:GetActiveWeapon()
        if not IsValid(activeWeapon) then return end -- Add check for active weapon validity
        local activeWeaponClass = activeWeapon:GetClass()
        if activeWeaponClass ~= "ix_hands" then return end -- Modify the condition to check for specific weapon classes

        if input.IsMouseDown(MOUSE_MIDDLE) then
            if not client.moodCyclePressed and os.time() >= lastMoodChangeTime + MOOD_CYCLE_COOLDOWN then
                CycleMood(client)
                client:ChatPrint("You have changed your idle stance.")
                client.moodCyclePressed = true
                lastMoodChangeTime = os.time()
            end
        else
            client.moodCyclePressed = false
        end
    end

    hook.Add("Think", "EmoteMoods_MoodCycle", HandleMoodCycle)
end



if SERVER or CLIENT then
    local tblWorkaround = {
        ["ix_keys"] = true,
        ["ix_hands"] = true
    }

    function PLUGIN:CalcMainActivity(client, velocity)
        local length = velocity:Length2DSqr()
        local clientInfo = client:GetTable()
        local mood = client:GetMood()

        if client and IsValid(client) and client:IsPlayer() then
            if not client:IsWepRaised() and not client:Crouching() and IsValid(client:GetActiveWeapon()) and tblWorkaround[client:GetActiveWeapon():GetClass()] and not client:InVehicle() and mood > 0 and not self.MoodBadMovetypes[client:GetMoveType()] and not client.m_bJumping and client:IsOnGround() then
                if length < 0.25 then
                    clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][0] and client:LookupSequence(self.MoodAnimTable[mood][0]) or clientInfo.CalcSeqOverride
                elseif length > 0.25 and length < 22500 then
                    clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][1] and client:LookupSequence(self.MoodAnimTable[mood][1]) or clientInfo.CalcSeqOverride
                elseif length > 22500 then
                    clientInfo.CalcSeqOverride = self.MoodAnimTable[mood][2] and client:LookupSequence(self.MoodAnimTable[mood][2]) or clientInfo.CalcSeqOverride
                end
            end
        end
    end
end
