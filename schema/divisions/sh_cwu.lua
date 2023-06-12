ix.divisions.cwu = {}

ix.divisions.cwu[1] = {
    id = 1,
    name = "Unemployed",
    description = [[Name: Unemployed
Description: No Job.]],
    xp = 0,
    class = CLASS_CITIZEN,
    loadout = function(ply)
        ply:SetBodygroup(1, 0)
        ply:SetBodygroup(2, 0)
        ply:SetBodygroup(3, 0)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 0)
        ply:SetBodygroup(6, 0)
        ply:SetBodygroup(7, 0)
        ply:SetBodygroup(8, 0)
        ply:SetBodygroup(9, 0)
        ply:SetBodygroup(10, 0)
        ply:SetBodygroup(11, 0)
        ply:SetBodygroup(12, 0)
        ply:SetBodygroup(13, 0)
    end,
}

ix.divisions.cwu[2] = {
    id = 2,
    name = "Worker",
    description = [[Name: Worker
Description: A Standard City Worker, you are the lowest class job class. You maintain the streets and keep them clean and tidy. Sometimes you'll have to constuct something for the Combine.]],
    xp = 0,
    class = CLASS_CWU_WORKER,
    loadout = function(ply)
        ply:SetBodygroup(1, 7)
    end,
}

ix.divisions.cwu[3] = {
    id = 3,
    name = "Cook",
    description = [[Name: Cook
Description: A Cook, you are capable of handing out food to random civilians whether it may be for tokens or for free.. up to you! Same applies to the Combine. You may open your own store to sell your Food with reasonable prices.]],
    xp = 5,
    class = CLASS_CWU_COOK,
    loadout = function(ply)
        ply:SetBodygroup(1, 1)
        ply:SetBodygroup(2, 3)
        ply.noBusinessAllow = false
    end,
}

ix.divisions.cwu[4] = {
    id = 4,
    name = "Medical Worker",
    description = [[Name: Medical Worker
Description: A Medical Worker, is a job capable of healing civilians or Benefactors whether it be for tokens or for free. You may open up your own Store to sell medical items. Though in Fighting Scenarios you might aswell support the Combine by healing!]],
    xp = 7,
    class = CLASS_CWU_MEDIC,
    loadout = function(ply)
        ply:SetBodygroup(1, 3)
        ply:SetBodygroup(2, 17)
    end,
}

ix.divisions.cwu[5] = {
    id = 5,
    name = "Director",
    description = [[Name: Director
Description: The Director's job is to keep the all the workers in tip top shape, once in a while a City Administrator might come to your doorstep to see how thing's are going. ]],
    xp = 30,
    class = CLASS_CWU_DIRECTOR,
    loadout = function(ply)
        ply:SetBodygroup(1, 37)
        ply:SetBodygroup(2, 19)
    end,
}