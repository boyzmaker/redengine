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

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

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

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
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

-- DragonFruit logo (base64 encoded to avoid external dependencies)
local dragonFruitBase64 = "iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAACXBIWXMAAAsTAAALEwEAmpwYAAABpklEQVR4nO2Vv0oDQRDGF7GxsLCw8AEsLHwBC8HGwkfwAXwBCwvBQrCxECwEC0HBQrAQFCwEhYCFEDAQAgYhYBACQggYhIBBCBhk4Bs5wm7uLneXNQY/GOb2z87Mzs5sJPK/foAYMAXsgTdA6XoFDoEFoCdUgBSwCTxgxwuwAWSdBOLAGXBnEbXpHrgARoEoEAOywDVQsYhXgG0gYRKYBYoOAqZVBOZMQjNAyUOg7nJm3SSU9xGouyJQNAnlAgpAOZNQ1iRwHlAAnEkpZRLYCigAJ6WUMQkcBRSAY1JKmgR2AgqAnVJKmAR2AwqAnVJxk8BBwCawU2rQJFAIKFBWSsVMAvmAAnBOSsVNAjsBBeyclPpjJz8lALuTH3fyXQJwTkrFTAKbAQVgp9SASWAtoACck1JJk8BSQIGyUipjEpgKKABHpZTOJDAeUACOSamMSWAkYBPYKTViEugDHgMKlIGsSajHY8DUXYFek1gMuPQQKAFzpjvTJJgGbjwEboFp2+Azwe+VrQKHQMYmkAaOgCeLQBk4A0ZcX9l6sBiwBOxrEVhfwDGw6CbwZ/QJaKPtwS+llhEAAAAASUVORK5CYII="

function Library:CreateWindow(hubname)
    local RedEngineGUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local MinimizeBtn = Instance.new("ImageButton")
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
    Title.Position = UDim2.new(0, 40, 0, 0)
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = hubname or "RedEngine"
    Title.TextColor3 = colors.text
    Title.TextSize = 16

    -- Create and setup the logo
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = TopBar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 5, 0, 2)
    Logo.Size = UDim2.new(0, 26, 0, 26)
    Logo.Image = "data:image/png;base64," .. dragonFruitBase64

    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Parent = TopBar
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Image = "rbxassetid://7072719338"
    MinimizeBtn.ImageColor3 = colors.text

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
    HomeTab.ScrollBarThickness = 0
    HomeTab.Visible = true

    UIListLayout.Parent = HomeTab
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)

    UIPadding.Parent = HomeTab
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)

    ServerTab.Name = "ServerTab"
    ServerTab.Parent = ContentContainer
    ServerTab.Active = true
    ServerTab.BackgroundTransparency = 1
    ServerTab.BorderSizePixel = 0
    ServerTab.Size = UDim2.new(1, 0, 1, 0)
    ServerTab.ScrollBarThickness = 0
    ServerTab.Visible = false

    UIListLayout_2.Parent = ServerTab
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Padding = UDim.new(0, 10)

    UIPadding_2.Parent = ServerTab
    UIPadding_2.PaddingLeft = UDim.new(0, 10)
    UIPadding_2.PaddingTop = UDim.new(0, 10)
    UIPadding_2.PaddingRight = UDim.new(0, 10)

    TeleportTab.Name = "TeleportTab"
    TeleportTab.Parent = ContentContainer
    TeleportTab.Active = true
    TeleportTab.BackgroundTransparency = 1
    TeleportTab.BorderSizePixel = 0
    TeleportTab.Size = UDim2.new(1, 0, 1, 0)
    TeleportTab.ScrollBarThickness = 0
    TeleportTab.Visible = false

    UIListLayout_3.Parent = TeleportTab
    UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_3.Padding = UDim.new(0, 10)

    UIPadding_3.Parent = TeleportTab
    UIPadding_3.PaddingLeft = UDim.new(0, 10)
    UIPadding_3.PaddingTop = UDim.new(0, 10)
    UIPadding_3.PaddingRight = UDim.new(0, 10)

    MainFarmTab.Name = "MainFarmTab"
    MainFarmTab.Parent = ContentContainer
    MainFarmTab.Active = true
    MainFarmTab.BackgroundTransparency = 1
    MainFarmTab.BorderSizePixel = 0
    MainFarmTab.Size = UDim2.new(1, 0, 1, 0)
    MainFarmTab.ScrollBarThickness = 0
    MainFarmTab.Visible = false

    UIListLayout_4.Parent = MainFarmTab
    UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_4.Padding = UDim.new(0, 10)

    UIPadding_4.Parent = MainFarmTab
    UIPadding_4.PaddingLeft = UDim.new(0, 10)
    UIPadding_4.PaddingTop = UDim.new(0, 10)
    UIPadding_4.PaddingRight = UDim.new(0, 10)

    SubFarmTab.Name = "SubFarmTab"
    SubFarmTab.Parent = ContentContainer
    SubFarmTab.Active = true
    SubFarmTab.BackgroundTransparency = 1
    SubFarmTab.BorderSizePixel = 0
    SubFarmTab.Size = UDim2.new(1, 0, 1, 0)
    SubFarmTab.ScrollBarThickness = 0
    SubFarmTab.Visible = false

    UIListLayout_5.Parent = SubFarmTab
    UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_5.Padding = UDim.new(0, 10)

    UIPadding_5.Parent = SubFarmTab
    UIPadding_5.PaddingLeft = UDim.new(0, 10)
    UIPadding_5.PaddingTop = UDim.new(0, 10)
    UIPadding_5.PaddingRight = UDim.new(0, 10)

    MacroTab.Name = "MacroTab"
    MacroTab.Parent = ContentContainer
    MacroTab.Active = true
    MacroTab.BackgroundTransparency = 1
    MacroTab.BorderSizePixel = 0
    MacroTab.Size = UDim2.new(1, 0, 1, 0)
    MacroTab.ScrollBarThickness = 0
    MacroTab.Visible = false

    UIListLayout_6.Parent = MacroTab
    UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_6.Padding = UDim.new(0, 10)

    UIPadding_6.Parent = MacroTab
    UIPadding_6.PaddingLeft = UDim.new(0, 10)
    UIPadding_6.PaddingTop = UDim.new(0, 10)
    UIPadding_6.PaddingRight = UDim.new(0, 10)

    ShopTab.Name = "ShopTab"
    ShopTab.Parent = ContentContainer
    ShopTab.Active = true
    ShopTab.BackgroundTransparency = 1
    ShopTab.BorderSizePixel = 0
    ShopTab.Size = UDim2.new(1, 0, 1, 0)
    ShopTab.ScrollBarThickness = 0
    ShopTab.Visible = false

    UIListLayout_7.Parent = ShopTab
    UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_7.Padding = UDim.new(0, 10)

    UIPadding_7.Parent = ShopTab
    UIPadding_7.PaddingLeft = UDim.new(0, 10)
    UIPadding_7.PaddingTop = UDim.new(0, 10)
    UIPadding_7.PaddingRight = UDim.new(0, 10)

    SettingsTab.Name = "SettingsTab"
    SettingsTab.Parent = ContentContainer
    SettingsTab.Active = true
    SettingsTab.BackgroundTransparency = 1
    SettingsTab.BorderSizePixel = 0
    SettingsTab.Size = UDim2.new(1, 0, 1, 0)
    SettingsTab.ScrollBarThickness = 0
    SettingsTab.Visible = false

    UIListLayout_8.Parent = SettingsTab
    UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_8.Padding = UDim.new(0, 10)

    UIPadding_8.Parent = SettingsTab
    UIPadding_8.PaddingLeft = UDim.new(0, 10)
    UIPadding_8.PaddingTop = UDim.new(0, 10)
    UIPadding_8.PaddingRight = UDim.new(0, 10)

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
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 4)
        UICorner_Button.Parent = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            switchTab(tab.name)
        end)
        
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
    RightColumnLayout.Padding = UDim.new(0, 10)

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
    ChangelogTitle.TextColor3 = colors.text
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
        end
    end

    -- Create toggle buttons in the right column
    local function createToggle(parent, name, callback)
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
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Font = Enum.Font.Gotham
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = colors.text
        ToggleButton.TextSize = 14
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 10)
        UICorner_Button.Parent = ToggleButton
        
        local ToggleCircle = Instance.new("Frame")
        ToggleCircle.Name = "ToggleCircle"
        ToggleCircle.Parent = ToggleButton
        ToggleCircle.BackgroundColor3 = colors.text
        ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
        ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
        
        local UICorner_Circle = Instance.new("UICorner")
        UICorner_Circle.CornerRadius = UDim.new(1, 0)
        UICorner_Circle.Parent = ToggleCircle
        
        local toggled = false
        
        ToggleButton.MouseButton1Click:Connect(function()
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
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 4)
        UICorner_Button.Parent = ButtonFrame
        
        ButtonFrame.MouseButton1Click:Connect(function()
            utility:Tween(ButtonFrame, {BackgroundColor3 = colors.highlight}, 0.1)
            if callback then
                callback()
            end
            wait(0.1)
            utility:Tween(ButtonFrame, {BackgroundColor3 = colors.primary}, 0.1)
        end)
        
        return ButtonFrame
    end
    
    local function createDropdown(parent, name, options, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = name .. "Dropdown"
        DropdownFrame.Parent = parent
        DropdownFrame.BackgroundColor3 = colors.border
        DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
        
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
        
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "DropdownButton"
        DropdownButton.Parent = DropdownFrame
        DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        DropdownButton.Position = UDim2.new(0, 120, 0.5, -15)
        DropdownButton.Size = UDim2.new(1, -130, 0, 30)
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.Text = options[1] or "Select..."
        DropdownButton.TextColor3 = colors.text
        DropdownButton.TextSize = 14
        DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
        DropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
        
        local UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = DropdownButton
        UIPadding.PaddingLeft = UDim.new(0, 10)
        
        local UICorner_Button = Instance.new("UICorner")
        UICorner_Button.CornerRadius = UDim.new(0, 4)
        UICorner_Button.Parent = DropdownButton
        
        local DropdownMenu = Instance.new("Frame")
        DropdownMenu.Name = "DropdownMenu"
        DropdownMenu.Parent = DropdownFrame
        DropdownMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        DropdownMenu.Position = UDim2.new(0, 120, 0, 40)
        DropdownMenu.Size = UDim2.new(1, -130, 0, 0)
        DropdownMenu.Visible = false
        DropdownMenu.ZIndex = 5
        DropdownMenu.ClipsDescendants = true
        
        local UICorner_Menu = Instance.new("UICorner")
        UICorner_Menu.CornerRadius = UDim.new(0, 4)
        UICorner_Menu.Parent = DropdownMenu
        
        local DropdownLayout = Instance.new("UIListLayout")
        DropdownLayout.Parent = DropdownMenu
        DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
        DropdownLayout.Padding = UDim.new(0, 5)
        
        local DropdownPadding = Instance.new("UIPadding")
        DropdownPadding.Parent = DropdownMenu
        DropdownPadding.PaddingTop = UDim.new(0, 5)
        DropdownPadding.PaddingBottom = UDim.new(0, 5)
        
        local menuOpen = false
        
        local function toggleMenu()
            menuOpen = not menuOpen
            
            if menuOpen then
                DropdownMenu.Visible = true
                utility:Tween(DropdownMenu, {Size = UDim2.new(1, -130, 0, math.min(#options * 30, 150))}, 0.2)
            else
                utility:Tween(DropdownMenu, {Size = UDim2.new(1, -130, 0, 0)}, 0.2)
                wait(0.2)
                DropdownMenu.Visible = false
            end
        end
        
        DropdownButton.MouseButton1Click:Connect(toggleMenu)
        
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = "Option_" .. i
            OptionButton.Parent = DropdownMenu
            OptionButton.BackgroundTransparency = 1
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.Text = option
            OptionButton.TextColor3 = colors.text
            OptionButton.TextSize = 14
            OptionButton.ZIndex = 6
            
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = option
                toggleMenu()
                if callback then
                    callback(option)
                end
            end)
        end
        
        return DropdownFrame
    end
    
    -- Add toggles to the right column
    createToggle(RightColumn, "Anti-AFK", function(state)
        -- Anti-AFK functionality
    end)
    
    createToggle(RightColumn, "Infinite Jump", function(state)
        -- Infinite Jump functionality
    end)
    
    createToggle(RightColumn, "No Clip", function(state)
        -- No Clip functionality
    end)
    
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
    
    -- Add sea teleport to the Teleport tab
    local seas = {"First Sea", "Second Sea", "Third Sea"}
    createDropdown(TeleportTab, "Select Sea", seas, function(selected)
        -- Sea selection functionality
    end)
    
    createButton(TeleportTab, "Teleport to Sea", function()
        -- Teleport to selected sea functionality
    end)
    
    -- Add world info to the Settings tab
    local WorldInfo = Instance.new("Frame")
    WorldInfo.Name = "WorldInfo"
    WorldInfo.Parent = SettingsTab
    WorldInfo.BackgroundColor3 = colors.border
    WorldInfo.Size = UDim2.new(1, 0, 0, 80)
    
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
    WorldTitle.TextColor3 = colors.text
    WorldTitle.TextSize = 16
    WorldTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local WorldValue = Instance.new("TextLabel")
    WorldValue.Name = "WorldValue"
    WorldValue.Parent = WorldInfo
    WorldValue.BackgroundTransparency = 1
    WorldValue.Position = UDim2.new(0, 10, 0, 40)
    WorldValue.Size = UDim2.new(1, -20, 0, 20)
    WorldValue.Font = Enum.Font.Gotham
    WorldValue.Text = "First Sea"
    WorldValue.TextColor3 = colors.secondary
    WorldValue.TextSize = 14
    WorldValue.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Add Destroy GUI button to Settings tab
    createButton(SettingsTab, "Destroy GUI", function()
        RedEngineGUI:Destroy()
    end)
    
    -- Make the GUI draggable
    utility:DraggingEnabled(TopBar, Main)
    
    -- Minimize functionality
    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        
        if minimized then
            utility:Tween(Main, {Size = UDim2.new(0, 600, 0, 30)}, 0.3)
        else
            utility:Tween(Main, {Size = UDim2.new(0, 600, 0, 350)}, 0.3)
        end
    end)
    
    -- Toggle GUI with LeftControl key
    local guiVisible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftControl then
            guiVisible = not guiVisible
            RedEngineGUI.Enabled = guiVisible
        end
    end)
    
    return {
        RedEngineGUI = RedEngineGUI,
        Main = Main
    }
end

-- Initialize the GUI
local Window = Library:CreateWindow("RedEngine")

-- Anti-AFK functionality
local antiAFK = false
local antiAFKConnection

local function setupAntiAFK()
    if antiAFK then
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
        end
        
        antiAFKConnection = RunService.Heartbeat:Connect(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
    end
end

-- Infinite Jump functionality
local infiniteJump = false
local infiniteJumpConnection

local function setupInfiniteJump()
    if infiniteJump then
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
        end
        
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    else
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end

-- No Clip functionality
local noClip = false
local noClipConnection

local function setupNoClip()
    if noClip then
        if noClipConnection then
            noClipConnection:Disconnect()
        end
        
        noClipConnection = RunService.Stepped:Connect(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
            
            if Player.Character then
                for _, part in pairs(Player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end

print("RedEngine GUI loaded successfully!")
