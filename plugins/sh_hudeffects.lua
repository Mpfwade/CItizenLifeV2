local PLUGIN = PLUGIN

if SERVER then
    return -- This script should only run on the client
end

hook.Add("RenderScreenspaceEffects", "HudEffects", function()
    if LocalPlayer():Team() == FACTION_VORTIGAUNT then
        DrawSobel(1)
    end

    if LocalPlayer():Team() == FACTION_CCA then
        DrawSharpen(1, 1)
    end
end)


ix.config.Add("enableHaloEffects", true, "Whether to enable halo effects for doors and items.", nil, {
    category = "Halo Effects"
})

ix.option.Add("enableHaloEffects", ix.type.bool, true, {
    category = "Halo Effects"
})

function PLUGIN:PreDrawHalos()
    if not ix.config.Get("enableHaloEffects", true) then
        return -- Halo effects are disabled
    end

    if not ix.option.Get("enableHaloEffects", true) then
        return -- Halo effects are disabled
    end

    local trace = LocalPlayer():GetEyeTrace()
    local ent = trace.Entity

    local doorTrace = LocalPlayer():GetEyeTrace().Entity
    if IsValid(doorTrace) and doorTrace:IsDoor() and doorTrace:GetPos():Distance(LocalPlayer():GetPos()) < 110 then
        halo.Add({doorTrace}, Color(255, 255, 255), 2, 2, 2, true, true)
    elseif IsValid(ent) and ent:GetClass() == "ix_item" and ent:GetPos():Distance(LocalPlayer():GetPos()) < 95 then
        halo.Add({ent}, Color(255, 255, 255), 2, 2, 2, true, true)
    end
end