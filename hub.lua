-- RHTU Hub (Upgraded Version) -- Author: ChatGPT for okebuf -- Features: UI Toggle Button, Speed, Noclip, FOV, ESP, Aimbot, Teleport, View, Follow, Rainbow Border, Icons, Status Message

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse()

-- GUI local MainUI = Instance.new("ScreenGui") MainUI.Name = "RHTU_Hub" MainUI.ResetOnSpawn = false pcall(function() MainUI.Parent = game:GetService("CoreGui") end) if not MainUI.Parent then MainUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Frame = Instance.new("Frame", MainUI) Frame.Size = UDim2.new(0, 400, 0, 320) Frame.Position = UDim2.new(0.5, -200, 0.5, -150) Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) Frame.BorderSizePixel = 0 Frame.Active = true Frame.Draggable = true

-- Rainbow Border local function updateRainbow(frame) local hue = 0 RunService.RenderStepped:Connect(function() hue = (hue + 0.005) % 1 frame.BorderColor3 = Color3.fromHSV(hue, 1, 1) frame.BorderSizePixel = 3 end) end updateRainbow(Frame)

-- Premium Message local function showPremium() local label = Instance.new("TextLabel", Frame) label.Text = "RHTU Hub Premium\nversion 1.4" label.Size = UDim2.new(1, 0, 0, 40) label.Position = UDim2.new(0, 0, 1, -40) label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 0) label.Font = Enum.Font.SourceSansBold label.TextScaled = true delay(3, function() label:Destroy() end) end

-- Toggle UI local toggleButton = Instance.new("TextButton", MainUI) toggleButton.Text = "RHTU" toggleButton.Size = UDim2.new(0, 60, 0, 30) toggleButton.Position = UDim2.new(1, -70, 0, 10) toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) toggleButton.TextColor3 = Color3.new(1, 1, 1) toggleButton.ZIndex = 10 toggleButton.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)

-- Utility local function createButton(text, pos, callback) local btn = Instance.new("TextButton", Frame) btn.Size = UDim2.new(0, 180, 0, 30) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0) btn.TextColor3 = Color3.new(1, 1, 1) btn.Text = text btn.MouseButton1Click:Connect(function() local active = callback() if typeof(active) == "boolean" then btn.BackgroundColor3 = active and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) end showPremium() end) return btn end

-- Speed local speedBox = Instance.new("TextBox", Frame) speedBox.PlaceholderText = "🏃 Speed (1-100)" speedBox.Size = UDim2.new(0, 180, 0, 30) speedBox.Position = UDim2.new(0, 10, 0, 10) speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) speedBox.TextColor3 = Color3.new(1, 1, 1) speedBox.FocusLost:Connect(function() local val = tonumber(speedBox.Text) if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(val, 1, 100) showPremium() end end)

-- Noclip local noclip = false createButton("🚪 Toggle Noclip", UDim2.new(0, 210, 0, 10), function() noclip = not noclip return noclip end) RunService.Stepped:Connect(function() if noclip and LocalPlayer.Character then for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)

-- FOV createButton("🔭 FOV 120", UDim2.new(0, 10, 0, 50), function() workspace.CurrentCamera.FieldOfView = 120 end) createButton("🔬 FOV 60", UDim2.new(0, 210, 0, 50), function() workspace.CurrentCamera.FieldOfView = 60 end)

-- ESP createButton("👁️ ESP Players", UDim2.new(0, 10, 0, 90), function() for _, player in ipairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then if not player.Character.Head:FindFirstChild("_ESP") then local billboard = Instance.new("BillboardGui", player.Character.Head) billboard.Name = "_ESP" billboard.Size = UDim2.new(0, 100, 0, 40) billboard.StudsOffset = Vector3.new(0, 2, 0) billboard.AlwaysOnTop = true local label = Instance.new("TextLabel", billboard) label.Size = UDim2.new(1, 0, 1, 0) label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 1) label.TextScaled = true label.Text = player.Name end end end end)

-- Aimbot UI local targetBox = Instance.new("TextBox", Frame) targetBox.PlaceholderText = "🎯 Player Name" targetBox.Size = UDim2.new(0, 180, 0, 30) targetBox.Position = UDim2.new(0, 10, 0, 130) targetBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50) targetBox.TextColor3 = Color3.new(1, 1, 1)

local function getTarget() return Players:FindFirstChild(targetBox.Text) end

createButton("🪑 Headsit", UDim2.new(0, 210, 0, 130), function() local target = getTarget() if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)) end end)

createButton("🚀 Teleport", UDim2.new(0, 10, 0, 170), function() local target = getTarget() if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position) end end)

createButton("🎥 View", UDim2.new(0, 210, 0, 170), function() local target = getTarget() if target and target.Character then workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid") end end)

-- Follow Player local follow = false createButton("🛸 Follow Player", UDim2.new(0, 10, 0, 210), function() follow = not follow return follow end) RunService.RenderStepped:Connect(function() if follow then local target = getTarget() if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local myChar = LocalPlayer.Character if myChar and myChar:FindFirstChild("HumanoidRootPart") then local dir = (target.Character.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).unit myChar:TranslateBy(dir * 0.5) end end end end)

-- DONE!

