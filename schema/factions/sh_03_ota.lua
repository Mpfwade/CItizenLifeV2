--[[ Base Config ]]--

FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = [[Name: Overwatch Transhuman Arm
Description: The Overwatch Transhuman Arm are the military wing of the Universal Union's forces. They are highly trained and extensively modified super soldiers, far stronger than any normal human. They are entirely without fear or emotion of any kind, called on to the streets only when circumstances are at their most dire. Otherwise, they remain in the Nexus or guarding hardpoints around the city. They are completely obedient to their commander, following orders without regard to their own safety. Operating in small squads, the Overwatch Transhuman Arm are a force to be reckoned with, and haunt the dreams of any citizen with common sense.]]
FACTION.color = Color(150, 50, 50)

--[[ Helix Base Config ]]--

FACTION.models = {
	"models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl",
}

FACTION.isGloballyRecognized = true
FACTION.isDefault = false

FACTION.payTime = 600
FACTION.pay = 0

--[[ Custom Config ]]--

FACTION.defaultClass = nil
FACTION.adminOnly = false
FACTION.donatorOnly = false
FACTION.noModelSelection = true
FACTION.command = "ix_faction_become_ota"
FACTION.modelWhitelist = "models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl"

--[[ Plugin Configs ]]--

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true

--[[ Do not change! ]]--

FACTION_OTA = FACTION.index