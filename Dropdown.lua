local _, Portality = ...

local function CreatePortalButton(buttonName, spellData)
    local PortalButton = CreateFrame("Button", buttonName, Portality.DropdownMenu, "SecureActionButtonTemplate, BackdropTemplate")
    PortalButton:SetSize(Portality.DropdownMenu:GetWidth() - 4, 32)
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

    PortalButton:SetScript("PostClick", function() Portality.DropdownMenu:Hide() end)

    local ButtonDurationStatusBar = CreateFrame("StatusBar", nil, PortalButton)
    ButtonDurationStatusBar:SetPoint("TOPLEFT", PortalButton, "TOPLEFT", 1, -1)
    ButtonDurationStatusBar:SetPoint("BOTTOMRIGHT", PortalButton, "BOTTOMRIGHT", -1, 1)
    ButtonDurationStatusBar:SetHeight(30)
    ButtonDurationStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    ButtonDurationStatusBar:SetStatusBarColor(0.5, 0.5, 0.5, 0.8)
    ButtonDurationStatusBar:SetMinMaxValues(0, 1)
    ButtonDurationStatusBar:SetValue(0)

    local ButtonSpellText = ButtonDurationStatusBar:CreateFontString(nil, "OVERLAY")
    ButtonSpellText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    ButtonSpellText:SetPoint("LEFT", PortalButton, "LEFT", 3, 0)
    ButtonSpellText:SetText(spellData.name)

    local ButtonDurationText = ButtonDurationStatusBar:CreateFontString(nil, "OVERLAY")
    ButtonDurationText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    ButtonDurationText:SetPoint("RIGHT", PortalButton, "RIGHT", -3, 0)

    if spellData.isSpell then
        PortalButton:SetScript("OnUpdate", function(self, elapsed)
            local spellCooldown = C_Spell.GetSpellCooldown(spellData.ID)
            if spellCooldown and spellCooldown.startTime > 0 then
                local remainingCooldown = spellCooldown.startTime + spellCooldown.duration - GetTime()
                ButtonDurationText:SetText(string.format("%02d:%02d", math.floor(remainingCooldown / 60), remainingCooldown % 60))
                ButtonDurationStatusBar:SetMinMaxValues(0, spellCooldown.duration)
                ButtonDurationStatusBar:SetValue(remainingCooldown)
            else
                ButtonDurationText:SetText("")
                ButtonDurationStatusBar:SetMinMaxValues(0, 1)
                ButtonDurationStatusBar:SetValue(0)
                PortalButton:SetScript("OnUpdate", nil)
            end
        end)
    else
        PortalButton:SetScript("OnUpdate", function(self, elapsed)
            local itemCooldownStart, itemCooldownDuration = C_Item.GetItemCooldown(spellData.ID)
            if itemCooldownStart and itemCooldownStart > 0 then
                local remainingCooldown = itemCooldownStart + itemCooldownDuration - GetTime()
                ButtonDurationText:SetText(string.format("%02d:%02d", math.floor(remainingCooldown / 60), remainingCooldown % 60))
                ButtonDurationStatusBar:SetMinMaxValues(0, itemCooldownDuration)
                ButtonDurationStatusBar:SetValue(remainingCooldown)
            else
                ButtonDurationText:SetText("")
                ButtonDurationStatusBar:SetMinMaxValues(0, 1)
                ButtonDurationStatusBar:SetValue(0)
                PortalButton:SetScript("OnUpdate", nil)
            end
        end)
    end



    return PortalButton
end

function Portality:CreateDropdownMenu()
    local DropdownMenu = CreateFrame("Frame", "PortalityDropdownMenu", UIParent, "BackdropTemplate")
    DropdownMenu:SetSize(300, 1)
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
            PortalButton:SetPoint("TOP", DropdownMenu, "TOP", 0, -2)
        else
            PortalButton:SetPoint("TOP", Portality.DropdownMenu.Buttons[index - 1], "BOTTOM", 0, -1)
        end
        table.insert(Portality.DropdownMenu.Buttons, PortalButton)
    end

   DropdownMenu:SetSize(300, #Portality.DropdownMenu.Buttons > 0 and #Portality.DropdownMenu.Buttons * 33 + 3 or 1)
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
            PortalButton:SetPoint("TOP", Portality.DropdownMenu, "TOP", 0, -2)
        else
            PortalButton:SetPoint("TOP", Portality.DropdownMenu.Buttons[index - 1], "BOTTOM", 0, -1)
        end
        table.insert(Portality.DropdownMenu.Buttons, PortalButton)
    end

        Portality.DropdownMenu:SetHeight(#Portality.DropdownMenu.Buttons > 0 and #Portality.DropdownMenu.Buttons * 33 + 3 or 1)
    end

function Portality:ToggleDropdownMenu()
    if not Portality.DropdownMenu then Portality:CreateDropdownMenu() end
    if Portality.DropdownMenu:IsShown() then Portality.DropdownMenu:Hide() else Portality:RefreshDropdownMenu() Portality.DropdownMenu:Show() end
    if Portality.DropdownMenu:IsShown() then
        local cursorX, cursorY = GetCursorPosition()
        local cursorScale = Portality.DropdownMenu:GetEffectiveScale()
        Portality.DropdownMenu:ClearAllPoints()
        Portality.DropdownMenu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", cursorX / cursorScale, cursorY / cursorScale)
    end
end

Portality_DropdownMenu = Portality.ToggleDropdownMenu