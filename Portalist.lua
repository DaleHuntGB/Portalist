local _, Portalist = ...
local AddOn = LibStub("AceAddon-3.0"):NewAddon("Portalist")

function AddOn:OnInitialize()
    Portalist.DB = LibStub("AceDB-3.0"):New("PortalistDB", Portalist:GetDefaults())
end

function AddOn:OnEnable()
    Portalist:GenerateDropdownData()
    SLASH_PORTALIST1 = "/portalist"
    SLASH_PORTALIST2 = "/port"
    SlashCmdList["PORTALIST"] = function() Portalist:CreateGUI() end

    print("|cFF8080FFPortalist|r: '|cFF8080FF/portalist|r' or '|cFF8080FF/port|r' to open the configuration menu.")
end