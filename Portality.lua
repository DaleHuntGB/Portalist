local _, Portality = ...
local AddOn = LibStub("AceAddon-3.0"):NewAddon("Portality")

function AddOn:OnInitialize()
    Portality.DB = LibStub("AceDB-3.0"):New("PortalityDB", Portality:GetDefaults())
    Portality:CreateOptions()
end

function AddOn:OnEnable()
    Portality:GenerateDropdownData()
    SLASH_PORTALITY1 = "/portality"
    SLASH_PORTALITY2 = "/port"
    SlashCmdList["PORTALITY"] = function() Portality:CreateGUI() end
end