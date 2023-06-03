local PLUGIN = PLUGIN

function InventoryAction(action, itemID, invID, data)
    net.Start("ixInventoryAction")
    net.WriteString(action)
    net.WriteUInt(itemID, 32)
    net.WriteUInt(invID, 32)
    net.WriteTable(data or {})
    net.SendToServer()
end

hook.Add("CreateMenuButtons", "ixInventory", function(tabs)
    if hook.Run("CanPlayerViewInventory") == false then return end

    tabs["inv"] = {
        bDefault = true,
        Create = function(info, container)
            local w, h = container:GetSize()
            local ply = LocalPlayer()
            local character = ply:GetCharacter()
            local items = ply:GetCharacter():GetInventory():GetItems()
            local inventory = ply:GetCharacter():GetInventory():GetID()
            local carry = character:GetData("carry", 0)
            local color = ix.config.Get("color")
            local maxWeight = ix.config.Get("maxWeight", 30)
            local canvas = container:Add("DTileLayout")
            local canvasLayout = canvas.PerformLayout
            container.categories = {}
            container.list = container:Add("DScrollPanel")
            container.list:Dock(FILL)
            container.list:SetPaintBackground(true)

            for class, itemTable in SortedPairs(items, "category") do
                local category = itemTable.category
                local category2 = string.lower(category)

                if not container.categories[category2] then
                    local category3 = container.list:Add("DCollapsibleCategory")
                    category3:Dock(TOP)
                    category3:SetLabel(category)
                    category3:DockMargin(5, 45, 5, 5)
                    category3:SetPadding(5)
                    local list = vgui.Create("DIconLayout")

                    list.Paint = function(this, w, h)
                        surface.SetDrawColor(0, 0, 0, 25)
                        surface.DrawRect(0, 0, w, h)
                    end

                    category3:SetContents(list)
                    local icon = list:Add("SpawnIcon")
                    icon:SetModel(Model(itemTable.model or "models/props_lab/box01a.mdl"))

                    icon.PaintOver = function(this, w, h)
                        surface.SetDrawColor(0, 0, 0, 45)
                        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
                    end

                    icon.DoClick = function(panel)
                        icon.disabled = true
                        icon:SetAlpha(70)

                        timer.Simple(1, function()
                            if IsValid(icon) then
                                icon.disabled = false
                                icon:SetAlpha(255)
                            end
                        end)
                    end

                    icon.DoClick = function(panel)
                        if class ~= itemTable:GetID() then return end
                        if icon.disabled then return end
                        icon.disabled = true
                        icon:SetAlpha(70)
                        if class ~= itemTable:GetID() then return end
                        itemTable.player = ply
                        local menu = DermaMenu()

                        for k, v in SortedPairs(itemTable.functions) do
                            if k == "drop" or k == "combine" or (v.OnCanRun and v.OnCanRun(itemTable) == false) then continue end

                            -- is Multi-Option Function
                            if v.isMulti then
                                local subMenu, subMenuOption = menu:AddSubMenu(L(v.name or k), function()
                                    itemTable.player = ply
                                    local send = true

                                    if v.OnClick then
                                        send = v.OnClick(itemTable)
                                    end

                                    if v.sound then
                                        surface.PlaySound(v.sound)
                                    end

                                    if send ~= false then
                                        InventoryAction(k, itemTable.id, inventory)
                                        icon:Remove()
                                    end

                                    itemTable.player = nil
                                end)

                                subMenuOption:SetImage(v.icon or "icon16/brick.png")

                                if v.multiOptions then
                                    local options = isfunction(v.multiOptions) and v.multiOptions(itemTable, ply) or v.multiOptions

                                    for _, sub in pairs(options) do
                                        subMenu:AddOption(L(sub.name or "subOption"), function()
                                            itemTable.player = ply
                                            local send = true

                                            if sub.OnClick then
                                                send = sub.OnClick(itemTable)
                                            end

                                            if sub.sound then
                                                surface.PlaySound(sub.sound)
                                            end

                                            if send ~= false then
                                                InventoryAction(k, itemTable.id, inventory, sub.data)
                                                icon:Remove()
                                            end

                                            itemTable.player = nil
                                        end)
                                    end
                                end
                            else
                                menu:AddOption(L(v.name or k), function()
                                    itemTable.player = ply + nil
                                    send = true

                                    if v.OnClick then
                                        send = v.OnClick(itemTable)
                                    end

                                    if v.sound then
                                        surface.PlaySound(v.sound)
                                    end

                                    if send ~= false then
                                        InventoryAction(k, itemTable.id, inventory)
                                        icon:Remove()
                                    end

                                    itemTable.player = nil
                                end):SetImage(v.icon or "icon16/brick.png")
                            end
                        end

                        -- we want drop to show up as the last option
                        local info = itemTable.functions.drop

                        if info and info.OnCanRun and info.OnCanRun(itemTable) ~= false then
                            menu:AddOption(L(info.name or "drop"), function()
                                itemTable.player = ply
                                local send = true

                                if info.OnClick then
                                    send = info.OnClick(itemTable)
                                end

                                if info.sound then
                                    surface.PlaySound(info.sound)
                                end

                                if send ~= false then
                                    InventoryAction("drop", itemTable.id, inventory)
                                    icon:Remove()
                                end

                                itemTable.player = nil
                            end):SetImage(info.icon or "icon16/brick.png")
                        end

                        menu:Open()
                        itemTable.player = nil

                        timer.Simple(1, function()
                            if IsValid(icon) then
                                icon.disabled = false
                                icon:SetAlpha(255)
                            end
                        end)
                    end

                    category3:InvalidateLayout(true)

                    container.categories[category2] = {
                        list = list,
                        category = category3,
                        panel = panel
                    }
                else
                    local list = container.categories[category2].list
                    local icon = list:Add("SpawnIcon")
                    icon:SetModel(itemTable.model or "models/props_lab/box01a.mdl")

                    icon.PaintOver = function(this, w, h)
                        surface.SetDrawColor(0, 0, 0, 45)
                        surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
                    end

                    icon.DoClick = function(panel)
                        if class ~= itemTable:GetID() then return end
                        if icon.disabled then return end
                        icon.disabled = true
                        icon:SetAlpha(70)
                        if class ~= itemTable:GetID() then return end
                        itemTable.player = ply
                        local menu = DermaMenu()

                        for k, v in SortedPairs(itemTable.functions) do
                            if k == "drop" or k == "combine" or (v.OnCanRun and v.OnCanRun(itemTable) == false) then continue end

                            -- is Multi-Option Function
                            if v.isMulti then
                                local subMenu, subMenuOption = menu:AddSubMenu(L(v.name or k), function()
                                    itemTable.player = ply
                                    local send = true

                                    if v.OnClick then
                                        send = v.OnClick(itemTable)
                                    end

                                    if v.sound then
                                        surface.PlaySound(v.sound)
                                    end

                                    if send ~= false then
                                        InventoryAction(k, itemTable.id, inventory)
                                        icon:Remove()
                                    end

                                    itemTable.player = nil
                                end)

                                subMenuOption:SetImage(v.icon or "icon16/brick.png")

                                if v.multiOptions then
                                    local options = isfunction(v.multiOptions) and v.multiOptions(itemTable, ply) or v.multiOptions

                                    for _, sub in pairs(options) do
                                        subMenu:AddOption(L(sub.name or "subOption"), function()
                                            itemTable.player = ply
                                            local send = true

                                            if sub.OnClick then
                                                send = sub.OnClick(itemTable)
                                            end

                                            if sub.sound then
                                                surface.PlaySound(sub.sound)
                                            end

                                            if send ~= false then
                                                InventoryAction(k, itemTable.id, inventory, sub.data)
                                                icon:Remove()
                                            end

                                            itemTable.player = nil
                                        end)
                                    end
                                end
                            else
                                menu:AddOption(L(v.name or k), function()
                                    itemTable.player = ply + nil
                                    send = true

                                    if v.OnClick then
                                        send = v.OnClick(itemTable)
                                    end

                                    if v.sound then
                                        surface.PlaySound(v.sound)
                                    end

                                    if send ~= false then
                                        InventoryAction(k, itemTable.id, inventory)
                                        icon:Remove()
                                    end

                                    itemTable.player = nil
                                end):SetImage(v.icon or "icon16/brick.png")
                            end
                        end

                        -- we want drop to show up as the last option
                        local info = itemTable.functions.drop

                        if info and info.OnCanRun and info.OnCanRun(itemTable) ~= false then
                            menu:AddOption(L(info.name or "drop"), function()
                                itemTable.player = ply
                                local send = true

                                if info.OnClick then
                                    send = info.OnClick(itemTable)
                                end

                                if info.sound then
                                    surface.PlaySound(info.sound)
                                end

                                if send ~= false then
                                    InventoryAction("drop", itemTable.id, inventory)
                                    icon:Remove()
                                end

                                itemTable.player = nil
                            end):SetImage(info.icon or "icon16/brick.png")
                        end

                        menu:Open()
                        itemTable.player = nil

                        timer.Simple(1, function()
                            if IsValid(icon) then
                                icon.disabled = false
                                icon:SetAlpha(255)
                            end
                        end)
                    end
                end
            end

            local weightPanel = container:Add("DPanel")
            weightPanel:SetPos(5, 10)
            weightPanel:SetSize(w - 15, 24)
            local weightBar = weightPanel:Add("DPanel")
            weightBar:SetSize(w - 5, 24) -- Adjusted size to match weightPanel

            weightBar.Paint = function(container)
                surface.SetDrawColor(color)
                surface.DrawRect(4, 4, math.min(((w - 3) / maxWeight) * carry, w - 3), 16) -- Adjusted position and size
            end

            local weightOverflowBar = weightPanel:Add("DPanel")
            weightOverflowBar:SetSize(w, 24) -- Adjusted size to match weightPanel

            weightOverflowBar.Paint = function(container)
                surface.SetDrawColor(Color(205, 50, 50))

                if carry > maxWeight then
                    surface.DrawRect(4, 4, math.min(((w - 3) / maxWeight) * (carry - maxWeight), w - 3), 16) -- Adjusted position and size
                end
            end

            local weightText = weightPanel:Add("DLabel")
            weightText:SetSize(w, 24)
            weightText:SetContentAlignment(5)

            weightText.Think = function()
                carry = character:GetData("carry", 0)

                if ix.option.Get("imperial", false) then
                    weightText:SetText(math.Round(carry * 2.20462, 2) .. " lbs / " .. math.Round(maxWeight * 2.20462, 2) .. " lbs")
                else
                    weightText:SetText(math.Round(carry, 2) .. " kg / " .. maxWeight .. " kg")
                end
            end
        end
    }
end)