local _, Portalist = ...

local function CreatePortalButton(buttonName, spellData)
    local DB = Portalist.DB.global.General.Buttons
    local PortalButton = CreateFrame("Button", buttonName, Portalist.DropdownMenu, "SecureActionButtonTemplate, BackdropTemplate")
    PortalButton:SetSize(Portalist.DropdownMenu:GetWidth() - 4, 32)
    PortalButton:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    PortalButton:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a)
    PortalButton:SetBackdropBorderColor(DB.BorderColour.r, DB.BorderColour.g, DB.BorderColour.b, DB.BorderColour.a)

    PortalButton:SetScript("OnEnter", function() PortalButton:SetBackdropColor(DB.HighlightColour.r, DB.HighlightColour.g, DB.HighlightColour.b, DB.HighlightColour.a) end)
    PortalButton:SetScript("OnLeave", function() PortalButton:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a) end)

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
    ButtonDurationStatusBar:SetStatusBarColor(DB.DurationColour.r, DB.DurationColour.g, DB.DurationColour.b, DB.DurationColour.a)
    ButtonDurationStatusBar:SetMinMaxValues(0, 1)
    ButtonDurationStatusBar:SetValue(0)

    local ButtonSpellText = ButtonDurationStatusBar:CreateFontString(nil, "OVERLAY")
    ButtonSpellText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    ButtonSpellText:SetPoint("LEFT", PortalButton, "LEFT", 3, 0)
    ButtonSpellText:SetText(spellData.name)
    ButtonSpellText:SetTextColor(DB.Text.NormalColour.r, DB.Text.NormalColour.g, DB.Text.NormalColour.b, DB.Text.NormalColour.a)
    ButtonSpellText:SetJustifyH("LEFT")

    local ButtonDurationText = ButtonDurationStatusBar:CreateFontString(nil, "OVERLAY")
    ButtonDurationText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
    ButtonDurationText:SetPoint("RIGHT", PortalButton, "RIGHT", -3, 0)
    ButtonDurationText:SetTextColor(DB.Text.DurationColour.r, DB.Text.DurationColour.g, DB.Text.DurationColour.b, DB.Text.DurationColour.a)
    ButtonDurationText:SetJustifyH("RIGHT")

    if spellData.isSpell then
        PortalButton:SetScript("OnUpdate", function()
            local spellCooldown = C_Spell.GetSpellCooldown(spellData.ID)
            if spellCooldown and spellCooldown.startTime > 0 then
                local remainingCooldown = spellCooldown.startTime + spellCooldown.duration - GetTime()
                if remainingCooldown > 3600 then
                    ButtonDurationText:SetText(string.format("%1dh %02dm", math.floor(remainingCooldown / 3600), math.floor((remainingCooldown % 3600) / 60)))
                else
                    ButtonDurationText:SetText(string.format("%02dm %02ds", math.floor(remainingCooldown / 60), remainingCooldown % 60))
                end
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
                if remainingCooldown > 3600 then
                    ButtonDurationText:SetText(string.format("%1dh %02dm", math.floor(remainingCooldown / 3600), math.floor((remainingCooldown % 3600) / 60)))
                else
                    ButtonDurationText:SetText(string.format("%02dm %02ds", math.floor(remainingCooldown / 60), remainingCooldown % 60))
                end
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
    local DB = Portalist.DB.global.General.Dropdown
    if InCombatLockdown() then return end
    local DropdownMenu = CreateFrame("Frame", "PortalistDropdownMenu", UIParent, "BackdropTemplate")
    DropdownMenu:SetSize(400, 1)
    DropdownMenu:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    DropdownMenu:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    DropdownMenu:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a)
    DropdownMenu:SetBackdropBorderColor(DB.BorderColour.r, DB.BorderColour.g, DB.BorderColour.b, DB.BorderColour.a)
    DropdownMenu:RegisterEvent("PLAYER_REGEN_DISABLED")
    DropdownMenu:RegisterEvent("ENCOUNTER_START")
    DropdownMenu:SetScript("OnEvent", function(_, event) if event == "PLAYER_REGEN_DISABLED" or event == "ENCOUNTER_START" and DropdownMenu:IsShown() then DropdownMenu:Hide() end end)
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

function Portalist:RefreshColours()
    if not Portalist.DropdownMenu then return end
    local DB = Portalist.DB.global.General.Dropdown
    Portalist.DropdownMenu:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a)
    Portalist.DropdownMenu:SetBackdropBorderColor(DB.BorderColour.r, DB.BorderColour.g, DB.BorderColour.b, DB.BorderColour.a)
    for _, portalButton in ipairs(Portalist.DropdownMenu.Buttons or {}) do
        local buttonDB = Portalist.DB.global.General.Buttons
        portalButton:SetBackdropColor(buttonDB.BackgroundColour.r, buttonDB.BackgroundColour.g, buttonDB.BackgroundColour.b, buttonDB.BackgroundColour.a)
        portalButton:SetBackdropBorderColor(buttonDB.BorderColour.r, buttonDB.BorderColour.g, buttonDB.BorderColour.b, buttonDB.BorderColour.a)
        portalButton:SetScript("OnEnter", function() portalButton:SetBackdropColor(buttonDB.HighlightColour.r, buttonDB.HighlightColour.g, buttonDB.HighlightColour.b, buttonDB.HighlightColour.a) end)
        portalButton:SetScript("OnLeave", function() portalButton:SetBackdropColor(buttonDB.BackgroundColour.r, buttonDB.BackgroundColour.g, buttonDB.BackgroundColour.b, buttonDB.BackgroundColour.a) end)
        if portalButton:GetChildren() then
            for _, child in ipairs({portalButton:GetChildren()}) do
                if child:IsObjectType("StatusBar") then
                    child:SetStatusBarColor(buttonDB.DurationColour.r, buttonDB.DurationColour.g, buttonDB.DurationColour.b, buttonDB.DurationColour.a)
                elseif child:IsObjectType("FontString") then
                    local textType = child:GetPoint()
                    if textType and textType:find("LEFT") then
                        child:SetTextColor(buttonDB.Text.NormalColour.r, buttonDB.Text.NormalColour.g, buttonDB.Text.NormalColour.b, buttonDB.Text.NormalColour.a)
                    elseif textType and textType:find("RIGHT") then
                        child:SetTextColor(buttonDB.Text.DurationColour.r, buttonDB.Text.DurationColour.g, buttonDB.Text.DurationColour.b, buttonDB.Text.DurationColour.a)
                    end
                end
            end
        end
    end
end

function Portalist:RefreshDropdownMenu()
    if InCombatLockdown() then return end
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
    if #Portalist.DropdownMenu.Buttons == 0 then Portalist.DropdownMenu.DisclaimerText:Show() else Portalist.DropdownMenu.DisclaimerText:Hide() end
end

function Portalist:ToggleDropdownMenu()
    if InCombatLockdown() then return end
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