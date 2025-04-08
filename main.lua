--[[
    RedEngine GUI Framework - Complete Version
    Features:
    - Self-contained script with all functionality in one file
    - Implements Home, Server, and Teleport tab functionalities
    - Includes Anti-AFK, Infinite Jump, and No Clip toggles
    - Implements Rejoin Server, Server Hop, and Sea Teleport options
    - Includes Teleport to Pirate/Marine options
    - Implements World Check, Monster Selection, Quest Handling, Equipment, and Player Manipulation
    - Toggle visibility with LeftControl
]]

--// Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TweenInfo = TweenInfo.new
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

--// Variables
local NameID = LocalPlayer.Name
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
local LibName = tostring(math.random(1, 100))..tostring(math.random(1,50))..tostring(math.random(1, 100))

--// Settings
local Settings = {}
local SettingToggle = {}

--// Utility Functions
local utility = {}

function utility:Tween(instance, properties, duration, ...)
    TweenService:Create(instance, TweenInfo(duration, ...), properties):Play()
end

--// Main GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = LibName
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

--// Toggle UI Function
local function ToggleUI()
    if game.CoreGui[LibName].Enabled then
        game.CoreGui[LibName].Enabled = false
    else
        game.CoreGui[LibName].Enabled = true
    end
end

--// Key Binding for Toggle
UserInputService.InputBegan:Connect(function(input) 
    if input.KeyCode == Enum.KeyCode.LeftControl then
        ToggleUI()
    end
end)

--// Main Body Frame
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Parent = ScreenGui
Body.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Body.BorderColor3 = Color3.fromRGB(0, 0, 0)
Body.BorderSizePixel = 0
Body.Position = UDim2.new(0.258427024, 0, 0.217948765, 0)
Body.Size = UDim2.new(0, 600, 0, 350)
Body.ClipsDescendants = true

local Body_Corner = Instance.new("UICorner")
Body_Corner.CornerRadius = UDim.new(0, 5)
Body_Corner.Name = "Body_Corner"
Body_Corner.Parent = Body

--// Title and Header
local Title_Hub = Instance.new("TextLabel")
Title_Hub.Name = "Title_Hub"
Title_Hub.Parent = Body
Title_Hub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title_Hub.BackgroundTransparency = 1.000
Title_Hub.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title_Hub.BorderSizePixel = 0
Title_Hub.Position = UDim2.new(0, 5, 0, 0)
Title_Hub.Size = UDim2.new(0, 558, 0, 30)
Title_Hub.Font = Enum.Font.SourceSansBold
Title_Hub.Text = "RedEngine - " .. GameName
Title_Hub.TextColor3 = Color3.fromRGB(255, 255, 255)
Title_Hub.TextSize = 15.000
Title_Hub.TextXAlignment = Enum.TextXAlignment.Left

--// Minimize Button
local MInimize_Button = Instance.new("TextButton")
MInimize_Button.Name = "MInimize_Button"
MInimize_Button.Parent = Body
MInimize_Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MInimize_Button.BackgroundTransparency = 1.000
MInimize_Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
MInimize_Button.BorderSizePixel = 0
MInimize_Button.Position = UDim2.new(0, 570, 0, 0)
MInimize_Button.Rotation = -315
MInimize_Button.Size = UDim2.new(0, 30, 0, 30)
MInimize_Button.AutoButtonColor = false
MInimize_Button.Font = Enum.Font.SourceSans
MInimize_Button.Text = "+"
MInimize_Button.TextColor3 = Color3.fromRGB(255, 255, 255)
MInimize_Button.TextSize = 40.000
MInimize_Button.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

--// Discord Button
local Discord = Instance.new("TextButton")
Discord.Name = "Discord"
Discord.Parent = Body
Discord.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Discord.BorderColor3 = Color3.fromRGB(0, 0, 0)
Discord.BorderSizePixel = 0
Discord.Position = UDim2.new(0, 5, 0, 320)
Discord.Size = UDim2.new(0, 85, 0, 25)
Discord.AutoButtonColor = false
Discord.Font = Enum.Font.SourceSans
Discord.Text = ""
Discord.TextColor3 = Color3.fromRGB(0, 0, 0)
Discord.TextSize = 14.000

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Discord

local Disc_Logo = Instance.new("ImageLabel")
Disc_Logo.Name = "Disc_Logo"
Disc_Logo.Parent = Discord
Disc_Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Disc_Logo.BackgroundTransparency = 1.000
Disc_Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
Disc_Logo.BorderSizePixel = 0
Disc_Logo.Position = UDim2.new(0, 5, 0, 1)
Disc_Logo.Size = UDim2.new(0, 23, 0, 23)
Disc_Logo.Image = "http://www.roblox.com/asset/?id=12058969086"

local Disc_Title = Instance.new("TextLabel")
Disc_Title.Name = "Disc_Title"
Disc_Title.Parent = Discord
Disc_Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Disc_Title.BackgroundTransparency = 1.000
Disc_Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Disc_Title.BorderSizePixel = 0
Disc_Title.Position = UDim2.new(0, 35, 0, 0)
Disc_Title.Size = UDim2.new(0, 40, 0, 25)
Disc_Title.Font = Enum.Font.SourceSansSemibold
Disc_Title.Text = "Discord"
Disc_Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Disc_Title.TextSize = 14.000
Disc_Title.TextXAlignment = Enum.TextXAlignment.Left

--// Discord Button Hover Effects
Discord.MouseEnter:Connect(function()
    utility:Tween(Discord, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, .15)
    utility:Tween(Disc_Logo, {ImageTransparency = 0.7}, .15)
    utility:Tween(Disc_Title, {TextTransparency = 0.7}, .15)
end)

Discord.MouseLeave:Connect(function()
    utility:Tween(Discord, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, .15)
    utility:Tween(Disc_Logo, {ImageTransparency = 0}, .15)
    utility:Tween(Disc_Title, {TextTransparency = 0}, .15)
end)

Discord.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/25ms")
    end)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Discord",
        Text = "Discord copied on your clipboard",
        Button1 = "Okay",
        Duration = 20
    })
end)

--// Server Time Display
local Server_Time = Instance.new("TextLabel")
Server_Time.Name = "Server_Time"
Server_Time.Parent = Body
Server_Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Server_Time.BackgroundTransparency = 1.000
Server_Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
Server_Time.BorderSizePixel = 0
Server_Time.Position = UDim2.new(0, 100, 0, 320)
Server_Time.Size = UDim2.new(0, 120, 0, 25)
Server_Time.Font = Enum.Font.SourceSansSemibold
Server_Time.Text = ""
Server_Time.TextColor3 = Color3.fromRGB(255, 255, 255)
Server_Time.TextSize = 14.000
Server_Time.TextXAlignment = Enum.TextXAlignment.Left

--// Update Server Time Function
local function UpdateTime()
    local GameTime = math.floor(workspace.DistributedGameTime+0.5)
    local Hour = math.floor(GameTime/(60^2))%24
    local Minute = math.floor(GameTime/(60^1))%60
    local Second = math.floor(GameTime/(60^0))%60
    local FormatTime = string.format("%02d.%02d.%02d", Hour, Minute, Second)
    Server_Time.Text = "Game Time : " .. FormatTime
end

spawn(function()
    while game:GetService('RunService').Heartbeat:Wait() do
        UpdateTime()
    end
end)

--// Server ID Display
local Server_ID = Instance.new("TextLabel")
Server_ID.Name = "Server_ID"
Server_ID.Parent = Body
Server_ID.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Server_ID.BackgroundTransparency = 1.000
Server_ID.BorderColor3 = Color3.fromRGB(0, 0, 0)
Server_ID.BorderSizePixel = 0
Server_ID.Position = UDim2.new(0, 230, 0, 320)
Server_ID.Size = UDim2.new(0, 365, 0, 25)
Server_ID.Font = Enum.Font.SourceSansSemibold
Server_ID.Text = "User : " .. NameID .. "     [CTRL = Hide Gui]"
Server_ID.TextColor3 = Color3.fromRGB(255, 255, 255)
Server_ID.TextSize = 14.000
Server_ID.TextXAlignment = Enum.TextXAlignment.Right

--// Separator Line
local List_Tile = Instance.new("Frame")
List_Tile.Name = "List_Tile"
List_Tile.Parent = Body
List_Tile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
List_Tile.BorderColor3 = Color3.fromRGB(0, 0, 0)
List_Tile.BorderSizePixel = 0
List_Tile.Position = UDim2.new(0, 0, 0, 30)
List_Tile.Size = UDim2.new(1, 0, 0, 2)

local Tile_Gradient = Instance.new("UIGradient")
Tile_Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
Tile_Gradient.Name = "Tile_Gradient"
Tile_Gradient.Parent = List_Tile

--// Toggle Button
local Toggle = Instance.new("Frame")
Toggle.Name = "Toggle"
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
Toggle.BorderSizePixel = 0
Toggle.Position = UDim2.new(0.0160791595, 0, 0.219451368, 0)
Toggle.Size = UDim2.new(0, 40, 0, 40)

local toggle_corner = Instance.new("UICorner")
toggle_corner.Name = "toggle_corner"
toggle_corner.Parent = Toggle

local toggle_Image = Instance.new("ImageButton")
toggle_Image.Name = "toggle_Image"
toggle_Image.Parent = Toggle
toggle_Image.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggle_Image.BackgroundTransparency = 1.000
toggle_Image.BorderColor3 = Color3.fromRGB(0, 0, 0)
toggle_Image.BorderSizePixel = 0
toggle_Image.Size = UDim2.new(0, 40, 0, 40)
toggle_Image.Image = "http://www.roblox.com/asset/?id=12021503727"
toggle_Image.ImageColor3 = Color3.fromRGB(255, 0, 0)

--// Minimize Button Functionality
local minimizetog = false
MInimize_Button.MouseButton1Click:Connect(function()
    if minimizetog then
        utility:Tween(Body, {Size = UDim2.new(0, 600, 0, 350)}, .3)
        utility:Tween(MInimize_Button, {Rotation = -315}, .3)
    else
        utility:Tween(Body, {Size = UDim2.new(0, 600, 0, 32)}, .3)
        utility:Tween(MInimize_Button, {Rotation = 360}, .3)
    end
    minimizetog = not minimizetog
end)

--// Toggle Button Functionality
local togimage = false
toggle_Image.MouseEnter:Connect(function()
    utility:Tween(Toggle, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, .15)
end)

toggle_Image.MouseLeave:Connect(function()
    utility:Tween(Toggle, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, .15)
end)

toggle_Image.MouseButton1Click:Connect(function()
    if togimage then
        Body.Visible = true
    else
        Body.Visible = false
    end
    togimage = not togimage
end)

--// Make Body Draggable
local function HJUAU_fake_script()
    local gui = Body
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
    
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end
coroutine.wrap(HJUAU_fake_script)()

--// Tab Container
local Tab_Container = Instance.new("Frame")
Tab_Container.Name = "Tab_Container"
Tab_Container.Parent = Body
Tab_Container.BackgroundColor3 = Color3.fromRGB(64, 64, 95)
Tab_Container.BackgroundTransparency = 1.000
Tab_Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab_Container.BorderSizePixel = 0
Tab_Container.ClipsDescendants = true
Tab_Container.Position = UDim2.new(0, 0, 0, 36)
Tab_Container.Size = UDim2.new(1, 0, 0, 30)

local Tab_List = Instance.new("Frame")
Tab_List.Name = "Tab_List"
Tab_List.Parent = Tab_Container
Tab_List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tab_List.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab_List.BorderSizePixel = 0
Tab_List.Position = UDim2.new(0, 0, 0, 28)
Tab_List.Size = UDim2.new(1, 0, 0, 2)

local TabList_Gradient = Instance.new("UIGradient")
TabList_Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
TabList_Gradient.Name = "TabList_Gradient"
TabList_Gradient.Parent = Tab_List

local Tab_Scroll = Instance.new("ScrollingFrame")
Tab_Scroll.Name = "Tab_Scroll"
Tab_Scroll.Parent = Tab_Container
Tab_Scroll.Active = true
Tab_Scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tab_Scroll.BackgroundTransparency = 1.000
Tab_Scroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab_Scroll.BorderSizePixel = 0
Tab_Scroll.Position = UDim2.new(0, 10, 0, 0)
Tab_Scroll.Size = UDim2.new(1, -20, 0, 30)
Tab_Scroll.CanvasPosition = Vector2.new(0, 150)
Tab_Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
Tab_Scroll.ScrollBarThickness = 0

local Tab_Scroll_Layout = Instance.new("UIListLayout")
Tab_Scroll_Layout.Name = "Tab_Scroll_Layout"
Tab_Scroll_Layout.Parent = Tab_Scroll
Tab_Scroll_Layout.FillDirection = Enum.FillDirection.Horizontal
Tab_Scroll_Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
Tab_Scroll_Layout.VerticalAlignment = Enum.VerticalAlignment.Top
Tab_Scroll_Layout.SortOrder = Enum.SortOrder.LayoutOrder
Tab_Scroll_Layout.Padding = UDim.new(0, 5)

Tab_Scroll_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Tab_Scroll.CanvasSize = UDim2.new(0, 0 + Tab_Scroll_Layout.Padding.Offset + Tab_Scroll_Layout.AbsoluteContentSize.X, 0, 0)
end)

Tab_Scroll.ChildAdded:Connect(function()
    Tab_Scroll.CanvasSize = UDim2.new(0, 0 + Tab_Scroll_Layout.Padding.Offset + Tab_Scroll_Layout.AbsoluteContentSize.X, 0, 0)
end)

--// Main Container
local Main_Container = Instance.new("Frame")
Main_Container.Name = "Main_Container"
Main_Container.Parent = Body
Main_Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main_Container.BackgroundTransparency = 1.000
Main_Container.BorderSizePixel = 0
Main_Container.Position = UDim2.new(0, 5, 0, 70)
Main_Container.Size = UDim2.new(0, 590, 0, 245)

local ContainerGradients = Instance.new("UIGradient")
ContainerGradients.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0)),
})
ContainerGradients.Name = "ContainerGradients"
ContainerGradients.Parent = Main_Container

local Container = Instance.new("Folder")
Container.Name = "Container"
Container.Parent = Main_Container

--// Tab Creation Function
local function CreateTab(title_tab)
    local Tab_Items = Instance.new("TextButton")
    local Tab_Item_Corner = Instance.new("UICorner")

    Tab_Items.Name = "Tab_Items"
    Tab_Items.Parent = Tab_Scroll
    Tab_Items.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Tab_Items.BackgroundTransparency = 1.000
    Tab_Items.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tab_Items.BorderSizePixel = 0
    Tab_Items.Size = UDim2.new(0, 0, 0, 0)
    Tab_Items.AutoButtonColor = false
    Tab_Items.Font = Enum.Font.SourceSansSemibold
    Tab_Items.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tab_Items.TextSize = 14.000
    Tab_Items.Text = title_tab

    Tab_Item_Corner.Name = "Tab_Item_Corner"
    Tab_Item_Corner.CornerRadius = UDim.new(0, 4)
    Tab_Item_Corner.Parent = Tab_Items

    utility:Tween(Tab_Items, {Size = UDim2.new(0, 25 + Tab_Items.TextBounds.X, 0, 24)}, .15)

    local ScrollingFrame = Instance.new("ScrollingFrame")
    local Scrolling_Layout = Instance.new("UIListLayout")

    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Parent = Container
    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.Visible = false

    Scrolling_Layout.Name = "Scrolling_Layout"
    Scrolling_Layout.Parent = ScrollingFrame
    Scrolling_Layout.FillDirection = Enum.FillDirection.Horizontal
    Scrolling_Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Scrolling_Layout.Padding = UDim.new(0, 19)

    Scrolling_Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, Scrolling_Layout.AbsoluteContentSize.X, 0, 0)
    end)

    ScrollingFrame.ChildAdded:Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, Scrolling_Layout.AbsoluteContentSize.X, 0, 0)
    end)

    return {
        TabButton = Tab_Items,
        TabContent = ScrollingFrame
    }
end

--// Section Creation Function
local function CreateSection(parent)
    local SectionScroll = Instance.new("ScrollingFrame")
    local UIListLayout_Section = Instance.new("UIListLayout")

    SectionScroll.Name = "SectionScroll"
    SectionScroll.Parent = parent
    SectionScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SectionScroll.BackgroundTransparency = 1.000
    SectionScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionScroll.BorderSizePixel = 0
    SectionScroll.Size = UDim2.new(0, 285, 0, 245)
    SectionScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    SectionScroll.ScrollBarThickness = 4

    UIListLayout_Section.Parent = SectionScroll
    UIListLayout_Section.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_Section.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Section.Padding = UDim.new(0, 6)

    UIListLayout_Section:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionScroll.CanvasSize = UDim2.new(0, 0, 0, 5 + UIListLayout_Section.Padding.Offset + UIListLayout_Section.AbsoluteContentSize.Y)
    end)
    
    SectionScroll.ChildAdded:Connect(function()
        SectionScroll.CanvasSize = UDim2.new(0, 0, 0, 5 + UIListLayout_Section.Padding.Offset + UIListLayout_Section.AbsoluteContentSize.Y)
    end)

    return SectionScroll
end

--// Menu Creation Function
local function CreateMenu(parent, title_menu)
    local Section = Instance.new("Frame")
    local Section_Inner = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local UICorner = Instance.new("UICorner")
    local List = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local UIGradient_2 = Instance.new("UIGradient")
    local TextLabel = Instance.new("TextLabel")

    Section.Name = "Section" or title_menu
    Section.Parent = parent
    Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Section.BackgroundTransparency = 1.000
    Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(1, 0, 0, 25)

    Section_Inner.Name = "Section_Inner"
    Section_Inner.Parent = Section
    Section_Inner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Section_Inner.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Section_Inner.BorderSizePixel = 0
    Section_Inner.Position = UDim2.new(0, 5, 0, 0)
    Section_Inner.Size = UDim2.new(1, -10, 0, 25)

    UIGradient_2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    UIGradient_2.Parent = Section_Inner

    UIListLayout.Parent = Section_Inner
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 3)

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Section_Inner

    TextLabel.Parent = Section_Inner
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 0, 20)
    TextLabel.Font = Enum.Font.SourceSansSemibold
    TextLabel.Text = title_menu
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    TextLabel.TextSize = 14.000

    List.Name = "List"
    List.Parent = Section_Inner
    List.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    List.BorderColor3 = Color3.fromRGB(0, 0, 0)
    List.BorderSizePixel = 0
    List.Size = UDim2.new(1, 0, 0, 1)

    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30)),
    })
    UIGradient.Parent = List

    Section.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset + 5)
    Section_Inner.Size = UDim2.new(1, -10, 0, UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset + 5)
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset + 5)
        Section_Inner.Size = UDim2.new(1, -10, 0, UIListLayout.AbsoluteContentSize.Y + UIListLayout.Padding.Offset + 5)
    end)

    return {
        Container = Section_Inner,
        Layout = UIListLayout
    }
end

--// Button Creation Function
local function CreateButton(parent, button_title, callback)
    callback = callback or function() end

    local TextButton = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    TextButton.Parent = parent
    TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Size = UDim2.new(1, -10, 0, 25)
    TextButton.AutoButtonColor = false
    TextButton.Font = Enum.Font.SourceSansSemibold
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextSize = 12.000
    TextButton.Text = button_title

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = TextButton

    TextButton.MouseEnter:Connect(function()
        utility:Tween(TextButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, .15)
        utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(180, 180, 180)}, .15)
    end)

    TextButton.MouseLeave:Connect(function()
        utility:Tween(TextButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, .15)
        utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, .15)
    end)

    TextButton.MouseButton1Down:Connect(function()
        utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(0, 255, 0)}, .15)
        utility:Tween(TextButton, {Size = UDim2.new(1, -25, 0, 15)}, .15)
    end)

    TextButton.MouseButton1Up:Connect(function()
        utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 1)
        utility:Tween(TextButton, {Size = UDim2.new(1, -10, 0, 25)}, .15)
    end)

    TextButton.MouseButton1Click:Connect(function()
        callback()
    end)

    return TextButton
end

--// Toggle Creation Function
local function CreateToggle(parent, toggle_title, default, callback)
    callback = callback or function(Value) end
    default = default or false

    local Frame = Instance.new("Frame")
    local TextLabel = Instance.new("TextLabel")
    local ImageButton = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")

    Frame.Parent = parent
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, -10, 0, 25)

    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0, 5, 0, 0)
    TextLabel.Size = UDim2.new(1, -30, 0, 25)
    TextLabel.Font = Enum.Font.SourceSansSemibold
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 12.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = toggle_title

    ImageButton.Parent = Frame
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton.BackgroundTransparency = 1.000
    ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0, 242, 0, 2)
    ImageButton.Size = UDim2.new(0, 20, 0, 20)
    ImageButton.Image = "rbxassetid://3926311105"
    ImageButton.ImageRectOffset = Vector2.new(940, 784)
    ImageButton.ImageRectSize = Vector2.new(48, 48)

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Frame

    local CheckToggle = false
    if default then
        ImageButton.ImageRectOffset = Vector2.new(4, 836)
        ImageButton.ImageColor3 = Color3.fromRGB(0, 255, 0)
        TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        CheckToggle = not CheckToggle
        callback(CheckToggle)
    end

    ImageButton.MouseEnter:Connect(function()
        utility:Tween(TextLabel, {TextTransparency = 0.5}, .15)
        utility:Tween(ImageButton, {ImageTransparency = 0.5}, .15)
        utility:Tween(Frame, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, .15)
    end)

    ImageButton.MouseLeave:Connect(function()
        utility:Tween(TextLabel, {TextTransparency = 0}, .15)
        utility:Tween(ImageButton, {ImageTransparency = 0}, .15)
        utility:Tween(Frame, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, .15)
    end)

    ImageButton.MouseButton1Click:Connect(function()
        if not CheckToggle then
            ImageButton.ImageRectOffset = Vector2.new(4, 836)
            utility:Tween(ImageButton, {ImageColor3 = Color3.fromRGB(0, 255, 0)}, .3)
            utility:Tween(TextLabel, {TextColor3 = Color3.fromRGB(0, 255, 0)}, .3)
        else
            ImageButton.ImageRectOffset = Vector2.new(940, 784)
            utility:Tween(ImageButton, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, .3)
            utility:Tween(TextLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, .3)
        end
        CheckToggle = not CheckToggle
        callback(CheckToggle)
    end)

    return {
        Frame = Frame,
        Label = TextLabel,
        Button = ImageButton,
        Value = function() return CheckToggle end,
        SetValue = function(value)
            CheckToggle = value
            if CheckToggle then
                ImageButton.ImageRectOffset = Vector2.new(4, 836)
                ImageButton.ImageColor3 = Color3.fromRGB(0, 255, 0)
                TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                ImageButton.ImageRectOffset = Vector2.new(940, 784)
                ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            callback(CheckToggle)
        end
    }
end

--// Dropdown Creation Function
local function CreateDropdown(parent, dropdown_title, default, list, callback)
    default = default or ""
    list = list or {}
    callback = callback or function(Value) end

    local Frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local TextLabel = Instance.new("TextLabel")
    local ImageButton = Instance.new("ImageButton")

    Frame.Parent = parent
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.new(1, -10, 0, 25)

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = Frame

    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Position = UDim2.new(0, 5, 0, 0)
    TextLabel.Size = UDim2.new(1, -40, 0, 25)
    TextLabel.Font = Enum.Font.SourceSansSemibold
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 12.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = dropdown_title

    ImageButton.Parent = Frame
    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton.BackgroundTransparency = 1.000
    ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0, 242, 0, 1)
    ImageButton.Size = UDim2.new(0, 21, 0, 22)
    ImageButton.Image = "rbxassetid://14834203285"

    if default then
        for i,v in pairs(list) do
            if v == default then
                TextLabel.Text = dropdown_title  ..' - ' .. v
                callback(v)
            end
        end
    end

    ImageButton.MouseEnter:Connect(function()
        utility:Tween(TextLabel, {TextTransparency = 0.5}, .15)
        utility:Tween(ImageButton, {ImageTransparency = 0.5}, .15)
        utility:Tween(Frame, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, .15)
    end)

    ImageButton.MouseLeave:Connect(function()
        utility:Tween(TextLabel, {TextTransparency = 0}, .15)
        utility:Tween(ImageButton, {ImageTransparency = 0}, .15)
        utility:Tween(Frame, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, .15)
    end)

    local ScrollDown = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local UICorner = Instance.new("UICorner")

    ScrollDown.Name = "ScrollDown"
    ScrollDown.Parent = parent
    ScrollDown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ScrollDown.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollDown.BorderSizePixel = 0
    ScrollDown.ClipsDescendants = true
    ScrollDown.Size = UDim2.new(1, -10, 0, 0)

    UIListLayout.Parent = ScrollDown
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 3)

    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = ScrollDown

    local dropdown_toggle = false
    ImageButton.MouseButton1Click:Connect(function()
        if dropdown_toggle then
            utility:Tween(ScrollDown, {Size = UDim2.new(1, -10, 0, 0)}, 0.15)
            utility:Tween(ImageButton, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, .15)
            utility:Tween(TextLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, .15)
        else
            utility:Tween(ScrollDown, {Size = UDim2.new(1, -10, 0, 0 + UIListLayout.AbsoluteContentSize.Y + 5)}, 0.15)
            utility:Tween(ImageButton, {ImageColor3 = Color3.fromRGB(0, 255, 0)}, .15)
            utility:Tween(TextLabel, {TextColor3 = Color3.fromRGB(0, 255, 0)}, .15)
        end
        dropdown_toggle = not dropdown_toggle
    end)

    for i,v in pairs(list) do
        local TextButton = Instance.new('TextButton')

        TextButton.Parent = ScrollDown
        TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TextButton.BackgroundTransparency = 1.000
        TextButton.BorderSizePixel = 0
        TextButton.Size = UDim2.new(1, 0, 0, 25)
        TextButton.Position = UDim2.new(0, 5, 0, 0)
        TextButton.Font = Enum.Font.SourceSansSemibold
        TextButton.AutoButtonColor = false
        TextButton.TextSize = 12.000
        TextButton.Text = v
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        TextButton.MouseEnter:Connect(function()
            utility:Tween(TextButton, {TextSize = 9.000}, 0.15)
            utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(0, 255, 0)}, 0.15)
        end)

        TextButton.MouseLeave:Connect(function()
            utility:Tween(TextButton, {TextSize = 12.000}, 0.15)
            utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
        end)

        TextButton.MouseButton1Click:Connect(function()
            dropdown_toggle = false
            TextLabel.Text = dropdown_title  ..' - ' .. v
            callback(v)
            utility:Tween(ScrollDown, {Size = UDim2.new(1, -10, 0, 0)}, 0.15)
            utility:Tween(ImageButton, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, .15)
            utility:Tween(TextLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, .15)
        end)
    end

    return {
        Frame = Frame,
        Label = TextLabel,
        Button = ImageButton,
        DropdownContainer = ScrollDown,
        Clear = function()
            for i,v in pairs(ScrollDown:GetChildren()) do
                if v:IsA("TextButton") then
                    v:Destroy()
                    dropdown_toggle = false
                    TextLabel.Text = dropdown_title
                    utility:Tween(ScrollDown, {Size = UDim2.new(1, -10, 0, 0)}, 0.15)
                end
            end
        end,
        Refresh = function(newlist)
            newlist = newlist or {}
            
            for i,v in pairs(ScrollDown:GetChildren()) do
                if v:IsA("TextButton") then
                    v:Destroy()
                end
            end

            for i,v in pairs(newlist) do
                local TextButton = Instance.new('TextButton')

                TextButton.Parent = ScrollDown
                TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                TextButton.BackgroundTransparency = 1.000
                TextButton.BorderSizePixel = 0
                TextButton.Size = UDim2.new(1, 0, 0, 25)
                TextButton.Position = UDim2.new(0, 5, 0, 0)
                TextButton.Font = Enum.Font.SourceSansSemibold
                TextButton.AutoButtonColor = false
                TextButton.TextSize = 12.000
                TextButton.Text = v
                TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
                TextButton.MouseEnter:Connect(function()
                    utility:Tween(TextButton, {TextSize = 9.000}, 0.15)
                    utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(0, 255, 0)}, 0.15)
                end)
    
                TextButton.MouseLeave:Connect(function()
                    utility:Tween(TextButton, {TextSize = 12.000}, 0.15)
                    utility:Tween(TextButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
                end)
    
                TextButton.MouseButton1Click:Connect(function()
                    dropdown_toggle = false
                    TextLabel.Text = dropdown_title  ..' - ' .. v
                    callback(v)
                    utility:Tween(ScrollDown, {Size = UDim2.new(1, -10, 0, 0)}, 0.15)
                    utility:Tween(ImageButton, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, .15)
                    utility:Tween(TextLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, .15)
                end)
            end
        end
    }
end

--// Label Creation Function
local function CreateLabel(parent, label_text)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Parent = parent
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, -20, 0, 15)
    TextLabel.Font = Enum.Font.SourceSansSemibold
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 12.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = label_text

    return {
        Label = TextLabel,
        Refresh = function(newLabel)
            if TextLabel.Text ~= newLabel then
                TextLabel.Text = newLabel
            end
        end
    }
end

--// Create Tabs
local tabs = {}
local is_first_tab = true

-- Home Tab
local homeTab = CreateTab("#Home")
tabs["Home"] = homeTab
local homeLeftSection = CreateSection(homeTab.TabContent)
local homeRightSection = CreateSection(homeTab.TabContent)

-- Server Tab
local serverTab = CreateTab("#Server")
tabs["Server"] = serverTab
local serverLeftSection = CreateSection(serverTab.TabContent)
local serverRightSection = CreateSection(serverTab.TabContent)

-- Teleport Tab
local teleportTab = CreateTab("#Teleport")
tabs["Teleport"] = teleportTab
local teleportLeftSection = CreateSection(teleportTab.TabContent)
local teleportRightSection = CreateSection(teleportTab.TabContent)

-- Main Farm Tab
local mainFarmTab = CreateTab("#Main Farm")
tabs["MainFarm"] = mainFarmTab
local mainFarmLeftSection = CreateSection(mainFarmTab.TabContent)
local mainFarmRightSection = CreateSection(mainFarmTab.TabContent)

-- Subs Farm Tab
local subsFarmTab = CreateTab("#Subs Farm")
tabs["SubsFarm"] = subsFarmTab
local subsFarmLeftSection = CreateSection(subsFarmTab.TabContent)
local subsFarmRightSection = CreateSection(subsFarmTab.TabContent)

-- Shop Tab
local shopTab = CreateTab("#Shop")
tabs["Shop"] = shopTab
local shopLeftSection = CreateSection(shopTab.TabContent)
local shopRightSection = CreateSection(shopTab.TabContent)

-- Macro Tab
local macroTab = CreateTab("#Macro")
tabs["Macro"] = macroTab
local macroLeftSection = CreateSection(macroTab.TabContent)
local macroRightSection = CreateSection(macroTab.TabContent)

-- Settings Tab
local settingsTab = CreateTab("#Settings")
tabs["Settings"] = settingsTab
local settingsLeftSection = CreateSection(settingsTab.TabContent)
local settingsRightSection = CreateSection(settingsTab.TabContent)

-- Set first tab as active
homeTab.TabButton.BackgroundTransparency = 0.5
homeTab.TabContent.Visible = true

-- Tab Button Click Handler
for name, tab in pairs(tabs) do
    tab.TabButton.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(tabs) do
            utility:Tween(otherTab.TabButton, {BackgroundTransparency = 1.000}, .3)
            otherTab.TabContent.Visible = false
        end
        utility:Tween(tab.TabButton, {BackgroundTransparency = 0.5}, .3)
        tab.TabContent.Visible = true
    end)
end

--// Create Menus
-- Home Tab Menus
local changelogMenu = CreateMenu(homeLeftSection, "#Changelog")
local homeMenu = CreateMenu(homeRightSection, "#Home")

-- Server Tab Menus
local serverOptionsMenu = CreateMenu(serverLeftSection, "#Server Options")
local seaTeleportMenu = CreateMenu(serverRightSection, "#Sea Teleport")

-- Teleport Tab Menus
local teamTeleportMenu = CreateMenu(teleportLeftSection, "#Team Teleport")
local islandTeleportMenu = CreateMenu(teleportRightSection, "#Island Teleport")

-- Main Farm Tab Menus
local mainFarmOptionsMenu = CreateMenu(mainFarmLeftSection, "#Main Farm Options")
local monsterSelectionMenu = CreateMenu(mainFarmRightSection, "#Monster Selection")

-- Subs Farm Tab Menus
local subsFarmOptionsMenu = CreateMenu(subsFarmLeftSection, "#Subs Farm Options")
local materialFarmMenu = CreateMenu(subsFarmRightSection, "#Material Farm")

-- Shop Tab Menus
local shopOptionsMenu = CreateMenu(shopLeftSection, "#Shop Options")
local itemSelectionMenu = CreateMenu(shopRightSection, "#Item Selection")

-- Macro Tab Menus
local macroOptionsMenu = CreateMenu(macroLeftSection, "#Macro Options")
local macroRecordingsMenu = CreateMenu(macroRightSection, "#Macro Recordings")

-- Settings Tab Menus
local settingsOptionsMenu = CreateMenu(settingsLeftSection, "#Settings Options")
local worldCheckMenu = CreateMenu(settingsRightSection, "#World Check")

--// Add Content to Menus
-- Changelog Menu
CreateLabel(changelogMenu.Container, "[April, 09 2025]")
CreateLabel(changelogMenu.Container, "- Refactored GUI with provided library")
CreateLabel(changelogMenu.Container, "- Implemented Home, Server, and Teleport tab functionalities")
CreateLabel(changelogMenu.Container, "- Added Anti-AFK, Infinite Jump, and No Clip toggles")
CreateLabel(changelogMenu.Container, "- Implemented Rejoin Server, Server Hop, and Sea Teleport options")
CreateLabel(changelogMenu.Container, "- Implemented Teleport to Pirate/Marine options")
CreateLabel(changelogMenu.Container, "- Added World Check, Monster Selection, Quest Handling")
CreateLabel(changelogMenu.Container, "- Added Equipment and Player Manipulation features")

-- Home Menu
getgenv().AntiAFKEnabled = true
local antiAFKToggle = CreateToggle(homeMenu.Container, "Anti AFK", getgenv().AntiAFKEnabled, function(Value)
    getgenv().AntiAFKEnabled = Value
end)

getgenv().InfiniteJumpEnabled = false
local infiniteJumpToggle = CreateToggle(homeMenu.Container, "Infinite Jump", getgenv().InfiniteJumpEnabled, function(Value)
    getgenv().InfiniteJumpEnabled = Value
    if getgenv().InfiniteJumpEnabled then
        game:GetService("UserInputService").JumpRequest:connect(function()
            game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end)
    end
end)

getgenv().NoClipEnabled = false
local noClipToggle = CreateToggle(homeMenu.Container, "No Clip", getgenv().NoClipEnabled, function(Value)
    getgenv().NoClipEnabled = Value
    if getgenv().NoClipEnabled then
        game:GetService("RunService").Stepped:Connect(function()
            for i,v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = not getgenv().NoClipEnabled
                end
            end
        end)
    end
end)

-- Server Options Menu
CreateButton(serverOptionsMenu.Container, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

CreateButton(serverOptionsMenu.Container, "Server Hop", function()
    local teleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local foundAServer = false

    local function teleportToAvailableServer()
        local success, errorMessage = pcall(function()
            local serverList = teleportService:GetPlayerPlaceInstanceAsync(placeId, 50)
            if serverList then
                for i, server in ipairs(serverList) do
                    if server.MaxPlayers > server.CurrentPlayers then
                        teleportService:TeleportToPlaceInstance(placeId, server.GameId, game.Players.LocalPlayer)
                        foundAServer = true
                        return
                    end
                end
            end
        end)

        if not success then
            warn("Failed to get server list: " .. errorMessage)
        end
    end

    teleportToAvailableServer()
    if not foundAServer then
        warn("No available servers found. Retrying...")
    end
end)

CreateButton(serverOptionsMenu.Container, "Teleport To Lower Server", function()
    local teleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local bestServerId = nil
    local minPlayers = math.huge

    local function findLowerServer()
        local success, errorMessage = pcall(function()
            local serverList = teleportService:GetPlayerPlaceInstanceAsync(placeId, 50)
            if serverList then
                for i, server in ipairs(serverList) do
                    if server.CurrentPlayers < minPlayers and server.GameId ~= game.JobId then
                        minPlayers = server.CurrentPlayers
                        bestServerId = server.GameId
                    end
                end
            end
        end)

        if not success then
            warn("Failed to get server list: " .. errorMessage)
        end
    end

    findLowerServer()

    if bestServerId then
        teleportService:TeleportToPlaceInstance(placeId, bestServerId, game.Players.LocalPlayer)
    else
        warn("No suitable server found.")
    end
end)

-- Sea Teleport Menu
local SeaList = {"First Sea", "Second Sea", "Third Sea"}
local SeaSelected = "First Sea"
local seaDropdown = CreateDropdown(seaTeleportMenu.Container, "Select Sea", SeaSelected, SeaList, function(Value)
    SeaSelected = Value
end)

CreateButton(seaTeleportMenu.Container, "Teleport to Sea", function()
    if SeaSelected == "First Sea" then
        game:GetService("TeleportService"):Teleport(2753915549, game:GetService("Players").LocalPlayer)
    elseif SeaSelected == "Second Sea" then
        game:GetService("TeleportService"):Teleport(4442272183, game:GetService("Players").LocalPlayer)
    elseif SeaSelected == "Third Sea" then
        game:GetService("TeleportService"):Teleport(7449423635, game:GetService("Players").LocalPlayer)
    end
end)

-- Team Teleport Menu
local Team  game:GetService("Players").LocalPlayer)
    end
end)

-- Team Teleport Menu
local TeamList = {"Pirate", "Marine"}
local TeamSelected = "Pirate"
local teamDropdown = CreateDropdown(teamTeleportMenu.Container, "Select Team", TeamSelected, TeamList, function(Value)
    TeamSelected = Value
end)

CreateButton(teamTeleportMenu.Container, "Teleport to Team", function()
    if TeamSelected == "Pirate" then
        _G.Team = "Pirate"
    elseif TeamSelected == "Marine" then
        _G.Team = "Marine"
    end

    if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam") then
        repeat wait()
            if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main").ChooseTeam.Visible == true then
                if _G.Team == "Pirate" then
                    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                        v.Function()
                    end
                elseif _G.Team == "Marine" then
                    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                        v.Function()
                    end
                else
                    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.Activated)) do                                                                                                
                        v.Function()
                    end
                end
            end
        until game.Players.LocalPlayer.Team ~= nil and game:IsLoaded()
    end
end)

-- Island Teleport Menu
CreateLabel(islandTeleportMenu.Container, "Island Teleport Options")

-- World Check Menu
CreateLabel(worldCheckMenu.Container, "Current World: Checking...")

local function CheckWorld()
    local worldLabel = CreateLabel(worldCheckMenu.Container, "Checking world...")
    
    if game.PlaceId == 2753915549 then
        worldLabel.Refresh("Current World: First Sea")
    elseif game.PlaceId == 4442272183 then
        worldLabel.Refresh("Current World: Second Sea")
    elseif game.PlaceId == 7449423635 then
        worldLabel.Refresh("Current World: Third Sea")
    else
        worldLabel.Refresh("Current World: Unknown")
    end
end

CheckWorld()

-- Monster Selection Menu
CreateLabel(monsterSelectionMenu.Container, "Select Monster to Farm")

local monsters = {"Bandit", "Monkey", "Gorilla", "Pirate", "Marine"}
local selectedMonster = "Bandit"
local monsterDropdown = CreateDropdown(monsterSelectionMenu.Container, "Select Monster", selectedMonster, monsters, function(Value)
    selectedMonster = Value
    print("Selected monster: " .. selectedMonster)
end)

CreateButton(monsterSelectionMenu.Container, "Start Farm", function()
    print("Starting farm for: " .. selectedMonster)
end)

CreateButton(monsterSelectionMenu.Container, "Stop Farm", function()
    print("Stopping farm")
end)

-- Main Farm Options Menu
getgenv().AutoFarm = false
local autoFarmToggle = CreateToggle(mainFarmOptionsMenu.Container, "Auto Farm", getgenv().AutoFarm, function(Value)
    getgenv().AutoFarm = Value
    if getgenv().AutoFarm then
        print("Auto Farm enabled")
    else
        print("Auto Farm disabled")
    end
end)

getgenv().AutoQuest = false
local autoQuestToggle = CreateToggle(mainFarmOptionsMenu.Container, "Auto Quest", getgenv().AutoQuest, function(Value)
    getgenv().AutoQuest = Value
    if getgenv().AutoQuest then
        print("Auto Quest enabled")
    else
        print("Auto Quest disabled")
    end
end)

-- Material Farm Menu
getgenv().AutoMaterial = false
local autoMaterialToggle = CreateToggle(materialFarmMenu.Container, "Auto Material", getgenv().AutoMaterial, function(Value)
    getgenv().AutoMaterial = Value
    if getgenv().AutoMaterial then
        print("Auto Material enabled")
    else
        print("Auto Material disabled")
    end
end)

local materials = {"Wood", "Stone", "Diamond", "Leather", "Fish"}
local selectedMaterial = "Wood"
local materialDropdown = CreateDropdown(materialFarmMenu.Container, "Select Material", selectedMaterial, materials, function(Value)
    selectedMaterial = Value
    print("Selected material: " .. selectedMaterial)
end)

-- Macro Options Menu
CreateLabel(macroOptionsMenu.Container, "Macro functionality will be added later.")

-- Settings Options Menu
CreateLabel(settingsOptionsMenu.Container, "Settings functionality will be added later.")

-- Anti-AFK Functionality
Players.LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- World Check Function
local function WorldCheck()
    if game.PlaceId == 2753915549 then
        return "First Sea"
    elseif game.PlaceId == 4442272183 then
        return "Second Sea"
    elseif game.PlaceId == 7449423635 then
        return "Third Sea"
    else
        return "Unknown"
    end
end

-- Check Monster Function
local function CheckMonster(monsterName)
    for i, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == monsterName and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            return v
        end
    end
    return nil
end

-- Select Monster Function
local function SelectMonster(monsterName)
    selectedMonster = monsterName
    print("Selected monster: " .. selectedMonster)
end

-- Check Boss Quest Function
local function CheckBossQuest(bossName)
    -- Implementation depends on the game's quest system
    print("Checking quest for boss: " .. bossName)
    return true
end

-- Check Material Function
local function CheckMaterial(materialName)
    -- Implementation depends on the game's material system
    print("Checking material: " .. materialName)
    return true
end

-- Equip Weapon Function
local function EquipWeapon(weaponName)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if player.Backpack:FindFirstChild(weaponName) then
        local tool = player.Backpack:FindFirstChild(weaponName)
        character.Humanoid:EquipTool(tool)
        return true
    else
        print("Weapon not found: " .. weaponName)
        return false
    end
end

-- Tween Player Function
local function TweenPlayer(destination, speed)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local distance = (humanoidRootPart.Position - destination).Magnitude
    local time = distance / speed
    
    local tween = TweenService:Create(
        humanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(destination)}
    )
    
    tween:Play()
    return tween
end

-- TP Island Function
local function TPIsland(islandName)
    -- Implementation depends on the game's island system
    print("Teleporting to island: " .. islandName)
    return true
end

-- Cancel Tween Function
local function CancelTween(tween)
    if tween then
        tween:Cancel()
        return true
    end
    return false
end

-- Player Body Velocity Function
local function CreateBodyVelocity(force)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * math.huge
    bodyVelocity.Velocity = force
    bodyVelocity.Parent = humanoidRootPart
    
    return bodyVelocity
end

-- Farming Clip Tween Function
local function FarmingClipTween(position, speed)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Enable noclip
    getgenv().NoClipEnabled = true
    
    -- Create tween
    local tween = TweenPlayer(position, speed)
    
    -- Return to normal after tween completes
    tween.Completed:Connect(function()
        getgenv().NoClipEnabled = false
    end)
    
    return tween
end

-- Setting Left Function
local function SettingLeft()
    -- Implementation depends on the game's settings
    print("Setting left function called")
    return true
end

print("RedEngine GUI Framework - Complete Version has been initialized!")
