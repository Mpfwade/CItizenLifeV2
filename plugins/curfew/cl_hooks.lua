local PLUGIN = PLUGIN
local sW = ScrW()

function PLUGIN:HUDPaint(ply )
    local font = "CLCHud1"
    local ply = LocalPlayer()

    -- Compatibility with one of my other plugins
    if ix.plugin.Get("chud") then
        font = "CLCHud1"
    end

    if LocalPlayer():IsCombine() then
        draw.SimpleTextOutlined("<:: CURRENT ASSIGNMENT: " .. self:GetEvent().. " ::>", font, sW / 2, 65, Color( 0,138,216 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0,0,0 ))
    end
end

-- Don't know who would change their screen size while in game but you never know
function PLUGIN:OnScreenSizeChanged()
    sW = ScrW()
end