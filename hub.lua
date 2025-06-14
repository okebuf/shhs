-- 🌈 RHTU Hub Premium - Mobile Friendly, Tab Buttons One Row

local player = game.Players.LocalPlayer local char = player.Character or player.CharacterAdded:Wait()

-- GUI Setup local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui")) gui.Name = "RHTU_HubPremium" gui.ResetOnSpawn = false

-- Toggle Button local toggle = Instance.new("TextButton", gui) toggle.Size = UDim2.new(0, 50, 0, 30) toggle.Position = UDim2.new(1, -60, 1, -60) toggle.Text = "👁️" toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0) toggle.TextColor3 = Color3.new(1, 1, 1) Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

-- Main Frame local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 350, 0, 300) frame.Position = UDim2.new(0.5, -175, 0.5, -150) frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) frame.Visible = true frame.Active = true frame.Draggable = true Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Rainbow Title local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, 0, 0, 25) title.BackgroundTransparency = 1 title.Text = "🌈 RHTU Hub Premium v1.4" title.Font = Enum.Font.GothamBold title.TextSize = 16 title.TextColor3 = Color3.new(1, 0, 0)

-- Rainbow Effect spawn(function() while true do for i = 0, 1, 0.01 do title.TextColor3 = Color3.fromHSV(i, 1, 1) task.wait(0.03) end end end)

-- Tab Buttons in One Horizontal Row local tabNames = {"Combat", "Tính năng", "Player"} local tabs = {} local contents = {}

for i, name in ipairs(tabNames) do local btn = Instance.new("TextButton") btn.Name = name btn.Size = UDim2.new(0, 100, 0, 25) btn.Position = UDim2.new(0, 10 + (i - 1) * 110, 0, 30) btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Text = name btn.Parent = frame Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) tabs[name] = btn

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 1, -70)
tabFrame.Position = UDim2.new(0, 10, 0, 60)
tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 6)
tabFrame.Visible = (i == 1)
tabFrame.Parent = frame
contents[name] = tabFrame

btn.MouseButton1Click:Connect(function()
	for _, c in pairs(contents) do c.Visible = false end
	contents[name].Visible = true
end)

end

-- Create Buttons in Tabs local function createButton(tab, text, posY, callback) local b = Instance.new("TextButton") b.Size = UDim2.new(0, 300, 0, 30) b.Position = UDim2.new(0, 10, 0, posY) b.Text = text b.BackgroundColor3 = Color3.fromRGB(70, 70, 70) b.TextColor3 = Color3.new(1, 1, 1) Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6) b.Parent = tab b.MouseButton1Click:Connect(callback) end

-- Combat tab buttons createButton(contents["Combat"], "Aimbot (Player gần nhất)", 10, function() -- Aimbot code end) createButton(contents["Combat"], "ESP Toggle", 50, function() -- ESP code end)

-- Tính năng tab buttons createButton(contents["Tính năng"], "AntiStun", 10, function() local s = char:FindFirstChild("Stunned") if s then s:Destroy() end end) createButton(contents["Tính năng"], "AntiVoid", 50, function() local root = char:WaitForChild("HumanoidRootPart") root:GetPropertyChangedSignal("Position"):Connect(function() if root.Position.Y < -20 then root.CFrame = CFrame.new(0, 50, 0) end end) end) createButton(contents["Tính năng"], "AntiSit", 90, function() char.Humanoid.Sit = false char.Humanoid:GetPropertyChangedSignal("Sit"):Connect(function() char.Humanoid.Sit = false end) end) createButton(contents["Tính năng"], "Tăng độ nhảy 1 lần", 130, function() local h = char:FindFirstChild("Humanoid") if h then local original = h.JumpPower h.JumpPower = 150 h:ChangeState(Enum.HumanoidStateType.Jumping) task.delay(1, function() h.JumpPower = original end) end end) createButton(contents["Tính năng"], "NoFog", 170, function() for _, v in pairs(game.Lighting:GetDescendants()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") then v:Destroy() end end end)

-- Player tab placeholder createButton(contents["Player"], "Chức năng cũ ở đây", 10, function() -- Placeholder end)

-- Toggle GUI visibility toggle.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

title.Parent = frame

