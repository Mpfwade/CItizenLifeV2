--[[---------------------------------------------------------------------------
	Clientside Hud
---------------------------------------------------------------------------]]
--
local colorModify = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0.03,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1.1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

local colorModifyStorm = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0.1,
    ["$pp_colour_addb"] = 0.2,
    ["$pp_colour_brightness"] = -0.03,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0.7,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0.7,
    ["$pp_colour_mulb"] = 0.8
}

function Schema:RenderScreenspaceEffects()
    if not (GetGlobalBool("ixAJStatus") == true) then
        if ix.option.Get("hudScreenEffect", true) then
            DrawColorModify(colorModify)
        end
    else
        DrawColorModify(colorModifyStorm)
    end
end

local healthIcon = ix.util.GetMaterial("litenetwork/icons/health.png")
local healthColor = Color(210, 0, 0, 255)
local tokensIcon = ix.util.GetMaterial("litenetwork/icons/money.png")
local tokensColor = Color(133, 227, 91, 255)
local hungerIcon = ix.util.GetMaterial("willardnetworks/hud/food.png")
local hungerColor = Color(205, 133, 63, 255)
local xpIcon = ix.util.GetMaterial("litenetwork/icons/salary.png")
local xpColor = Color(63, 120, 205)
local surface = surface

local buildingWeapon = {
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["swep_construction_kit"] = true,
}

local function DrawBox(x, y, w, h, ply, char)
    ix.util.DrawBlurAt(x, y, w, h, 1)
    surface.SetDrawColor(ColorAlpha(team.GetColor(ply:Team()), 25))
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(Color(30, 30, 30, 100))
    surface.DrawRect(x, y, w, h)
end

local text01position = 50
local text02position = 30

local function DrawHud(ply, char)
    if ply:GetActiveWeapon():IsValid() and buildingWeapon[ply:GetActiveWeapon():GetClass()] then
        text01position = Lerp(0.03, text01position, 50)
        text02position = Lerp(0.03, text02position, 30)
    else
        text01position = Lerp(0.03, text01position, -100)
        text02position = Lerp(0.03, text02position, -100)
    end

    surface.SetFont("LiteNetworkFont24")
    surface.SetTextColor(Color(200, 0, 0))
    surface.SetTextPos(10, text01position)
    surface.DrawText("Don't have this weapon out in RP.")
    surface.SetTextPos(10, text02position)
    surface.DrawText("You may be punished for this.")
end



ix.gui.CombineHudMessagesList = {"Updating biosignal co-ordinates...", "Parsing heads-up display and data arrays...", "Working deconfliction with other ground assets...", "Transmitting physical transition vector...", "Sensoring proximity...", "Regaining equalization modules...", "Encoding network messages...", "Analyzing Overwatch protocols...", "Filtering incoming messages...", "Updating biosignal coordinates...", "Synchronizing database records...", "Appending all data to black box...",}

ix.gui.CombineHudMessages = ix.gui.CombineHudMessages or {}
ix.gui.CombineHudMessageID = ix.gui.CombineHudMessageID or 0

function ix.gui.AddCombineDisplayMessage(text, col, sound, soundfile, font)
    local ply = LocalPlayer()
    ix.gui.CombineHudMessageID = ix.gui.CombineHudMessageID + 1
    text = "<:: " .. string.upper(text)

    local data = {
        message = "",
        bgCol = col,
        messagefont = font or "CLCHud1"
    }

    table.insert(ix.gui.CombineHudMessages, data)

    if #ix.gui.CombineHudMessages > math.random(4, 8) then
        table.remove(ix.gui.CombineHudMessages, 1)
    end

    local i = 1
    local id = "ix.gui.CombineHudMessages.ID." .. ix.gui.CombineHudMessageID

    timer.Create(id, 0.01, #text + 1, function()
        data.message = string.sub(text, 1, i + 2)
        i = i + 3

        if data.message == #text then
            timer.Remove(id)
        end
    end)

    if sound then
        ply:EmitSound(soundfile or "npc/roller/code2.wav")
    end
end

local nextMessage = 0
local lastMessage = ""

function Schema:Think()
    if IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu) then return end
    local ply = LocalPlayer()
    local char = ply:GetCharacter()

    if (nextMessage or 0) < CurTime() then
        local message = ix.gui.CombineHudMessagesList[math.random(1, #ix.gui.CombineHudMessagesList)]

        if message ~= (lastMessage or "") then
            ix.gui.AddCombineDisplayMessage(message, nil, false)
            lastMessage = message
        end

        nextMessage = CurTime() + math.random(4, 20)
    end
end

local combatWeapons = {
    ["ls_pistol"] = "USP MATCH",
    ["ls_smg"] = "smg",
    ["ls_357mag"] = "357",
    ["ix_spas12"] = "SPAS-12",
    ["ls_ar2"] = "OSIPR",
}

local function DrawCombineHud(ply, char)
    local ply = LocalPlayer()
    local char = ply:GetCharacter()
    local pos = LocalPlayer():GetPos()
    local grid = math.Round(pos.x / 100) .. " / " .. math.Round(pos.y / 100)
    local zone = ply:GetPlayerInArea() or "<UNDOCUMENTED ZONE>"
    local quota = ply:GetData("quota")
    local quotamax = ply:GetData("quotamax")

    for i = 1, #ix.gui.CombineHudMessages do
        local msgData = ix.gui.CombineHudMessages[i]
        msgData.y = msgData.y or 0
        surface.SetFont("CLCHud1")
        local w, h = surface.GetTextSize(msgData.message)
        x, y = 10, ((i - 1) * h) + 5
        msgData.y = Lerp(0.07, msgData.y, y)
        draw.SimpleTextOutlined(msgData.message, "CLCHud1", x, msgData.y, msgData.bgCol or color_white, nil, nil, 1, color_black)
    end

    -- City Codes
    draw.SimpleTextOutlined([[<:: // LOCAL INFORMATION ASSET \\ ::>]], "CLCHud1", ScrW() / 2, 5, Color( 0,138,216 ), TEXT_ALIGN_CENTER, nil, 1, color_black)

    for k, v in pairs(ix.cityCodes) do
        local value = ix.config.Get("cityCode", 0)

        if value == k then
            draw.SimpleTextOutlined("<:: CIVIC POLITISTABILIZATION INDEX: " .. v[1] .. " ::>", "CLCHud1", ScrW() / 2, 5 + 16, v[2] or color_white, TEXT_ALIGN_CENTER, nil, 1, color_black)
        end
    end

    -- Top Right
    draw.SimpleTextOutlined("// LOCAL ASSET ::>", "CLCHud1", ScrW() - 10, 5, Color( 0,138,216 ), TEXT_ALIGN_RIGHT, nil, 1, color_black)
    draw.SimpleTextOutlined("VITALS: " .. ply:Health() .. "% ::>", "CLCHud1", ScrW() - 10, 42, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
    draw.SimpleTextOutlined("SPS CHARGE: " .. ply:Armor() .. "% ::>", "CLCHud1", ScrW() - 10, 58, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
    draw.SimpleTextOutlined("BIOSIGNAL GRID: " .. grid .. " ::>", "CLCHud1", ScrW() - 10, 74, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
    draw.SimpleTextOutlined("BIOSIGNAL ZONE: " .. zone .. " ::>", "CLCHud1", ScrW() - 10, 90, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
    
    if quota then
        draw.SimpleTextOutlined("BEATING QUOTA: " .. quota .. " ::>", "CLCHud1", ScrW() - 10, 109, color_white, TEXT_ALIGN_RIGHT, nil, 1, color_black)
    end

    local y = 16

    if ix.option.Get("showLocalAssets", true) == true then
        local squad = ply:GetSquad() or "NONE"
        draw.SimpleTextOutlined("<:: PATROL TEAM: ".. squad .." //", "CLCHud1", 10, 200, Color( 0,138,216 ), nil, nil, 1, color_black)

        for k, v in pairs(player.GetAll()) do
            if (v:Team() == FACTION_CCA and v:GetNetVar("squad")) and (ply:Team() == FACTION_CCA) then

                if not v:Alive() then
                    squad = "<BIOSIGNAL LOST>"
                end

                draw.SimpleTextOutlined("<:: UNIT: " .. string.upper(v:Nick()), "CLCHud1", 10, 210 + y, color_white, nil, nil, 1, color_black)
                y = y + 16
            elseif (v:Team() == FACTION_OTA) and (ply:Team() == FACTION_OTA) then
                local health = v:Health() .. "%"

                if not v:Alive() then
                    health = "<BIOSIGNAL LOST>"
                end

                draw.SimpleTextOutlined("<:: UNIT: " .. string.upper(v:Nick()), "CLCHud1", 10, 210 + y, color_white, nil, nil, 1, color_black)
                draw.SimpleTextOutlined(" | VITALS: " .. v:Health(), "CLCHud1", 250, 210 + y, color_white, nil, nil, 1, color_black)
                y = y + 16
            end
        end
    end

    if IsValid(ply:GetActiveWeapon()) and combatWeapons[ply:GetActiveWeapon():GetClass()] then
        local weapon = ply:GetActiveWeapon()
        local weaponName = weapon:GetPrintName()
        local weaponAmmo1 = weapon:Clip1()
        local weaponAmmo2 = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
        local weaponAmmo3 = ply:GetAmmoCount(weapon:GetSecondaryAmmoType())
        local weaponprimarycolor = color_white

        if weaponAmmo1 == 0 then
            weaponAmmo1 = "N/A"
        end

        if weaponAmmo2 == 0 then
            weaponAmmo2 = "N/A"
        end

        if weaponAmmo3 == 0 then
            weaponAmmo3 = "N/A"
        end

        if combatWeapons[weapon:GetClass()] then
            weaponName = combatWeapons[weapon:GetClass()]
        end

        if weapon:Clip1() < weapon:GetMaxClip1() / 4 then
            weaponprimarycolor = Color(255, 0, 0)

            if (ply.nextAmmoWarn or 0) < CurTime() then
                ix.gui.AddCombineDisplayMessage("LOW ON AMMO.. RELOAD.", weaponprimarycolor, true)
                ply.nextAmmoWarn = CurTime() + 20
            end
        end

        draw.SimpleTextOutlined("<:: LOCAL WEAPONRY //", "CLCHud1", ScrW() - 195, 133, Color( 0,138,216 ), nil, nil, 1, color_black)
        draw.SimpleTextOutlined("<:: FIREARM: " .. string.upper(weaponName), "CLCHud1", ScrW() - 195, 155, color_white, nil, nil, 1, color_black)
        draw.SimpleTextOutlined("<:: AM: [ " .. weaponAmmo1 .. " ] / [ " .. weaponAmmo2 .. " ]", "CLCHud1", ScrW() - 195, 177, weaponprimarycolor, nil, nil, 1, color_black)
    end
end

local function DrawEffects(ply, char)
    surface.SetDrawColor(Color(255, 0, 0, 0))

    if ply:Health() <= 80 then
        surface.SetDrawColor(Color(255, 0, 0, 10))
    elseif ply:Health() <= 60 then
        surface.SetDrawColor(Color(255, 0, 0, 20))
    elseif ply:Health() <= 40 then
        surface.SetDrawColor(Color(255, 0, 0, 40))
    elseif ply:Health() <= 20 then
        surface.SetDrawColor(Color(255, 0, 0, 60))
    end

    surface.SetMaterial(Material("willardnetworks/nlrbleedout/bleedout-background.png"))
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

end



function Schema:HUDPaint()
    local ply = LocalPlayer()
    local char = ply:GetCharacter()

    if ply:IsValid() and ply:Alive() and char then
        if (ix.hudEnabled == false) or (ix.CinematicIntro and ply:Alive()) or ply.ixIntroBool or (IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu)) or (hook.Run("ShouldDrawHUDBox") == false) then
            if IsValid(PlayerIcon) then
                PlayerIcon:Remove()
            end

            return false
        end

        DrawEffects(ply, char)


        if ix.option.Get("hudDrawBox", true) or (not ply.ixIntroBool) then
            DrawHud(ply, char)
        end

        if ply:IsCombine() and not (ply.adminHud == true) then
            DrawCombineHud(ply, char)
        end
	else
        if IsValid(PlayerIcon) then
            PlayerIcon:Remove()
        end
    end
end

local letterBoxFade = 0
local letterBoxTitleFade = 0
local letterBoxHoldTime = nil
ix.CinematicholdTime = 10

function Schema:HUDPaintBackground()
    local ply = LocalPlayer()
    local char = ply:GetCharacter()
    local ft = FrameTime()

    if ix.CinematicIntro and ply:Alive() then
        local letterBoxHeight = ScrH() / 8

        if letterBoxHoldTime and letterBoxHoldTime + ix.CinematicholdTime + 4 < CurTime() then
            letterBoxFade = Lerp(ft, letterBoxFade, 0)
            letterBoxTitleFade = Lerp(ft * 4, letterBoxTitleFade, 0)

            if letterBoxFade <= 0.01 then
                ix.CinematicIntro = false
            end
        elseif letterBoxHoldTime and letterBoxHoldTime + ix.CinematicholdTime < CurTime() then
            letterBoxTitleFade = Lerp(ft * 4, letterBoxTitleFade, 0)
        else
            letterBoxFade = Lerp(ft, letterBoxFade, 1)

            if letterBoxFade >= 0.9 then
                letterBoxTitleFade = Lerp(ft, letterBoxTitleFade, 1)
                letterBoxHoldTime = letterBoxHoldTime or CurTime()
            end
        end

        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, ScrW(), letterBoxHeight * letterBoxFade)
        surface.DrawRect(0, (ScrH() - (letterBoxHeight * letterBoxFade)) + 1, ScrW(), letterBoxHeight)
        draw.DrawText(ix.CinematicTitle, "ixTitleFont", 20, ScrH() - ScreenScale(20) * 2, ColorAlpha(color_white, 255 * letterBoxTitleFade))
    else
        letterBoxTitleFade = 0
        letterBoxHoldTime = nil
        end
    end