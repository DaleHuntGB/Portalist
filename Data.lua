local _, Portality = ...

Portality.Data = {}

Portality.Data.ChallengeModePortals = {
    -- Midnight
    {
        [1254400] = true, -- Windrunner Spire
        [1254572] = true, -- Magisters' Terrace
        --[2813] = , -- Murder Row
        --[2825] = , -- Den of Nalorakk
        --[2859] = , -- The Blinding Vale
        [1254559] = true, -- Maisara Caverns
        [1254563] = true, -- Nexus-Point Xenas
        --[2923] = , -- Voidscar Arena
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
        --[1762] = , -- King's Rest
        --[1864] = , -- Shrine of the Storm
        [445418] = true, -- Siege of Boralus (Alliance)
        [464256] = true, -- Siege of Boralus (Horde)
        --[1771] = , -- Tol Dagor
        [410074] = true, -- The Underrot
        [424167] = true, -- Waycrest Manor
        [373274] = true, -- Operation: Mechagon
    },
    -- Legion
    {
        --[1544] = , -- Assault on Violet Hold
        --[1677] = , -- Cathedral of Eternal Night
        [393766] = true, -- Court of Stars
        [373262] = true, -- Return to Karazhan
        [424153] = true, -- Black Rook Hold
        --[1516] = , -- The Arcway
        [424163] = true, -- Darkheart Thicket
        [410078] = true, -- Neltharion's Lair
        --[1456] = , -- Eye of Azshara
        --[1492] = , -- Maw of Souls
        [393764] = true, -- Halls of Valor
        --[1493] = , -- Vault of the Wardens
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
        --[1112] = , -- Pursuing the Black Harvest
        [131229] = true, -- Scarlet Monastery
    },
    -- Cataclysm
    {
        --[859] = , -- Zul'Gurub
        [424142] = true, -- Throne of the Tides
        --[644] = , -- Halls of Origination
        --[645] = , -- Blackrock Caverns
        --[755] = , -- Lost City of the Tol'vir
        --[725] = , -- The Stonecore
        --[938] = , -- End Time
        --[939] = , -- Well of Eternity
        --[940] = , -- Hour of Twilight
        [410080] = true, -- The Vortex Pinnacle
        [445424] = true, -- Grim Batol
    },
    -- Wrath of the Lich King
    {
        --[576] = , -- The Nexus
        --[578] = , -- The Oculus
        --[608] = , -- Violet Hold
        --[595] = , -- The Culling of Stratholme
        --[619] = , -- Ahn'kahet: The Old Kingdom
        --[604] = , -- Gundrak
        --[574] = , -- Utgarde Keep
        --[575] = , -- Utgarde Pinnacle
        --[602] = , -- Halls of Lightning
        --[601] = , -- Azjol-Nerub
        [1254555] = true, -- Pit of Saron
        --[599] = , -- Halls of Stone
        --[600] = , -- Drak'Tharon Keep
        --[650] = , -- Trial of the Champion
        --[668] = , -- Halls of Reflection
        --[632] = , -- The Forge of Souls
    },
}

Portality.Data.Hearthstones = {
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

function Portality:CreateDisplayName(spellID, isSpell)
    if isSpell then
        local spellData = C_Spell.GetSpellInfo(spellID)
        if spellData then
            local spellName = spellData.name
            local spellTexture = spellData.iconID
            return string.format("|T%s:24:24|t %s", spellTexture, spellName)
        end
    else
        local itemName = select(1, C_Item.GetItemInfo(spellID))
        local itemTexture = select(10, C_Item.GetItemInfo(spellID))
        if itemName and itemTexture then
            return string.format("|T%s:24:24|t %s", itemTexture, itemName)
        end
    end
end

function Portality:IsLearnt(spellID, isSpell)
    if isSpell then
        return C_SpellBook.IsSpellKnown(spellID)
    else
        return PlayerHasToy(spellID)
    end
end

function Portality:GenerateDropdownData()
    local DropdownData = {}
    for spellID, isActive in pairs(Portality.DB.global.ChallengeModePortals) do
        if isActive then
            DropdownData[spellID] = Portality:CreateDisplayName(spellID, true)
        end
    end
    for itemID, isActive in pairs(Portality.DB.global.Hearthstones) do
        if isActive then
            DropdownData[itemID] = Portality:CreateDisplayName(itemID, false)
        end
    end
    Portality.DropdownData = DropdownData
end