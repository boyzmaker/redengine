--[[
    RedEngine GUI Framework - Refactored Version
    Features:
    - Matches the original UI design
    - Implements Home and Server tab functionalities
    - Includes Anti-AFK, Infinite Jump, and No Clip toggles
    - Implements Rejoin Server, Server Hop, and Sea Teleport options
    - Toggle visibility with LeftControl key
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local MarketplaceService = game:GetService("MarketplaceService")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name

-- Settings
getgenv().AntiAFKEnabled = true
getgenv().InfiniteJumpEnabled = false
getgenv().NoClipEnabled = false

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedEngineGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "RedEngine"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 24
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TitleBar

-- Navigation Panel
local NavPanel = Instance.new("Frame")
NavPanel.Name = "NavPanel"
NavPanel.Size = UDim2.new(0, 120, 1, -30)
NavPanel.Position = UDim2.new(0, 0, 0, 30)
NavPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
NavPanel.BorderSizePixel = 0
NavPanel.Parent = MainFrame

-- Content Panel
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -120, 1, -30)
ContentPanel.Position = UDim2.new(0, 120, 0, 30)
ContentPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ContentPanel.BorderSizePixel = 0
ContentPanel.Parent = MainFrame

-- Create Tab System
local tabs = {}
local tabButtons = {}
local currentTab = nil

local function createTab(name)
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Button"
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, (#tabButtons * 40))
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.SourceSansSemibold
    tabButton.Parent = NavPanel
    
    -- Tab Content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.Visible = false
    tabContent.Parent = ContentPanel
    
    -- Auto layout for tab content
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = tabContent
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab Button Click
    tabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Content.Visible = false
            currentTab.Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            currentTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        
        tabContent.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        currentTab = {Content = tabContent, Button = tabButton}
    end)
    
    table.insert(tabButtons, tabButton)
    
    tabs[name] = {
        Content = tabContent,
        Button = tabButton
    }
    
    return tabContent
end

-- Create Sections
local function createSection(parent, title)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(0.9, 0, 0, 30) -- Initial size, will grow
    section.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Size = UDim2.new(1, 0, 0, 25)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.TextSize = 14
    sectionTitle.Font = Enum.Font.SourceSansBold
    sectionTitle.Parent = section
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -30)
    contentFrame.Position = UDim2.new(0, 10, 0, 25)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = section
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = contentFrame
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(0.9, 0, 0, UIListLayout.AbsoluteContentSize.Y + 35)
    end)
    
    return contentFrame
end

-- Create UI Elements
local function createToggle(parent, text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = text .. "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 25)
    toggle.BackgroundTransparency = 1
    toggle.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local button = Instance.new("Frame")
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Position = UDim2.new(1, -25, 0, 2)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    button.Parent = toggle
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    local value = default
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            value = not value
            button.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            callback(value)
        end
    end)
    
    return {
        Value = function() return value end,
        Set = function(newValue)
            value = newValue
            button.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            callback(value)
        end
    }
end

local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSansBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

local function createDropdown(parent, text, options, default, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Name = text .. "Dropdown"
    dropdown.Size = UDim2.new(1, 0, 0, 30)
    dropdown.BackgroundTransparency = 1
    dropdown.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdown
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.5, -5, 1, 0)
    button.Position = UDim2.new(0.5, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    button.BorderSizePixel = 0
    button.Text = default or options[1]
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.Parent = dropdown
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(0.5, -5, 0, #options * 25)
    optionsFrame.Position = UDim2.new(0.5, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.Parent = dropdown
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 4)
    optionsCorner.Parent = optionsFrame
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.SourceSans
        optionButton.ZIndex = 11
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            button.Text = option
            optionsFrame.Visible = false
            callback(option)
        end)
    end
    
    button.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
    end)
    
    return {
        Value = function() return button.Text end,
        Set = function(option)
            if table.find(options, option) then
                button.Text = option
                callback(option)
            end
        end
    }
end

-- Create Tabs
local homeTab = createTab("Home")
local serverTab = createTab("Server")
local settingsTab = createTab("Settings")
local macroTab = createTab("Macro")
local shopTab = createTab("Shop")
local subsFarmTab = createTab("Subs Farm")
local mainFarmTab = createTab("Main Farm")

-- Home Tab Content
local homeSection = createSection(homeTab, "Home Options")

-- Anti-AFK Toggle
local antiAFK = createToggle(homeSection, "Anti AFK", true, function(value)
    getgenv().AntiAFKEnabled = value
end)

-- Infinite Jump Toggle
local infiniteJump = createToggle(homeSection, "Infinite Jump", false, function(value)
    getgenv().InfiniteJumpEnabled = value
    
    if getgenv().InfiniteJumpEnabled then
        local connection
        connection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if getgenv().InfiniteJumpEnabled then
                local character = game:GetService("Players").LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            else
                connection:Disconnect()
            end
        end)
    end
end)

-- No Clip Toggle
local noClip = createToggle(homeSection, "No Clip", false, function(value)
    getgenv().NoClipEnabled = value
    
    if getgenv().NoClipEnabled then
        local runService = game:GetService("RunService")
        local connection
        connection = runService.Stepped:Connect(function()
            if getgenv().NoClipEnabled then
                local character = game:GetService("Players").LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            else
                connection:Disconnect()
            end
        end)
    end
end)

-- Server Tab Content
local serverSection = createSection(serverTab, "Server Options")

-- Rejoin Server Button
createButton(serverSection, "Rejoin Server", function()
    local ts = game:GetService("TeleportService")
    ts:Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

-- Server Hop Button
createButton(serverSection, "Server Hop", function()
    local ts = game:GetService("TeleportService")
    local placeId = game.PlaceId
    
    local servers = {}
    pcall(function()
        local response = ts:GetPlayerPlaceInstanceAsync(placeId, 100)
        for _, server in pairs(response) do
            if server.playing < server.maxPlayers then
                table.insert(servers, server)
            end
        end
    end)
    
    if #servers > 0 then
        ts:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)].id)
    else
        print("No available servers found")
    end
end)

-- Sea Teleport Section
local seaSection = createSection(serverTab, "Sea Teleport")

-- Sea Dropdown
local seaOptions = {"First Sea", "Second Sea", "Third Sea"}
local selectedSea = createDropdown(seaSection, "Select Sea", seaOptions, "First Sea", function(option)
    print("Selected sea: " .. option)
end)

-- Teleport to Sea Button
createButton(seaSection, "Teleport to Sea", function()
    local sea = selectedSea.Value()
    local placeId
    
    if sea == "First Sea" then
        placeId = 2753915549
    elseif sea == "Second Sea" then
        placeId = 4442272183
    elseif sea == "Third Sea" then
        placeId = 7449423635
    end
    
    if placeId then
        game:GetService("TeleportService"):Teleport(placeId, game:GetService("Players").LocalPlayer)
    end
end)

-- Settings Tab Content
local settingsSection = createSection(settingsTab, "Settings")

-- World Check
local worldLabel = Instance.new("TextLabel")
worldLabel.Size = UDim2.new(1, 0, 0, 25)
worldLabel.BackgroundTransparency = 1
worldLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
worldLabel.TextSize = 14
worldLabel.Font = Enum.Font.SourceSans
worldLabel.Parent = settingsSection

-- Check current world
local function updateWorldLabel()
    local placeId = game.PlaceId
    local worldName = "Unknown"
    
    if placeId == 2753915549 then
        worldName = "First Sea"
    elseif placeId == 4442272183 then
        worldName = "Second Sea"
    elseif placeId == 7449423635 then
        worldName = "Third Sea"
    end
    
    worldLabel.Text = "Current World: " .. worldName
end

updateWorldLabel()

-- Placeholder content for other tabs
local function createPlaceholder(tab, message)
    local placeholder = createSection(tab, "Coming Soon")
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.Parent = placeholder
end

createPlaceholder(macroTab, "Macro functionality will be added later.")
createPlaceholder(shopTab, "Shop functionality will be added later.")
createPlaceholder(subsFarmTab, "Subs Farm functionality will be added later.")
createPlaceholder(mainFarmTab, "Main Farm functionality will be added later.")

-- Anti-AFK Implementation
local VirtualUser = game:GetService("VirtualUser")

Player.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Button Actions
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        NavPanel.Visible = false
        ContentPanel.Visible = false
        MainFrame.Size = UDim2.new(0, 500, 0, 30)
    else
        NavPanel.Visible = true
        ContentPanel.Visible = true
        MainFrame.Size = UDim2.new(0, 500, 0, 300)
    end
end)

-- Toggle GUI with LeftControl
local guiVisible = true

-- Create a small indicator when GUI is hidden
local ToggleIndicator = Instance.new("Frame")
ToggleIndicator.Name = "ToggleIndicator"
ToggleIndicator.Size = UDim2.new(0, 40, 0, 40)
ToggleIndicator.Position = UDim2.new(0, 10, 0, 10)
ToggleIndicator.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleIndicator.BorderSizePixel = 0
ToggleIndicator.Visible = false
ToggleIndicator.Parent = ScreenGui

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(0, 5)
IndicatorCorner.Parent = ToggleIndicator

local IndicatorLabel = Instance.new("TextLabel")
IndicatorLabel.Size = UDim2.new(1, 0, 1, 0)
IndicatorLabel.BackgroundTransparency = 1
IndicatorLabel.Text = "RE"
IndicatorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
IndicatorLabel.TextSize = 16
IndicatorLabel.Font = Enum.Font.SourceSansBold
IndicatorLabel.Parent = ToggleIndicator

-- Make indicator draggable
local dragging = false
local dragInput, dragStart, startPos

ToggleIndicator.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = ToggleIndicator.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleIndicator.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleIndicator.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle indicator click to show GUI
ToggleIndicator.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if not dragging then
            guiVisible = true
            MainFrame.Visible = true
            ToggleIndicator.Visible = false
        end
    end
end)

-- Ctrl key toggle functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
        guiVisible = not guiVisible
        
        if guiVisible then
            MainFrame.Visible = true
            ToggleIndicator.Visible = false
        else
            MainFrame.Visible = false
            ToggleIndicator.Visible = true
        end
    end
end)

-- Set first tab as active
tabs["Home"].Button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
tabs["Home"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Home"].Content.Visible = true
currentTab = tabs["Home"]

print("RedEngine GUI Framework has been initialized!")
