local PLUGIN = PLUGIN

PLUGIN.name = "City Codes"
PLUGIN.author = "Riggs Mackay"
PLUGIN.description = "City Codes for Lite Network, used from Overlord Community."

ix.util.Include("sv_plugin.lua")

ix.cityCodes = {
    [0] = {"PRESERVED", Color( 0,138,216 ), "Civil"},
    [1] = {"MARGINAL", Color(223, 195, 33), "Civil Unrest"},
    [2] = {"FRACTURED", Color(128, 0, 0), "City Turmoil"},
    [3] = {"RE-ADMINISTRATION IN PROGRESS", Color(150, 150, 150), "Judgement Waiver"},
    [4] = {"CODE VOID", Color(50, 50, 50), "Autonomous Judgement"},
}

local cityCodes = {
	["blue"] = 0,
	["yellow"] = 1,
	["red"] = 2,
	["white"] = 3,
	["gray"] = 4,
}

ix.command.Add("ChangeCityCode", {
	description = "Change the current civic politistabilization index. (blue, yellow, red, white, gray)",
	syntax = ix.type.string,
	OnRun = function(self, ply, status)
		if not (ply:IsCombineCommand() or ply:IsAdmin() or ply:IsGamemaster() or ply:IsMod() or ply:IsDispatch() ) then
			ply:Notify("You can't change the city codes, only commanders can do it.")
			return false
		end

		for code, id in pairs(cityCodes) do
			if (status[1] == code) then
				ix.config.Set("cityCode", id)
			end
		end

		if (status[1] == "white") then -- Judgement Waiver
			if not ( GetGlobalBool("ixJWStatus") == true ) then
				PLUGIN:JudgementWaiverStart()

				if ( GetGlobalBool("ixCTStatus") == true ) then
					PLUGIN:CityTurmoilStop()
				end
				
				if ( GetGlobalBool("ixAJStatus") == true ) then
					timer.Simple(10, function()
						PLUGIN:AutonomousJudgementStop()
					end)
				end
			end
		elseif (status[1] == "gray") then -- Autonomous Judgement
			if ( GetGlobalBool("ixJWStatus") == true ) then
				PLUGIN:JudgementWaiverStopSilent()
			end

			if ( GetGlobalBool("ixCTStatus") == true ) then
				PLUGIN:CityTurmoilStop()
			end

			if not ( GetGlobalBool("ixAJStatus") == true ) then
				PLUGIN:AutonomousJudgementStart()
			end
		elseif (status[1] == "red") then -- City Turmoil
			if not ( GetGlobalBool("ixCTStatus") == true ) then
				PLUGIN:CityTurmoilStart()
				
				if ( GetGlobalBool("ixJWStatus") == true ) then
					PLUGIN:JudgementWaiverStop()
				end
				
				if ( GetGlobalBool("ixAJStatus") == true ) then
					timer.Simple(10, function()
						PLUGIN:AutonomousJudgementStop()
					end)
				end
			end
		elseif (status[1] == "yellow") then -- City Unrest
			if not ( GetGlobalBool("ixCUStatus") == true ) then
				PLUGIN:CivilUnrestStart()
				
				if ( GetGlobalBool("ixJWStatus") == true ) then
					PLUGIN:JudgementWaiverStop()
				end

				if ( GetGlobalBool("ixCTStatus") == true ) then
					PLUGIN:CityTurmoilStop()
				end
				
				if ( GetGlobalBool("ixAJStatus") == true ) then
					timer.Simple(10, function()
						PLUGIN:AutonomousJudgementStop()
					end)
				end
			end
		else -- Disable Everything if it is on..
			if ( GetGlobalBool("ixJWStatus") == true ) then
				PLUGIN:JudgementWaiverStop()
			end

			if ( GetGlobalBool("ixAJStatus") == true ) then
				PLUGIN:AutonomousJudgementStop()
			end

			if ( GetGlobalBool("ixCTStatus") == true ) then
				PLUGIN:CityTurmoilStop()
			end

			if ( GetGlobalBool("ixCUStatus") == true ) then
			    PLUGIN:CivilUnrestStop()
			end
		end
	end
})
