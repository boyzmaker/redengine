--[[
    RedEngine GUI Framework - Optimized Version
    Features:
    - Improved memory usage and performance
    - Modern UI design with smooth animations
    - Tab system with Home, Teleport, Main Farm, Subs Farm, Shop, Macro, and Settings
    - Anti-AFK functionality
    - Toggle visibility with LeftControl
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local menuVisible = true
local antiAFKEnabled = true
local dragging = false
local dragInput, dragStart, startPos

-- Create ScreenGui with ZIndexBehavior to optimize rendering
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RedEngineGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling -- Optimizes Z-index calculations
screenGui.Parent = playerGui

-- Create main container with rounded corners
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Darker background for modern look
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true -- Prevents children from rendering outside bounds
mainFrame.Parent = screenGui

-- Add corner radius
local cornerRadius = Instance.new("UICorner")
cornerRadius.CornerRadius = UDim.new(0, 8)
cornerRadius.Parent = mainFrame

-- Create a top bar for dragging and title
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Red accent
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

-- Add corner radius to top bar (just top corners)
local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

-- Fix the bottom corners of top bar
local bottomFix = Instance.new("Frame")
bottomFix.Name = "BottomFix"
bottomFix.Size = UDim2.new(1, 0, 0, 10)
bottomFix.Position = UDim2.new(0, 0, 1, -10)
bottomFix.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
bottomFix.BorderSizePixel = 0
bottomFix.Parent = topBar

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "RedEngine"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Parent = topBar

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundTransparency = 1
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 20
minimizeButton.Parent = topBar

-- Create tab container with a modern look
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, 150, 1, -30)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

-- Create content area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -150, 1, -30)
contentArea.Position = UDim2.new(0, 150, 0, 30)
contentArea.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = mainFrame

-- Define the tab names (added Macro tab)
local tabNames = {
    "Home",
    "Teleport",
    "Main Farm",
    "Subs Farm",
    "Shop",
    "Macro",
    "Settings"
}

local tabs = {}  -- Table to store both tab buttons and content frames

-- Create a scrolling frame for tabs
local tabScroll = Instance.new("ScrollingFrame")
tabScroll.Name = "TabScroll"
tabScroll.Size = UDim2.new(1, 0, 1, 0)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel = 0
tabScroll.ScrollBarThickness = 0
tabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tabScroll.Parent = tabContainer

-- Add list layout for tabs
local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 5)
tabList.Parent = tabScroll

-- Add padding to the tab list
local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingTop = UDim.new(0, 10)
tabPadding.PaddingBottom = UDim.new(0, 10)
tabPadding.Parent = tabScroll

-- Function to create a new tab and its corresponding content frame
local function createTab(tabName, index)
    -- Create the tab button with a modern design
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Button"
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    button.BorderSizePixel = 0
    button.Text = tabName
    button.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.LayoutOrder = index
    button.Parent = tabScroll
    
    -- Add corner radius to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Add icon holder (for future icons)
    local iconHolder = Instance.new("Frame")
    iconHolder.Name = "IconHolder"
    iconHolder.Size = UDim2.new(0, 20, 0, 20)
    iconHolder.Position = UDim2.new(0, 10, 0.5, -10)
    iconHolder.BackgroundTransparency = 1
    iconHolder.Parent = button
    
    -- Create the content frame for this tab
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = tabName .. "Content"
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = contentArea

    tabs[tabName] = {
        button = button,
        frame = contentFrame,
    }

    -- Button toggle with animation
    button.MouseButton1Click:Connect(function()
        for name, tab in pairs(tabs) do
            -- Update visibility
            tab.frame.Visible = (name == tabName)
            
            -- Animate button colors
            local targetColor = (name == tabName) 
                and Color3.fromRGB(180, 0, 0)  -- Selected tab
                or Color3.fromRGB(50, 50, 55)  -- Unselected tab
                
            local targetTextColor = (name == tabName)
                and Color3.new(1, 1, 1)  -- Selected text
                or Color3.new(0.8, 0.8, 0.8)  -- Unselected text
            
            -- Create tweens for smooth transition
            local colorTween = TweenService:Create(
                tab.button,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = targetColor}
            )
            
            local textTween = TweenService:Create(
                tab.button,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {TextColor3 = targetTextColor}
            )
            
            colorTween:Play()
            textTween:Play()
        end
    end)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        if tabs[tabName].frame.Visible == false then
            local hoverTween = TweenService:Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(70, 70, 75)}
            )
            hoverTween:Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if tabs[tabName].frame.Visible == false then
            local leaveTween = TweenService:Create(
                button,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}
            )
            leaveTween:Play()
        end
    end)
end

-- Function to create a styled button
local function createStyledButton(parent, text, posX, posY, sizeX, sizeY)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(0, sizeX, 0, sizeY)
    button.Position = UDim2.new(0, posX, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = parent
    
    -- Add corner radius
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Add hover effects
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(220, 0, 0)}
        )
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}
        )
        leaveTween:Play()
    end)
    
    -- Add click effect
    button.MouseButton1Down:Connect(function()
        local clickTween = TweenService:Create(
            button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}
        )
        clickTween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local releaseTween = TweenService:Create(
            button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(220, 0, 0)}
        )
        releaseTween:Play()
    end)
    
    return button
end

-- Function to create a styled toggle
local function createStyledToggle(parent, text, posX, posY, initialState)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = text .. "Container"
    toggleContainer.Size = UDim2.new(0, 300, 0, 40)
    toggleContainer.Position = UDim2.new(0, posX, 0, posY)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. (initialState and "Enabled" or "Disabled")
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 24)
    toggleButton.Position = UDim2.new(1, -50, 0.5, -12)
    toggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
    toggleButton.Parent = toggleContainer
    
    -- Add corner radius
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton
    
    -- Add toggle indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = initialState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    indicator.BackgroundColor3 = Color3.new(1, 1, 1)
    indicator.Parent = toggleButton
    
    -- Add corner radius to indicator
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 10)
    indicatorCorner.Parent = indicator
    
    -- Make the toggle clickable
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            initialState = not initialState
            label.Text = text .. ": " .. (initialState and "Enabled" or "Disabled")
            
            -- Animate the toggle
            local colorTween = TweenService:Create(
                toggleButton,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = initialState and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)}
            )
            
            local posTween = TweenService:Create(
                indicator,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position = initialState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}
            )
            
            colorTween:Play()
            posTween:Play()
            
            return initialState
        end
    end)
    
    return {
        container = toggleContainer,
        label = label,
        button = toggleButton,
        indicator = indicator,
        getValue = function() return initialState end,
        setValue = function(value) 
            initialState = value
            label.Text = text .. ": " .. (initialState and "Enabled" or "Disabled")
            toggleButton.BackgroundColor3 = initialState and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
            indicator.Position = initialState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        end
    }
end

-- Create all the tabs
for i, name in ipairs(tabNames) do
    createTab(name, i)
end

-- Show the first tab by default
if #tabNames > 0 then
    tabs[tabNames[1]].frame.Visible = true
    tabs[tabNames[1]].button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    tabs[tabNames[1]].button.TextColor3 = Color3.new(1, 1, 1)
end

--------------------------------------------------------------------------------
-- Home Tab Content
local homeTab = tabs["Home"].frame

local welcomeContainer = Instance.new("Frame")
welcomeContainer.Name = "WelcomeContainer"
welcomeContainer.Size = UDim2.new(1, -40, 1, -40)
welcomeContainer.Position = UDim2.new(0, 20, 0, 20)
welcomeContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
welcomeContainer.BorderSizePixel = 0
welcomeContainer.Parent = homeTab

-- Add corner radius
local welcomeCorner = Instance.new("UICorner")
welcomeCorner.CornerRadius = UDim.new(0, 8)
welcomeCorner.Parent = welcomeContainer

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Name = "WelcomeTitle"
welcomeTitle.Size = UDim2.new(1, 0, 0, 40)
welcomeTitle.Position = UDim2.new(0, 0, 0, 20)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "Welcome to RedEngine"
welcomeTitle.TextColor3 = Color3.new(1, 1, 1)
welcomeTitle.Font = Enum.Font.GothamBold
welcomeTitle.TextSize = 24
welcomeTitle.Parent = welcomeContainer

local versionLabel = Instance.new("TextLabel")
versionLabel.Name = "VersionLabel"
versionLabel.Size = UDim2.new(1, 0, 0, 20)
versionLabel.Position = UDim2.new(0, 0, 0, 60)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Version 2.0 - Optimized"
versionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 14
versionLabel.Parent = welcomeContainer

local statusContainer = Instance.new("Frame")
statusContainer.Name = "StatusContainer"
statusContainer.Size = UDim2.new(1, -40, 0, 80)
statusContainer.Position = UDim2.new(0, 20, 0, 100)
statusContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
statusContainer.BorderSizePixel = 0
statusContainer.Parent = welcomeContainer

-- Add corner radius
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusContainer

local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(1, 0, 0, 30)
statusTitle.Position = UDim2.new(0, 10, 0, 0)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "Status"
statusTitle.TextColor3 = Color3.new(1, 1, 1)
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 16
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
statusTitle.Parent = statusContainer

local antiAFKStatus = Instance.new("TextLabel")
antiAFKStatus.Name = "AntiAFKStatus"
antiAFKStatus.Size = UDim2.new(0, 200, 0, 20)
antiAFKStatus.Position = UDim2.new(0, 10, 0, 30)
antiAFKStatus.BackgroundTransparency = 1
antiAFKStatus.Text = "Anti-AFK: Enabled"
antiAFKStatus.TextColor3 = Color3.fromRGB(0, 200, 0)
antiAFKStatus.Font = Enum.Font.Gotham
antiAFKStatus.TextSize = 14
antiAFKStatus.TextXAlignment = Enum.TextXAlignment.Left
antiAFKStatus.Parent = statusContainer

local gameStatus = Instance.new("TextLabel")
gameStatus.Name = "GameStatus"
gameStatus.Size = UDim2.new(0, 200, 0, 20)
gameStatus.Position = UDim2.new(0, 10, 0, 50)
gameStatus.BackgroundTransparency = 1
gameStatus.Text = "Game: " .. game.Name
gameStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
gameStatus.Font = Enum.Font.Gotham
gameStatus.TextSize = 14
gameStatus.TextXAlignment = Enum.TextXAlignment.Left
gameStatus.Parent = statusContainer

-- Quick actions
local quickActionsTitle = Instance.new("TextLabel")
quickActionsTitle.Name = "QuickActionsTitle"
quickActionsTitle.Size = UDim2.new(1, 0, 0, 30)
quickActionsTitle.Position = UDim2.new(0, 0, 0, 200)
quickActionsTitle.BackgroundTransparency = 1
quickActionsTitle.Text = "Quick Actions"
quickActionsTitle.TextColor3 = Color3.new(1, 1, 1)
quickActionsTitle.Font = Enum.Font.GothamBold
quickActionsTitle.TextSize = 18
quickActionsTitle.Parent = welcomeContainer

-- Create quick action buttons
local teleportQuickButton = createStyledButton(welcomeContainer, "Teleport", 20, 240, 120, 40)
local farmQuickButton = createStyledButton(welcomeContainer, "Start Farm", 150, 240, 120, 40)
local shopQuickButton = createStyledButton(welcomeContainer, "Shop", 280, 240, 120, 40)

--------------------------------------------------------------------------------
-- Teleport Tab Content
local teleportTab = tabs["Teleport"].frame

local teleportContainer = Instance.new("Frame")
teleportContainer.Name = "TeleportContainer"
teleportContainer.Size = UDim2.new(1, -40, 1, -40)
teleportContainer.Position = UDim2.new(0, 20, 0, 20)
teleportContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
teleportContainer.BorderSizePixel = 0
teleportContainer.Parent = teleportTab

-- Add corner radius
local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportContainer

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Name = "TeleportTitle"
teleportTitle.Size = UDim2.new(1, 0, 0, 40)
teleportTitle.Position = UDim2.new(0, 0, 0, 10)
teleportTitle.BackgroundTransparency = 1
teleportTitle.Text = "Teleport Locations"
teleportTitle.TextColor3 = Color3.new(1, 1, 1)
teleportTitle.Font = Enum.Font.GothamBold
teleportTitle.TextSize = 20
teleportTitle.Parent = teleportContainer

-- Create teleport buttons
local safeZoneButton = createStyledButton(teleportContainer, "Safe Zone", 20, 60, 150, 40)
local farmZoneButton = createStyledButton(teleportContainer, "Farm Zone", 20, 110, 150, 40)
local shopZoneButton = createStyledButton(teleportContainer, "Shop Zone", 20, 160, 150, 40)
local bossZoneButton = createStyledButton(teleportContainer, "Boss Zone", 20, 210, 150, 40)

-- Teleport logic
safeZoneButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end)

farmZoneButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(100, 100, 100)
    end
end)

shopZoneButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-100, 100, -100)
    end
end)

bossZoneButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(200, 100, 200)
    end
end)

-- Status section
local statusTitle = Instance.new("TextLabel")
statusTitle.Name = "StatusTitle"
statusTitle.Size = UDim2.new(0, 200, 0, 30)
statusTitle.Position = UDim2.new(0, 200, 0, 60)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "Player Status"
statusTitle.TextColor3 = Color3.new(1, 1, 1)
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 16
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
statusTitle.Parent = teleportContainer

local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Name = "PlayerNameLabel"
playerNameLabel.Size = UDim2.new(0, 200, 0, 20)
playerNameLabel.Position = UDim2.new(0, 200, 0, 90)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = "Name: " .. player.Name
playerNameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
playerNameLabel.Font = Enum.Font.Gotham
playerNameLabel.TextSize = 14
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.Parent = teleportContainer

local playerPositionLabel = Instance.new("TextLabel")
playerPositionLabel.Name = "PlayerPositionLabel"
playerPositionLabel.Size = UDim2.new(0, 200, 0, 20)
playerPositionLabel.Position = UDim2.new(0, 200, 0, 110)
playerPositionLabel.BackgroundTransparency = 1
playerPositionLabel.Text = "Position: Loading..."
playerPositionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
playerPositionLabel.Font = Enum.Font.Gotham
playerPositionLabel.TextSize = 14
playerPositionLabel.TextXAlignment = Enum.TextXAlignment.Left
playerPositionLabel.Parent = teleportContainer

-- Update position label
local function updatePositionLabel()
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        playerPositionLabel.Text = "Position: " .. math.floor(pos.X) .. ", " .. math.floor(pos.Y) .. ", " .. math.floor(pos.Z)
    end
end

-- Update position every second
spawn(function()
    while wait(1) do
        updatePositionLabel()
    end
end)

--------------------------------------------------------------------------------
-- Settings Tab Content
local settingsTab = tabs["Settings"].frame

local settingsContainer = Instance.new("Frame")
settingsContainer.Name = "SettingsContainer"
settingsContainer.Size = UDim2.new(1, -40, 1, -40)
settingsContainer.Position = UDim2.new(0, 20, 0, 20)
settingsContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
settingsContainer.BorderSizePixel = 0
settingsContainer.Parent = settingsTab

-- Add corner radius
local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 8)
settingsCorner.Parent = settingsContainer

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Name = "SettingsTitle"
settingsTitle.Size = UDim2.new(1, 0, 0, 40)
settingsTitle.Position = UDim2.new(0, 0, 0, 10)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Settings"
settingsTitle.TextColor3 = Color3.new(1, 1, 1)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 20
settingsTitle.Parent = settingsContainer

-- Create toggles
local antiAFKToggle = createStyledToggle(settingsContainer, "Anti-AFK", 20, 60, antiAFKEnabled)
local autoFarmToggle = createStyledToggle(settingsContainer, "Auto Farm", 20, 110, false)
local autoCollectToggle = createStyledToggle(settingsContainer, "Auto Collect", 20, 160, false)
local notificationsToggle = createStyledToggle(settingsContainer, "Notifications", 20, 210, true)

-- Reset button
local resetButton = createStyledButton(settingsContainer, "Reset Settings", 20, 270, 150, 40)

resetButton.MouseButton1Click:Connect(function()
    antiAFKToggle.setValue(true)
    autoFarmToggle.setValue(false)
    autoCollectToggle.setValue(false)
    notificationsToggle.setValue(true)
    antiAFKEnabled = true
end)

--------------------------------------------------------------------------------
-- Macro Tab Content (New)
local macroTab = tabs["Macro"].frame

local macroContainer = Instance.new("Frame")
macroContainer.Name = "MacroContainer"
macroContainer.Size = UDim2.new(1, -40, 1, -40)
macroContainer.Position = UDim2.new(0, 20, 0, 20)
macroContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
macroContainer.BorderSizePixel = 0
macroContainer.Parent = macroTab

-- Add corner radius
local macroCorner = Instance.new("UICorner")
macroCorner.CornerRadius = UDim.new(0, 8)
macroCorner.Parent = macroContainer

local macroTitle = Instance.new("TextLabel")
macroTitle.Name = "MacroTitle"
macroTitle.Size = UDim2.new(1, 0, 0, 40)
macroTitle.Position = UDim2.new(0, 0, 0, 10)
macroTitle.BackgroundTransparency = 1
macroTitle.Text = "Macro Recorder"
macroTitle.TextColor3 = Color3.new(1, 1, 1)
macroTitle.Font = Enum.Font.GothamBold
macroTitle.TextSize = 20
macroTitle.Parent = macroContainer

-- Macro description
local macroDescription = Instance.new("TextLabel")
macroDescription.Name = "MacroDescription"
macroDescription.Size = UDim2.new(1, -40, 0, 40)
macroDescription.Position = UDim2.new(0, 20, 0, 50)
macroDescription.BackgroundTransparency = 1
macroDescription.Text = "Record and play sequences of actions automatically"
macroDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
macroDescription.Font = Enum.Font.Gotham
macroDescription.TextSize = 14
macroDescription.TextWrapped = true
macroDescription.Parent = macroContainer

-- Macro buttons
local recordButton = createStyledButton(macroContainer, "Record Macro", 20, 100, 150, 40)
local stopButton = createStyledButton(macroContainer, "Stop Recording", 180, 100, 150, 40)
local playButton = createStyledButton(macroContainer, "Play Macro", 20, 150, 150, 40)
local saveButton = createStyledButton(macroContainer, "Save Macro", 180, 150, 150, 40)

-- Macro list
local macroListTitle = Instance.new("TextLabel")
macroListTitle.Name = "MacroListTitle"
macroListTitle.Size = UDim2.new(0, 200, 0, 30)
macroListTitle.Position = UDim2.new(0, 20, 0, 200)
macroListTitle.BackgroundTransparency = 1
macroListTitle.Text = "Saved Macros"
macroListTitle.TextColor3 = Color3.new(1, 1, 1)
macroListTitle.Font = Enum.Font.GothamBold
macroListTitle.TextSize = 16
macroListTitle.TextXAlignment = Enum.TextXAlignment.Left
macroListTitle.Parent = macroContainer

-- Macro list container
local macroListContainer = Instance.new("ScrollingFrame")
macroListContainer.Name = "MacroListContainer"
macroListContainer.Size = UDim2.new(1, -40, 0, 120)
macroListContainer.Position = UDim2.new(0, 20, 0, 230)
macroListContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
macroListContainer.BorderSizePixel = 0
macroListContainer.ScrollBarThickness = 4
macroListContainer.ScrollingDirection = Enum.ScrollingDirection.Y
macroListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
macroListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
macroListContainer.Parent = macroContainer

-- Add corner radius
local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = macroListContainer

-- Add list layout
local macroListLayout = Instance.new("UIListLayout")
macroListLayout.FillDirection = Enum.FillDirection.Vertical
macroListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
macroListLayout.SortOrder = Enum.SortOrder.LayoutOrder
macroListLayout.Padding = UDim.new(0, 5)
macroListLayout.Parent = macroListContainer

-- Add padding
local macroListPadding = Instance.new("UIPadding")
macroListPadding.PaddingTop = UDim.new(0, 5)
macroListPadding.PaddingBottom = UDim.new(0, 5)
macroListPadding.PaddingLeft = UDim.new(0, 5)
macroListPadding.PaddingRight = UDim.new(0, 5)
macroListPadding.Parent = macroListContainer

-- Sample macro entries
local function createMacroEntry(name, duration)
    local entry = Instance.new("Frame")
    entry.Name = name .. "Entry"
    entry.Size = UDim2.new(1, 0, 0, 30)
    entry.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    entry.BorderSizePixel = 0
    entry.Parent = macroListContainer
    
    -- Add corner radius
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 4)
    entryCorner.Parent = entry
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 10, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = entry
    
    local durationLabel = Instance.new("TextLabel")
    durationLabel.Name = "DurationLabel"
    durationLabel.Size = UDim2.new(0.3, -10, 1, 0)
    durationLabel.Position = UDim2.new(0.7, 0, 0, 0)
    durationLabel.BackgroundTransparency = 1
    durationLabel.Text = duration
    durationLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    durationLabel.Font = Enum.Font.Gotham
    durationLabel.TextSize = 12
    durationLabel.TextXAlignment = Enum.TextXAlignment.Right
    durationLabel.Parent = entry
    
    return entry
end

-- Add sample macros
createMacroEntry("Farm Route", "2m 30s")
createMacroEntry("Boss Fight", "45s")
createMacroEntry("Collect Items", "1m 15s")

--------------------------------------------------------------------------------
-- Main Farm Tab (Placeholder)
local mainFarmTab = tabs["Main Farm"].frame

local mainFarmContainer = Instance.new("Frame")
mainFarmContainer.Name = "MainFarmContainer"
mainFarmContainer.Size = UDim2.new(1, -40, 1, -40)
mainFarmContainer.Position = UDim2.new(0, 20, 0, 20)
mainFarmContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
mainFarmContainer.BorderSizePixel = 0
mainFarmContainer.Parent = mainFarmTab

-- Add corner radius
local mainFarmCorner = Instance.new("UICorner")
mainFarmCorner.CornerRadius = UDim.new(0, 8)
mainFarmCorner.Parent = mainFarmContainer

local mainFarmTitle = Instance.new("TextLabel")
mainFarmTitle.Name = "MainFarmTitle"
mainFarmTitle.Size = UDim2.new(1, 0, 0, 40)
mainFarmTitle.Position = UDim2.new(0, 0, 0, 10)
mainFarmTitle.BackgroundTransparency = 1
mainFarmTitle.Text = "Main Farm"
mainFarmTitle.TextColor3 = Color3.new(1, 1, 1)
mainFarmTitle.Font = Enum.Font.GothamBold
mainFarmTitle.TextSize = 20
mainFarmTitle.Parent = mainFarmContainer

-- Create farm buttons
local startFarmButton = createStyledButton(mainFarmContainer, "Start Farm", 20, 60, 150, 40)
local stopFarmButton = createStyledButton(mainFarmContainer, "Stop Farm", 180, 60, 150, 40)

--------------------------------------------------------------------------------
-- Subs Farm Tab (Placeholder)
local subsFarmTab = tabs["Subs Farm"].frame

local subsFarmContainer = Instance.new("Frame")
subsFarmContainer.Name = "SubsFarmContainer"
subsFarmContainer.Size = UDim2.new(1, -40, 1, -40)
subsFarmContainer.Position = UDim2.new(0, 20, 0, 20)
subsFarmContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
subsFarmContainer.BorderSizePixel = 0
subsFarmContainer.Parent = subsFarmTab

-- Add corner radius
local subsFarmCorner = Instance.new("UICorner")
subsFarmCorner.CornerRadius = UDim.new(0, 8)
subsFarmCorner.Parent = subsFarmContainer

local subsFarmTitle = Instance.new("TextLabel")
subsFarmTitle.Name = "SubsFarmTitle"
subsFarmTitle.Size = UDim2.new(1, 0, 0, 40)
subsFarmTitle.Position = UDim2.new(0, 0, 0, 10)
subsFarmTitle.BackgroundTransparency = 1
subsFarmTitle.Text = "Subs Farm"
subsFarmTitle.TextColor3 = Color3.new(1, 1, 1)
subsFarmTitle.Font = Enum.Font.GothamBold
subsFarmTitle.TextSize = 20
subsFarmTitle.Parent = subsFarmContainer

--------------------------------------------------------------------------------
-- Shop Tab (Placeholder)
local shopTab = tabs["Shop"].frame

local shopContainer = Instance.new("Frame")
shopContainer.Name = "ShopContainer"
shopContainer.Size = UDim2.new(1, -40, 1, -40)
shopContainer.Position = UDim2.new(0, 20, 0, 20)
shopContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
shopContainer.BorderSizePixel = 0
shopContainer.Parent = shopTab

-- Add corner radius
local shopCorner = Instance.new("UICorner")
shopCorner.CornerRadius = UDim.new(0, 8)
shopCorner.Parent = shopContainer

local shopTitle = Instance.new("TextLabel")
shopTitle.Name = "ShopTitle"
shopTitle.Size = UDim2.new(1, 0, 0, 40)
shopTitle.Position = UDim2.new(0, 0, 0, 10)
shopTitle.BackgroundTransparency = 1
shopTitle.Text = "Shop"
shopTitle.TextColor3 = Color3.new(1, 1, 1)
shopTitle.Font = Enum.Font.GothamBold
shopTitle.TextSize = 20
shopTitle.Parent = shopContainer

--------------------------------------------------------------------------------
-- Anti-AFK Functionality (Optimized)
local VirtualUser = game:GetService("VirtualUser")
local antiAFKConnection = nil

local function setupAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
    end
    
    if antiAFKEnabled then
        antiAFKConnection = Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(0.1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            antiAFKStatus.Text = "Anti-AFK: Active (Prevented Kick)"
            antiAFKStatus.TextColor3 = Color3.fromRGB(0, 200, 0)
            
            -- Flash the status for visual feedback
            spawn(function()
                for i = 1, 3 do
                    antiAFKStatus.TextColor3 = Color3.fromRGB(200, 200, 0)
                    wait(0.2)
                    antiAFKStatus.TextColor3 = Color3.fromRGB(0, 200, 0)
                    wait(0.2)
                end
            end)
        end)
        antiAFKStatus.Text = "Anti-AFK: Enabled"
        antiAFKStatus.TextColor3 = Color3.fromRGB(0, 200, 0)
    else
        antiAFKStatus.Text = "Anti-AFK: Disabled"
        antiAFKStatus.TextColor3 = Color3.fromRGB(200, 0, 0)
    end
end

-- Update Anti-AFK when toggle changes
antiAFKToggle.button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wait(0.3) -- Wait for toggle animation
        antiAFKEnabled = antiAFKToggle.getValue()
        setupAntiAFK()
    end
end)

-- Initial setup
setupAntiAFK()

--------------------------------------------------------------------------------
-- Make the GUI draggable
local function updateDrag(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    
    -- Create smooth dragging with tweening
    local dragTween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = position}
    )
    dragTween:Play()
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        updateDrag(input)
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize button functionality
local isMinimized = false
local originalSize = mainFrame.Size
local minimizedSize = UDim2.new(0, 600, 0, 30)

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    local targetSize = isMinimized and minimizedSize or originalSize
    
    local sizeTween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = targetSize}
    )
    
    sizeTween:Play()
    
    -- Hide/show content based on minimized state
    if isMinimized then
        contentArea.Visible = false
        tabContainer.Visible = false
    else
        -- Wait for animation to complete before showing content
        delay(0.3, function()
            contentArea.Visible = true
            tabContainer.Visible = true
        end)
    end
end)

--------------------------------------------------------------------------------
-- Hide/Unhide GUI using Left Control (Optimized with animation)
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftControl then
        menuVisible = not menuVisible
        
        -- Animate the visibility change
        if menuVisible then
            mainFrame.Visible = true
            mainFrame.Position = UDim2.new(0.5, -300, 0, -400)
            
            local showTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Position = UDim2.new(0.5, -300, 0.5, -200)}
            )
            
            showTween:Play()
        else
            local hideTween = TweenService:Create(
                mainFrame,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Position = UDim2.new(0.5, -300, 0, -400)}
            )
            
            hideTween:Play()
            
            hideTween.Completed:Connect(function()
                if not menuVisible then
                    mainFrame.Visible = false
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
print("RedEngine GUI Framework - Optimized Version has been initialized!")
print("Press LeftControl to toggle visibility")
