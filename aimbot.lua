local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local aimEnabled = false
local espEnabled = false
local isAiming = false
local espObjects = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AIMBOTMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 280, 0, 180)
MenuFrame.Position = UDim2.new(0.5, -140, 0.1, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MenuFrame.BorderSizePixel = 2
MenuFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MenuFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MenuFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.BorderSizePixel = 0
Title.Text = "Menu Fonctionnel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MenuFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local AimButton = Instance.new("TextButton")
AimButton.Name = "AimButton"
AimButton.Size = UDim2.new(0, 240, 0, 40)
AimButton.Position = UDim2.new(0, 20, 0, 55)
AimButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
AimButton.BorderSizePixel = 0
AimButton.Text = "AIMBOT: OFF"
AimButton.TextColor3 = Color3.fromRGB(255, 100, 100)
AimButton.Font = Enum.Font.GothamBold
AimButton.TextSize = 16
AimButton.Parent = MenuFrame

local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(0, 8)
AimCorner.Parent = AimButton

local ESPButton = Instance.new("TextButton")
ESPButton.Name = "ESPButton"
ESPButton.Size = UDim2.new(0, 240, 0, 40)
ESPButton.Position = UDim2.new(0, 20, 0, 105)
ESPButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ESPButton.BorderSizePixel = 0
ESPButton.Text = "ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 100, 100)
ESPButton.Font = Enum.Font.GothamBold
ESPButton.TextSize = 16
ESPButton.Parent = MenuFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 8)
ESPCorner.Parent = ESPButton

local Instructions = Instance.new("TextLabel")
Instructions.Name = "Instructions"
Instructions.Size = UDim2.new(1, -20, 0, 20)
Instructions.Position = UDim2.new(0, 10, 0, 155)
Instructions.BackgroundTransparency = 1
Instructions.Text = "Right click to activate aimbot"
Instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
Instructions.Font = Enum.Font.Gotham
Instructions.TextSize = 11
Instructions.Parent = MenuFrame

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

local function createESP(player)
    if espObjects[player] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. player.Name
    espObjects[player] = espFolder
    
    local function updateESP()
        if not player.Character then return end
        
        for _, v in pairs(espFolder:GetChildren()) do
            v:Destroy()
        end
        
        local character = player.Character
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then return end
        
        local parts = {
            "Head", "UpperTorso", "LowerTorso",
            "LeftUpperArm", "LeftLowerArm", "LeftHand",
            "RightUpperArm", "RightLowerArm", "RightHand",
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
            "RightUpperLeg", "RightLowerLeg", "RightFoot"
        }
        
        for _, partName in pairs(parts) do
            local part = character:FindFirstChild(partName)
            if part then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = part.Size
                box.Adornee = part
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.Transparency = 0.7
                box.AlwaysOnTop = true
                box.ZIndex = 1
                box.Parent = espFolder
            end
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = rootPart
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = espFolder
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Parent = billboard
        
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
        healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextSize = 12
        healthLabel.TextStrokeTransparency = 0
        healthLabel.Parent = billboard
    end
    
    updateESP()
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if espEnabled and player.Character then
            updateESP()
        end
    end)
    
    espFolder.Parent = CoreGui or game:GetService("CoreGui")
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

local function removeAllESP()
    for player, _ in pairs(espObjects) do
        removeESP(player)
    end
end

local function updateAllESP()
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    else
        removeAllESP()
    end
end

AimButton.MouseButton1Click:Connect(function()
    aimEnabled = not aimEnabled
    
    if aimEnabled then
        AimButton.Text = "AIMBOT: ON"
        AimButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        AimButton.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
    else
        AimButton.Text = "AIMBOT: OFF"
        AimButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        AimButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        isAiming = false
    end
end)

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        ESPButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        ESPButton.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
    else
        ESPButton.Text = "ESP: OFF"
        ESPButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        ESPButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
    
    updateAllESP()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 and aimEnabled then
        isAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if isAiming and aimEnabled then
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

Players.PlayerAdded:Connect(function(player)
    if espEnabled and player ~= LocalPlayer then
        player.CharacterAdded:Wait()
        wait(0.5)
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

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
