Schema.name = "CitizenLife"
Schema.author = "Wade"
Schema.description = "A base schema for development."
ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("cl_fonts.lua")
ix.util.Include("sh_chat.lua")
ix.util.Include("sh_commands.lua")
ix.util.Include("sh_settings.lua")
ix.ranks = ix.ranks or {}
ix.divisions = ix.divisions or {}
ix.util.IncludeDir("divisions")
ix.util.IncludeDir("meta")
ix.util.IncludeDir("voicelines")

ix.moreItemsTable = {
    ["damagedcpvest"] = {
        ["name"] = "Damaged Civil Protection Vest",
        ["description"] = "A damaged Civil Protection vest, can be turned into a resistance shirt.",
        ["model"] = "models/tnb/items/shirt_rebelmetrocop.mdl",
        ["skin"] = 1,
        ["width"] = 2,
        ["height"] = 2,
        ["price"] = 105,
    },
}

for k, v in pairs(ix.moreItemsTable) do
    local ITEM = ix.item.Register(k, nil, false, nil, true)
    ITEM.name = v.name or "An Undefined Name, please configue items.lua in the plugins folder."
    ITEM.description = v.description or "An Undefined Description, please configue items.lua in the plugins folder."
    ITEM.model = v.model or "models/hunter/plates/plate025x025.mdl"
    ITEM.skin = v.skin or 0
    ITEM.width = v.width or 1
    ITEM.height = v.height or 1
    ITEM.price = v.price or 10
    ITEM.category = "Items"
    ITEM.noBusiness = true

    function ITEM:GetDescription()
        return self.description
    end

    function ITEM:PopulateTooltip(tooltip)
        local illitem = tooltip:AddRow("illitem")
        illitem:SetBackgroundColor(Color(255, 0, 0))
        illitem:SetText("69, possession of resources (CONTRABAND).")
        illitem:SetFont("DermaDefault")
        illitem:SetExpensiveShadow(0.5)
        illitem:SizeToContents()
    end
end

ix.char.RegisterVar("description", {
    bNoDisplay = false,
    bHidden = {
        FACTION_CCA = true
    },
    field = "description",
    fieldType = ix.type.text,
    default = "",
    index = 2,
    OnValidate = function(self, value, payload)
        value = string.Trim(tostring(value):gsub("\r\n", ""):gsub("\n", ""))
        local minLength = ix.config.Get("minDescriptionLength", 16)

        if value:utf8len() < minLength then
            return false, "descMinLen", minLength
        elseif not value:find("%s+") or not value:find("%S") then
            return false, "invalid", "description"
        end

        return value
    end,
    OnPostSetup = function(self, panel, payload)
        panel:SetMultiline(true)
        panel:SetFont("ixMenuButtonFont")
        panel:SetTall(panel:GetTall() * 2 + 6) -- add another line

        panel.AllowInput = function(_, character)
            if character == "\n" or character == "\r" then return true end
        end
    end,
    alias = "Desc"
})

ix.char.RegisterVar("attributes", {
    bNoDisplay = true,
    field = "attributes",
    fieldType = ix.type.text,
    default = {},
    index = 4,
    category = "attributes",
    isLocal = true,
    OnDisplay = function(self, container, payload)
        local maximum = hook.Run("GetDefaultAttributePoints", LocalPlayer(), payload) or 10
        if maximum < 1 then return end
        local attributes = container:Add("DPanel")
        attributes:Dock(TOP)
        local y
        local total = 0
        payload.attributes = {}
        -- total spendable attribute points
        local totalBar = attributes:Add("ixAttributeBar")
        totalBar:SetMax(maximum)
        totalBar:SetValue(maximum)
        totalBar:Dock(TOP)
        totalBar:DockMargin(2, 2, 2, 2)
        totalBar:SetText(L("attribPointsLeft"))
        totalBar:SetReadOnly(true)
        totalBar:SetColor(Color(20, 120, 20, 255))
        y = totalBar:GetTall() + 4

        for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
            payload.attributes[k] = 0
            local bar = attributes:Add("ixAttributeBar")
            bar:SetMax(maximum)
            bar:Dock(TOP)
            bar:DockMargin(2, 2, 2, 2)
            bar:SetText(L(v.name))

            bar.OnChanged = function(this, difference)
                if (total + difference) > maximum then return false end
                total = total + difference
                payload.attributes[k] = payload.attributes[k] + difference
                totalBar:SetValue(totalBar.value - difference)
            end

            if v.noStartBonus then
                bar:SetReadOnly()
            end

            y = y + bar:GetTall() + 4
        end

        attributes:SetTall(y)

        return attributes
    end,
    OnValidate = function(self, value, data, client)
        if value ~= nil then
            if istable(value) then
                local count = 0

                for _, v in pairs(value) do
                    count = count + v
                end

                if count > (hook.Run("GetDefaultAttributePoints", client, count) or 10) then return false, "unknownError" end
            else
                return false, "unknownError"
            end
        end
    end,
    ShouldDisplay = function(self, container, payload) return not table.IsEmpty(ix.attributes.list) end
})

ix.char.RegisterVar("model", {
    field = "model",
    fieldType = ix.type.string,
    default = "models/error.mdl",
    index = 3,
    OnSet = function(character, value)
        local client = character:GetPlayer()

        if IsValid(client) and client:GetCharacter() == character then
            client:SetModel(value)
        end

        character.vars.model = value
    end,
    OnGet = function(character, default) return character.vars.model or default end,
    OnDisplay = function(self, container, payload)
        local scroll = container:Add("DScrollPanel")
        scroll:Dock(FILL) -- TODO: don't fill so we can allow other panels

        scroll.Paint = function(panel, width, height)
            derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, Color(255, 255, 255, 25))
        end

        local layout = scroll:Add("DIconLayout")
        layout:Dock(FILL)
        layout:SetSpaceX(1)
        layout:SetSpaceY(1)
        local faction = ix.faction.indices[payload.faction]

        if faction then
            local models = faction:GetModels(LocalPlayer())

            for k, v in SortedPairs(models) do
                local icon = layout:Add("ixSpawnIcon")
                icon:SetSize(ScreenScale(75) / 2, ScreenScale(75))
                icon:InvalidateLayout(true)

                icon.DoClick = function(this)
                    payload:Set("model", k)
                end

                icon.PaintOver = function(this, w, h)
                    if payload.model == k then
                        local color = ix.config.Get("color", color_white)
                        surface.SetDrawColor(color.r, color.g, color.b, 200)

                        for i = 1, 3 do
                            local i2 = i * 2
                            surface.DrawOutlinedRect(i, i, w - i2, h - i2)
                        end
                    end
                end

                if isstring(v) then
                    icon:SetModel(v)
                else
                    icon:SetModel(v[1], v[2] or 0, v[3])
                end

                icon.Entity:SetBodygroup(2, 1)
                icon.Entity:SetBodygroup(3, 1)
            end
        end

        return scroll
    end,
    OnValidate = function(self, value, payload, client)
        local faction = ix.faction.indices[payload.faction]

        if faction then
            local models = faction:GetModels(client)
            if not payload.model or not models[payload.model] then return false, "needModel" end
        else
            return false, "needModel"
        end
    end,
    OnAdjust = function(self, client, data, value, newData)
        local faction = ix.faction.indices[data.faction]

        if faction then
            local model = faction:GetModels(client)[value]

            if isstring(model) then
                newData.model = model
            elseif istable(model) then
                newData.model = model[1]
                -- save skin/bodygroups to character data
                local bodygroups = {}

                for i = 1, #model[3] do
                    bodygroups[i - 1] = tonumber(model[3][i]) or 0
                end

                newData.data = newData.data or {}
                newData.data.skin = model[2] or 0
                newData.data.groups = bodygroups
            end
        end
    end,
    ShouldDisplay = function(self, container, payload)
        local faction = ix.faction.indices[payload.faction]

        return #faction:GetModels(LocalPlayer()) > 1
    end
})

function Schema:ZeroNumber(number, length)
    local amount = math.max(0, length - string.len(number))

    return string.rep("0", amount) .. tostring(number)
end

do
    local CLASS = {}
    CLASS.color = Color(75, 150, 50)
    CLASS.format = "%s calls in \"%s\""

    function CLASS:CanHear(speaker, listener)
        local character = listener:GetCharacter()
        local inventory = character:GetInventory()
        local bHasPhone = false

        for k, v in pairs(inventory:GetItemsByUniqueID("phone", true)) do
            if v:GetData("enabled", false) and speaker:GetCharacter():GetData("frequency") == character:GetData("frequency") then
                bHasPhone = true
                break
            end
        end

        return bHasPhone
    end

    function CLASS:OnChatAdd(speaker, text)
        text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
        chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
    end

    ix.chat.Register("phone", CLASS)
end