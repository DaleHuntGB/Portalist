local _, Portalist = ...

Portalist.Data = {}

Portalist.Data.ChallengeModePortals = {
    {
        [1254400]   = true, -- Windrunner Spire
        [1254572]   = true, -- Magisters' Terrace
        [1254559]   = true, -- Maisara Caverns
        [1254563]   = true, -- Nexus-Point Xenas
        [393273]    = true, -- Algeth'ar Academy
        [1254551]   = true, -- Seat of the Triumvirate
        [159898]    = true, -- Skyreach
        [1254555]   = true, -- Pit of Saron
    },
    {
        [1254400] = true, -- Windrunner Spire
        [1254572] = true, -- Magisters' Terrace
        [1254559] = true, -- Maisara Caverns
        [1254563] = true, -- Nexus-Point Xenas
    },
    -- The War Within
    {
        [445443] = true, -- The Rookery
        [445444] = true, -- Priory of the Sacred Flame
        [445441] = true, -- Darkflame Cleft
        [445269] = true, -- The Stonevault
        [445417] = true, -- Ara-Kara, City of Echoes
        [445440] = true, -- Cinderbrew Meadery
        [445414] = true, -- The Dawnbreaker
        [445416] = true, -- City of Threads
        [1216786] = true, -- Operation: Floodgate
        [1237215] = true, -- Eco-Dome Al'dani
    },
    -- Dragonflight
    {
        [393222] = true, -- Uldaman: Legacy of Tyr
        [393279] = true, -- The Azure Vault
        [393262] = true, -- The Nokhud Offensive
        [393276] = true, -- Neltharus
        [393267] = true, -- Brackenhide Hollow
        [393256] = true, -- Ruby Life Pools
        [393273] = true, -- Algeth'ar Academy
        [393283] = true, -- Halls of Infusion
        [424197] = true, -- Dawn of the Infinite
    },
    -- Shadowlands
    {
        [354469] = true, -- Sanguine Depths
        [354466] = true, -- Spires of Ascension
        [354462] = true, -- The Necrotic Wake
        [354465] = true, -- Halls of Atonement
        [354463] = true, -- Plaguefall
        [354464] = true, -- Mists of Tirna Scithe
        [354468] = true, -- De Other Side
        [354467] = true, -- Theater of Pain
        [367416] = true, -- Tazavesh, the Veiled Market
    },
    -- Battle for Azeroth
    {
        [424187] = true, -- Atal'Dazar
        [410071] = true, -- Freehold
        [445418] = UnitFactionGroup("player") == "Alliance", -- Siege of Boralus (Alliance)
        [464256] = UnitFactionGroup("player") == "Horde", -- Siege of Boralus (Horde)
        [410074] = true, -- The Underrot
        [424167] = true, -- Waycrest Manor
        [373274] = true, -- Operation: Mechagon
    },
    -- Legion
    {
        [393766] = true, -- Court of Stars
        [373262] = true, -- Return to Karazhan
        [424153] = true, -- Black Rook Hold
        [424163] = true, -- Darkheart Thicket
        [410078] = true, -- Neltharion's Lair
        [393764] = true, -- Halls of Valor
        [1254551] = true, -- Seat of the Triumvirate
    },
    -- Warlords of Draenor
    {
        [159898] = true, -- Skyreach -- XXX 1254557 was also added, which will be used..?
        [159899] = true, -- Shadowmoon Burial Grounds
        [159900] = true, -- Grimrail Depot
        [159901] = true, -- The Everbloom
        [159896] = true, -- Iron Docks
        [159897] = true, -- Auchindoun
        [159895] = true, -- Bloodmaul Slag Mines
        [159902] = true, -- Upper Blackrock Spire
    },
    -- Mists of Pandaria
    {
        [131206] = true, -- Shado-Pan Monastery
        [131204] = true, -- Temple of the Jade Serpent
        [131205] = true, -- Stormstout Brewery
        [131225] = true, -- Gate of the Setting Sun
        [131222] = true, -- Mogu'shan Palace
        [131231] = true, -- Scarlet Halls
        [131232] = true, -- Scholomance
        [131228] = true, -- Siege of Niuzao Temple
        [131229] = true, -- Scarlet Monastery
    },
    -- Cataclysm
    {
        [424142] = true, -- Throne of the Tides
        [410080] = true, -- The Vortex Pinnacle
        [445424] = true, -- Grim Batol
    },
    -- Wrath of the Lich King
    {
        [1254555] = true, -- Pit of Saron
    },
}

Portalist.Data.ChallengeModePortalsByExpansion = {
    [Portalist.Data.ChallengeModePortals[1]] = "Season 01", -- Current
    [Portalist.Data.ChallengeModePortals[2]] = "Midnight", -- Midnight
    [Portalist.Data.ChallengeModePortals[3]] = "The War Within", -- The War Within
    [Portalist.Data.ChallengeModePortals[4]] = "Dragonflight", -- Dragonflight
    [Portalist.Data.ChallengeModePortals[5]] = "Shadowlands", -- Shadowlands
    [Portalist.Data.ChallengeModePortals[6]] = "Battle for Azeroth", -- Battle for Azeroth
    [Portalist.Data.ChallengeModePortals[7]] = "Legion", -- Legion
    [Portalist.Data.ChallengeModePortals[8]] = "Warlords of Draenor", -- Warlords of Draenor
    [Portalist.Data.ChallengeModePortals[9]] = "Mists of Pandaria", -- Mists of Pandaria
    [Portalist.Data.ChallengeModePortals[10]] = "Cataclysm", -- Cataclysm
    [Portalist.Data.ChallengeModePortals[11]] = "Wrath of the Lich King", -- Wrath of the Lich King
}

Portalist.Data.ChallengeModePortalsByName = {
    [1254400] = "Windrunner Spire",
    [1254572] = "Magisters' Terrace",
    [1254559] = "Maisara Caverns",
    [1254563] = "Nexus-Point Xenas",
    [445443] = "The Rookery",
    [445444] = "Priory of the Sacred Flame",
    [445441] = "Darkflame Cleft",
    [445269] = "The Stonevault",
    [445417] = "Ara-Kara, City of Echoes",
    [445418] = "Siege of Boralus (Alliance)",
    [464256] = "Siege of Boralus (Horde)",
    [445414] = "The Dawnbreaker",
    [445416] = "City of Threads",
    [1216786] = "Operation: Floodgate",
    [1237215] = "Eco-Dome Al'dani",
    [393222] = "Uldaman: Legacy of Tyr",
    [393279] = "The Azure Vault",
    [393262] = "The Nokhud Offensive",
    [393276] = "Neltharus",
    [393267] = "Brackenhide Hollow",
    [393256] = "Ruby Life Pools",
    [393273] = "Algeth'ar Academy",
    [393283] = "Halls of Infusion",
    [424197] = "Dawn of the Infinite",
    [354469] = "Sanguine Depths",
    [354466] = "Spires of Ascension",
    [354462] = "The Necrotic Wake",
    [354465] = "Halls of Atonement",
    [354463] = "Plaguefall",
    [354464] = "Mists of Tirna Scithe",
    [354468] = "De Other Side",
    [354467] = "Theater of Pain",
    [367416] = "Tazavesh, the Veiled Market",
    [424187] = "Atal'Dazar",
    [410071] = "Freehold",
    [410074] = "The Underrot",
    [424167] = "Waycrest Manor",
    [373274] = "Operation: Mechagon",
    [393766] = "Court of Stars",
    [373262] = "Return to Karazhan",
    [424153] = "Black Rook Hold",
    [424163] = "Darkheart Thicket",
    [410078] = "Neltharion's Lair",
    [393764] = "Halls of Valor",
    [1254551] = "Seat of the Triumvirate",
    [159898] = "Skyreach",
    [159899] = "Shadowmoon Burial Grounds",
    [159900] = "Grimrail Depot",
    [159901] = "The Everbloom",
    [159896] = "Iron Docks",
    [159897] = "Auchindoun",
    [159895] = "Bloodmaul Slag Mines",
    [159902] = "Upper Blackrock Spire",
    [131206] = "Shado-Pan Monastery",
    [131204] = "Temple of the Jade Serpent",
    [131205] = "Stormstout Brewery",
    [131225] = "Gate of the Setting Sun",
    [131222] = "Mogu'shan Palace",
    [131231] = "Scarlet Halls",
    [131232] = "Scholomance",
    [131228] = "Siege of Niuzao Temple",
    [131229] = "Scarlet Monastery",
    [424142] = "Throne of the Tides",
    [410080] = "The Vortex Pinnacle",
    [445424] = "Grim Batol",
    [1254555] = "Pit of Saron",
    [445440] = "Cinderbrew Meadery",
}

Portalist.Data.CurrentSeason = {
    [1254400] = "Windrunner Spire",
    [1254572] = "Magisters' Terrace",
    [1254559] = "Maisara Caverns",
    [1254563] = "Nexus-Point Xenas",
    [393273] = "Algeth'ar Academy",
    [1254551] = "Seat of the Triumvirate",
    [159898] = "Skyreach",
    [1254555] = "Pit of Saron",
}

Portalist.Data.Hearthstones = {
	[54452] = true,
	[64488] = true,
	[93672] = true,
	[142542] = true,
	[162973] = true,
	[163045] = true,
	[165669] = true,
	[165670] = true,
	[165802] = true,
	[166746] = true,
	[166747] = true,
	[168907] = true,
	[172179] = true,
	[188952] = true,
	[190196] = true,
	[190237] = true,
	[193588] = true,
	[200630] = true,
	[206195] = true,
	[208704] = true,
	[209035] = true,
	[212337] = true,
	[228940] = true,
	[235016] = true,
	[236687] = true,
	[245970] = true,
	[246565] = true,
	[257736] = true,
	[263489] = true,
	[263933] = true,
	[265100] = true,
    [253629] = true,
    [140192] = true,
    [110560] = true,
}

Portalist.Data.Wormholes = {
    [18984] = true,
	[18986] = true,
	[30542] = true,
	[30544] = true,
	[48933] = true,
	[87215] = true,
	[112059] = true,
	[151652] = true,
	[168807] = true,
	[168808] = true,
	[172924] = true,
	[198156] = true,
	[221966] = true,
	[248485] = true,
}

Portalist.Data.WormholesByName = {
    [18984] = "Everlook",
	[18986] = "Gadgetzan",
	[30542] = "Area 52",
	[30544] = "Blade's Edge",
	[48933] = "Northrend",
	[87215] = "Pandaria",
	[112059] = "Draenor",
	[151652] = "Argus",
	[168807] = "Kul Tiras",
	[168808] = "Zandalar",
	[172924] = "Shadowlands",
	[198156] = "Dragon Isles",
	[221966] = "Khaz Algar",
	[248485] = "Quel'Thalas",
}

Portalist.Data.Portals = {
    [446534] = true,
    [1259194] = true,
    [395289] = true,
    [344597] = true,
    [11419] = true,
    [32266] = true,
    [11416] = true,
    [11417] = true,
    [32267] = true,
    [10059] = true,
    [49360] = true,
    [11420] = true,
    [11418] = true,
    [120146] = true,
    [53142] = true,
    [281402] = true,
    [224871] = true,
    [33691] = true,
    [35717] = true,
    [49361] = true,
    [176246] = true,
    [88345] = true,
    [88346] = true,
    [132620] = true,
    [132626] = true,
    [176244] = true
}

Portalist.Data.PortalByName = {
    [132620] = "Vale of Eternal Blossoms",
    [32266] = "Exodar",
    [32267] = "Silvermoon (Burning Crusade)",
    [33691] = "Shattrath",
    [10059] = "Stormwind",
    [176246] = "Stormshield",
    [11418] = "Undercity",
    [88346] = "Tol Barad",
    [120146] = "Dalaran - Ancient",
    [281402] = "Dazar'alor",
    [49360] = "Theramore",
    [11417] = "Orgrimmar",
    [395289] = "Valdrakken",
    [35717] = "Shattrath",
    [446534] = "Dornogal",
    [344597] = "Oribos",
    [53142] = "Dalaran - Northrend",
    [224871] = "Dalaran - Broken Isles",
    [1259194] = "Silvermoon City",
    [11419] = "Darnassus",
    [176244] = "Warspear",
    [49361] = "Stonard",
    [88345] = "Tol Barad",
    [11420] = "Thunder Bluff",
    [132626] = "Vale of Eternal Blossoms",
    [11416] = "Ironforge",
}

Portalist.Data.Mailboxes = {
    [194885] = true,
    [156833] = true,
    [264695] = true,
    [40768] = true,
}

function Portalist:CreateDisplayName(spellID, isSpell)
    if isSpell then
        local spellData = C_Spell.GetSpellInfo(spellID)
        if spellData then
            local spellName = Portalist.Data.ChallengeModePortalsByName[spellID] or Portalist.Data.PortalByName[spellID] or spellData.name
            return spellName
        end
    else
        local itemName = Portalist.Data.WormholesByName[spellID] or select(1, C_Item.GetItemInfo(spellID))
        if itemName then return itemName end
    end
end

function Portalist:IsLearnt(spellID, isSpell)
    if isSpell then
        return C_SpellBook.IsSpellKnown(spellID)
    else
        return PlayerHasToy(spellID)
    end
end

function Portalist:FetchTooltipInformation(parent, spellID, isSpell)
    GameTooltip:SetOwner(parent, "ANCHOR_CURSOR")
    if isSpell then
        GameTooltip:SetSpellByID(spellID)
    else
        GameTooltip:SetToyByItemID(spellID)
    end
    GameTooltip:Show()
end

function Portalist:IsSpellUsable(spellID)
    local isUsable = C_Spell.IsSpellUsable(spellID) and Portalist:IsLearnt(spellID, true)
    return isUsable
end

function Portalist:IsItemUsable(itemID)
    local isUsable = C_ToyBox.IsToyUsable(itemID) and Portalist:IsLearnt(itemID, false)
    return isUsable
end

function Portalist:GenerateDropdownData()
    local DropdownData = {}

    for spellID, isActive in pairs(Portalist.DB.global.ChallengeModePortals) do
        if isActive and Portalist:IsSpellUsable(spellID) then
            table.insert(DropdownData, { ID = spellID, name = Portalist:CreateDisplayName(spellID, true), isSpell = true, sortOrder = 2 })
        end
    end

    for portalID, isActive in pairs(Portalist.DB.global.Portals) do
        if isActive and Portalist:IsSpellUsable(portalID) then
            table.insert(DropdownData, { ID = portalID, name = Portalist:CreateDisplayName(portalID, true), isSpell = true, sortOrder = 5 })
        end
    end

    for itemID, isActive in pairs(Portalist.DB.global.Hearthstones) do
        if isActive and Portalist:IsItemUsable(itemID) then
            table.insert(DropdownData, { ID = itemID, name = Portalist:CreateDisplayName(itemID, false), isSpell = false, sortOrder = 1 })
        end
    end

    for wormholeID, isActive in pairs(Portalist.DB.global.Wormholes) do
        if isActive and Portalist:IsItemUsable(wormholeID) then
            table.insert(DropdownData, { ID = wormholeID, name = Portalist:CreateDisplayName(wormholeID, false), isSpell = false, sortOrder = 3 })
        end
    end

    for mailBoxID, isActive in pairs(Portalist.DB.global.Mailboxes) do
        if isActive and Portalist:IsItemUsable(mailBoxID) then
            table.insert(DropdownData, { ID = mailBoxID, name = Portalist:CreateDisplayName(mailBoxID, false), isSpell = false, sortOrder = 4 })
        end
    end

    table.sort(DropdownData, function(a, b)
        if a.sortOrder ~= b.sortOrder then
            return a.sortOrder < b.sortOrder
        end
        return a.name < b.name
    end)

    Portalist.DropdownData = DropdownData
end
