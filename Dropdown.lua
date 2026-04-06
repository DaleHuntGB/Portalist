local _, Portalist = ...

local function CreatePortalButton(buttonName, spellData)
    local PortalButton = CreateFrame("Button", buttonName, Portalist.DropdownMenu, "SecureActionButtonTemplate, BackdropTemplate")
    PortalButton:SetSize(Portalist.DropdownMenu:GetWidth() - 4, 32)
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

    PortalButton:SetScript("PostClick", function() Portalist.DropdownMenu:Hide() end)

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
    ButtonSpellText:SetJustifyH("LEFT")

    local ButtonDurationText = ButtonDurationStatusBar:CreateFontString(nil, "OVERLAY")
    ButtonDurationText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    ButtonDurationText:SetPoint("RIGHT", PortalButton, "RIGHT", -3, 0)
    ButtonDurationText:SetJustifyH("RIGHT")

    if spellData.isSpell then
        PortalButton:SetScript("OnUpdate", function()
            local spellCooldown = C_Spell.GetSpellCooldown(spellData.ID)
            if spellCooldown and spellCooldown.startTime > 0 then
                local remainingCooldown = spellCooldown.startTime + spellCooldown.duration - GetTime()
                ButtonDurationText:SetText(string.format("|cFFCCCCCC%02d:%02d|r", math.floor(remainingCooldown / 60), remainingCooldown % 60))
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
        PortalButton:SetScript("OnUpdate", function()
            local itemCooldownStart, itemCooldownDuration = C_Item.GetItemCooldown(spellData.ID)
            if itemCooldownStart and itemCooldownStart > 0 then
                local remainingCooldown = itemCooldownStart + itemCooldownDuration - GetTime()
                ButtonDurationText:SetText(string.format("|cFFCCCCCC%02d:%02d|r", math.floor(remainingCooldown / 60), remainingCooldown % 60))
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

function Portalist:CreateDropdownMenu()
    local DropdownMenu = CreateFrame("Frame", "PortalistDropdownMenu", UIParent, "BackdropTemplate")
    DropdownMenu:SetSize(400, 1)
    DropdownMenu:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    DropdownMenu:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    DropdownMenu:SetBackdropColor(0, 0, 0, 0.8)
    DropdownMenu:SetBackdropBorderColor(0, 0, 0, 1)
    DropdownMenu:Hide()

    local DisclaimerText = DropdownMenu:CreateFontString(nil, "OVERLAY")
    DisclaimerText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    DisclaimerText:SetPoint("CENTER", DropdownMenu, "CENTER", 0, 0)
    DisclaimerText:SetText("|cFFCCCCCCNo Portals Chosen or Available!|r")
    DisclaimerText:SetJustifyH("CENTER")
    DisclaimerText:Hide()

    Portalist.DropdownMenu = DropdownMenu
    Portalist.DropdownMenu.Buttons = {}
    Portalist.DropdownMenu.DisclaimerText = DisclaimerText

    Portalist:GenerateDropdownData()

    for spellIndex, spellData in ipairs(Portalist.DropdownData) do
        local isUsable = false;
        if spellData.isSpell then isUsable = Portalist:IsSpellUsable(spellData.ID) else isUsable = Portalist:IsItemUsable(spellData.ID) end
        if isUsable then
            local buttonName = "PortalistDropdownButton" .. spellIndex
            local PortalButton = CreatePortalButton(buttonName, spellData)
            if spellIndex == 1 then
                PortalButton:SetPoint("TOP", DropdownMenu, "TOP", 0, -2)
            else
                PortalButton:SetPoint("TOP", Portalist.DropdownMenu.Buttons[spellIndex - 1], "BOTTOM", 0, -1)
            end
            table.insert(Portalist.DropdownMenu.Buttons, PortalButton)
        end
    end

   DropdownMenu:SetSize(400, #Portalist.DropdownMenu.Buttons > 0 and #Portalist.DropdownMenu.Buttons * 33 + 3 or 32)
   if #Portalist.DropdownMenu.Buttons == 0 then Portalist.DropdownMenu.DisclaimerText:Show() else Portalist.DropdownMenu.DisclaimerText:Hide() end

    local DropdownMenuController = CreateFrame("Frame", nil, UIParent)
    DropdownMenuController:SetAllPoints(UIParent)
    DropdownMenuController:SetFrameStrata("LOW")
    DropdownMenuController:SetFrameLevel(1)
    DropdownMenuController:EnableMouse(true)
    DropdownMenuController:SetPropagateMouseClicks(true)
    DropdownMenuController:SetPropagateKeyboardInput(true)
    DropdownMenuController:SetScript("OnMouseDown", function() if Portalist.DropdownMenu and Portalist.DropdownMenu:IsShown() then Portalist.DropdownMenu:Hide() DropdownMenuController:Hide() end end)
    DropdownMenuController:SetScript("OnKeyDown", function(self, key) if key == "ESCAPE" and Portalist.DropdownMenu and Portalist.DropdownMenu:IsShown() then Portalist.DropdownMenu:Hide() DropdownMenuController:Hide() end end)
    DropdownMenuController:Hide()

    Portalist.DropdownMenuController = DropdownMenuController
end

function Portalist:RefreshDropdownMenu()
    if not Portalist.DropdownMenu then return end

    for _, portalButton in ipairs(Portalist.DropdownMenu.Buttons or {}) do portalButton:Hide() portalButton:SetParent(nil) end

    Portalist.DropdownMenu.Buttons = {}

    Portalist:GenerateDropdownData()

    for spellIndex, spellData in ipairs(Portalist.DropdownData) do
        local buttonName = "PortalistDropdownButton" .. spellIndex
        local PortalButton = CreatePortalButton(buttonName, spellData)
        if spellIndex == 1 then
            PortalButton:SetPoint("TOP", Portalist.DropdownMenu, "TOP", 0, -2)
        else
            PortalButton:SetPoint("TOP", Portalist.DropdownMenu.Buttons[spellIndex - 1], "BOTTOM", 0, -1)
        end
        table.insert(Portalist.DropdownMenu.Buttons, PortalButton)
    end

    Portalist.DropdownMenu:SetHeight(#Portalist.DropdownMenu.Buttons > 0 and #Portalist.DropdownMenu.Buttons * 33 + 3 or 32)
    if #Portalist.DropdownMenu.Buttons == 0 then
        Portalist.DropdownMenu.DisclaimerText:Show()
    else
        Portalist.DropdownMenu.DisclaimerText:Hide()
    end
end

function Portalist:ToggleDropdownMenu()
    if not Portalist.DropdownMenu then Portalist:CreateDropdownMenu() end
    if Portalist.DropdownMenu:IsShown() then
        Portalist.DropdownMenu:Hide()
        Portalist.DropdownMenuController:Hide()
    else
        Portalist:RefreshDropdownMenu()
        Portalist.DropdownMenuController:Show()
        Portalist.DropdownMenu:Show()

        local cursorX, cursorY = GetCursorPosition()
        local cursorScale = Portalist.DropdownMenu:GetEffectiveScale()
        Portalist.DropdownMenu:ClearAllPoints()
        Portalist.DropdownMenu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", cursorX / cursorScale, cursorY / cursorScale)
    end
end


Portalist_DropdownMenu = Portalist.ToggleDropdownMenu