local _, Portalist = ...
local AG = LibStub("AceGUI-3.0")
local isGUIOpen = false
local GUIFrame = nil

function Portalist:CreateGUI()
    local DB = Portalist.DB.global
    if isGUIOpen then return end
    isGUIOpen = true
    GUIFrame = AG:Create("Frame")
    GUIFrame:SetTitle("|A:dungeon:18:18|a|cFF8080FFPortalist|r")
    GUIFrame:SetLayout("Flow")
    GUIFrame:SetWidth(800)
    GUIFrame:SetHeight(600)
    GUIFrame:SetCallback("OnClose", function() isGUIOpen = false AG:Release(GUIFrame) end)
    GUIFrame:EnableResize(false)
    GUIFrame:Show()

    local KeybindContainer = AG:Create("InlineGroup")
    KeybindContainer:SetLayout("Flow")
    KeybindContainer:SetTitle("Dropdown Menu Keybind")
    KeybindContainer:SetFullWidth(true)
    GUIFrame:AddChild(KeybindContainer)

    Portalist.ActiveKeybind = nil

    local keybindButton = AG:Create("Button")
    keybindButton:SetRelativeWidth(0.5)
    keybindButton:SetText(select(1, GetBindingKey("PORTALIST_OPEN")) or "None")
    keybindButton:SetCallback("OnClick", function() Portalist.ActiveKeybind = 1 Portalist.KeybindCaptureFrame:Show() end)
    KeybindContainer:AddChild(keybindButton)

    local keybindButtonTwo = AG:Create("Button")
    keybindButtonTwo:SetRelativeWidth(0.5)
    keybindButtonTwo:SetText(select(2, GetBindingKey("PORTALIST_OPEN")) or "None")
    keybindButtonTwo:SetCallback("OnClick", function() Portalist.ActiveKeybind = 2 Portalist.KeybindCaptureFrame:Show() end)
    KeybindContainer:AddChild(keybindButtonTwo)

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
                            Toggle:SetLabel(Portalist:CreateDisplayName(spellID, isSpell))
                            Toggle:SetValue(activeTable[spellID] == true)
                            Toggle:SetRelativeWidth(0.5)
                            Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[spellID] = value Portalist:GenerateDropdownData() end)
                            Toggle:SetDisabled(not Portalist:IsLearnt(spellID, isSpell))
                            ScrollContainer:AddChild(Toggle)
                        end
                    end
                end
            else
                for spellID in pairs(dataList) do
                    local Toggle = AG:Create("CheckBox")
                    Toggle:SetLabel(Portalist:CreateDisplayName(spellID, isSpell))
                    Toggle:SetValue(activeTable[spellID] == true)
                    Toggle:SetRelativeWidth(0.5)
                    Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[spellID] = value Portalist:GenerateDropdownData() end)
                    Toggle:SetDisabled(not Portalist:IsLearnt(spellID, isSpell))
                    ScrollContainer:AddChild(Toggle)
                end
            end
            return
        end

        for itemID in pairs(dataList) do
            local Toggle = AG:Create("CheckBox")
            Toggle:SetLabel(Portalist:CreateDisplayName(itemID, isSpell))
            Toggle:SetValue(activeTable[itemID] == true)
            Toggle:SetRelativeWidth(0.5)
            Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[itemID] = value Portalist:GenerateDropdownData() end)
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