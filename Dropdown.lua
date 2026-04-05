local _, Portality = ...

function Portality:UsePortal(spellID)
    local spellData = Portality.DropdownData[spellID]
    if not spellData then return end

    local button = Portality.secureButton

    if spellData.isSpell then
        button:SetAttribute("type", "spell")
        button:SetAttribute("spell", spellID)
    else
        button:SetAttribute("type", "item")
        button:SetAttribute("item", "item:" .. spellID)
    end

    button:Click()
end

local function CreatePortalButton(buttonName, spellData)
    local PortalButton = CreateFrame("Button", buttonName, Portality.DropdownMenu, "SecureActionButtonTemplate, BackdropTemplate")
    PortalButton:SetSize(Portality.DropdownMenu:GetWidth() - 6, 32)
    PortalButton:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    PortalButton:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
    PortalButton:SetBackdropBorderColor(0, 0, 0, 1)

    PortalButton:SetScript("OnEnter", function(self) self:SetBackdropColor(0.3, 0.3, 0.3, 0.8) end)
    PortalButton:SetScript("OnLeave", function(self) self:SetBackdropColor(0.1, 0.1, 0.1, 0.8) end)

    PortalButton:RegisterForClicks("AnyUp", "AnyDown")
    if spellData.isSpell then
        PortalButton:SetAttribute("type", "spell")
        PortalButton:SetAttribute("spell", spellData.ID)
    else
        PortalButton:SetAttribute("type", "item")
        PortalButton:SetAttribute("item", "item:" .. spellData.ID)
    end

    local ButtonText = PortalButton:CreateFontString(nil, "OVERLAY")
    ButtonText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    ButtonText:SetPoint("CENTER", PortalButton, "CENTER", 0, -1)
    ButtonText:SetText(spellData.name)

    return PortalButton
end

function Portality:CreateDropdownMenu()
    local DropdownMenu = CreateFrame("Frame", "PortalityDropdownMenu", UIParent, "BackdropTemplate")
    DropdownMenu:SetSize(300, 600)
    DropdownMenu:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    DropdownMenu:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    DropdownMenu:SetBackdropColor(0, 0, 0, 0.8)
    DropdownMenu:SetBackdropBorderColor(0, 0, 0, 1)
    DropdownMenu:Hide()

    Portality.DropdownMenu = DropdownMenu
    Portality.DropdownMenu.Buttons = {}

    Portality:GenerateDropdownData()

    for index, spellData in ipairs(Portality.DropdownData) do
        local buttonName = "PortalityDropdownButton" .. index
        local PortalButton = CreatePortalButton(buttonName, spellData)
        if index == 1 then
            PortalButton:SetPoint("TOP", DropdownMenu, "TOP", 0, -3)
        else
            PortalButton:SetPoint("TOP", Portality.DropdownMenu.Buttons[index - 1], "BOTTOM", 0, -3)
        end
        table.insert(Portality.DropdownMenu.Buttons, PortalButton)
    end
end

function Portality:RefreshDropdownMenu()
    if not Portality.DropdownMenu then return end
    for _, button in ipairs(Portality.DropdownMenu.Buttons or {}) do button:Hide() button:SetParent(nil) end
    Portality.DropdownMenu.Buttons = {}

    Portality:GenerateDropdownData()

    for index, spellData in ipairs(Portality.DropdownData) do
        local buttonName = "PortalityDropdownButton" .. index
        local PortalButton = CreatePortalButton(buttonName, spellData)
        if index == 1 then
            PortalButton:SetPoint("TOP", Portality.DropdownMenu, "TOP", 0, -3)
        else
            PortalButton:SetPoint("TOP", Portality.DropdownMenu.Buttons[index - 1], "BOTTOM", 0, -3)
        end
        table.insert(Portality.DropdownMenu.Buttons, PortalButton)
    end
end

function Portality:ToggleDropdownMenu()
    if not Portality.DropdownMenu then Portality:CreateDropdownMenu() end
    if Portality.DropdownMenu:IsShown() then Portality.DropdownMenu:Hide() else Portality:RefreshDropdownMenu() Portality.DropdownMenu:Show() end
end

Portality_DropdownMenu = Portality.ToggleDropdownMenu