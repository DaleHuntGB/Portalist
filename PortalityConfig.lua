local _, Portality = ...
local AG = LibStub("AceGUI-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local isGUIOpen = false
local GUIFrame = nil

function Portality:CreateGUI()
    local DB = Portality.DB.global
    if isGUIOpen then return end
    isGUIOpen = true
    GUIFrame = AG:Create("Frame")
    GUIFrame:SetTitle("|A:dungeon:18:18|a|cFF8080FFPortality|r")
    GUIFrame:SetStatusText("Set Dropdown Keybind in Keybindings Menu")
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

    Portality.ActiveKeybind = nil

    local keybindButton = AG:Create("Button")
    keybindButton:SetRelativeWidth(0.5)
    keybindButton:SetText(select(1, GetBindingKey("PORTALITY_OPEN")) or "None")
    keybindButton:SetCallback("OnClick", function() Portality.ActiveKeybind = 1 Portality.KeybindCaptureFrame:Show() end)
    KeybindContainer:AddChild(keybindButton)

    local keybindButtonTwo = AG:Create("Button")
    keybindButtonTwo:SetRelativeWidth(0.5)
    keybindButtonTwo:SetText(select(2, GetBindingKey("PORTALITY_OPEN")) or "None")
    keybindButtonTwo:SetCallback("OnClick", function() Portality.ActiveKeybind = 2 Portality.KeybindCaptureFrame:Show() end)
    KeybindContainer:AddChild(keybindButtonTwo)

    if not Portality.KeybindCaptureFrame then
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

            local KeybindA, KeybindB = GetBindingKey("PORTALITY_OPEN")
            local activeKeybind = Portality.ActiveKeybind
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
                if key ~= "ESCAPE" then SetBinding(keyCombo, "PORTALITY_OPEN") end
            elseif activeKeybind == 2 then
                if KeybindB then SetBinding(KeybindB, nil) end
                if key ~= "ESCAPE" then SetBinding(keyCombo, "PORTALITY_OPEN") end
            end

            SaveBindings(GetCurrentBindingSet())
            keybindCaptureFrame:Hide()
        end)

        keybindCaptureFrame:SetScript("OnHide", function()
            local KeybindA, KeybindB = GetBindingKey("PORTALITY_OPEN")
            keybindButton:SetText(KeybindA or "None")
            keybindButtonTwo:SetText(KeybindB or "None")
            Portality.ActiveKeybind = nil
        end)

        keybindCaptureFrame:Hide()

        local captureFrameText = keybindCaptureFrame:CreateFontString(nil, "OVERLAY")
        captureFrameText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
        captureFrameText:SetPoint("CENTER", keybindCaptureFrame, "CENTER", 0, 0)
        captureFrameText:SetText("Set a Keybind\nPress Escape to Clear")
        captureFrameText:SetJustifyH("CENTER")

        Portality.KeybindCaptureFrame = keybindCaptureFrame
    end

    local function CreateToggleList(parent, dataList, activeTable, isSpell)
        local ScrollContainer = AG:Create("ScrollFrame")
        ScrollContainer:SetLayout("Flow")
        ScrollContainer:SetFullWidth(true)
        ScrollContainer:SetFullHeight(true)
        parent:AddChild(ScrollContainer)

        if isSpell then
            for _, expansionPortals in ipairs(dataList) do
                local HasVisiblePortals = false
                for spellID, isAvailable in pairs(expansionPortals) do
                    if isAvailable then
                        if not HasVisiblePortals then
                            local ExpansionHeading = AG:Create("Heading")
                            ExpansionHeading:SetText(Portality.Data.ChallengeModePortalsByExpansion[expansionPortals])
                            ExpansionHeading:SetFullWidth(true)
                            ScrollContainer:AddChild(ExpansionHeading)
                            HasVisiblePortals = true
                        end

                        local Toggle = AG:Create("CheckBox")
                        Toggle:SetLabel(Portality:CreateDisplayName(spellID, isSpell))
                        Toggle:SetValue(activeTable[spellID] == true)
                        Toggle:SetRelativeWidth(0.5)
                        Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[spellID] = value Portality:GenerateDropdownData() end)
                        Toggle:SetDisabled(not Portality:IsLearnt(spellID, isSpell))
                        ScrollContainer:AddChild(Toggle)
                    end
                end
            end
            return
        end

        for itemID in pairs(dataList) do
            local Toggle = AG:Create("CheckBox")
            Toggle:SetLabel(Portality:CreateDisplayName(itemID, isSpell))
            Toggle:SetValue(activeTable[itemID] == true)
            Toggle:SetRelativeWidth(0.5)
            Toggle:SetCallback("OnValueChanged", function(_, _, value) activeTable[itemID] = value Portality:GenerateDropdownData() end)
            Toggle:SetDisabled(not Portality:IsLearnt(itemID, isSpell))
            ScrollContainer:AddChild(Toggle)
        end
    end

    local function SelectTabGroup(GUIContainer, _, TabGroup)
        GUIContainer:ReleaseChildren()
        if TabGroup == "ChallengeModePortals" then
            CreateToggleList(GUIContainer, Portality.Data.ChallengeModePortals, DB.ChallengeModePortals, true)
        elseif TabGroup == "Hearthstones" then
            CreateToggleList(GUIContainer, Portality.Data.Hearthstones, DB.Hearthstones, false)
        elseif TabGroup == "Wormholes" then
            CreateToggleList(GUIContainer, Portality.Data.Wormholes, DB.Wormholes, false)
        end
    end

    local TabGroup = AG:Create("TabGroup")
    TabGroup:SetLayout("Flow")
    TabGroup:SetTabs({
        { text = "Challenge Mode Portals", value = "ChallengeModePortals" },
        { text = "Hearthstones", value = "Hearthstones" },
        { text = "Wormholes", value = "Wormholes" },
    })
    TabGroup:SetCallback("OnGroupSelected", SelectTabGroup)
    TabGroup:SetFullHeight(true)
    TabGroup:SetFullWidth(true)
    TabGroup:SelectTab("ChallengeModePortals")
    GUIFrame:AddChild(TabGroup)
end

function Portality:CreateOptions()
    local DB = Portality.DB.global

    local function GetBinding(index)
        return select(index, GetBindingKey("PORTALITY_OPEN")) or "None"
    end

    local function SetBindingKey(index, key)
        local KeybindA, KeybindB = GetBindingKey("PORTALITY_OPEN")

        if index == 1 then
            if KeybindA then SetBinding(KeybindA, nil) end
            if key then SetBinding(key, "PORTALITY_OPEN") end
        else
            if KeybindB then SetBinding(KeybindB, nil) end
            if key then SetBinding(key, "PORTALITY_OPEN") end
        end

        SaveBindings(GetCurrentBindingSet())
    end

    local options = {
        type = "group",
        name = "Portality",
        args = {
            ConfigurationDescription = {
                type = "description",
                name = "`/port` will also open a configuration window.",
                order = 0,
            },
            KeybindHeader = {
                type = "header",
                name = "Keybinds",
                order = 1,
            },
            KeybindOne = {
                type = "keybinding",
                name = "",
                order = 2,
                width = "full",
                get = function() return GetBinding(1) end,
                set = function(_, key) SetBindingKey(1, key) end,
            },
            KeybindTwo = {
                type = "keybinding",
                name = "",
                order = 3,
                width = "full",
                get = function() return GetBinding(2) end,
                set = function(_, key) SetBindingKey(2, key) end,
            },
            ChallengeModePortals = {
                type = "group",
                name = "Challenge Mode Portals",
                order = 10,
                args = (function()
                    local args = {}
                    local order = 1
                    for expansionIndex, expansionPortals in ipairs(Portality.Data.ChallengeModePortals) do
                        local hasHeader = false
                        for spellID, isAvailable in pairs(expansionPortals) do
                            if isAvailable then
                                if not hasHeader then
                                    args["header_" .. order] = {
                                        type = "header",
                                        name = Portality.Data.ChallengeModePortalsByExpansion[expansionPortals],
                                        order = order,
                                    }
                                    order = order + 1
                                    hasHeader = true
                                end

                                args["spell_" .. expansionIndex .. "_" .. spellID] = {
                                    type = "toggle",
                                    name = Portality:CreateDisplayName(spellID, true),
                                    order = order,
                                    width = "full",
                                    get = function() return DB.ChallengeModePortals[spellID] == true end,
                                    set = function(_, val) DB.ChallengeModePortals[spellID] = val Portality:GenerateDropdownData() end,
                                    disabled = function() return not Portality:IsLearnt(spellID, true) end,
                                    descStyle = "hidden"
                                }
                                order = order + 1
                            end
                        end
                    end

                    return args
                end)(),
            },

            Hearthstones = {
                type = "group",
                name = "Hearthstones",
                order = 20,
                args = (function()
                    local args = {}
                    local order = 1

                    for itemID in pairs(Portality.Data.Hearthstones) do
                        args["item_" .. itemID] = {
                            type = "toggle",
                            name = Portality:CreateDisplayName(itemID, false),
                            order = order,
                            width = "full",
                            get = function() return DB.Hearthstones[itemID] == true end,
                            set = function(_, val) DB.Hearthstones[itemID] = val Portality:GenerateDropdownData() end,
                            disabled = function() return not Portality:IsLearnt(itemID, false) end,
                            descStyle = "hidden"
                        }
                        order = order + 1
                    end

                    return args
                end)(),
            },

            Wormholes = {
                type = "group",
                name = "Wormholes",
                order = 30,
                args = (function()
                    local args = {}
                    local order = 1

                    for itemID in pairs(Portality.Data.Wormholes) do
                        args["wormhole_" .. itemID] = {
                            type = "toggle",
                            name = Portality:CreateDisplayName(itemID, false),
                            order = order,
                            width = "full",
                            get = function() return DB.Wormholes[itemID] == true end,
                            set = function(_, val) DB.Wormholes[itemID] = val Portality:GenerateDropdownData() end,
                            disabled = function() return not Portality:IsLearnt(itemID, false) end,
                            descStyle = "hidden"
                        }
                        order = order + 1
                    end

                    return args
                end)(),
            },
        },
    }

    ACR:RegisterOptionsTable("Portality", options)
    ACD:AddToBlizOptions("Portality", "Portality")
end