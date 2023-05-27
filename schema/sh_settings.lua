--[[---------------------------------------------------------------------------
	Helix Base Config
---------------------------------------------------------------------------]]--

ALWAYS_RAISED["swep_construction_kit"] = true
ALWAYS_RAISED["ix_zombie_claws"] = true

ix.config.SetDefault("communityText", "Website")
ix.config.SetDefault("communityURL", "http://lite-network.de")
ix.config.SetDefault("color", Color(200, 75, 25) or color_white)
ix.config.SetDefault("font", "Segoe Ui Light")
ix.config.SetDefault("genericFont", "Segoe Ui")
ix.config.SetDefault("music", "LiteNetwork/hl2rp/music/teaser.ogg")
ix.config.SetDefault("scoreboardRecognition", false)

ix.config.Add("cityCode", 0, "The Current City Code of the City.", nil, {
	data = {
		min = 0,
		max = 4
	},
	category = "Miscellaneous",
})

ix.currency.symbol = "T"
ix.currency.singular = "token"
ix.currency.plural = "tokens"
ix.currency.model = "models/bioshockinfinite/hext_coin.mdl"

ix.vendingItems = {
	{"REGULAR", "water", 15},
	{"SPARKLING", "water_sparkling", 25},
	{"SPECIAL", "water_special", 35}
}

ix.act.Register("Knock", "metrocop", {
    sequence = "adoorknock",
    untimed = true
})

ix.flag.Add("V", "Access to voice chat.")

function Schema:IllegalRow(tooltip)
    local warning = tooltip:AddRow("warning")
    warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
    warning:SetText("// THIS ITEM IS ILLEGAL TO CARRY AROUND, FOUND WITH THIS ITEM CAN CAUSE VIOLATIONS BY UU AUTHORITIES //")
    warning:SetFont("BudgetLabel")
    warning:SetExpensiveShadow(0.5)
    warning:SizeToContents()
end

--[[---------------------------------------------------------------------------
	Helix Base Settings
---------------------------------------------------------------------------]]--

ix.option.Add("hudScreenEffect", ix.type.bool, true)

ix.option.Add("showLocalAssets", ix.type.bool, true, {
	description = "Should the local assets on your Combine Hud show?",
})

ix.lang.AddTable("english", {
	optshowLocalAssets = "Show local Assets?",
    opthudScreenEffect = "Toggle Screen Effect",
    opthudDrawBox = "Toggle Hud Box",
    opthudDrawPlayerInformation = "Toggle Hud Player Information",
})