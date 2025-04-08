--[[
    RedEngine GUI Framework - Redesigned Version
    Features:
    - Sleek red and green accent UI design
    - Optimized for performance
    - Draggable minimized mode
    - Improved server hopping functionality
    - Tabs: Home, Server, Teleport, Main Farm, Subs Farm, Shop, Macro, Settings
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Settings
getgenv().AntiAFKEnabled = true
getgenv().InfiniteJumpEnabled = false
getgenv().NoClipEnabled = false

-- Performance Optimization
local renderSteppedConnection
local steppedConnection

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedEngineGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Add rounded corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Add shadow effect
local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "Shadow"
MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
MainShadow.Size = UDim2.new(1, 24, 1, 24)
MainShadow.ZIndex = 0
MainShadow.Image = "rbxassetid://6014261993"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.5
MainShadow.ScaleType = Enum.ScaleType.Slice
MainShadow.SliceCenter = Rect.new(49, 49, 450, 450)
MainShadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(180, 25, 25) -- Softer red
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Title Bar Corner
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

-- Fix the bottom corners of title bar
local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(1, 0, 0.5, 0)
BottomFrame.Position = UDim2.new(0, 0, 0.5, 0)
BottomFrame.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
BottomFrame.BorderSizePixel = 0
BottomFrame.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "RedEngine"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Position = UDim2.new(1, -70, 0, 8)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Image = "rbxassetid://7072718185" -- Minimize icon
MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -40, 0, 8)
CloseButton.BackgroundTransparency = 1
CloseButton.Image = "rbxassetid://7072725342" -- Close icon
CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = TitleBar

-- Make the main frame draggable
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Navigation Panel
local NavPanel = Instance.new("Frame")
NavPanel.Name = "NavPanel"
NavPanel.Size = UDim2.new(0, 130, 1, -40)
NavPanel.Position = UDim2.new(0, 0, 0, 40)
NavPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
NavPanel.BorderSizePixel = 0
NavPanel.Parent = MainFrame

-- Content Panel
local ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -130, 1, -40)
ContentPanel.Position = UDim2.new(0, 130, 0, 40)
ContentPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ContentPanel.BorderSizePixel = 0
ContentPanel.Parent = MainFrame

-- Create Tab System
local tabs = {}
local tabButtons = {}
local currentTab = nil

local function createTab(name, order)
    -- Tab Button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Button"
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Position = UDim2.new(0, 0, 0, (order * 40))
    tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.Parent = NavPanel
    
    -- Tab Indicator
    local tabIndicator = Instance.new("Frame")
    tabIndicator.Name = "Indicator"
    tabIndicator.Size = UDim2.new(0, 3, 1, 0)
    tabIndicator.BackgroundColor3 = Color3.fromRGB(40, 180, 40) -- Green accent
    tabIndicator.BorderSizePixel = 0
    tabIndicator.Visible = false
    tabIndicator.Parent = tabButton
    
    -- Tab Content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "Content"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(180, 25, 25)
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
            currentTab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            currentTab.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            currentTab.Indicator.Visible = false
        end
        
        tabContent.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabIndicator.Visible = true
        
        currentTab = {Content = tabContent, Button = tabButton, Indicator = tabIndicator}
    end)
    
    table.insert(tabButtons, tabButton)
    
    tabs[name] = {
        Content = tabContent,
        Button = tabButton,
        Indicator = tabIndicator
    }
    
    return tabContent
end

-- Create Sections
local function createSection(parent, title)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(0.95, 0, 0, 40) -- Initial size, will grow
    section.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    -- Add rounded corners
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Size = UDim2.new(1, 0, 0, 30)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionTitle.TextSize = 14
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.Parent = section
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -35)
    contentFrame.Position = UDim2.new(0, 10, 0, 30)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = section
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.Parent = contentFrame
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(0.95, 0, 0, UIListLayout.AbsoluteContentSize.Y + 40)
    end)
    
    return contentFrame
end

-- Create UI Elements
local function createToggle(parent, text, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = text .. "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.BackgroundTransparency = 1
    toggle.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -45, 0, 5)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 25, 25)
    toggleButton.Parent = toggle
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleButton
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(default and 0.6 or 0.1, 0, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.Parent = toggleButton
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local value = default
    
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            value = not value
            
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = value and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 25, 25)
            }):Play()
            
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = value and UDim2.new(0.6, 0, 0.5, -8) or UDim2.new(0.1, 0, 0.5, -8)
            }):Play()
            
            callback(value)
        end
    end)
    
    return {
        Value = function() return value end,
        Set = function(newValue)
            value = newValue
            
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = value and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 25, 25)
            }):Play()
            
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = value and UDim2.new(0.6, 0, 0.5, -8) or UDim2.new(0.1, 0, 0.5, -8)
            }):Play()
            
            callback(value)
        end
    }
end

local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Button hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(180, 25, 25)
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(150, 20, 20),
            Size = UDim2.new(0.98, 0, 0, 34)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(200, 40, 40),
            Size = UDim2.new(1, 0, 0, 36)
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

local function createDropdown(parent, text, options, default, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Name = text .. "Dropdown"
    dropdown.Size = UDim2.new(1, 0, 0, 36)
    dropdown.BackgroundTransparency = 1
    dropdown.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdown
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 36)
    button.Position = UDim2.new(0, 0, 0, 20)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    button.BorderSizePixel = 0
    button.Text = default or options[1]
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = dropdown
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    local arrowIcon = Instance.new("ImageLabel")
    arrowIcon.Size = UDim2.new(0, 20, 0, 20)
    arrowIcon.Position = UDim2.new(1, -25, 0.5, -10)
    arrowIcon.BackgroundTransparency = 1
    arrowIcon.Image = "rbxassetid://7072706318" -- Down arrow
    arrowIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    arrowIcon.Parent = button
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, 0) -- Will be resized when opened
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.ClipsDescendants = true
    optionsFrame.Parent = button
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 6)
    optionsCorner.Parent = optionsFrame
    
    local optionsList = Instance.new("ScrollingFrame")
    optionsList.Size = UDim2.new(1, 0, 1, 0)
    optionsList.BackgroundTransparency = 1
    optionsList.BorderSizePixel = 0
    optionsList.ScrollBarThickness = 4
    optionsList.ScrollBarImageColor3 = Color3.fromRGB(180, 25, 25)
    optionsList.ZIndex = 11
    optionsList.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsList
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.Gotham
        optionButton.ZIndex = 12
        optionButton.Parent = optionsList
        
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.8,
                BackgroundColor3 = Color3.fromRGB(180, 25, 25)
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            button.Text = option
            
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(arrowIcon, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
            
            wait(0.2)
            optionsFrame.Visible = false
            
            callback(option)
        end)
    end
    
    optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsList.CanvasSize = UDim2.new(0, 0, 0, optionsLayout.AbsoluteContentSize.Y)
    end)
    
    local dropdownOpen = false
    
    button.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        
        if dropdownOpen then
            optionsFrame.Visible = true
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, math.min(120, #options * 30))
            }):Play()
            
            TweenService:Create(arrowIcon, TweenInfo.new(0.2), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(arrowIcon, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
            
            wait(0.2)
            optionsFrame.Visible = false
        end
    end)
    
    dropdown.Size = UDim2.new(1, 0, 0, 60) -- Adjust for label + button
    
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

-- Create Minimized Mode
local MinimizedGui = Instance.new("Frame")
MinimizedGui.Name = "MinimizedGui"
MinimizedGui.Size = UDim2.new(0, 50, 0, 50)
MinimizedGui.Position = UDim2.new(0, 20, 0, 20)
MinimizedGui.BackgroundColor3 = Color3.fromRGB(180, 25, 25)
MinimizedGui.BorderSizePixel = 0
MinimizedGui.Visible = false
MinimizedGui.Parent = ScreenGui

-- Add rounded corners
local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MinimizedGui

-- Add shadow
local MiniShadow = Instance.new("ImageLabel")
MiniShadow.Name = "Shadow"
MiniShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MiniShadow.BackgroundTransparency = 1
MiniShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
MiniShadow.Size = UDim2.new(1, 24, 1, 24)
MiniShadow.ZIndex = 0
MiniShadow.Image = "rbxassetid://6014261993"
MiniShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MiniShadow.ImageTransparency = 0.5
MiniShadow.ScaleType = Enum.ScaleType.Slice
MiniShadow.SliceCenter = Rect.new(49, 49, 450, 450)
MiniShadow.Parent = MinimizedGui

-- Logo
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 1, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "RE"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 20
Logo.Font = Enum.Font.GothamBold
Logo.Parent = MinimizedGui

-- Make minimized GUI draggable
local miniDragging = false
local miniDragInput, miniDragStart, miniStartPos

MinimizedGui.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        miniDragging = true
        miniDragStart = input.Position
        miniStartPos = MinimizedGui.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                miniDragging = false
            end
        end)
    end
end)

MinimizedGui.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        miniDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == miniDragInput and miniDragging then
        local delta = input.Position - miniDragStart
        MinimizedGui.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
    end
end)

-- Restore from minimized mode
MinimizedGui.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not miniDragging then
        wait(0.1) -- Small delay to prevent accidental clicks
        if not miniDragging then
            MinimizedGui.Visible = false
            MainFrame.Visible = true
        end
    end
end)

-- Create Tabs
local homeTab = createTab("Home", 0)
local serverTab = createTab("Server", 1)
local teleportTab = createTab("Teleport", 2)
local mainFarmTab = createTab("Main Farm", 3)
local subsFarmTab = createTab("Subs Farm", 4)
local shopTab = createTab("Shop", 5)
local macroTab = createTab("Macro", 6)
local settingsTab = createTab("Settings", 7)

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
        if renderSteppedConnection then
            renderSteppedConnection:Disconnect()
        end
        
        renderSteppedConnection = UserInputService.JumpRequest:Connect(function()
            if getgenv().InfiniteJumpEnabled then
                local character = Player.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end
        end)
    else
        if renderSteppedConnection then
            renderSteppedConnection:Disconnect()
        end
    end
end)

-- No Clip Toggle
local noClip = createToggle(homeSection, "No Clip", false, function(value)
    getgenv().NoClipEnabled = value
    
    if getgenv().NoClipEnabled then
        if steppedConnection then
            steppedConnection:Disconnect()
        end
        
        steppedConnection = RunService.Stepped:Connect(function()
            if getgenv().NoClipEnabled then
                local character = Player.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        if steppedConnection then
            steppedConnection:Disconnect()
        end
    end
end)

-- Server Tab Content
local serverSection = createSection(serverTab, "Server Options")

-- Rejoin Server Button
createButton(serverSection, "Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, Player)
end)

-- Server Hop Button
createButton(serverSection, "Server Hop", function()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    
    local function TPReturner()
        local Site
        if foundAnything == "" then
            Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        
        local num = 0
        for i, v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait(0.1)
                    pcall(function()
                        wait()
                        TeleportService:TeleportToPlaceInstance(PlaceID, ID, Player)
                    end)
                    wait(0.1)
                end
            end
        end
    end
    
    TPReturner()
end)

-- Lower Server Button
createButton(serverSection, "Lower Server", function()
    local PlaceID = game.PlaceId
    local servers = {}
    local req = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    
    if req.data then
        local lowest = nil
        local lowestCount = math.huge
        
        for i, v in pairs(req.data) do
            if v.playing < lowestCount and v.id ~= game.JobId then
                lowestCount = v.playing
                lowest = v.id
            end
        end
        
        if lowest then
            TeleportService:TeleportToPlaceInstance(PlaceID, lowest, Player)
        else
            print("No suitable server found")
        end
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
        TeleportService:Teleport(placeId, Player)
    end
end)

-- Settings Tab Content
local settingsSection = createSection(settingsTab, "Settings")

-- World Check
local worldLabel = Instance.new("TextLabel")
worldLabel.Size = UDim2.new(1, 0, 0, 30)
worldLabel.BackgroundTransparency = 1
worldLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
worldLabel.TextSize = 14
worldLabel.Font = Enum.Font.Gotham
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

-- Destroy GUI Button
createButton(settingsSection, "Destroy GUI", function()
    -- Clean up connections
    if renderSteppedConnection then
        renderSteppedConnection:Disconnect()
    end
    
    if steppedConnection then
        steppedConnection:Disconnect()
    end
    
    -- Destroy the GUI
    ScreenGui:Destroy()
end)

-- Placeholder content for other tabs
local function createPlaceholder(tab, message)
    local placeholder = createSection(tab, "Coming Soon")
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.Parent = placeholder
end

createPlaceholder(teleportTab, "Teleport functionality will be added later.")
createPlaceholder(mainFarmTab, "Main Farm functionality will be added later.")
createPlaceholder(subsFarmTab, "Subs Farm functionality will be added later.")
createPlaceholder(shopTab, "Shop functionality will be added later.")
createPlaceholder(macroTab, "Macro functionality will be added later.")

-- Anti-AFK Implementation
Player.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Button Actions
CloseButton.MouseButton1Click:Connect(function()
    -- Clean up connections
    if renderSteppedConnection then
        renderSteppedConnection:Disconnect()
    end
    
    if steppedConnection then
        steppedConnection:Disconnect()
    end
    
    -- Destroy the GUI
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedGui.Visible = true
    MinimizedGui.Position = UDim2.new(0, MainFrame.AbsolutePosition.X, 0, MainFrame.AbsolutePosition.Y)
end)

-- Set first tab as active
tabs["Home"].Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
tabs["Home"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Home"].Content.Visible = true
tabs["Home"].Indicator.Visible = true
currentTab = {
    Content = tabs["Home"].Content,
    Button = tabs["Home"].Button,
    Indicator = tabs["Home"].Indicator
}

print("RedEngine GUI Framework has been initialized!")
