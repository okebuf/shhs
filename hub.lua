-- RHTU Hub (Full Version for Delta Mobile) -- Author: ChatGPT for okebuf

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local StarterGui = game:GetService("StarterGui")

-- UI Setup local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "RHTU_Hub" ScreenGui.ResetOnSpawn = false ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function createTab(name, position) local tab = Instance.new("Frame") tab.Size = UDim2.new(0, 400, 0, 300) tab.Position = position or UDim2.new(0.5, -200, 0.5, -150) tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30) tab.BorderSizePixel = 2 tab.Visible = false tab.Active = true tab.Draggable = true tab.Parent = ScreenGui return tab end

local function rainbowBorder(frame) local hue = 0 RunService.RenderStepped:Connect(function() hue = (hue + 0.005) % 1 frame.BorderColor3 = Color3.fromHSV(hue, 1, 1) end) end

local MainTab = createTab("Main") local VisualTab = createTab("Visual") local CombatTab = createTab("Combat") rainbowBorder(MainTab) rainbowBorder(VisualTab) rainbowBorder(CombatTab)

-- Tab Buttons local tabButtonsFrame = Instance.new("Frame") tabButtonsFrame.Size = UDim2.new(0, 400, 0, 30) tabButtonsFrame.Position = UDim2.new(0.5, -200, 0.5, -180) tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) tabButtonsFrame.BorderSizePixel = 0 tabButtonsFrame.Parent = ScreenGui

local function createTabButton(text, icon, tabToShow, posX) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 130, 0, 30) btn.Position = UDim2.new(0, posX, 0, 0) btn.Text = icon .. " " .. text btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Parent = tabButtonsFrame btn.MouseButton1Click:Connect(function() MainTab.Visible = false VisualTab.Visible = false CombatTab.Visible = false tabToShow.Visible = true end) end

createTabButton("Main", "⚙️", MainTab, 10) createTabButton("Visual", "👁️", VisualTab, 140) createTabButton("Combat", "🎯", CombatTab, 270)

-- Toggle Button local toggleBtn = Instance.new("TextButton") toggleBtn.Text = "🌈" toggleBtn.Size = UDim2.new(0, 40, 0, 40) toggleBtn.Position = UDim2.new(1, -50, 1, -50) toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) toggleBtn.TextColor3 = Color3.new(1, 1, 1) toggleBtn.Parent = ScreenGui

local uiVisible = true toggleBtn.MouseButton1Click:Connect(function() uiVisible = not uiVisible tabButtonsFrame.Visible = uiVisible MainTab.Visible = uiVisible VisualTab.Visible = false CombatTab.Visible = false end)

-- Functions local function createTextBox(parent, placeholder, pos, size, callback) local box = Instance.new("TextBox") box.PlaceholderText = placeholder box.Size = size box.Position = pos box.BackgroundColor3 = Color3.fromRGB(40, 40, 40) box.TextColor3 = Color3.new(1, 1, 1) box.Parent = parent box.FocusLost:Connect(function() callback(box.Text) end) return box end

local function createButton(parent, text, pos, callback) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 120, 0, 30) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) btn.TextColor3 = Color3.new(1, 1, 1) btn.Text = text btn.Parent = parent btn.MouseButton1Click:Connect(callback) end

-- MainTab Content createTextBox(MainTab, "WalkSpeed (1-100)", UDim2.new(0,10,0,10), UDim2.new(0,180,0,30), function(txt) local val = tonumber(txt) if val then LocalPlayer.Character.Humanoid.WalkSpeed = math.clamp(val, 1, 100) end end)

local flying = false local flyspeed = 5 createTextBox(MainTab, "Fly Speed (1-10)", UDim2.new(0,210,0,10), UDim2.new(0,180,0,30), function(txt) flyspeed = math.clamp(tonumber(txt) or 5, 1, 10) end)

createButton(MainTab, "🛸 Fly", UDim2.new(0,10,0,50), function() flying = not flying end)

RunService.RenderStepped:Connect(function() if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:Move(Vector3.new(0, flyspeed, 0)) end end)

createButton(MainTab, "🚫 Noclip", UDim2.new(0,140,0,50), function() for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end)

-- VisualTab Content createButton(VisualTab, "👁️ ESP", UDim2.new(0,10,0,10), function() for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then local bb = Instance.new("BillboardGui", p.Character.Head) bb.Size = UDim2.new(0,100,0,40) bb.AlwaysOnTop = true local txt = Instance.new("TextLabel", bb) txt.Size = UDim2.new(1,0,1,0) txt.BackgroundTransparency = 1 txt.TextColor3 = Color3.new(1,1,1) txt.TextScaled = true txt.Text = p.Name end end end)

createButton(VisualTab, "FOV 120", UDim2.new(0,10,0,50), function() workspace.CurrentCamera.FieldOfView = 120 end) createButton(VisualTab, "FOV 60", UDim2.new(0,140,0,50), function() workspace.CurrentCamera.FieldOfView = 60 end)

-- CombatTab Content local targetName = "" createTextBox(CombatTab, "Target Player", UDim2.new(0,10,0,10), UDim2.new(0,180,0,30), function(txt) targetName = txt end)

createButton(CombatTab, "🎯 Aimbot", UDim2.new(0,210,0,10), function() RunService.RenderStepped:Connect(function() local target = Players:FindFirstChild(targetName) if target and target.Character and target.Character:FindFirstChild("Head") then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) end end) end)

createButton(CombatTab, "🛸 Follow", UDim2.new(0,10,0,50), function() RunService.RenderStepped:Connect(function() local target = Players:FindFirstChild(targetName) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position) end end) end)

createTextBox(CombatTab, "Hitbox Size (1-100)", UDim2.new(0,10,0,90), UDim2.new(0,180,0,30), function(txt) local val = tonumber(txt) if val then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then for _, v in pairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.Size = Vector3.new(val, val, val) end end end end end end)

-- AntiKick hookfunction(Instance.new("RemoteEvent").FireServer, function(...) return nil end)

