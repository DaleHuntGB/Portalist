local _, Portalist = ...
Portalist.Buttons = {}

local function CreatePortalButton(buttonName, spellData, parent)
    local DB = Portalist.DB.global.General.Buttons
    parent = parent or Portalist.DropdownMenu
    local PortalButton = CreateFrame("Button", buttonName, parent, "SecureActionButtonTemplate, BackdropTemplate")
    PortalButton:SetSize(parent:GetWidth() - 4, DB.Height)
    PortalButton:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    PortalButton:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a)
    PortalButton:SetBackdropBorderColor(DB.BorderColour.r, DB.BorderColour.g, DB.BorderColour.b, DB.BorderColour.a)
    PortalButton:SetScript("OnEnter", function() PortalButton:SetBackdropColor(DB.HighlightColour.r, DB.HighlightColour.g, DB.HighlightColour.b, DB.HighlightColour.a) Portalist:FetchTooltipInformationOnDropdown(parent, PortalButton, spellData.ID, spellData.isSpell) end)
    PortalButton:SetScript("OnLeave", function() PortalButton:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a) GameTooltip:Hide() end)
    PortalButton:RegisterForClicks("AnyUp", "AnyDown")

    if spellData.isSpell then
        PortalButton:SetAttribute("type", "spell")
        PortalButton:SetAttribute("spell", spellData.ID)
    else
        PortalButton:SetAttribute("type", "item")
        PortalButton:SetAttribute("item", "item:" .. spellData.ID)
    end
    PortalButton.SpellData = spellData

    PortalButton:SetScript("PostClick", function() if Portalist.SeasonalSubMenu then Portalist.SeasonalSubMenu:Hide() end Portalist.DropdownMenu:Hide() Portalist.DropdownMenuController:Hide() end)

    local ButtonDurationStatusBar = CreateFrame("StatusBar", nil, PortalButton)
    ButtonDurationStatusBar:SetPoint("TOPLEFT", PortalButton, "TOPLEFT", 1, -1)
    ButtonDurationStatusBar:SetPoint("BOTTOMRIGHT", PortalButton, "BOTTOMRIGHT", -1, 1)
    ButtonDurationStatusBar:SetHeight(DB.Height - 2)
    ButtonDurationStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    ButtonDurationStatusBar:SetStatusBarColor(DB.DurationColour.r, DB.DurationColour.g, DB.DurationColour.b, DB.DurationColour.a)
    ButtonDurationStatusBar:SetMinMaxValues(0, 1)
    ButtonDurationStatusBar:SetValue(0)

    PortalButton.ButtonDurationStatusBar = ButtonDurationStatusBar

    local ButtonIcon = ButtonDurationStatusBar:CreateTexture(nil, "OVERLAY")
    ButtonIcon:SetPoint("LEFT", PortalButton, "LEFT", 2, 0)
    ButtonIcon:SetSize(DB.Height - 4, DB.Height - 4)
    if spellData.isSpell then
        ButtonIcon:SetTexture(C_Spell.GetSpellInfo(spellData.ID).iconID)
    else
        local itemTexture = select(10, C_Item.GetItemInfo(spellData.ID))
        ButtonIcon:SetTexture(itemTexture)
    end

    PortalButton.ButtonIcon = ButtonIcon

    local ButtonSpellText = ButtonDurationStatusBar:CreateFontString(nil, "OVERLAY")
    ButtonSpellText:SetFont("Fonts\\FRIZQT__.TTF", DB.Text.Size, "OUTLINE, SLUG")
    ButtonSpellText:SetPoint("LEFT", ButtonIcon, "RIGHT", 3, 0.1)
    ButtonSpellText:SetText(spellData.name)
    ButtonSpellText:SetWidth(PortalButton:GetWidth() * 0.6)
    ButtonSpellText:SetWordWrap(false)
    local isLearnt = spellData.isSpell and Portalist:IsLearnt(spellData.ID, true) or Portalist:IsLearnt(spellData.ID, false)
    if not isLearnt then ButtonSpellText:SetTextColor(DB.Text.UnusableColour.r, DB.Text.UnusableColour.g, DB.Text.UnusableColour.b, DB.Text.UnusableColour.a) else ButtonSpellText:SetTextColor(DB.Text.NormalColour.r, DB.Text.NormalColour.g, DB.Text.NormalColour.b, DB.Text.NormalColour.a) end
    ButtonSpellText:SetJustifyH("LEFT")

    PortalButton.ButtonSpellText = ButtonSpellText

    local ButtonDurationText = ButtonDurationStatusBar:CreateFontString(nil, "OVERLAY")
    ButtonDurationText:SetFont("Fonts\\FRIZQT__.TTF", DB.Text.Size, "OUTLINE, SLUG")
    ButtonDurationText:SetPoint("RIGHT", PortalButton, "RIGHT", -2, 0.1)
    ButtonDurationText:SetTextColor(DB.Text.DurationColour.r, DB.Text.DurationColour.g, DB.Text.DurationColour.b, DB.Text.DurationColour.a)
    ButtonDurationText:SetJustifyH("RIGHT")

    PortalButton.ButtonDurationText = ButtonDurationText

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

local function CreateGroupButton(buttonName, groupData)
    local DB = Portalist.DB.global.General.Buttons
    local GroupButton = CreateFrame("Button", buttonName, Portalist.DropdownMenu, "BackdropTemplate")
    GroupButton:SetSize(Portalist.DropdownMenu:GetWidth() - 4, DB.Height)
    GroupButton:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    GroupButton:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a)
    GroupButton:SetBackdropBorderColor(DB.BorderColour.r, DB.BorderColour.g, DB.BorderColour.b, DB.BorderColour.a)
    GroupButton:SetScript("OnEnter", function() GroupButton:SetBackdropColor(DB.HighlightColour.r, DB.HighlightColour.g, DB.HighlightColour.b, DB.HighlightColour.a) end)
    GroupButton:SetScript("OnLeave", function() GroupButton:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a) end)
    GroupButton.GroupData = groupData

    local ButtonIcon = GroupButton:CreateTexture(nil, "OVERLAY")
    ButtonIcon:SetPoint("LEFT", GroupButton, "LEFT", 2, 0)
    ButtonIcon:SetSize(DB.Height - 4, DB.Height - 4)
    ButtonIcon:SetTexture(groupData.icon or (groupData.portals[1] and C_Spell.GetSpellInfo(groupData.portals[1].ID) and C_Spell.GetSpellInfo(groupData.portals[1].ID).iconID))

    local ButtonText = GroupButton:CreateFontString(nil, "OVERLAY")
    ButtonText:SetFont("Fonts\\FRIZQT__.TTF", DB.Text.Size, "OUTLINE, SLUG")
    ButtonText:SetPoint("LEFT", ButtonIcon, "RIGHT", 3, 0.1)
    ButtonText:SetText(groupData.name)
    ButtonText:SetTextColor(DB.Text.NormalColour.r, DB.Text.NormalColour.g, DB.Text.NormalColour.b, DB.Text.NormalColour.a)
    ButtonText:SetWidth(GroupButton:GetWidth() * 0.5)
    ButtonText:SetWordWrap(false)
    ButtonText:SetJustifyH("LEFT")

    local ArrowText = GroupButton:CreateFontString(nil, "OVERLAY")
    ArrowText:SetFont("Fonts\\FRIZQT__.TTF", DB.Text.Size, "OUTLINE, SLUG")
    ArrowText:SetPoint("RIGHT", GroupButton, "RIGHT", -2, 0.1)
    ArrowText:SetText(">")
    ArrowText:SetTextColor(DB.Text.NormalColour.r, DB.Text.NormalColour.g, DB.Text.NormalColour.b, DB.Text.NormalColour.a)
    ArrowText:SetJustifyH("RIGHT")

    GroupButton:SetScript("OnClick", function() Portalist:ToggleSeasonalSubMenu(groupData, GroupButton) end)

    return GroupButton
end

function Portalist:ToggleSeasonalSubMenu(groupData, anchorButton)
    if Portalist.SeasonalSubMenu and Portalist.SeasonalSubMenu:IsShown() then
        Portalist.SeasonalSubMenu:Hide()
        return
    end

    local dropdownDB = Portalist.DB.global.General.Dropdown
    if not Portalist.SeasonalSubMenu then
        local SubMenu = CreateFrame("Frame", "PortalistSeasonalSubMenu", UIParent, "BackdropTemplate")
        SubMenu:SetSize(dropdownDB.Width, 1)
        SubMenu:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
        SubMenu:SetBackdropColor(dropdownDB.BackgroundColour.r, dropdownDB.BackgroundColour.g, dropdownDB.BackgroundColour.b, dropdownDB.BackgroundColour.a)
        SubMenu:SetBackdropBorderColor(dropdownDB.BorderColour.r, dropdownDB.BorderColour.g, dropdownDB.BorderColour.b, dropdownDB.BorderColour.a)
        SubMenu:Hide()
        SubMenu.Buttons = {}
        Portalist.SeasonalSubMenu = SubMenu
    end

    for _, btn in ipairs(Portalist.SeasonalSubMenu.Buttons) do btn:Hide() btn:SetParent(nil) end
    Portalist.SeasonalSubMenu.Buttons = {}

    Portalist.SeasonalSubMenu:SetSize(dropdownDB.Width, 1)
    for portalIndex, portalData in ipairs(groupData.portals) do
        local buttonName = "PortalistSeasonalSubMenuButton" .. portalIndex
        local SubButton = CreatePortalButton(buttonName, portalData, Portalist.SeasonalSubMenu)
        if portalIndex == 1 then
            SubButton:SetPoint("TOP", Portalist.SeasonalSubMenu, "TOP", 0, -2)
        else
            SubButton:SetPoint("TOP", Portalist.SeasonalSubMenu.Buttons[portalIndex - 1], "BOTTOM", 0, -1)
        end
        table.insert(Portalist.SeasonalSubMenu.Buttons, SubButton)
    end

    local buttonDB = Portalist.DB.global.General.Buttons
    local subMenuHeight = #Portalist.SeasonalSubMenu.Buttons > 0 and #Portalist.SeasonalSubMenu.Buttons * (buttonDB.Height + 1) + 3 or buttonDB.Height
    Portalist.SeasonalSubMenu:SetSize(dropdownDB.Width, subMenuHeight)

    Portalist.SeasonalSubMenu:ClearAllPoints()
    Portalist.SeasonalSubMenu:SetPoint("TOPLEFT", Portalist.DropdownMenu, "TOPRIGHT", 1, 0)
    Portalist.SeasonalSubMenu:Show()
end

function Portalist:CreateDropdownMenu()
    local DB = Portalist.DB.global.General.Dropdown
    if InCombatLockdown() then return end
    local DropdownMenu = CreateFrame("Frame", "PortalistDropdownMenu", UIParent, "BackdropTemplate")
    DropdownMenu:SetSize(DB.Width, 1)
    DropdownMenu:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    DropdownMenu:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    DropdownMenu:SetBackdropColor(DB.BackgroundColour.r, DB.BackgroundColour.g, DB.BackgroundColour.b, DB.BackgroundColour.a)
    DropdownMenu:SetBackdropBorderColor(DB.BorderColour.r, DB.BorderColour.g, DB.BorderColour.b, DB.BorderColour.a)
    DropdownMenu:RegisterEvent("PLAYER_REGEN_DISABLED")
    DropdownMenu:RegisterEvent("ENCOUNTER_START")
    DropdownMenu:SetScript("OnEvent", function(_, event) if event == "PLAYER_REGEN_DISABLED" or event == "ENCOUNTER_START" and DropdownMenu:IsShown() then if Portalist.SeasonalSubMenu then Portalist.SeasonalSubMenu:Hide() end DropdownMenu:Hide() end end)
    DropdownMenu:Hide()

    local DisclaimerText = DropdownMenu:CreateFontString(nil, "OVERLAY")
    DisclaimerText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE, SLUG")
    DisclaimerText:SetPoint("CENTER", DropdownMenu, "CENTER", 0, 0)
    DisclaimerText:SetText("|cFFCCCCCCNo Portals Chosen or Available!|r")
    DisclaimerText:SetJustifyH("CENTER")
    DisclaimerText:Hide()

    Portalist.DropdownMenu = DropdownMenu
    Portalist.DropdownMenu.Buttons = {}
    Portalist.DropdownMenu.DisclaimerText = DisclaimerText

    Portalist:GenerateDropdownData()

    for spellIndex, spellData in ipairs(Portalist.DropdownData) do
        local isUsable = false
        if spellData.isGroup then
            isUsable = true
        elseif spellData.isSpell then
            isUsable = Portalist:IsSpellUsable(spellData.ID)
        else
            isUsable = Portalist:IsItemUsable(spellData.ID)
        end
        if isUsable then
            local buttonName = "PortalistDropdownButton" .. spellIndex
            local PortalButton
            if spellData.isGroup then
                PortalButton = CreateGroupButton(buttonName, spellData)
            else
                PortalButton = CreatePortalButton(buttonName, spellData)
            end
            if spellIndex == 1 then
                PortalButton:SetPoint("TOP", DropdownMenu, "TOP", 0, -2)
            else
                PortalButton:SetPoint("TOP", Portalist.DropdownMenu.Buttons[spellIndex - 1], "BOTTOM", 0, -1)
            end
            table.insert(Portalist.DropdownMenu.Buttons, PortalButton)
        end
    end

   DropdownMenu:SetSize(DB.Width, #Portalist.DropdownMenu.Buttons > 0 and #Portalist.DropdownMenu.Buttons * (Portalist.DB.global.General.Buttons.Height + 1) + 3 or Portalist.DB.global.General.Buttons.Height)
   if #Portalist.DropdownMenu.Buttons == 0 then Portalist.DropdownMenu.DisclaimerText:Show() else Portalist.DropdownMenu.DisclaimerText:Hide() end

    local DropdownMenuController = CreateFrame("Frame", "PortalistDropdownMenuController", UIParent)
    DropdownMenuController:SetAllPoints(UIParent)
    DropdownMenuController:SetFrameStrata("LOW")
    DropdownMenuController:SetFrameLevel(1)
    DropdownMenuController:EnableMouse(true)
    DropdownMenuController:SetPropagateMouseClicks(true)
    DropdownMenuController:SetPropagateKeyboardInput(true)
    DropdownMenuController:SetScript("OnMouseDown", function() if Portalist.DropdownMenu and Portalist.DropdownMenu:IsShown() then if Portalist.SeasonalSubMenu then Portalist.SeasonalSubMenu:Hide() end Portalist.DropdownMenu:Hide() DropdownMenuController:Hide() end end)
    DropdownMenuController:SetScript("OnKeyDown", function(self, key) if key == "ESCAPE" and Portalist.DropdownMenu and Portalist.DropdownMenu:IsShown() then if Portalist.SeasonalSubMenu then Portalist.SeasonalSubMenu:Hide() end Portalist.DropdownMenu:Hide() DropdownMenuController:Hide() end end)
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
        if portalButton.ButtonDurationStatusBar then portalButton.ButtonDurationStatusBar:SetStatusBarColor(buttonDB.DurationColour.r, buttonDB.DurationColour.g, buttonDB.DurationColour.b, buttonDB.DurationColour.a) end
        local buttonData = portalButton.SpellData
        local spellTextColour = buttonDB.Text.NormalColour
        if buttonData then
            local isLearnt = buttonData.isSpell and Portalist:IsLearnt(buttonData.ID, true) or Portalist:IsLearnt(buttonData.ID, false)
            if not isLearnt then spellTextColour = buttonDB.Text.UnusableColour end
        end
        if portalButton.ButtonSpellText then portalButton.ButtonSpellText:SetTextColor(spellTextColour.r, spellTextColour.g, spellTextColour.b, spellTextColour.a) end
        if portalButton.ButtonDurationText then portalButton.ButtonDurationText:SetTextColor(buttonDB.Text.DurationColour.r, buttonDB.Text.DurationColour.g, buttonDB.Text.DurationColour.b, buttonDB.Text.DurationColour.a) end
    end
end

function Portalist:RefreshSizes()
    if not Portalist.DropdownMenu then return end
    local DB = Portalist.DB.global.General.Dropdown
    Portalist:GenerateDropdownData()
    Portalist.DropdownMenu:SetSize(DB.Width, #Portalist.DropdownMenu.Buttons > 0 and #Portalist.DropdownMenu.Buttons * (Portalist.DB.global.General.Buttons.Height + 1) + 3 or Portalist.DB.global.General.Buttons.Height)
    for index, portalButton in ipairs(Portalist.DropdownMenu.Buttons or {}) do
        portalButton:ClearAllPoints()
        if index == 1 then
            portalButton:SetPoint("TOP", Portalist.DropdownMenu, "TOP", 0, -2)
        else
            portalButton:SetPoint("TOP", Portalist.DropdownMenu.Buttons[index - 1], "BOTTOM", 0, -1)
        end
        portalButton:SetSize(Portalist.DropdownMenu:GetWidth() - 4, Portalist.DB.global.General.Buttons.Height)
        if not portalButton.GroupData then
            portalButton.ButtonIcon:SetSize(Portalist.DB.global.General.Buttons.Height - 4, Portalist.DB.global.General.Buttons.Height - 4)
            portalButton.ButtonSpellText:SetWidth(portalButton:GetWidth() * 0.6)
            portalButton.ButtonSpellText:SetFont("Fonts\\FRIZQT__.TTF", Portalist.DB.global.General.Buttons.Text.Size, "OUTLINE, SLUG")
            portalButton.ButtonDurationText:SetPoint("RIGHT", portalButton, "RIGHT", -2, 0.1)
            portalButton.ButtonDurationText:SetFont("Fonts\\FRIZQT__.TTF", Portalist.DB.global.General.Buttons.Text.Size, "OUTLINE, SLUG")
            portalButton.ButtonDurationStatusBar:SetHeight(Portalist.DB.global.General.Buttons.Height - 2)
        end
    end
end

function Portalist:RefreshDropdownMenu()
    local DB = Portalist.DB.global.General.Dropdown
    if InCombatLockdown() then return end
    if not Portalist.DropdownMenu then return end
    if Portalist.SeasonalSubMenu then Portalist.SeasonalSubMenu:Hide() end
    for _, portalButton in ipairs(Portalist.DropdownMenu.Buttons or {}) do portalButton:Hide() portalButton:SetParent(nil) end
    Portalist.DropdownMenu.Buttons = {}
    Portalist:GenerateDropdownData()
    for spellIndex, spellData in ipairs(Portalist.DropdownData) do
        local buttonName = "PortalistDropdownButton" .. spellIndex
        local PortalButton
        if spellData.isGroup then
            PortalButton = CreateGroupButton(buttonName, spellData)
        else
            PortalButton = CreatePortalButton(buttonName, spellData)
        end
        if spellIndex == 1 then
            PortalButton:SetPoint("TOP", Portalist.DropdownMenu, "TOP", 0, -2)
        else
            PortalButton:SetPoint("TOP", Portalist.DropdownMenu.Buttons[spellIndex - 1], "BOTTOM", 0, -1)
        end
        table.insert(Portalist.DropdownMenu.Buttons, PortalButton)
    end
    Portalist.DropdownMenu:SetSize(DB.Width, #Portalist.DropdownMenu.Buttons > 0 and #Portalist.DropdownMenu.Buttons * (Portalist.DB.global.General.Buttons.Height + 1) + 3 or Portalist.DB.global.General.Buttons.Height)
    if #Portalist.DropdownMenu.Buttons == 0 then Portalist.DropdownMenu.DisclaimerText:Show() else Portalist.DropdownMenu.DisclaimerText:Hide() end
end

function Portalist:ToggleDropdownMenu()
    if InCombatLockdown() then return end
    if not Portalist.DropdownMenu then Portalist:CreateDropdownMenu() end
    if Portalist.DropdownMenu:IsShown() then
        if Portalist.SeasonalSubMenu then Portalist.SeasonalSubMenu:Hide() end
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
