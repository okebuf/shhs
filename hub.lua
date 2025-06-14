-- RHTU Hub (Full Version for Delta Mobile)
-- Author: ChatGPT for okebuf

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RHTU_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create Tabs
local function createTab()
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 400, 0, 300)
    f.Position = UDim2.new(0.5, -200, 0.5, -150)
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    f.BorderSizePixel = 2
    f.Visible = false
    f.Active = true
    f.Draggable = true
    f.Parent = ScreenGui
    return f
end

local MainTab = createTab()
local VisualTab = createTab()
local CombatTab = createTab()

-- Rainbow border update
local function addRainbow(f)
    local hue = 0
    RunService.RenderStepped:Connect(function()
        hue = (hue+0.005)%1
        f.BorderColor3 = Color3.fromHSV(hue,1,1)
    end)
end
addRainbow(MainTab); addRainbow(VisualTab); addRainbow(CombatTab)

-- Tab buttons
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 400, 0, 30)
tabFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
tabFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
tabFrame.Parent = ScreenGui

local function tabButton(txt, icon, tab, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,130,0,30)
    b.Position = UDim2.new(0, x, 0, 0)
    b.Text = icon.." "..txt
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = tabFrame
    b.MouseButton1Click:Connect(function()
        MainTab.Visible = false
        VisualTab.Visible = false
        CombatTab.Visible = false
        tab.Visible = true
    end)
end

tabButton("Main","⚙️",MainTab,10)
tabButton("Visual","👁️",VisualTab,140)
tabButton("Combat","🎯",CombatTab,270)

-- Toggle GUI
local tog = Instance.new("TextButton")
tog.Text = "🌈"
tog.Size = UDim2.new(0,40,0,40)
tog.Position = UDim2.new(1,-50,1,-50)
tog.BackgroundColor3 = Color3.fromRGB(0,0,0)
tog.TextColor3 = Color3.new(1,1,1)
tog.Parent = ScreenGui

local show = true
tog.MouseButton1Click:Connect(function()
    show = not show
    tabFrame.Visible = show
    MainTab.Visible = show
    -- optionally hide others
    if not show then VisualTab.Visible = false; CombatTab.Visible = false end
end)

-- Helper UI functions
local function addTextBox(parent, place, pos, callback)
    local tb = Instance.new("TextBox")
    tb.PlaceholderText=place
    tb.Size=UDim2.new(0,180,0,30)
    tb.Position=pos
    tb.BackgroundColor3=Color3.fromRGB(40,40,40)
    tb.TextColor3=Color3.new(1,1,1)
    tb.Parent=parent
    tb.FocusLost:Connect(function()
        callback(tonumber(tb.Text))
    end)
    return tb
end

local function addButton(parent, icon, pos, cb)
    local b = Instance.new("TextButton")
    b.Size=UDim2.new(0,120,0,30)
    b.Position=pos
    b.BackgroundColor3=Color3.fromRGB(60,60,60)
    b.TextColor3=Color3.new(1,1,1)
    b.Text = icon
    b.Parent = parent
    b.MouseButton1Click:Connect(cb)
end

-- Main tab
addTextBox(MainTab,"WalkSpeed 1-100",UDim2.new(0,10,0,10),function(v)
    if v then LocalPlayer.Character.Humanoid.WalkSpeed=math.clamp(v,1,100) end
end)
local fly = false; local flyspd=5
addTextBox(MainTab,"Fly Speed 1-10",UDim2.new(0,210,0,10),function(v)
    flyspd=math.clamp(v or 5,1,10)
end)
addButton(MainTab,"🛸 Fly",UDim2.new(0,10,0,50),function() fly = not fly end)
RunService.RenderStepped:Connect(function()
    if fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:Move(Vector3.new(0, flyspd, 0))
    end
end)
addButton(MainTab,"🚫 Noclip",UDim2.new(0,140,0,50),function()
    for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide=false end
    end
end)

-- Visual tab
addButton(VisualTab,"👁️ ESP",UDim2.new(0,10,0,10),function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local bb = Instance.new("BillboardGui",p.Character.Head)
            bb.Size=UDim2.new(0,100,0,40)
            bb.AlwaysOnTop=true
            local tl=Instance.new("TextLabel",bb)
            tl.Size=UDim2.new(1,0,1,0)
            tl.BackgroundTransparency=1
            tl.TextColor3=Color3.new(1,1,1)
            tl.TextScaled=true
            tl.Text=p.Name
        end
    end
end)
addButton(VisualTab,"FOV 120",UDim2.new(0,10,0,50),function()
    workspace.CurrentCamera.FieldOfView=120
end)
addButton(VisualTab,"FOV 60",UDim2.new(0,140,0,50),function()
    workspace.CurrentCamera.FieldOfView=60
end)

-- Combat tab
local target=""
addTextBox(CombatTab,"Target",UDim2.new(0,10,0,10),function(v) target=Users end)
addButton(CombatTab,"🎯 Aimbot",UDim2.new(0,210,0,10),function()
    RunService.RenderStepped:Connect(function()
        local t=Players:FindFirstChild(target)
        if t and t.Character and t.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame=CFrame.new(workspace.CurrentCamera.CFrame.Position, t.Character.Head.Position)
        end
    end)
end)
addButton(CombatTab,"🛸 Follow",UDim2.new(0,10,0,50),function()
    RunService.RenderStepped:Connect(function()
        local t=Players:FindFirstChild(target)
        if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character:MoveTo( t.Character.HumanoidRootPart.Position )
        end
    end)
end)
addTextBox(CombatTab,"Hitbox 1-100",UDim2.new(0,10,0,90),function(v)
    if v then
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LocalPlayer and p.Character then
                for _,c in pairs(p.Character:GetDescendants()) do
                    if c:IsA("BasePart") then
                        c.Size=Vector3.new(v,v,v)
                    end
                end
            end
        end
    end
end)

-- AntiKick hook
local old = game.GetService(game, "Players")
-- no hook but placeholder (real hook requires exploit context)
