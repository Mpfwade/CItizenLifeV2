AddCSLuaFile()
ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "Process Term"
ENT.Category = "IX:HL2RP"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AdminOnly = true

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_interiors/printer.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        --self:PhysicsInit(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.health = 50
    end

    function ENT:Think()
        if (self.nextTerminalCheck or 0) < CurTime() then
            self:StopSound("ambient/levels/labs/equipment_printer_loop1.wav")
            self:EmitSound("ambient/levels/labs/equipment_printer_loop1.wav", 50)
            self:StopSound("ambient/levels/labs/equipment_beep_loop1.wav")
            self:EmitSound("ambient/levels/labs/equipment_beep_loop1.wav", 50)
            self.nextTerminalCheck = CurTime() + 10
        end
    end

    function ENT:OnRemove()
        self:StopSound("ambient/levels/labs/equipment_printer_loop1.wav")
        self:StopSound("ambient/levels/labs/equipment_beep_loop1.wav")
    end

    if SERVER then
        util.AddNetworkString("ProcessorActionConfirmation")

        function ENT:Use(user)
            local char = user:GetCharacter()
            local inv = char:GetInventory()

            if user:Team() == FACTION_CITIZEN and inv:HasItem("cp_papers") then
                user:SetAction("Putting paper in...", 1, function()
                    -- Display a warning message on the player's screen
                    net.Start("ProcessorActionConfirmation")
                    net.Send(user)

                    -- Wait for the player's response
                    net.Receive("ProcessorActionConfirmation", function(_, ply)
                        local confirmed = net.ReadBool()

                        if confirmed then
                            net.Start("PlayJobAcceptedSound") -- Send a network message to play the sound on the client
                            net.Send(user)

                            timer.Simple(23.5, function()
                                user:Freeze(false)
                                char:SetFaction(FACTION_CCA)
                                char:SetModel("models/police.mdl")
                                char:SetName("UNRANKED-UNIT")
                                user:SetWhitelisted(FACTION_CCA, true)
                                hook.Run("PlayerLoadout", user)
                                user:ResetBodygroups()

                                for k, v in pairs(char:GetInventory():GetItems()) do
                                    v:Remove()
                                end

                                net.Start("StopJobAcceptedSound") -- Send a network message to stop the sound on the client
                                net.Send(user)

                                timer.Simple(0.30, function()
                                    user:Spawn()
                                    char:SetClass(nil)
                                end)
                            end)
                        else
                            user:ChatPrint("Processing canceled.")
                            user:SelectWeapon("ix_hands")
                            user:Freeze(false)
                            user:SetAction()
                        end
                    end)
                end)

                self:EmitSound("ambient/machines/keyboard7_clicks_enter.wav", 100, 50)
                user:SelectWeapon("ix_hands")
                user:Freeze(true)
            else
                user:ChatPrint("You need acceptance paper to use this terminal.")
            end
        end
    end
else
    surface.CreateFont("panel_font", {
        ["font"] = "verdana",
        ["size"] = 12,
        ["weight"] = 128,
        ["antialias"] = true
    })

    function ENT:Draw()
        self:DrawModel()
        local ang = self:GetAngles() + Angle(180, 0, 0)
        local pos = self:GetPos() + ang:Up() * -10 + ang:Right() * -13 + ang:Forward() * -9.75
        ang:RotateAroundAxis(ang:Forward(), -90)
        cam.Start3D2D(pos, ang, 0.1)
        local width, height = 155, 77
        surface.SetDrawColor(Color(16, 16, 16))
        surface.DrawRect(0, 0, width, height)
        surface.SetDrawColor(Color(255, 255, 255, 16))
        surface.DrawRect(0, height / 2 + math.sin(CurTime() * 4) * height / 2, width, 1)
        local alpha = 191 + 64 * math.sin(CurTime() * 4)

        if not self:GetNetVar("InUse", false) then
            -- Rotate the text drawing operations by 180 degrees
            draw.SimpleText("Processing Terminal", "panel_font", width / 2, height - 25, Color(90, 210, 255, alpha), TEXT_ALIGN_CENTER)
            draw.SimpleText("Waiting for input", "panel_font", width / 2, 16, Color(205, 255, 180, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(LocalPlayer():SteamID64(), "panel_font", 5, height - 36, Color(90, 210, 255, alpha))
            draw.SimpleText("Validating Input...", "panel_font", 5, height - 46, Color(102, 255, 255, alpha))
        end

        cam.End3D2D()
    end
end

if CLIENT then
    net.Receive("PlayJobAcceptedSound", function()
        local user = LocalPlayer()
        user.JobAcceptedMusicPatch = CreateSound(user, "music/hl2_song25_teleporter.mp3")
        user.JobAcceptedMusicPatch:PlayEx(75, 100)
    end)

    net.Receive("StopJobAcceptedSound", function()
        local user = LocalPlayer()

        if user.JobAcceptedMusicPatch then
            user.JobAcceptedMusicPatch:FadeOut(1)
        end
    end)
end