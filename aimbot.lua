-- Script LocalScript à placer dans StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local isActive = false
local menuOpen = true

-- Création du GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CurseurMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame principale du menu
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 250, 0, 120)
MenuFrame.Position = UDim2.new(0.5, -125, 0.1, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MenuFrame.BorderSizePixel = 2
MenuFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MenuFrame.Parent = ScreenGui

-- Coins arrondis
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MenuFrame

-- Titre
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.BorderSizePixel = 0
Title.Text = "AIMBOT & ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MenuFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Statut
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 30)
StatusLabel.Position = UDim2.new(0, 10, 0, 50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "AIMBOT: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 16
StatusLabel.Parent = MenuFrame

-- Instructions
local Instructions = Instance.new("TextLabel")
Instructions.Name = "Instructions"
Instructions.Size = UDim2.new(1, -20, 0, 25)
Instructions.Position = UDim2.new(0, 10, 0, 85)
Instructions.BackgroundTransparency = 1
Instructions.Text = "Right click to activate aimbot"
Instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
Instructions.Font = Enum.Font.Gotham
Instructions.TextSize = 12
Instructions.Parent = MenuFrame

-- Fonction pour trouver le joueur le plus proche
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local character = player.Character
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local screenPoint = Camera:WorldToScreenPoint(head.Position)
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Gestion du clic droit
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isActive = true
        StatusLabel.Text = "AIMBOT: ON"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isActive = false
        StatusLabel.Text = "AIMBOT: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Boucle principale pour verrouiller le curseur
RunService.RenderStepped:Connect(function()
    if isActive then
        local target = getClosestPlayer()
        
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            
            if head then
                local headPosition = head.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPosition)
            end
        end
    end
end)

-- Rendre le menu draggable (optionnel)
local dragging = false
local dragInput, mousePos, framePos

MenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MenuFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        MenuFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)
