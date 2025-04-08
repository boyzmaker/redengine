--[[
    RedEngine GUI Framework - Refactored and Enhanced
    Features:
    - Uses provided GUI library for better structure and maintainability
    - Implements Home, Server, and Teleport tab functionalities
    - Includes Anti-AFK, Infinite Jump, and No Clip toggles
    - Implements Rejoin Server, Server Hop, and Sea Teleport options
    - Includes Teleport to Pirate/Marine options
    - Toggle visibility with LeftControl
]]

-- Load the GUI library from the provided text
local Library = loadstring(text)();

-- Create the main window
local Window = Library:CreateWindow('RedEngine');

-- Create tabs
local Tab = {
    Home = Window:addTab('#Home'),
    Server = Window:addTab('#Server'),
    Teleport = Window:addTab('#Teleport'),
    MainFarm = Window:addTab('#Main Farm'),
    SubsFarm = Window:addTab('#Subs Farm'),
    Shop = Window:addTab('#Shop'),
    Macro = Window:addTab('#Macro'),
    Settings = Window:addTab('#Settings')
}

--[[
    Home Tab Functionality
]]
local Home_Left = Tab.Home:addSection()
local Changelog = Home_Left:addMenu("#Changelog")
Changelog:addChangelog('[April, 09 2025]')
Changelog:addChangelog('- Refactored GUI with provided library')
Changelog:addChangelog('- Implemented Home, Server, and Teleport tab functionalities')
Changelog:addChangelog('- Added Anti-AFK, Infinite Jump, and No Clip toggles')
Changelog:addChangelog('- Implemented Rejoin Server, Server Hop, and Sea Teleport options')
Changelog:addChangelog('- Implemented Teleport to Pirate/Marine options')

local Home_Right = Tab.Home:addSection()
local Main_Home = Home_Right:addMenu("#Home")

-- Anti-AFK Toggle
getgenv().AntiAFKEnabled = true
Main_Home:addToggle("Anti AFK", getgenv().AntiAFKEnabled, function(Value)
    getgenv().AntiAFKEnabled = Value
end)

-- Infinite Jump Toggle
getgenv().InfiniteJumpEnabled = false
Main_Home:addToggle("Infinite Jump", getgenv().InfiniteJumpEnabled, function(Value)
    getgenv().InfiniteJumpEnabled = Value
    if getgenv().InfiniteJumpEnabled then
        game:GetService("UserInputService").JumpRequest:connect(function()
            game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end)
    end
end)

-- No Clip Toggle
getgenv().NoClipEnabled = false
Main_Home:addToggle("No Clip", getgenv().NoClipEnabled, function(Value)
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

--[[
    Server Tab Functionality
]]
local Server_Left = Tab.Server:addSection()
local Server_Options = Server_Left:addMenu("#Server Options")

-- Rejoin Server Button
Server_Options:addButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

-- Server Hop Button
Server_Options:addButton("Server Hop", function()
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

-- Teleport To Lower Server Button
Server_Options:addButton("Teleport To Lower Server", function()
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

local Server_Right = Tab.Server:addSection()
local Sea_Teleport = Server_Right:addMenu('#Sea Teleport')

-- Sea Selection Dropdown
local SeaList = {"First Sea", "Second Sea", "Third Sea"}
local SeaSelected = "First Sea"
Sea_Teleport:addDropdown("Select Sea", SeaSelected, SeaList, function(Value)
    SeaSelected = Value
end)

-- Teleport to Selected Sea Button
Sea_Teleport:addButton("Teleport to Sea", function()
    if SeaSelected == "First Sea" then
        game:GetService("TeleportService"):Teleport(2753915549, game:GetService("Players").LocalPlayer)
    elseif SeaSelected == "Second Sea" then
        game:GetService("TeleportService"):Teleport(4442272183, game:GetService("Players").LocalPlayer)
    elseif SeaSelected == "Third Sea" then
        game:GetService("TeleportService"):Teleport(7449423635, game:GetService("Players").LocalPlayer)
    end
end)

--[[
    Teleport Tab Functionality
]]
local Teleport_Left = Tab.Teleport:addSection()
local Team_Teleport = Teleport_Left:addMenu('#Team Teleport')

-- Team Selection Dropdown
local TeamList = {"Pirate", "Marine"}
local TeamSelected = "Pirate"
Team_Teleport:addDropdown("Select Team", TeamSelected, TeamList, function(Value)
    TeamSelected = Value
end)

-- Teleport to Selected Team Button
Team_Teleport:addButton("Teleport to Team", function()
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

--[[
    Macro Tab Functionality
]]
local Macro_Left = Tab.Macro:addSection()
local Macro_Options = Macro_Left:addMenu("#Macro Options")

Macro_Options:addLabel("Macro functionality will be added later.")

--[[
    Settings Tab Functionality
]]
local Settings_Left = Tab.Settings:addSection()
local Settings_Options = Settings_Left:addMenu("#Settings Options")

Settings_Options:addLabel("Settings functionality will be added later.")

-- Anti-AFK Functionality
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    if getgenv().AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Hide/Unhide GUI using Left Control
local UserInputService = game:GetService("UserInputService")
local menuVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        if input.KeyCode == Enum.KeyCode.LeftControl then
            menuVisible = not menuVisible
            Library:ToggleUI()
        end
    end
end)

print("RedEngine GUI Framework - Refactored Version has been initialized!")
