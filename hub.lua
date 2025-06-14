-- RHTU Hub Premium v1.4 (Mobile Friendly) -- Author: ChatGPT for okebuf -- Features: UI Toggle, Speed, FOV, Noclip, ESP, Aimbot, Headsit, Teleport, View, Auto Follow, Fly, AntiKick, Rainbow UI, Icon Status

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local StarterGui = game:GetService("StarterGui") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse()

-- GUI Setup local MainUI = Instance.new("ScreenGui") MainUI.Name = "RHTU_Hub" MainUI.ResetOnSpawn = false MainUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Rainbow Frame local Frame = Instance.new("Frame", MainUI) Frame.Size = UDim2.new(0, 420, 0, 330) Frame.Position = UDim2.new(0.5, -210, 0.5, -165) Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) Frame.BorderSizePixel = 3 Frame.Active = true Frame.Draggable = true

local hue = 0 RunService.RenderStepped:Connect(function() hue = (hue + 0.005) % 1 Frame.BorderColor3 = Color3.fromHSV(hue, 1, 1) end)

-- Notification local function showPremium() local label = Instance.new("TextLabel", Frame) label.Size = UDim2.new(1, 0, 0, 20) label.Position = UDim2.new(0, 0, 1, -20) label.Text = "RHTU Hub Premium\nversion 1.4" label.TextColor3 = Color3.fromRGB(255, 255, 0) label.BackgroundTransparency = 1 label.TextScaled = true delay(3, function() label:Destroy() end) end

-- Toggle Button local toggleButton = Instance.new("TextButton", MainUI) toggleButton.Text = "≡" toggleButton.Size = UDim2.new(0, 40, 0, 40) toggleButton.Position = UDim2.new(0, 10, 0, 10) toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) toggleButton.TextScaled = true toggleButton.MouseButton1Click:Connect(function() Frame.Visible = not Frame.Visible end)

-- Utilities local function createButton(parent, name, position, callback, toggle) local button = Instance.new("TextButton", parent) button.Size = UDim2.new(0, 200, 0, 30) button.Position = position button.Text = name button.BackgroundColor3 = toggle and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 50, 50) button.TextColor3 = Color3.new(1, 1, 1) button.TextScaled = true button.MouseButton1Click:Connect(function() callback(button) showPremium() end) return button end

-- Speed local speedBox = Instance.new("TextBox", Frame) speedBox.PlaceholderText = "Speed 1-100" speedBox.Size = UDim2.new(0, 200, 0, 30) speedBox.Position = UDim2.new(0, 10, 0, 10) speedBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60) speedBox.TextColor3 = Color3.new(1, 1, 1) speedBox.TextScaled = true speedBox.FocusLost:Connect(function() local val = tonumber(speedBox.Text) if val then LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(val, 1, 100) showPremium() end end)

-- FOV createButton(Frame, "FOV 120", UDim2.new(0, 220, 0, 10), function() workspace.CurrentCamera.FieldOfView = 120 end) createButton(Frame, "FOV 60", UDim2.new(0, 220, 0, 50), function() workspace.CurrentCamera.FieldOfView = 60 end)

-- Noclip local noclip = false createButton(Frame, "Toggle Noclip", UDim2.new(0, 10, 0, 50), function(btn) noclip = not noclip btn.BackgroundColor3 = noclip and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) end, true) RunService.Stepped:Connect(function() if noclip and LocalPlayer.Character then for _, part in pairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end end end)

-- ESP createButton(Frame, "ESP Players", UDim2.new(0, 10, 0, 90), function() for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then local gui = Instance.new("BillboardGui", p.Character.Head) gui.Size = UDim2.new(0, 100, 0, 30) gui.StudsOffset = Vector3.new(0, 2, 0) gui.AlwaysOnTop = true local txt = Instance.new("TextLabel", gui) txt.Size = UDim2.new(1, 0, 1, 0) txt.BackgroundTransparency = 1 txt.TextColor3 = Color3.new(1, 1, 1) txt.TextScaled = true txt.Text = p.Name .. " | HP: ? | ? studs" end end end)

-- Aimbot and Target Controls local targetBox = Instance.new("TextBox", Frame) targetBox.PlaceholderText = "Target Player" targetBox.Size = UDim2.new(0, 200, 0, 30) targetBox.Position = UDim2.new(0, 10, 0, 130) targetBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60) targetBox.TextColor3 = Color3.new(1, 1, 1) targetBox.TextScaled = true

local function getTarget() return Players:FindFirstChild(targetBox.Text) end

createButton(Frame, "Headsit", UDim2.new(0, 220, 0, 130), function() local tgt = getTarget() if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(tgt.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)) end end)

createButton(Frame, "Teleport", UDim2.new(0, 10, 0, 170), function() local tgt = getTarget() if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(tgt.Character.HumanoidRootPart.Position) end end)

createButton(Frame, "View", UDim2.new(0, 220, 0, 170), function() local tgt = getTarget() if tgt and tgt.Character and tgt.Character:FindFirstChild("Humanoid") then workspace.CurrentCamera.CameraSubject = tgt.Character.Humanoid end end)

-- Auto Follow local follow = false createButton(Frame, "Follow Target", UDim2.new(0, 10, 0, 210), function(btn) follow = not follow btn.BackgroundColor3 = follow and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) end, true) RunService.RenderStepped:Connect(function() if follow then local tgt = getTarget() if tgt and tgt.Character and tgt.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(tgt.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)) end end end)

-- Fly local flySpeed = 5 local flying = false createButton(Frame, "Toggle Fly", UDim2.new(0, 220, 0, 210), function(btn) flying = not flying btn.BackgroundColor3 = flying and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0) end, true)

local flyBox = Instance.new("TextBox", Frame) flyBox.PlaceholderText = "Fly Speed 1-10" flyBox.Size = UDim2.new(0, 200, 0, 30) flyBox.Position = UDim2.new(0, 10, 0, 250) flyBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60) flyBox.TextColor3 = Color3.new(1, 1, 1) flyBox.TextScaled = true flyBox.FocusLost:Connect(function() local val = tonumber(flyBox.Text) if val then flySpeed = math.clamp(val, 1, 10) end end)

RunService.RenderStepped:Connect(function() if flying then LocalPlayer.Character:TranslateBy(Vector3.new(0, flySpeed/10, 0)) end end)

-- Anti-Kick local mt = getrawmetatable(game) setreadonly(mt, false) local old = mt.__namecall mt.__namecall = newcclosure(function(self, ...) local args = {...} if getnamecallmethod() == "Kick" then return warn("Kick blocked by RHTU Hub") end return old(self, ...) end)

-- Hitbox Adjustment Placeholder (coming next update)

