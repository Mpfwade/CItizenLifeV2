
hook.Add("RenderScreenspaceEffects", "HudEffects", function()

    if LocalPlayer():Team() == FACTION_VORTIGAUNT then
        DrawSobel(1)
    end
         if LocalPlayer():Team() == FACTION_CCA then
            DrawSharpen(1, 1)
         end
    end)