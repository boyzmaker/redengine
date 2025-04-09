-- RedEngine GUI - Consolidated Version
-- All library dependencies included within this file

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

-- Store all connections for proper cleanup
local Connections = {}
local ActiveFeatures = {}

-- Hand cursor icon URL - using a transparent hand cursor
local HandCursorIcon = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
local DefaultCursor = ""

-- World Check
local First_Sea = false
local Second_Sea = false
local Third_Sea = false
local placeId = game.PlaceId

if placeId == 2753915549 then
    First_Sea = true
elseif placeId == 4442272183 then
    Second_Sea = true
elseif placeId == 7449423635 then
    Third_Sea = true
end

-- Utility Functions
local utility = {}

function utility:Tween(instance, properties, duration, ...)
    local tween = TweenService:Create(instance, TweenInfo.new(duration, ...), properties)
    tween:Play()
    return tween
end

function utility:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    local connection1 = frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            local connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            table.insert(Connections, connection)
        end
    end)
    
    local connection2 = frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    local connection3 = UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    
    -- Set hand cursor for draggable area
    local mouseEnterConn = frame.MouseEnter:Connect(function()
        Mouse.Icon = HandCursorIcon
    end)
    
    local mouseLeaveConn = frame.MouseLeave:Connect(function()
        if not dragging then
            Mouse.Icon = DefaultCursor
        end
    end)
    
    table.insert(Connections, connection1)
    table.insert(Connections, connection2)
    table.insert(Connections, connection3)
    table.insert(Connections, mouseEnterConn)
    table.insert(Connections, mouseLeaveConn)
end

-- Function to apply hand cursor to an element
function utility:ApplyHandCursor(element)
    local mouseEnterConn = element.MouseEnter:Connect(function()
        Mouse.Icon = HandCursorIcon
    end)
    
    local mouseLeaveConn = element.MouseLeave:Connect(function()
        Mouse.Icon = DefaultCursor
    end)
    
    table.insert(Connections, mouseEnterConn)
    table.insert(Connections, mouseLeaveConn)
end

-- Library
local Library = {}

-- Color scheme
local colors = {
    primary = Color3.fromRGB(200, 30, 30),    -- Cool red
    secondary = Color3.fromRGB(30, 180, 30),  -- Green accent
    background = Color3.fromRGB(30, 30, 30),  -- Dark background
    text = Color3.fromRGB(255, 255, 255),     -- White text
    border = Color3.fromRGB(60, 60, 60),      -- Dark border
    highlight = Color3.fromRGB(255, 100, 100) -- Highlight red
}

-- Changelog data
local changelogs = {
    {version = "v1.2.1", date = "2023-06-15", changes = {"Fixed server hop functionality", "Improved UI performance", "Added Lower Server option"}},
    {version = "v1.2.0", date = "2023-06-01", changes = {"Added Teleport tab", "New color scheme", "Optimized code"}},
    {version = "v1.1.5", date = "2023-05-20", changes = {"Bug fixes", "Added more farm options", "UI improvements"}},
    {version = "v1.1.0", date = "2023-05-05", changes = {"Added Macro functionality", "New settings options", "Performance enhancements"}},
    {version = "v1.0.0", date = "2023-04-20", changes = {"Initial release", "Basic functionality implemented"}}
}

function Library:CreateWindow(hubname)
    local RedEngineGUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local MinimizeBtn = Instance.new("TextButton")
    local NavBar = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local NavBarLayout = Instance.new("UIListLayout")
    local NavBarPadding = Instance.new("UIPadding")
    local ContentContainer = Instance.new("Frame")
    local HomeTab = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local ServerTab = Instance.new("ScrollingFrame")
    local UIListLayout_2 = Instance.new("UIListLayout")
    local UIPadding_2 = Instance.new("UIPadding")
    local TeleportTab = Instance.new("ScrollingFrame")
    local UIListLayout_3 = Instance.new("UIListLayout")
    local UIPadding_3 = Instance.new("UIPadding")
    local MainFarmTab = Instance.new("ScrollingFrame")
    local UIListLayout_4 = Instance.new("UIListLayout")
    local UIPadding_4 = Instance.new("UIPadding")
    local SubFarmTab = Instance.new("ScrollingFrame")
    local UIListLayout_5 = Instance.new("UIListLayout")
    local UIPadding_5 = Instance.new("UIPadding")
    local MacroTab = Instance.new("ScrollingFrame")
    local UIListLayout_6 = Instance.new("UIListLayout")
    local UIPadding_6 = Instance.new("UIPadding")
    local ShopTab = Instance.new("ScrollingFrame")
    local UIListLayout_7 = Instance.new("UIListLayout")
    local UIPadding_7 = Instance.new("UIPadding")
    local SettingsTab = Instance.new("ScrollingFrame")
    local UIListLayout_8 = Instance.new("UIListLayout")
    local UIPadding_8 = Instance.new("UIPadding")

    -- Properties
    RedEngineGUI.Name = "RedEngineGUI"
    RedEngineGUI.Parent = game.CoreGui
    RedEngineGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    RedEngineGUI.ResetOnSpawn = false
    RedEngineGUI.DisplayOrder = 999 -- Ensure it's on top

    Main.Name = "Main"
    Main.Parent = RedEngineGUI
    Main.BackgroundColor3 = colors.background
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.ClipsDescendants = true
    Main.Active = true

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main

    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = colors.primary
    TopBar.Size = UDim2.new(1, 0, 0, 30)

    UICorner_2.CornerRadius = UDim.new(0, 6)
    UICorner_2.Parent = TopBar

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = hubname or "RedEngine"
    Title.TextColor3 = colors.text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Create a circular minimize button with "RE" text
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.BackgroundColor3 = colors.secondary
    MinimizeBtn.Position = UDim2.new(1, -30, 0.5, -10)
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "RE"
    MinimizeBtn.TextColor3 = colors.text
    MinimizeBtn.TextSize = 10
    MinimizeBtn.AutoButtonColor = false
    MinimizeBtn.Selectable = false
    MinimizeBtn.Active = true
    MinimizeBtn.ClipsDescendants = true
    
    local UICorner_MinBtn = Instance.new("UICorner")
    UICorner_MinBtn.CornerRadius = UDim.new(1, 0)
    UICorner_MinBtn.Parent = MinimizeBtn
    
    -- Apply hand cursor to minimize button
    utility:ApplyHandCursor(MinimizeBtn)

    NavBar.Name = "NavBar"
    NavBar.Parent = Main
    NavBar.BackgroundColor3 = colors.border
    NavBar.Position = UDim2.new(0, 0, 0, 30)
    NavBar.Size = UDim2.new(0, 120, 1, -30)

    UICorner_3.CornerRadius = UDim.new(0, 6)
    UICorner_3.Parent = NavBar

    NavBarLayout.Name = "NavBarLayout"
    NavBarLayout.Parent = NavBar
    NavBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NavBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavBarLayout.Padding = UDim.new(0, 5)

    NavBarPadding.Name = "NavBarPadding"
    NavBarPadding.Parent = NavBar
    NavBarPadding.PaddingTop = UDim.new(0, 10)

    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 120, 0, 30)
    ContentContainer.Size = UDim2.new(1, -120, 1, -30)

    -- Setup tabs
    HomeTab.Name = "HomeTab"
    HomeTab.Parent = ContentContainer
    HomeTab.Active = true
    HomeTab.BackgroundTransparency = 1
    HomeTab.BorderSizePixel = 0
    HomeTab.Size = UDim2.new(1, 0, 1, 0)
    HomeTab.ScrollBarThickness = 4
    HomeTab.Visible = true
    HomeTab.ScrollingEnabled = true
    HomeTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    HomeTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout.Parent = HomeTab
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)

    UIPadding.Parent = HomeTab
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)

    ServerTab.Name = "ServerTab"
    ServerTab.Parent = ContentContainer
    ServerTab.Active = true
    ServerTab.BackgroundTransparency = 1
    ServerTab.BorderSizePixel = 0
    ServerTab.Size = UDim2.new(1, 0, 1, 0)
    ServerTab.ScrollBarThickness = 4
    ServerTab.Visible = false
    ServerTab.ScrollingEnabled = true
    ServerTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    ServerTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout_2.Parent = ServerTab
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Padding = UDim.new(0, 10)

    UIPadding_2.Parent = ServerTab
    UIPadding_2.PaddingLeft = UDim.new(0, 10)
    UIPadding_2.PaddingTop = UDim.new(0, 10)
    UIPadding_2.PaddingRight = UDim.new(0, 10)
    UIPadding_2.PaddingBottom = UDim.new(0, 10)

    TeleportTab.Name = "TeleportTab"
    TeleportTab.Parent = ContentContainer
    TeleportTab.Active = true
    TeleportTab.BackgroundTransparency = 1
    TeleportTab.BorderSizePixel = 0
    TeleportTab.Size = UDim2.new(1, 0, 1, 0)
    TeleportTab.ScrollBarThickness = 4
    TeleportTab.Visible = false
    TeleportTab.ScrollingEnabled = true
    TeleportTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    TeleportTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout_3.Parent = TeleportTab
    UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_3.Padding = UDim.new(0, 10)

    UIPadding_3.Parent = TeleportTab
    UIPadding_3.PaddingLeft = UDim.new(0, 10)
    UIPadding_3.PaddingTop = UDim.new(0, 10)
    UIPadding_3.PaddingRight = UDim.new(0, 10)
    UIPadding_3.PaddingBottom = UDim.new(0, 10)

    MainFarmTab.Name = "MainFarmTab"
    MainFarmTab.Parent = ContentContainer
    MainFarmTab.Active = true
    MainFarmTab.BackgroundTransparency = 1
    MainFarmTab.BorderSizePixel = 0
    MainFarmTab.Size = UDim2.new(1, 0, 1, 0)
    MainFarmTab.ScrollBarThickness = 4
    MainFarmTab.Visible = false
    MainFarmTab.ScrollingEnabled = true
    MainFarmTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    MainFarmTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout_4.Parent = MainFarmTab
    UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_4.Padding = UDim.new(0, 10)

    UIPadding_4.Parent = MainFarmTab
    UIPadding_4.PaddingLeft = UDim.new(0, 10)
    UIPadding_4.PaddingTop = UDim.new(0, 10)
    UIPadding_4.PaddingRight = UDim.new(0, 10)
    UIPadding_4.PaddingBottom = UDim.new(0, 10)

    SubFarmTab.Name = "SubFarmTab"
    SubFarmTab.Parent = ContentContainer
    SubFarmTab.Active = true
    SubFarmTab.BackgroundTransparency = 1
    SubFarmTab.BorderSizePixel = 0
    SubFarmTab.Size = UDim2.new(1, 0, 1, 0)
    SubFarmTab.ScrollBarThickness = 4
    SubFarmTab.Visible = false
    SubFarmTab.ScrollingEnabled = true
    SubFarmTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    SubFarmTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout_5.Parent = SubFarmTab
    UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_5.Padding = UDim.new(0, 10)

    UIPadding_5.Parent = SubFarmTab
    UIPadding_5.PaddingLeft = UDim.new(0, 10)
    UIPadding_5.PaddingTop = UDim.new(0, 10)
    UIPadding_5.PaddingRight = UDim.new(0, 10)
    UIPadding_5.PaddingBottom = UDim.new(0, 10)

    MacroTab.Name = "MacroTab"
    MacroTab.Parent = ContentContainer
    MacroTab.Active = true
    MacroTab.BackgroundTransparency = 1
    MacroTab.BorderSizePixel = 0
    MacroTab.Size = UDim2.new(1, 0, 1, 0)
    MacroTab.ScrollBarThickness = 4
    MacroTab.Visible = false
    MacroTab.ScrollingEnabled = true
    MacroTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    MacroTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout_6.Parent = MacroTab
    UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_6.Padding = UDim.new(0, 10)

    UIPadding_6.Parent = MacroTab
    UIPadding_6.PaddingLeft = UDim.new(0, 10)
    UIPadding_6.PaddingTop = UDim.new(0, 10)
    UIPadding_6.PaddingRight = UDim.new(0, 10)
    UIPadding_6.PaddingBottom = UDim.new(0, 10)

    ShopTab.Name = "ShopTab"
    ShopTab.Parent = ContentContainer
    ShopTab.Active = true
    ShopTab.BackgroundTransparency = 1
    ShopTab.BorderSizePixel = 0
    ShopTab.Size = UDim2.new(1, 0, 1, 0)
    ShopTab.ScrollBarThickness = 4
    ShopTab.Visible = false
    ShopTab.ScrollingEnabled = true
    ShopTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    ShopTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout_7.Parent = ShopTab
    UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_7.Padding = UDim.new(0, 10)

    UIPadding_7.Parent = ShopTab
    UIPadding_7.PaddingLeft = UDim.new(0, 10)
    UIPadding_7.PaddingTop = UDim.new(0, 10)
    UIPadding_7.PaddingRight = UDim.new(0, 10)
    UIPadding_7.PaddingBottom = UDim.new(0, 10)

    SettingsTab.Name = "SettingsTab"
    SettingsTab.Parent = ContentContainer
    SettingsTab.Active = true
    SettingsTab.BackgroundTransparency = 1
    SettingsTab.BorderSizePixel = 0
    SettingsTab.Size = UDim2.new(1, 0, 1, 0)
    SettingsTab.ScrollBarThickness = 4
    SettingsTab.Visible = false
    SettingsTab.ScrollingEnabled = true
    SettingsTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    SettingsTab.AutomaticCanvasSize = Enum.AutomaticSize.Y

    UIListLayout_8.Parent = SettingsTab
    UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_8.Padding = UDim.new(0, 10)

    UIPadding_8.Parent = SettingsTab
    UIPadding_8.PaddingLeft = UDim.new(0, 10)
    UIPadding_8.PaddingTop = UDim.new(0, 10)
    UIPadding_8.PaddingRight = UDim.new(0, 10)
    UIPadding_8.PaddingBottom = UDim.new(0, 10)

    -- Create tab buttons in the specified order
    local tabButtons = {}
    local tabs = {
        {name = "Home", frame = HomeTab},
        {name = "Server", frame = ServerTab},
        {name = "Teleport", frame = TeleportTab},
        {name = "Main Farm", frame = MainFarmTab},
        {name = "Sub Farm", frame = SubFarmTab},
        {name = "Macro", frame = MacroTab},
        {name = "Shop", frame = ShopTab},
        {name = "Settings", frame = SettingsTab}
    }

    local function switchTab(tabName)
        for _, tab in pairs(tabs) do
            tab.frame.Visible = (tab.name == tabName)
        end
        
        for _, button in pairs(tabButtons) do
            if button.Name == tabName .. "Button" then
                button.BackgroundColor3 = colors.primary
                button.TextColor3 = colors.text
            else
                button.BackgroundColor3 = colors.border
                button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end

    for i, tab in ipairs(tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tab.name .. "Button"
        TabButton.Parent = NavBar
        TabButton.BackgroundColor3 = i == 1 and colors.primary or colors.border
        TabButton.Size = UDim2.new(0.9, 0, 0, 30)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = tab.name
        TabButton.TextColor3 = i == 1 and colors.text or Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.LayoutOrder = i
        TabButton.AutoButtonColor = false
        TabButton.Selectable = false
        TabButton.Active = true
        TabButton.ClipsDescendants = true
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 4)
        UICorner_Button.Parent = TabButton
        
        -- Apply hand cursor to tab button
        utility:ApplyHandCursor(TabButton)
        
        local connection = TabButton.MouseButton1Click:Connect(function()
            switchTab(tab.name)
        end)
        table.insert(Connections, connection)
        
        table.insert(tabButtons, TabButton)
    end

    -- Create two-column layout for Home tab
    local HomeColumns = Instance.new("Frame")
    HomeColumns.Name = "HomeColumns"
    HomeColumns.Parent = HomeTab
    HomeColumns.BackgroundTransparency = 1
    HomeColumns.Size = UDim2.new(1, 0, 0, 280)
    
    local LeftColumn = Instance.new("Frame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Parent = HomeColumns
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    
    local RightColumn = Instance.new("Frame")
    RightColumn.Name = "RightColumn"
    RightColumn.Parent = HomeColumns
    RightColumn.BackgroundTransparency = 1
    RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
    RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    
    local LeftColumnLayout = Instance.new("UIListLayout")
    LeftColumnLayout.Parent = LeftColumn
    LeftColumnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftColumnLayout.Padding = UDim.new(0, 10)
    
    local RightColumnLayout = Instance.new("UIListLayout")
    RightColumnLayout.Parent = RightColumn
    RightColumnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftColumnLayout.Padding = UDim.new(0, 10)

    -- Create changelog section
    local ChangelogSection = Instance.new("Frame")
    ChangelogSection.Name = "ChangelogSection"
    ChangelogSection.Parent = LeftColumn
    ChangelogSection.BackgroundColor3 = colors.border
    ChangelogSection.Size = UDim2.new(1, 0, 0, 280)
    
    local UICorner_Changelog = Instance.new("UICorner")
    UICorner_Changelog.CornerRadius = UDim.new(0, 4)
    UICorner_Changelog.Parent = ChangelogSection
    
    local ChangelogTitle = Instance.new("TextLabel")
    ChangelogTitle.Name = "ChangelogTitle"
    ChangelogTitle.Parent = ChangelogSection
    ChangelogTitle.BackgroundTransparency = 1
    ChangelogTitle.Position = UDim2.new(0, 0, 0, 0)
    ChangelogTitle.Size = UDim2.new(1, 0, 0, 30)
    ChangelogTitle.Font = Enum.Font.GothamBold
    ChangelogTitle.Text = "Changelog"
    ChangelogTitle.TextColor3 = colors.secondary
    ChangelogTitle.TextSize = 16
    
    local ChangelogList = Instance.new("ScrollingFrame")
    ChangelogList.Name = "ChangelogList"
    ChangelogList.Parent = ChangelogSection
    ChangelogList.BackgroundTransparency = 1
    ChangelogList.Position = UDim2.new(0, 5, 0, 35)
    ChangelogList.Size = UDim2.new(1, -10, 1, -40)
    ChangelogList.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChangelogList.ScrollBarThickness = 4
    ChangelogList.ScrollingDirection = Enum.ScrollingDirection.Y
    ChangelogList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ChangelogList.ScrollingEnabled = true
    ChangelogList.ClipsDescendants = true
    
    -- Apply hand cursor to scrolling frame
    utility:ApplyHandCursor(ChangelogList)
    
    local ChangelogLayout = Instance.new("UIListLayout")
    ChangelogLayout.Parent = ChangelogList
    ChangelogLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ChangelogLayout.Padding = UDim.new(0, 10)
    
    -- Populate changelog
    for i, log in ipairs(changelogs) do
        local ChangelogEntry = Instance.new("Frame")
        ChangelogEntry.Name = "ChangelogEntry_" .. i
        ChangelogEntry.Parent = ChangelogList
        ChangelogEntry.BackgroundColor3 = colors.background
        ChangelogEntry.Size = UDim2.new(1, 0, 0, 80)
        ChangelogEntry.LayoutOrder = i
        
        local UICorner_Entry = Instance.new("UICorner")
        UICorner_Entry.CornerRadius = UDim.new(0, 4)
        UICorner_Entry.Parent = ChangelogEntry
        
        local VersionLabel = Instance.new("TextLabel")
        VersionLabel.Name = "VersionLabel"
        VersionLabel.Parent = ChangelogEntry
        VersionLabel.BackgroundTransparency = 1
        VersionLabel.Position = UDim2.new(0, 5, 0, 5)
        VersionLabel.Size = UDim2.new(0.5, 0, 0, 20)
        VersionLabel.Font = Enum.Font.GothamBold
        VersionLabel.Text = log.version
        VersionLabel.TextColor3 = colors.secondary
        VersionLabel.TextSize = 14
        VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
        VersionLabel.Active = false
        VersionLabel.Selectable = false
        
        local DateLabel = Instance.new("TextLabel")
        DateLabel.Name = "DateLabel"
        DateLabel.Parent = ChangelogEntry
        DateLabel.BackgroundTransparency = 1
        DateLabel.Position = UDim2.new(0.5, 0, 0, 5)
        DateLabel.Size = UDim2.new(0.5, -5, 0, 20)
        DateLabel.Font = Enum.Font.Gotham
        DateLabel.Text = log.date
        DateLabel.TextColor3 = colors.text
        DateLabel.TextSize = 12
        DateLabel.TextXAlignment = Enum.TextXAlignment.Right
        DateLabel.Active = false
        DateLabel.Selectable = false
        
        local ChangesList = Instance.new("Frame")
        ChangesList.Name = "ChangesList"
        ChangesList.Parent = ChangelogEntry
        ChangesList.BackgroundTransparency = 1
        ChangesList.Position = UDim2.new(0, 5, 0, 30)
        ChangesList.Size = UDim2.new(1, -10, 0, 45)
        
        local ChangesLayout = Instance.new("UIListLayout")
        ChangesLayout.Parent = ChangesList
        ChangesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ChangesLayout.Padding = UDim.new(0, 5)
        
        for j, change in ipairs(log.changes) do
            local ChangeItem = Instance.new("TextLabel")
            ChangeItem.Name = "ChangeItem_" .. j
            ChangeItem.Parent = ChangesList
            ChangeItem.BackgroundTransparency = 1
            ChangeItem.Size = UDim2.new(1, 0, 0, 15)
            ChangeItem.Font = Enum.Font.Gotham
            ChangeItem.Text = "• " .. change
            ChangeItem.TextColor3 = colors.text
            ChangeItem.TextSize = 12
            ChangeItem.TextXAlignment = Enum.TextXAlignment.Left
            ChangeItem.TextWrapped = true
            ChangeItem.Active = false
            ChangeItem.Selectable = false
        end
    end

    -- Create toggle buttons in the right column
    local function createToggle(parent, name, callback, defaultState)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = name .. "Toggle"
        ToggleFrame.Parent = parent
        ToggleFrame.BackgroundColor3 = colors.border
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        
        local UICorner_Toggle = Instance.new("UICorner")
        UICorner_Toggle.CornerRadius = UDim.new(0, 4)
        UICorner_Toggle.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "ToggleLabel"
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = colors.text
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Active = false
        ToggleLabel.Selectable = false
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = defaultState and colors.secondary or Color3.fromRGB(50, 50, 50)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Font = Enum.Font.Gotham
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = colors.text
        ToggleButton.TextSize = 14
        ToggleButton.AutoButtonColor = false
        ToggleButton.Selectable = false
        ToggleButton.Active = true
        ToggleButton.ClipsDescendants = true
        
        -- Apply hand cursor to toggle button
        utility:ApplyHandCursor(ToggleButton)
        
        ToggleButton.Selectable = false
        ToggleButton.Active = true
        ToggleButton.ClipsDescendants = true
        
        -- Apply hand cursor to toggle button
        utility:ApplyHandCursor(ToggleButton)
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 10)
        UICorner_Button.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Name = "ToggleCircle"
        ToggleCircle.Parent = ToggleButton
        ToggleCircle.BackgroundColor3 = colors.text
        ToggleCircle.Position = defaultState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
        
        local UICorner_Circle = Instance.new("UICorner")
        UICorner_Circle.CornerRadius = UDim.new(1, 0)
        UICorner_Circle.Parent = ToggleCircle
        
        local toggled = defaultState or false
        
        if toggled and callback then
            callback(toggled)
        end
        
        local connection = ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            if toggled then
                utility:Tween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                utility:Tween(ToggleButton, {BackgroundColor3 = colors.secondary}, 0.2)
            else
                utility:Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                utility:Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
            end
            
            if callback then
                callback(toggled)
            end
        end)
        table.insert(Connections, connection)
        
        return ToggleFrame, toggled
    end
    
    local function createButton(parent, name, callback)
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Name = name .. "Button"
        ButtonFrame.Parent = parent
        ButtonFrame.BackgroundColor3 = colors.primary
        ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
        ButtonFrame.Font = Enum.Font.GothamBold
        ButtonFrame.Text = name
        ButtonFrame.TextColor3 = colors.text
        ButtonFrame.TextSize = 14
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.Selectable = false
        ButtonFrame.Active = true
        ButtonFrame.ClipsDescendants = true
        
        -- Apply hand cursor to button
        utility:ApplyHandCursor(ButtonFrame)
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 4)
        UICorner_Button.Parent = ButtonFrame
        
        local connection = ButtonFrame.MouseButton1Click:Connect(function()
            utility:Tween(ButtonFrame, {BackgroundColor3 = colors.highlight}, 0.1)
            if callback then
                callback()
            end
            task.wait(0.1)
            utility:Tween(ButtonFrame, {BackgroundColor3 = colors.primary}, 0.1)
        end)
        table.insert(Connections, connection)
        
        return ButtonFrame
    end
    
    local function createDropdown(parent, name, options, callback, defaultOption)
        -- Create a simple dropdown that doesn't use text input fields
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = name .. "Dropdown"
        DropdownFrame.Parent = parent
        DropdownFrame.BackgroundColor3 = colors.border
        DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
        DropdownFrame.ZIndex = 1
        
        local UICorner_Dropdown = Instance.new("UICorner")
        UICorner_Dropdown.CornerRadius = UDim.new(0, 4)
        UICorner_Dropdown.Parent = DropdownFrame
        
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Name = "DropdownLabel"
        DropdownLabel.Parent = DropdownFrame
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
        DropdownLabel.Size = UDim2.new(0, 100, 1, 0)
        DropdownLabel.Font = Enum.Font.Gotham
        DropdownLabel.Text = name
        DropdownLabel.TextColor3 = colors.text
        DropdownLabel.TextSize = 14
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.ZIndex = 1
        DropdownLabel.Active = false
        DropdownLabel.Selectable = false
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "DropdownButton"
        DropdownButton.Parent = DropdownFrame
        DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        DropdownButton.Position = UDim2.new(0, 120, 0.5, -15)
        DropdownButton.Size = UDim2.new(1, -130, 0, 30)
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.Text = defaultOption or options[1] or "Select..."
        DropdownButton.TextColor3 = colors.text
        DropdownButton.TextSize = 14
        DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
        DropdownButton.AutoButtonColor = false
        DropdownButton.ZIndex = 2
        DropdownButton.Selectable = false
        DropdownButton.Active = true
        DropdownButton.ClipsDescendants = true
        
        -- Apply hand cursor to dropdown button
        utility:ApplyHandCursor(DropdownButton)
        
        local UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = DropdownButton
        UIPadding.PaddingLeft = UDim.new(0, 10)
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 4)
        UICorner_Button.Parent = DropdownButton
        
        -- Create dropdown options container with high ZIndex
        local OptionsContainer = Instance.new("ScrollingFrame")
        OptionsContainer.Name = "OptionsContainer"
        OptionsContainer.Parent = RedEngineGUI
        OptionsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        OptionsContainer.BorderSizePixel = 0
        OptionsContainer.Position = UDim2.new(0, 0, 0, 0)
        OptionsContainer.Size = UDim2.new(0, 200, 0, 0)
        OptionsContainer.Visible = false
        OptionsContainer.ZIndex = 100
        OptionsContainer.ScrollBarThickness = 4
        OptionsContainer.ScrollingEnabled = true
        OptionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        OptionsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        OptionsContainer.ClipsDescendants = true
        
        local UICorner_Options = Instance.new("UICorner")
        UICorner_Options.CornerRadius = UDim.new(0, 4)
        UICorner_Options.Parent = OptionsContainer
        
        local OptionsLayout = Instance.new("UIListLayout")
        OptionsLayout.Parent = OptionsContainer
        OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        OptionsLayout.Padding = UDim.new(0, 2)
        
        local OptionsPadding = Instance.new("UIPadding")
        OptionsPadding.Parent = OptionsContainer
        OptionsPadding.PaddingTop = UDim.new(0, 5)
        OptionsPadding.PaddingBottom = UDim.new(0, 5)
        OptionsPadding.PaddingLeft = UDim.new(0, 5)
        OptionsPadding.PaddingRight = UDim.new(0, 5)
        
        -- Create option buttons
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = "Option_" .. i
            OptionButton.Parent = OptionsContainer
            OptionButton.BackgroundColor3 = colors.border
            OptionButton.BackgroundTransparency = 0.5
            OptionButton.Size = UDim2.new(1, -10, 0, 25)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = option
            OptionButton.TextColor3 = colors.text
            OptionButton.TextSize = 14
            OptionButton.ZIndex = 101
            OptionButton.AutoButtonColor = false
            OptionButton.Selectable = false
            OptionButton.Active = true
            OptionButton.ClipsDescendants = true
            
            -- Apply hand cursor to option button
            utility:ApplyHandCursor(OptionButton)
            
            local UICorner_Option = Instance.new("UICorner")
            UICorner_Option.CornerRadius = UDim.new(0, 4)
            UICorner_Option.Parent = OptionButton
            
            local mouseEnterConnection = OptionButton.MouseEnter:Connect(function()
                utility:Tween(OptionButton, {BackgroundColor3 = colors.secondary}, 0.2)
                Mouse.Icon = HandCursorIcon
            end)
            
            local mouseLeaveConnection = OptionButton.MouseLeave:Connect(function()
                utility:Tween(OptionButton, {BackgroundColor3 = colors.border}, 0.2)
                Mouse.Icon = DefaultCursor
            end)
            
            local clickConnection = OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                OptionsContainer.Visible = false
                if callback then
                    callback(option)
                end
            end)
            
            table.insert(Connections, mouseEnterConnection)
            table.insert(Connections, mouseLeaveConnection)
            table.insert(Connections, clickConnection)
        end
        
        -- Toggle dropdown
        local dropdownOpen = false
        
        local dropdownClickConnection = DropdownButton.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            
            if dropdownOpen then
                -- Position the options container relative to the UI
                local buttonAbsPos = DropdownButton.AbsolutePosition
                local buttonAbsSize = DropdownButton.AbsoluteSize
                local mainGuiPos = RedEngineGUI.AbsolutePosition
                
                -- Calculate relative position to the GUI
                local relativeX = buttonAbsPos.X - mainGuiPos.X
                local relativeY = buttonAbsPos.Y - mainGuiPos.Y + buttonAbsSize.Y + 5
                
                OptionsContainer.Position = UDim2.new(0, relativeX, 0, relativeY)
                OptionsContainer.Size = UDim2.new(0, buttonAbsSize.X, 0, 0)
                OptionsContainer.Visible = true
                
                -- Animate opening with max height for scrolling
                utility:Tween(OptionsContainer, {Size = UDim2.new(0, buttonAbsSize.X, 0, math.min(#options * 30, 150))}, 0.2)
                utility:Tween(DropdownButton, {BackgroundColor3 = colors.secondary}, 0.2)
            else
                -- Animate closing
                utility:Tween(OptionsContainer, {Size = UDim2.new(0, OptionsContainer.AbsoluteSize.X, 0, 0)}, 0.2)
                utility:Tween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
                
                task.delay(0.2, function()
                    OptionsContainer.Visible = false
                end)
            end
        end)
        table.insert(Connections, dropdownClickConnection)
        
        -- Close dropdown when clicking elsewhere
        local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdownOpen then
                local mousePos = UserInputService:GetMouseLocation()
                local optionsPos = OptionsContainer.AbsolutePosition
                local optionsSize = OptionsContainer.AbsoluteSize
                local buttonPos = DropdownButton.AbsolutePosition
                local buttonSize = DropdownButton.AbsoluteSize
                
                -- Check if click is outside both the dropdown button and options container
                if not (
                    (mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                    mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y) or
                    (mousePos.X >= optionsPos.X and mousePos.X <= optionsPos.X + optionsSize.X and
                    mousePos.Y >= optionsPos.Y and mousePos.Y <= optionsPos.Y + optionsSize.Y)
                ) then
                    dropdownOpen = false
                    utility:Tween(OptionsContainer, {Size = UDim2.new(0, OptionsContainer.AbsoluteSize.X, 0, 0)}, 0.2)
                    utility:Tween(DropdownButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
                    
                    task.delay(0.2, function()
                        OptionsContainer.Visible = false
                    end)
                end
            end
        end)
        table.insert(Connections, inputBeganConnection)
        
        return DropdownFrame, DropdownButton.Text
    end
    
    -- Add toggles to the right column with default states
    local antiAFKToggle, antiAFKState = createToggle(RightColumn, "Anti-AFK", function(state)
        if state then
            setupAntiAFK(true)
        else
            setupAntiAFK(false)
        end
    end, true) -- Set to true to enable by default
    
    local infiniteJumpToggle, infiniteJumpState = createToggle(RightColumn, "Infinite Jump", function(state)
        if state then
            setupInfiniteJump(true)
        else
            setupInfiniteJump(false)
        end
    end, false)
    
    local noClipToggle, noClipState = createToggle(RightColumn, "No Clip", function(state)
        if state then
            setupNoClip(true)
        else
            setupNoClip(false)
        end
    end, false)
    
    -- Add server buttons to the Server tab
    createButton(ServerTab, "Rejoin Server", function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)
    
    createButton(ServerTab, "Server Hop", function()
        local servers = {}
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        
        for _, server in pairs(req.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Player)
        else
            -- No available servers
        end
    end)
    
    createButton(ServerTab, "Lower Server", function()
        local servers = {}
        local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        
        for _, server in pairs(req.data) do
            if server.playing < 10 and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Player)
        else
            -- No available servers with less than 10 players
        end
    end)
    
    -- Add sea teleport to the Teleport tab with improved visibility
    local seas = {"First Sea", "Second Sea", "Third Sea"}
    local selectedSea = "First Sea"
    
    local SeaDropdown, currentSea = createDropdown(TeleportTab, "Select Sea", seas, function(selected)
        selectedSea = selected
    end, "First Sea")
    
    createButton(TeleportTab, "Teleport to Sea", function()
        -- Teleport to selected sea functionality based on the provided code
        if selectedSea == "First Sea" then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
        elseif selectedSea == "Second Sea" then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        elseif selectedSea == "Third Sea" then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
        end
    end)
    
    -- Island Teleport section
    local IslandCheck = { -- Keep the island list
        "Start Island",
        "Marine Start",
        "Middle Town",
        "Jungle",
        "Pirate Village",
        "Desert",
        "Frozen Village",
        "Marine Ford",
        "Colosseum 1",
        "Sky island 1",
        "Sky island 2",
        "Sky island 3",
        "Sky island 4",
        "Prison",
        "Magma Village",
        "UndeyWater City",
        "Fountain City",
        "House Cyborgs",
        "Shanks Room"
    }
    local SelectedIsland = "Start Island" -- Keep the SelectedIsland variable

    local function teleportToIsland(islandName)
        local targetCFrame
        if islandName == "Start Island" then
            targetCFrame = CFrame.new(1071.2832, 16.3085976, 1426.86792)
        elseif islandName == "Marine Start" then
            targetCFrame = CFrame.new(-2573.3374, 6.88881969, 2046.99817)
        elseif islandName == "Middle Town" then
            targetCFrame = CFrame.new(-655.824158, 7.88708115, 1436.67908)
        elseif islandName == "Jungle" then
            targetCFrame = CFrame.new(-1249.77222, 11.8870859, 341.356476)
        elseif islandName == "Pirate Village" then
            targetCFrame = CFrame.new(-1122.34998, 4.78708982, 3855.91992)
        elseif islandName == "Desert" then
            targetCFrame = CFrame.new(1094.14587, 6.47350502, 4192.88721)
        elseif islandName == "Frozen Village" then
            targetCFrame = CFrame.new(1198.00928, 27.0074959, -1211.73376)
        elseif islandName == "Marine Ford" then
            targetCFrame = CFrame.new(-4505.375, 20.687294, 4260.55908)
        elseif islandName == "Colosseum 1" then
            targetCFrame = CFrame.new(-1428.35474, 7.38933945, -3014.37305)
        elseif islandName == "Sky island 1" then
            targetCFrame = CFrame.new(-4970.21875, 717.707275, -2622.35449)
        elseif islandName == "Sky island 2" then
            targetCFrame = CFrame.new(-4813.0249, 903.708557, -1912.69055)
        elseif islandName == "Sky island 3" then
            targetCFrame = CFrame.new(-7952.31006, 5545.52832, -320.704956)
        elseif islandName == "Sky island 4" then
            targetCFrame = CFrame.new(-7793.43896, 5607.22168, -2016.58362)
        elseif islandName == "Prison" then
            targetCFrame = CFrame.new(4854.16455, 5.68742752, 740.194641)
        elseif islandName == "Magma Village" then
            targetCFrame = CFrame.new(-5231.75879, 8.61593437, 8467.87695)
        elseif islandName == "UndeyWater City" then
            targetCFrame = CFrame.new(4040.8516, 3.7796879, -1832.78418)
        elseif islandName == "Fountain City" then
            targetCFrame = CFrame.new(5132.7124, 4.53632832, 4037.8562)
        elseif islandName == "House Cyborgs" then
            targetCFrame = CFrame.new(6262.72559, 71.3003616, 3998.23047)
        elseif islandName == "Shanks Room" then
            targetCFrame = CFrame.new(-1442.16553, 29.8788261, -28.3547478)
        elseif islandName == "Dock" then
            targetCFrame = CFrame.new(82.9490662, 18.0710983, 2834.98779)
        elseif islandName == "Kingdom of Rose" then
            targetCFrame = CFrame.new(-394.983521, 118.503128, 1245.8446)
        elseif islandName == "Mansion 1" then
            targetCFrame = CFrame.new(-390.096313, 331.886475, 673.464966)
        elseif islandName == "Flamingo Room" then
            targetCFrame = CFrame.new(2302.19019, 15.1778421, 663.811035)
        elseif islandName == "Green Zone" then
            targetCFrame = CFrame.new(-2372.14697, 72.9919434, -3166.51416)
        elseif islandName == "Cafe" then
            targetCFrame = CFrame.new(-385.250916, 73.0458984, 297.388397)
        elseif islandName == "Factory" then
            targetCFrame = CFrame.new(430.42569, 210.019623, -432.504791)
        elseif islandName == "Colosseum 2" then
            targetCFrame = CFrame.new(-1836.58191, 44.5890656, 1360.30652)
        elseif islandName == "Grave Island" then
            targetCFrame = CFrame.new(-5411.47607, 48.8234024, -721.272522)
        elseif islandName == "Snow Mountain" then
            targetCFrame = CFrame.new(511.825226, 401.765198, -5380.396)
        elseif islandName == "Cold Island" then
            targetCFrame = CFrame.new(-6026.96484, 14.7461271, -5071.96338)
        elseif islandName == "Hot Island" then
            targetCFrame = CFrame.new(-5478.39209, 15.9775667, -5246.9126)
        elseif islandName == "Cursed Ship" then
            targetCFrame = CFrame.new(902.059143, 124.752518, 33071.8125)
        elseif islandName == "Ice Castle" then
            targetCFrame = CFrame.new(5400.40381, 28.21698, -6236.99219)
        elseif islandName == "Forgotten Island" then
            targetCFrame = CFrame.new(-3043.31543, 238.881271, -10191.5791)
        elseif islandName == "Usoapp Island" then
            targetCFrame = CFrame.new(4748.78857, 8.35370827, 2849.57959)
        elseif islandName == "Minisky Island" then
            targetCFrame = CFrame.new(-260.358917, 49325.49609375, -35260)
        elseif islandName == "Port Town" then
            targetCFrame = CFrame.new(-610.309692, 57.8323097, 6436.33594)
        elseif islandName == "Hydra Island" then
            targetCFrame = CFrame.new(5229.99561, 603.916565, 345.154022)
        elseif islandName == "Great Tree" then
            targetCFrame = CFrame.new(2174.94873, 28.7312393, -6728.83154)
        elseif islandName == "Castle on the Sea" then
            targetCFrame = CFrame.new(-5477.62842, 313.794739, -2808.4585)
        elseif islandName == "Floating Turtle" then
            targetCFrame = CFrame.new(-10919.2998, 331.788452, -8637.57227)
        elseif islandName == "Mansion 2" then
            targetCFrame = CFrame.new(-12553.8125, 332.403961, -7621.91748)
        elseif islandName == "Secret Temple" then
            targetCFrame = CFrame.new(5217.35693, 6.56511116, 1100.88159)
        elseif islandName == "Friendly Arena" then
            targetCFrame = CFrame.new(5220.28955, 72.8193436, -1450.86304)
        elseif islandName == "Beautiful Pirate Domain" then
            targetCFrame = CFrame.new(5310.8095703125, 21.594484329224, 129.39053344727)
        elseif islandName == "Teler Park" then
            targetCFrame = CFrame.new(-9512.3623046875, 142.13258361816, 5548.845703125)
        elseif islandName == "Peanut Island" then
            targetCFrame = CFrame.new(-2142, 48, -10031)
        elseif islandName == "Chocolate Island" then
            targetCFrame = CFrame.new(156.896484, 30.5935211, -12662.7031, -0.573599219, 0, 0.81913656, 0, 1, 0, -0.81913656, 0, -0.573599219)
        elseif islandName == "Ice Cream Island" then
            targetCFrame = CFrame.new(-949, 59, -10907)
        elseif islandName == "Haunted Castle" then
            targetCFrame = CFrame.new(-9530.61035, -132.860657, 5763.13477)
        elseif islandName == "Cake Loaf" then
            targetCFrame = CFrame.new(-2099.33154, 66.9970703, -12128.585, 0.997561574, 0, 0.0697919354, 0, 1, 0, -0.0697919354, 0, 0.997561574)
        elseif islandName == "Candy Cane" then
            targetCFrame = CFrame.new(-1530.97144, 13.728817, -14770.0889, 0.898790359, -0, -0.438378751, 0, 1, -0, 0.438378751, 0, 0.898790359)
        elseif islandName == "Tiki Outpost" then
            targetCFrame = CFrame.new(-16548.8164, 55.6059914, -172.8125, 0.213092566, -0, -0.977032006, 0, 1, -0, 0.977032006, 0, 0.213092566)
        elseif islandName == "Raid Lab" then
            targetCFrame = CFrame.new(-5057.146484375, 314.54132080078, -2934.7995605469)
        elseif islandName == "Mini Sky" then
            targetCFrame = CFrame.new(-263.66668701172, 49325.49609375, -35260)
        elseif islandName == "Sea Beast" then
            targetCFrame = game:GetService("Workspace")["_WorldOrigin"].Locations["Sea of Treats"].CFrame
        end

        Tween(targetCFrame)
    end

    local IslandDropdown, currentIsland = createDropdown(TeleportTab, "Select Island", IslandCheck, function(selected)
        SelectedIsland = selected
    end, "Start Island")

    createButton(TeleportTab, "Teleport to Island", function()
        teleportToIsland(SelectedIsland)
    end)
    
    -- Add player info to the Settings tab
    local PlayerInfo = Instance.new("Frame")
    PlayerInfo.Name = "PlayerInfo"
    PlayerInfo.Parent = SettingsTab
    PlayerInfo.BackgroundColor3 = colors.border
    PlayerInfo.Size = UDim2.new(1, 0, 0, 120)
    
    local UICorner_PlayerInfo = Instance.new("UICorner")
    UICorner_PlayerInfo.CornerRadius = UDim.new(0, 4)
    UICorner_PlayerInfo.Parent = PlayerInfo
    
    local PlayerTitle = Instance.new("TextLabel")
    PlayerTitle.Name = "PlayerTitle"
    PlayerTitle.Parent = PlayerInfo
    PlayerTitle.BackgroundTransparency = 1
    PlayerTitle.Position = UDim2.new(0, 10, 0, 10)
    PlayerTitle.Size = UDim2.new(1, -20, 0, 20)
    PlayerTitle.Font = Enum.Font.GothamBold
    PlayerTitle.Text = "Player Information"
    PlayerTitle.TextColor3 = colors.secondary
    PlayerTitle.TextSize = 16
    PlayerTitle.TextXAlignment = Enum.TextXAlignment.Left
    PlayerTitle.Active = false
    PlayerTitle.Selectable = false
    
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Name = "PlayerName"
    PlayerName.Parent = PlayerInfo
    PlayerName.BackgroundTransparency = 1
    PlayerName.Position = UDim2.new(0, 10, 0, 40)
    PlayerName.Size = UDim2.new(1, -20, 0, 20)
    PlayerName.Font = Enum.Font.Gotham
    PlayerName.Text = "Username: " .. Player.Name
    PlayerName.TextColor3 = colors.secondary
    PlayerName.TextSize = 14
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    PlayerName.Active = false
    PlayerName.Selectable = false
    
    local PlayerID = Instance.new("TextLabel")
    PlayerID.Name = "PlayerID"
    PlayerID.Parent = PlayerInfo
    PlayerID.BackgroundTransparency = 1
    PlayerID.Position = UDim2.new(0, 10, 0, 65)
    PlayerID.Size = UDim2.new(1, -20, 0, 20)
    PlayerID.Font = Enum.Font.Gotham
    PlayerID.Text = "User ID: " .. Player.UserId
    PlayerID.TextColor3 = colors.secondary
    PlayerID.TextSize = 14
    PlayerID.TextXAlignment = Enum.TextXAlignment.Left
    PlayerID.Active = false
    PlayerID.Selectable = false
    
    local AccountAge = Instance.new("TextLabel")
    AccountAge.Name = "AccountAge"
    AccountAge.Parent = PlayerInfo
    AccountAge.BackgroundTransparency = 1
    AccountAge.Position = UDim2.new(0, 10, 0, 90)
    AccountAge.Size = UDim2.new(1, -20, 0, 20)
    AccountAge.Font = Enum.Font.Gotham
    AccountAge.Text = "Account Age: " .. Player.AccountAge .. " days"
    AccountAge.TextColor3 = colors.secondary
    AccountAge.TextSize = 14
    AccountAge.TextXAlignment = Enum.TextXAlignment.Left
    AccountAge.Active = false
    AccountAge.Selectable = false
    
    -- Add world info to the Settings tab
    local WorldInfo = Instance.new("Frame")
    WorldInfo.Name = "WorldInfo"
    WorldInfo.Parent = SettingsTab
    WorldInfo.BackgroundColor3 = colors.border
    WorldInfo.Size = UDim2.new(1, 0, 0, 80)
    WorldInfo.LayoutOrder = 2
    
    local UICorner_WorldInfo = Instance.new("UICorner")
    UICorner_WorldInfo.CornerRadius = UDim.new(0, 4)
    UICorner_WorldInfo.Parent = WorldInfo
    
    local WorldTitle = Instance.new("TextLabel")
    WorldTitle.Name = "WorldTitle"
    WorldTitle.Parent = WorldInfo
    WorldTitle.BackgroundTransparency = 1
    WorldTitle.Position = UDim2.new(0, 10, 0, 10)
    WorldTitle.Size = UDim2.new(1, -20, 0, 20)
    WorldTitle.Font = Enum.Font.GothamBold
    WorldTitle.Text = "Current World"
    WorldTitle.TextColor3 = colors.secondary
    WorldTitle.TextSize = 16
    WorldTitle.TextXAlignment = Enum.TextXAlignment.Left
    WorldTitle.Active = false
    WorldTitle.Selectable = false
    
    local WorldValue = Instance.new("TextLabel")
    WorldValue.Name = "WorldValue"
    WorldValue.Parent = WorldInfo
    WorldValue.BackgroundTransparency = 1
    WorldValue.Position = UDim2.new(0, 10, 0, 40)
    WorldValue.Size = UDim2.new(1, -20, 0, 20)
    WorldValue.Font = Enum.Font.Gotham
    WorldValue.Active = false
    WorldValue.Selectable = false
    
    -- Set the current world text based on the place ID
    if First_Sea then
        WorldValue.Text = "First Sea"
    elseif Second_Sea then
        WorldValue.Text = "Second Sea"
    elseif Third_Sea then
        WorldValue.Text = "Third Sea"
    else
        WorldValue.Text = "Unknown Sea"
    end
    
    WorldValue.TextColor3 = colors.secondary
    WorldValue.TextSize = 14
    WorldValue.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Add Destroy GUI button to Settings tab with proper cleanup
    createButton(SettingsTab, "Destroy GUI", function()
        -- Clean up all connections
        for _, connection in pairs(Connections) do
            if typeof(connection) == "RBXScriptConnection" and connection.Connected then
                connection:Disconnect()
            end
        end
        
        -- Disable all active features
        setupAntiAFK(false)
        setupInfiniteJump(false)
        setupNoClip(false)
        
        -- Reset cursor
        Mouse.Icon = DefaultCursor
        
        -- Destroy the GUI
        RedEngineGUI:Destroy()
        
        -- Clear variables
        Connections = {}
        ActiveFeatures = {}
        
        print("RedEngine GUI destroyed and all functions stopped")
    end)
    
    -- Make the GUI draggable
    utility:DraggingEnabled(TopBar, Main)
    
    -- Minimize functionality - transform into a circular icon
    local minimized = false
    local originalSize = UDim2.new(0, 600, 0, 350)
    local originalPosition = Main.Position
    
    local minimizeConnection = MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            -- Save current position
            originalPosition = Main.Position
            
            -- Animate to circle
            utility:Tween(Main, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
            utility:Tween(Main, {Position = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset + 275, originalPosition.Y.Scale, originalPosition.Y.Offset + 150)}, 0.3)
            
            -- Hide all content except TopBar
            NavBar.Visible = false
            ContentContainer.Visible = false
            
            -- Modify TopBar
            utility:Tween(TopBar, {Size = UDim2.new(1, 0, 1, 0)}, 0.3)
            Title.Visible = false
            
            -- Center minimize button
            MinimizeBtn.Position = UDim2.new(0.5, -10, 0.5, -10)
            MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
            MinimizeBtn.Text = "RE"
        else
            -- Restore to original state
            utility:Tween(Main, {Size = originalSize}, 0.3)
            utility:Tween(Main, {Position = originalPosition}, 0.3)
            
            -- Show all content
            NavBar.Visible = true
            ContentContainer.Visible = true
            
            -- Restore TopBar
            utility:Tween(TopBar, {Size = UDim2.new(1, 0, 0, 30)}, 0.3)
            Title.Visible = true
            
            -- Restore minimize button
            MinimizeBtn.Position = UDim2.new(1, -30, 0.5, -10)
            MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
            MinimizeBtn.Text = "RE"
        end
    end)
    table.insert(Connections, minimizeConnection)
    
    -- Toggle GUI with LeftControl key
    local guiVisible = true
    local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftControl then
            guiVisible = not guiVisible
            RedEngineGUI.Enabled = guiVisible
        end
    end)
    table.insert(Connections, inputBeganConnection)
    
    -- Ensure cursor is reset when mouse leaves GUI elements
    local mainLeaveConnection = Main.MouseLeave:Connect(function()
        Mouse.Icon = DefaultCursor
    end)
    table.insert(Connections, mainLeaveConnection)
    
    -- Initialize features based on default states
    if antiAFKState then
        setupAntiAFK(true)
        table.insert(ActiveFeatures, "AntiAFK")
    end
    
    if infiniteJumpState then
        setupInfiniteJump(true)
        table.insert(ActiveFeatures, "InfiniteJump")
    end
    
    if noClipState then
        setupNoClip(true)
        table.insert(ActiveFeatures, "NoClip")
    end
    
    -- Add new settings to the Settings tab
    local SettingsColumn = Instance.new("Frame")
    SettingsColumn.Name = "SettingsColumn"
    SettingsColumn.Parent = SettingsTab
    SettingsColumn.BackgroundTransparency = 1
    SettingsColumn.Size = UDim2.new(1, 0, 1, 0)

    local SettingsLayout = Instance.new("UIListLayout")
    SettingsLayout.Parent = SettingsColumn
    SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsLayout.Padding = UDim.new(0, 10)

    local WeaponList = {"Melee","Blox Fruit","Sword","Gun"}
    local SelectWeaponFarm = "Melee"
    
    local WeaponDropdown, currentWeapon = createDropdown(SettingsColumn, "Select Weapon", WeaponList, function(selected)
        SelectWeaponFarm = selected
    end, "Melee")

    local FarmTypeList = {"Quest", "No Quest"}
    local SelectFarmType = "Quest"

    local FarmTypeDropdown, currentFarmType = createDropdown(SettingsColumn, "Select Farm Type", FarmTypeList, function(selected)
        SelectFarmType = selected
    end, "Quest")

    local DistanceFarmTextbox = Instance.new("TextBox")
    DistanceFarmTextbox.Name = "DistanceFarmTextbox"
    DistanceFarmTextbox.Parent = SettingsColumn
    DistanceFarmTextbox.PlaceholderText = "Distance Farm (Default 250)"
    DistanceFarmTextbox.Size = UDim2.new(1, 0, 0, 40)
    DistanceFarmTextbox.Font = Enum.Font.Gotham
    DistanceFarmTextbox.TextSize = 14
    DistanceFarmTextbox.TextColor3 = colors.text
    DistanceFarmTextbox.BackgroundColor3 = colors.border
    DistanceFarmTextbox.BorderSizePixel = 0
    DistanceFarmTextbox.TextXAlignment = Enum.TextXAlignment.Left
    DistanceFarmTextbox.ClearTextOnFocus = false
    DistanceFarmTextbox.Text = "250"

    local UICorner_DistanceFarm = Instance.new("UICorner")
    UICorner_DistanceFarm.CornerRadius = UDim.new(0, 4)
    UICorner_DistanceFarm.Parent = DistanceFarmTextbox

    local FastAttackDelayList = {"Slow", "Normal", "Fast"}
    local FastAttackSelected = "Normal"

    local FastAttackDropdown, currentFastAttack = createDropdown(SettingsColumn, "Fast Attack Delay", FastAttackDelayList, function(selected)
        FastAttackSelected = selected
    end, "Normal")

    local BringMobsDistanceTextbox = Instance.new("TextBox")
    BringMobsDistanceTextbox.Name = "BringMobsDistanceTextbox"
    BringMobsDistanceTextbox.Parent = SettingsColumn
    BringMobsDistanceTextbox.PlaceholderText = "Bring Mobs Distance (Default 250)"
    BringMobsDistanceTextbox.Size = UDim2.new(1, 0, 0, 40)
    BringMobsDistanceTextbox.Font = Enum.Font.Gotham
    BringMobsDistanceTextbox.TextSize = 14
    BringMobsDistanceTextbox.TextColor3 = colors.text
    BringMobsDistanceTextbox.BackgroundColor3 = colors.border
    BringMobsDistanceTextbox.BorderSizePixel = 0
    BringMobsDistanceTextbox.TextXAlignment = Enum.TextXAlignment.Left
    BringMobsDistanceTextbox.ClearTextOnFocus = false
    BringMobsDistanceTextbox.Text = "250"

    local UICorner_BringMobsDistance = Instance.new("UICorner")
    UICorner_BringMobsDistance.CornerRadius = UDim.new(0, 4)
    UICorner_BringMobsDistance.Parent = BringMobsDistanceTextbox

    local BusoHakiToggle, BusoHakiState = createToggle(SettingsColumn, "Buso Haki", function(state)
        BusoHaki = Value
    end, false)

    -- Apply hand cursor to text box
    utility:ApplyHandCursor(DistanceFarmTextbox)
    utility:ApplyHandCursor(BringMobsDistanceTextbox)

    -- Update the settings tab's layout order
    PlayerInfo.LayoutOrder = 1
    WorldInfo.LayoutOrder = 2
    SettingsColumn.LayoutOrder = 3

    return {
        RedEngineGUI = RedEngineGUI,
        Main = Main,
        Connections = Connections,
        ActiveFeatures = ActiveFeatures
    }
end

-- Anti-AFK functionality
local antiAFKConnection = nil

function setupAntiAFK(enabled)
    if enabled then
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
        end
        
        antiAFKConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        print("Anti-AFK enabled")
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
        print("Anti-AFK disabled")
    end
end

-- Infinite Jump functionality
local infiniteJumpConnection = nil

function setupInfiniteJump(enabled)
    if enabled then
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
        end
        
        infiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        print("Infinite Jump enabled")
    else
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
        print("Infinite Jump disabled")
    end
end

-- No Clip functionality
local noClipConnection = nil

function setupNoClip(enabled)
    if enabled then
        if noClipConnection then
            noClipConnection:Disconnect()
        end
        
        noClipConnection = game:GetService("RunService").Stepped:Connect(function()
            for _, part in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
        print("No Clip enabled")
    else
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
            
            for _, part in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        print("No Clip disabled")
    end
end

--// TWEEN PLAYER
function Tween(P1)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance > 1 then
        Speed = 350
    end
    game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),{CFrame = P1}):Play()
    if _G.StopTween then
        game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),{CFrame = P1}):Cancel()
    end
end

--// TP ISLAND
function TP2(P1)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance > 1 then
        Speed = 350
    end
    game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),{CFrame = P1}):Play()
    if _G.StopTween2 then
        game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),{CFrame = P1}):Cancel()
    end
    _G.Clip2 = true
    wait(Distance/Speed)
    _G.Clip2 = false
end

--// CANCEL TWEEN
function CancelTween(target)
    if not target then
        _G.StopTween = true
        wait(.1)
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait(.1)
        _G.StopTween = false
    end
end

-- Initialize the GUI
local Window = Library:CreateWindow("RedEngine")

print("RedEngine GUI loaded successfully!")
