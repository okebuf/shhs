-- RHTU Hub Premium v1.4 (Mobile Friendly) -- Author: ChatGPT for okebuf -- Features: Toggle UI, Speed, Noclip, FOV, Fly, ESP, Aimbot, Teleport/View, Follow Player, AntiKick, Rainbow Border, Notification

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse() local RunService = game:GetService("RunService")

-- ( UI Setup ) local MainUI = Instance.new("ScreenGui") MainUI.Name = "RHTU_Hub" MainUI.ResetOnSpawn = false MainUI.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame") Frame.Size = UDim2.new(0, 400, 0, 320) Frame.Position = UDim2.new(0.5, -200, 0.5, -160) Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) Frame.Active = true Frame.Draggable = true Frame.Parent = MainUI

-- ( Rainbow Border ) local function updateRainbow(frame) local hue = 0 RunService.RenderStepped:Connect(function() hue = (hue + 0.005) % 1 frame.BorderColor3 = Color3.fromHSV(hue, 1, 1) frame.BorderSizePixel = 3 end) end updateRainbow(Frame)

-- ( Toggle Button ) local toggleButton = Instance.new("TextButton") toggleButton.Text = "RHTU" toggleButton.Size = UDim2.new(0, 60, 0, 30) toggleButton.Position = UDim2.new(1, -70, 0, 10) toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) toggleButton.TextColor3 = Color3.new(1, 1, 1) toggleButton.Parent = MainUI toggleButton.ZIndex = 10 toggleButton.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)

-- ( Notify ) local function notify() local n = Instance.new("TextLabel", MainUI) n.Text = "RHTU Hub Premium\nversion 1.4" n.TextColor3 = Color3.new(1, 1, 1) n.BackgroundColor3 = Color3.fromRGB(0, 0, 0) n.Position = UDim2.new(0.5, -100, 1, -60) n.Size = UDim2.new(0, 200, 0, 40) n.TextScaled = true n.ZIndex = 10 wait(3) n:Destroy() end

-- ( Helper Functions ) local function createButton(text, pos, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 180, 0, 30) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Text = text btn.Parent = Frame local state = false btn.MouseButton1Click:Connect(function() state = not state btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0) callback(state) notify() end) return btn end

-- ( Speed ) local speedBox = Instance.new("TextBox", Frame) speedBox.PlaceholderText = "Speed (1-100)" speedBox.Size = UDim2.new(0, 180, 0, 30) speedBox.Position = UDim2.new(0, 10, 0, 10) speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) speedBox.TextColor3 = Color3.new(1, 1, 1) speedBox.FocusLost:Connect(function() local val = tonumber(speedBox.Text) if val then LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(val, 1, 100) notify() end end)

-- ( Fly ) local UIS = game:GetService("UserInputService") local flying = false local flyspeed = 1 local bodyGyro, bodyVel

createButton("Fly Toggle", UDim2.new(0, 210, 0, 10), function(on) flying = on if on and LocalPlayer.Character then local char = LocalPlayer.Character local hrp = char:WaitForChild("HumanoidRootPart") bodyGyro = Instance.new("BodyGyro", hrp) bodyGyro.P = 9e4 bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bodyVel = Instance.new("BodyVelocity", hrp) bodyVel.Velocity = Vector3.new(0, 0, 0) bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9) RunService.RenderStepped:Connect(function() if flying then local cam = workspace.CurrentCamera bodyGyro.CFrame = cam.CFrame bodyVel.Velocity = cam.CFrame.LookVector * flyspeed * 10 end end) else if bodyGyro then bodyGyro:Destroy() end if bodyVel then bodyVel:Destroy() end end end)

local flySpeedBox = Instance.new("TextBox", Frame) flySpeedBox.PlaceholderText = "Fly Speed (1-10)" flySpeedBox.Size = UDim2.new(0, 180, 0, 30) flySpeedBox.Position = UDim2.new(0, 10, 0, 50) flySpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) flySpeedBox.TextColor3 = Color3.new(1, 1, 1) flySpeedBox.FocusLost:Connect(function() local val = tonumber(flySpeedBox.Text) if val then flyspeed = math.clamp(val, 1, 10) notify() end end)

-- ( FOV ) createButton("FOV 120", UDim2.new(0, 210, 0, 50), function() workspace.CurrentCamera.FieldOfView = 120 end) createButton("FOV 60", UDim2.new(0, 210, 0, 90), function() workspace.CurrentCamera.FieldOfView = 60 end)

-- ( Noclip ) local noclip = false createButton("Noclip", UDim2.new(0, 10, 0, 90), function(on) noclip = on end) RunService.Stepped:Connect(function() if noclip and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- ( ESP ) createButton("ESP Players", UDim2.new(0, 10, 0, 130), function() for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then local billboard = Instance.new("BillboardGui", player.Character.Head) billboard.Size = UDim2.new(0, 100, 0, 40) billboard.StudsOffset = Vector3.new(0, 2, 0) billboard.AlwaysOnTop = true local textLabel = Instance.new("TextLabel", billboard) textLabel.Size = UDim2.new(1, 0, 1, 0) textLabel.BackgroundTransparency = 1 textLabel.TextColor3 = Color3.new(1, 1, 1) textLabel.TextScaled = true textLabel.Text = player.Name end end end)

-- ( Target UI ) local targetBox = Instance.new("TextBox", Frame) targetBox.PlaceholderText = "Player Name" targetBox.Size = UDim2.new(0, 180, 0, 30) targetBox.Position = UDim2.new(0, 10, 0, 170) targetBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) targetBox.TextColor3 = Color3.new(1, 1, 1)

local function getTarget() return Players:FindFirstChild(targetBox.Text) end

-- ( Teleport / View / Follow / Aimbot ) createButton("Teleport", UDim2.new(0, 210, 0, 170), function() local target = getTarget() if target and target.Character then LocalPlayer.Character:MoveTo(target.Character:FindFirstChild("HumanoidRootPart").Position) end end)

createButton("View", UDim2.new(0, 10, 0, 210), function() local target = getTarget() if target and target.Character then workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid") end end)

createButton("Follow", UDim2.new(0, 210, 0, 210), function(on) RunService.RenderStepped:Connect(function() if on then local target = getTarget() if target and target.Character then LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)) end end end) end)

createButton("Aimbot", UDim2.new(0, 10, 0, 250), function(on) RunService.RenderStepped:Connect(function() if on then local target = getTarget() if target and target.Character then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) end end end) end)

-- ( AntiKick ) hookmetamethod = hookmetamethod or hookfunction or nil if hookmetamethod then local mt = getrawmetatable(game) setreadonly(mt, false) local old = mt.__namecall mt.__namecall = newcclosure(function(self, ...) local args = {...} local method = getnamecallmethod() if method == "Kick" then return end return old(self, unpack(args)) end) end

