ix.command.Add("datapad", {
	description = "A datapad that shows info on all citizens.",
    OnCheckAccess = function(_, ply) return ply:IsSuperAdmin() or ply:IsAdmin() or ply:Team() == FACTION_CCA end,
	OnRun = function(self, client, target)
        
		netstream.Start(client, "ixViewData", target:GetPlayer(), cid, data)
	end;
})