local _, Portalist = ...
local AG = LibStub("AceGUI-3.0")
local isGUIOpen = false
local GUIFrame = nil

local function CreateDisplayName(spellID, isSpell)
    local DB = Portalist.DB.global.General
    local isLearntColour = Portalist:IsLearnt(spellID, isSpell) and "FFFFFFFF" or "FFFF4040"
    if isSpell then
        local spellData = C_Spell.GetSpellInfo(spellID)
        if spellData then
            local spellName = Portalist.Data.ChallengeModePortalsByName[spellID] or Portalist.Data.PortalByName[spellID] or spellData.name
            local spellTexture = spellData.iconID
            return string.format("|T%s:24:24|t |c%s%s|r", spellTexture, isLearntColour, spellName)
        end
    else
        local itemName = Portalist.Data.WormholesByName[spellID] or select(1, C_Item.GetItemInfo(spellID))
        local itemTexture = select(10, C_Item.GetItemInfo(spellID))
        if itemName and itemTexture then
            return string.format("|T%s:24:24|t |c%s%s|r", itemTexture, isLearntColour, itemName)
        end
    end
end

function Portalist:CreateGUI()
    if InCombatLockdown() then return end
    local DB = Portalist.DB.global
    if isGUIOpen then return end
    isGUIOpen = true
    GUIFrame = AG:Create("Frame")
    GUIFrame:SetTitle("|cFF8080FFPortalist|r")
    GUIFrame:SetLayout("Flow")
    GUIFrame:SetWidth(800)
    GUIFrame:SetHeight(800)
    GUIFrame:SetCallback("OnClose", function() isGUIOpen = false AG:Release(GUIFrame) end)
    GUIFrame:EnableResize(false)
    GUIFrame:Show()

    local GeneralContainer = AG:Create("InlineGroup")
    GeneralContainer:SetLayout("Flow")
    GeneralContainer:SetTitle("General Settings")
    GeneralContainer:SetFullWidth(true)
    GUIFrame:AddChild(GeneralContainer)

    local ShowLoginMessageToggle = AG:Create("CheckBox")
    ShowLoginMessageToggle:SetLabel("Show Login Message")
    ShowLoginMessageToggle:SetValue(DB.General.ShowLoginMessage)
    ShowLoginMessageToggle:SetCallback("OnValueChanged", function(_, _, value) DB.General.ShowLoginMessage = value end)
    ShowLoginMessageToggle:SetRelativeWidth(0.33)
    GeneralContainer:AddChild(ShowLoginMessageToggle)

    local ColoursContainer = AG:Create("InlineGroup")
    ColoursContainer:SetLayout("Flow")
    ColoursContainer:SetTitle("Colours")
    ColoursContainer:SetFullWidth(true)
    GeneralContainer:AddChild(ColoursContainer)

    local DropdownHeader = AG:Create("Heading")
    DropdownHeader:SetText("Dropdown")
    DropdownHeader:SetFullWidth(true)
    ColoursContainer:AddChild(DropdownHeader)

    local DropdownBackgroundColourPicker = AG:Create("ColorPicker")
    DropdownBackgroundColourPicker:SetLabel("Background")
    DropdownBackgroundColourPicker:SetColor(DB.General.Dropdown.BackgroundColour.r, DB.General.Dropdown.BackgroundColour.g, DB.General.Dropdown.BackgroundColour.b, DB.General.Dropdown.BackgroundColour.a)
    DropdownBackgroundColourPicker:SetHasAlpha(true)
    DropdownBackgroundColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Dropdown.BackgroundColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    DropdownBackgroundColourPicker:SetRelativeWidth(0.5)
    ColoursContainer:AddChild(DropdownBackgroundColourPicker)

    local DropdownBorderColourPicker = AG:Create("ColorPicker")
    DropdownBorderColourPicker:SetLabel("Border")
    DropdownBorderColourPicker:SetColor(DB.General.Dropdown.BorderColour.r, DB.General.Dropdown.BorderColour.g, DB.General.Dropdown.BorderColour.b, DB.General.Dropdown.BorderColour.a)
    DropdownBorderColourPicker:SetHasAlpha(true)
    DropdownBorderColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Dropdown.BorderColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    DropdownBorderColourPicker:SetRelativeWidth(0.5)
    ColoursContainer:AddChild(DropdownBorderColourPicker)

    local ButtonHeader = AG:Create("Heading")
    ButtonHeader:SetText("Buttons")
    ButtonHeader:SetFullWidth(true)
    ColoursContainer:AddChild(ButtonHeader)

    local ButtonBackgroundColourPicker = AG:Create("ColorPicker")
    ButtonBackgroundColourPicker:SetLabel("Background")
    ButtonBackgroundColourPicker:SetColor(DB.General.Buttons.BackgroundColour.r, DB.General.Buttons.BackgroundColour.g, DB.General.Buttons.BackgroundColour.b, DB.General.Buttons.BackgroundColour.a)
    ButtonBackgroundColourPicker:SetHasAlpha(true)
    ButtonBackgroundColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Buttons.BackgroundColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    ButtonBackgroundColourPicker:SetRelativeWidth(0.25)
    ColoursContainer:AddChild(ButtonBackgroundColourPicker)

    local ButtonBorderColourPicker = AG:Create("ColorPicker")
    ButtonBorderColourPicker:SetLabel("Border")
    ButtonBorderColourPicker:SetColor(DB.General.Buttons.BorderColour.r, DB.General.Buttons.BorderColour.g, DB.General.Buttons.BorderColour.b, DB.General.Buttons.BorderColour.a)
    ButtonBorderColourPicker:SetHasAlpha(true)
    ButtonBorderColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Buttons.BorderColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    ButtonBorderColourPicker:SetRelativeWidth(0.25)
    ColoursContainer:AddChild(ButtonBorderColourPicker)

    local ButtonHighlightColourPicker = AG:Create("ColorPicker")
    ButtonHighlightColourPicker:SetLabel("Highlight")
    ButtonHighlightColourPicker:SetColor(DB.General.Buttons.HighlightColour.r, DB.General.Buttons.HighlightColour.g, DB.General.Buttons.HighlightColour.b, DB.General.Buttons.HighlightColour.a)
    ButtonHighlightColourPicker:SetHasAlpha(true)
    ButtonHighlightColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Buttons.HighlightColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    ButtonHighlightColourPicker:SetRelativeWidth(0.25)
    ColoursContainer:AddChild(ButtonHighlightColourPicker)

    local ButtonDurationColourPicker = AG:Create("ColorPicker")
    ButtonDurationColourPicker:SetLabel("Duration")
    ButtonDurationColourPicker:SetColor(DB.General.Buttons.DurationColour.r, DB.General.Buttons.DurationColour.g, DB.General.Buttons.DurationColour.b, DB.General.Buttons.DurationColour.a)
    ButtonDurationColourPicker:SetHasAlpha(true)
    ButtonDurationColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Buttons.DurationColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    ButtonDurationColourPicker:SetRelativeWidth(0.25)
    ColoursContainer:AddChild(ButtonDurationColourPicker)

    local TextHeader = AG:Create("Heading")
    TextHeader:SetText("Text")
    TextHeader:SetFullWidth(true)
    ColoursContainer:AddChild(TextHeader)

    local ButtonSpellTextColourPicker = AG:Create("ColorPicker")
    ButtonSpellTextColourPicker:SetLabel("Learnt")
    ButtonSpellTextColourPicker:SetColor(DB.General.Buttons.Text.NormalColour.r, DB.General.Buttons.Text.NormalColour.g, DB.General.Buttons.Text.NormalColour.b, DB.General.Buttons.Text.NormalColour.a)
    ButtonSpellTextColourPicker:SetHasAlpha(true)
    ButtonSpellTextColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Buttons.Text.NormalColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    ButtonSpellTextColourPicker:SetRelativeWidth(0.25)
    ColoursContainer:AddChild(ButtonSpellTextColourPicker)

    local ButtonSpellNotLearntColourPicker = AG:Create("ColorPicker")
    ButtonSpellNotLearntColourPicker:SetLabel("Unlearnt")
    ButtonSpellNotLearntColourPicker:SetColor(DB.General.Buttons.Text.UnusableColour.r, DB.General.Buttons.Text.UnusableColour.g, DB.General.Buttons.Text.UnusableColour.b, DB.General.Buttons.Text.UnusableColour.a)
    ButtonSpellNotLearntColourPicker:SetHasAlpha(true)
    ButtonSpellNotLearntColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Buttons.Text.UnusableColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    ButtonSpellNotLearntColourPicker:SetRelativeWidth(0.25)
    ColoursContainer:AddChild(ButtonSpellNotLearntColourPicker)

    local ButtonDurationTextColourPicker = AG:Create("ColorPicker")
    ButtonDurationTextColourPicker:SetLabel("Duration")
    ButtonDurationTextColourPicker:SetColor(DB.General.Buttons.Text.DurationColour.r, DB.General.Buttons.Text.DurationColour.g, DB.General.Buttons.Text.DurationColour.b, DB.General.Buttons.Text.DurationColour.a)
    ButtonDurationTextColourPicker:SetHasAlpha(true)
    ButtonDurationTextColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) DB.General.Buttons.Text.DurationColour = { r = r, g = g, b = b, a = a } Portalist:RefreshColours() end)
    ButtonDurationTextColourPicker:SetRelativeWidth(0.25)
    ColoursContainer:AddChild(ButtonDurationTextColourPicker)

    local SizesHeader = AG:Create("Heading")
    SizesHeader:SetText("Sizes")
    SizesHeader:SetFullWidth(true)
    ColoursContainer:AddChild(SizesHeader)

    local DropdownWidth = AG:Create("Slider")
    DropdownWidth:SetLabel("Dropdown: Width")
    DropdownWidth:SetValue(DB.General.Dropdown.Width)
    DropdownWidth:SetSliderValues(100, 500, 1)
    DropdownWidth:SetCallback("OnValueChanged", function(_, _, value) DB.General.Dropdown.Width = value Portalist:RefreshSizes() end)
    DropdownWidth:SetRelativeWidth(0.33)
    ColoursContainer:AddChild(DropdownWidth)

    local DropdownHeight = AG:Create("Slider")
    DropdownHeight:SetLabel("Button: Height")
    DropdownHeight:SetValue(DB.General.Buttons.Height)
    DropdownHeight:SetSliderValues(24, 128, 1)
    DropdownHeight:SetCallback("OnValueChanged", function(_, _, value) DB.General.Buttons.Height = value Portalist:RefreshSizes() end)
    DropdownHeight:SetRelativeWidth(0.33)
    ColoursContainer:AddChild(DropdownHeight)

    local ButtonTextSize = AG:Create("Slider")
    ButtonTextSize:SetLabel("Text: Size")
    ButtonTextSize:SetValue(DB.General.Buttons.Text.Size)
    ButtonTextSize:SetSliderValues(8, 24, 1)
    ButtonTextSize:SetCallback("OnValueChanged", function(_, _, value) DB.General.Buttons.Text.Size = value Portalist:RefreshSizes() end)
    ButtonTextSize:SetRelativeWidth(0.33)
    ColoursContainer:AddChild(ButtonTextSize)

    local KeybindHeader = AG:Create("Heading")
    KeybindHeader:SetText("Dropdown Keybinds")
    KeybindHeader:SetFullWidth(true)
    GeneralContainer:AddChild(KeybindHeader)

    Portalist.ActiveKeybind = nil

    local keybindButton = AG:Create("Button")
    keybindButton:SetRelativeWidth(0.5)
    keybindButton:SetText(select(1, GetBindingKey("PORTALIST_OPEN")) or "None")
    keybindButton:SetCallback("OnClick", function() Portalist.ActiveKeybind = 1 Portalist.KeybindCaptureFrame:Show() end)
    GeneralContainer:AddChild(keybindButton)

    local keybindButtonTwo = AG:Create("Button")
    keybindButtonTwo:SetRelativeWidth(0.5)
    keybindButtonTwo:SetText(select(2, GetBindingKey("PORTALIST_OPEN")) or "None")
    keybindButtonTwo:SetCallback("OnClick", function() Portalist.ActiveKeybind = 2 Portalist.KeybindCaptureFrame:Show() end)
    GeneralContainer:AddChild(keybindButtonTwo)

    if not Portalist.KeybindCaptureFrame then
        local keybindCaptureFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        keybindCaptureFrame:SetSize(300, 48)
        keybindCaptureFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        keybindCaptureFrame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1 })
        keybindCaptureFrame:SetBackdropColor(0, 0, 0, 0.8)
        keybindCaptureFrame:SetBackdropBorderColor(0, 0, 0, 1)
        keybindCaptureFrame:EnableKeyboard(true)
        keybindCaptureFrame:SetPropagateKeyboardInput(false)

        keybindCaptureFrame:SetScript("OnKeyDown", function(_, key)
            if key == "LSHIFT" or key == "RSHIFT" or key == "LCTRL" or key == "RCTRL" or key == "LALT" or key == "RALT" then return end

            local KeybindA, KeybindB = GetBindingKey("PORTALIST_OPEN")
            local activeKeybind = Portalist.ActiveKeybind
            if not activeKeybind then return end

            local keyCombo
            if key ~= "ESCAPE" then
                keyCombo = key
                if IsShiftKeyDown() then keyCombo = "SHIFT-" .. keyCombo end
                if IsControlKeyDown() then keyCombo = "CTRL-" .. keyCombo end
                if IsAltKeyDown() then keyCombo = "ALT-" .. keyCombo end
            end

            if activeKeybind == 1 then
                if KeybindA then SetBinding(KeybindA, nil) end
                if key ~= "ESCAPE" then SetBinding(keyCombo, "PORTALIST_OPEN") end
            elseif activeKeybind == 2 then
                if KeybindB then SetBinding(KeybindB, nil) end
                if key ~= "ESCAPE" then SetBinding(keyCombo, "PORTALIST_OPEN") end
            end

            SaveBindings(GetCurrentBindingSet())
            keybindCaptureFrame:Hide()
        end)

        keybindCaptureFrame:SetScript("OnHide", function()
            local KeybindA, KeybindB = GetBindingKey("PORTALIST_OPEN")
            keybindButton:SetText(KeybindA or "None")
            keybindButtonTwo:SetText(KeybindB or "None")
            Portalist.ActiveKeybind = nil
        end)

        keybindCaptureFrame:Hide()

        local captureFrameText = keybindCaptureFrame:CreateFontString(nil, "OVERLAY")
        captureFrameText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        captureFrameText:SetPoint("CENTER", keybindCaptureFrame, "CENTER", 0, 0)
        captureFrameText:SetText("Set a Keybind\nPress Escape to Clear")
        captureFrameText:SetJustifyH("CENTER")

        Portalist.KeybindCaptureFrame = keybindCaptureFrame
    end

    local function CreateToggleList(parent, dataList, activeTable, isSpell)
        local ScrollContainer = AG:Create("ScrollFrame")
        ScrollContainer:SetLayout("Flow")
        ScrollContainer:SetFullWidth(true)
        ScrollContainer:SetFullHeight(true)
        parent:AddChild(ScrollContainer)

        if isSpell then
            if dataList == Portalist.Data.ChallengeModePortals then
                for _, expansionPortals in ipairs(dataList) do
                    local HasVisiblePortals = false
                    for spellID, isAvailable in pairs(expansionPortals) do
                        if isAvailable then
                            if not HasVisiblePortals then
                                local ExpansionHeading = AG:Create("Heading")
                                ExpansionHeading:SetText(Portalist.Data.ChallengeModePortalsByExpansion[expansionPortals])
                                ExpansionHeading:SetFullWidth(true)
                                ScrollContainer:AddChild(ExpansionHeading)
                                HasVisiblePortals = true
                            end

                            local Toggle = AG:Create("CheckBox")
                            Toggle:SetLabel(CreateDisplayName(spellID, isSpell))
                            Toggle:SetValue(activeTable[spellID] == true)
                            Toggle:SetRelativeWidth(0.5)
                            Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[spellID] = value Portalist:GenerateDropdownData() end)
                            Toggle:SetCallback("OnEnter", function() Portalist:FetchTooltipInformation(Toggle.frame, spellID, isSpell) end)
                            Toggle:SetCallback("OnLeave", function() GameTooltip:Hide() end)
                            Toggle:SetDisabled(not Portalist:IsLearnt(spellID, isSpell))
                            ScrollContainer:AddChild(Toggle)
                        end
                    end
                end
            else
                for spellID in pairs(dataList) do
                    local Toggle = AG:Create("CheckBox")
                    Toggle:SetLabel(CreateDisplayName(spellID, isSpell))
                    Toggle:SetValue(activeTable[spellID] == true)
                    Toggle:SetRelativeWidth(0.5)
                    Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[spellID] = value Portalist:GenerateDropdownData() end)
                    Toggle:SetCallback("OnEnter", function() Portalist:FetchTooltipInformation(Toggle.frame, spellID, isSpell) end)
                    Toggle:SetCallback("OnLeave", function() GameTooltip:Hide() end)
                    Toggle:SetDisabled(not Portalist:IsLearnt(spellID, isSpell))
                    ScrollContainer:AddChild(Toggle)
                end
            end
            return
        end

        for itemID in pairs(dataList) do
            local Toggle = AG:Create("CheckBox")
            Toggle:SetLabel(CreateDisplayName(itemID, isSpell))
            Toggle:SetValue(activeTable[itemID] == true)
            Toggle:SetRelativeWidth(0.5)
            Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[itemID] = value Portalist:GenerateDropdownData() end)
            Toggle:SetCallback("OnEnter", function() Portalist:FetchTooltipInformation(Toggle.frame, itemID, isSpell) end)
            Toggle:SetCallback("OnLeave", function() GameTooltip:Hide() end)
            Toggle:SetDisabled(not Portalist:IsLearnt(itemID, isSpell))
            ScrollContainer:AddChild(Toggle)
        end
    end

    local function SelectTabGroup(GUIContainer, _, TabGroup)
        GUIContainer:ReleaseChildren()
        if TabGroup == "ChallengeModePortals" then
            CreateToggleList(GUIContainer, Portalist.Data.ChallengeModePortals, DB.ChallengeModePortals, true)
        elseif TabGroup == "Hearthstones" then
            CreateToggleList(GUIContainer, Portalist.Data.Hearthstones, DB.Hearthstones, false)
        elseif TabGroup == "Wormholes" then
            CreateToggleList(GUIContainer, Portalist.Data.Wormholes, DB.Wormholes, false)
        elseif TabGroup == "Portals" then
            CreateToggleList(GUIContainer, Portalist.Data.Portals, DB.Portals, true)
        elseif TabGroup == "Mailboxes" then
            CreateToggleList(GUIContainer, Portalist.Data.Mailboxes, DB.Mailboxes, false)
        end
    end

    local TabGroup = AG:Create("TabGroup")
    TabGroup:SetLayout("Flow")
    TabGroup:SetTabs({
        { text = "Challenge Mode Portals", value = "ChallengeModePortals" },
        { text = "Hearthstones", value = "Hearthstones" },
        { text = "Wormholes", value = "Wormholes" },
        { text = "Portals", value = "Portals" },
        { text = "Mailboxes", value = "Mailboxes" }
    })
    TabGroup:SetCallback("OnGroupSelected", SelectTabGroup)
    TabGroup:SetFullHeight(true)
    TabGroup:SetFullWidth(true)
    TabGroup:SelectTab("ChallengeModePortals")
    GUIFrame:AddChild(TabGroup)
end