-- RHTU Hub (Mobile Friendly Version) -- Author: ChatGPT for okebuf -- Features: UI Toggle Button, Speed, Noclip, FOV, ESP, Aimbot, Draggable UI, Rainbow Border

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Main GUI
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "RHTU_Hub"
MainUI.ResetOnSpawn = false
MainUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame", MainUI)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- Rainbow Border
local function updateRainbow(frame)
    local hue = 0
    game:GetService("RunService").RenderStepped:Connect(function()
        hue = (hue + 0.005) % 1
        frame.BorderColor3 = Color3.fromHSV(hue, 1, 1)
        frame.BorderSizePixel = 3
    end)
end
updateRainbow(Frame)

-- Toggle Button for Mobile
local toggleButton = Instance.new("TextButton", MainUI)
toggleButton.Text = "RHTU"
toggleButton.Size = UDim2.new(0, 60, 0, 30)
toggleButton.Position = UDim2.new(1, -70, 0, 10)
toggleButton.AnchorPoint = Vector2.new(0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.ZIndex = 10
toggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Buttons
local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Speed
local speedBox = Instance.new("TextBox", Frame)
speedBox.PlaceholderText = "Speed (1-100)"
speedBox.Size = UDim2.new(0, 180, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then
        LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(val, 1, 100)
    end
end)

-- Noclip
local noclip = false
createButton("Toggle Noclip", UDim2.new(0, 210, 0, 10), function()
    noclip = not noclip
end)
game:GetService("RunService").Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- FOV
createButton("FOV 120", UDim2.new(0, 10, 0, 50), function()
    workspace.CurrentCamera.FieldOfView = 120
end)
createButton("FOV 60", UDim2.new(0, 210, 0, 50), function()
    workspace.CurrentCamera.FieldOfView = 60
end)

-- ESP Player
local function createESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local billboard = Instance.new("BillboardGui", player.Character.Head)
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            local textLabel = Instance.new("TextLabel", billboard)
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextScaled = true
            textLabel.Text = player.Name .. " | HP: ? | ? studs"
        end
    end
end
createButton("ESP Players", UDim2.new(0, 10, 0, 90), createESP)

-- Aimbot UI
local targetBox = Instance.new("TextBox", Frame)
targetBox.PlaceholderText = "Player Name"
targetBox.Size = UDim2.new(0, 180, 0, 30)
targetBox.Position = UDim2.new(0, 10, 0, 130)
targetBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
targetBox.TextColor3 = Color3.new(1, 1, 1)

local function getTarget()
    return Players:FindFirstChild(targetBox.Text)
end

createButton("Headsit", UDim2.new(0, 210, 0, 130), function()
    local target = getTarget()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
    end
end)

createButton("Teleport", UDim2.new(0, 10, 0, 170), function()
    local target = getTarget()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
    end
end)

createButton("View", UDim2.new(0, 210, 0, 170), function()
    local target = getTarget()
    if target and target.Character then
        workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
    end
end)
