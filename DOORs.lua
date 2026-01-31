--====================================================
-- 🌊 CIPIK HUB | OCEAN BLUE EDITION 2026 🌊
-- STATUS: PREMIUM SKELETON FIXED 🔒
-- FIXED: SKELETON COMPATIBILITY FOR ALL AVATARS
--====================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Cleanup UI Lama
pcall(function() 
    if LP.PlayerGui:FindFirstChild("CipsHubGui") then LP.PlayerGui.CipsHubGui:Destroy() end
    if Lighting:FindFirstChild("CipsBlur") then Lighting.CipsBlur:Destroy() end
end)

local Gui = Instance.new("ScreenGui", LP.PlayerGui)
Gui.Name = "CipsHubGui"
Gui.IgnoreGuiInset = true
Gui.ResetOnSpawn = false 

local Blur = Instance.new("BlurEffect", Lighting)
Blur.Name = "CipsBlur"
Blur.Size = 0
Blur.Enabled = true

-- THEME: OCEAN BLUE GLASS
local Theme = {
    Main = Color3.fromRGB(5, 15, 25),
    Sidebar = Color3.fromRGB(10, 25, 40),
    Accent = Color3.fromRGB(0, 200, 255),
    Text = Color3.fromRGB(230, 250, 255),
    SubText = Color3.fromRGB(140, 180, 200),
    InputBG = Color3.fromRGB(20, 40, 60),
    GlassTrans = 0.25
}

-- Global Variables
local SpeedOn, JumpOn, NoClip, InfJump = false, false, false, false
local SpeedVal, JumpVal = 16, 50
local SelectedTarget = nil
local TPFollow, BodyLock = false, false
local FollowDistance = 4
local AimlockOn = false
local ESP_Master, ESP_Name_On, ESP_Skeleton_On, ESP_Health_On, ESP_Dist_On, ESP_Team_Check = false, false, false, false, false, true

local function Round(obj, rad)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, rad)
end

-- DRAGGABLE ENGINE (100% PROTECTED)
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function CreateSeaEmber(parent)
    local ember = Instance.new("Frame", parent)
    ember.Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4))
    ember.BackgroundColor3 = Color3.fromRGB(150, 240, 255)
    ember.Position = UDim2.new(math.random(), 0, 1.1, 0)
    ember.BorderSizePixel = 0
    Round(ember, 10)
    local glow = Instance.new("ImageLabel", ember)
    glow.Size = UDim2.fromScale(6, 6); glow.Position = UDim2.fromScale(-2.5, -2.5); glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://6034289557"; glow.ImageColor3 = Theme.Accent; glow.ImageTransparency = 0.6
    local speed = math.random(5, 9)
    task.spawn(function()
        local t = 0
        while ember and ember.Parent and t < speed do
            t = t + RunService.RenderStepped:Wait()
            local p = t / speed
            ember.Position = UDim2.new(ember.Position.X.Scale + (math.sin(t) * 0.0006), 0, 1.1 - p * 1.3, 0)
            ember.BackgroundColor3 = Color3.fromRGB(150 - (p * 50), 240 - (p * 40), 255)
            ember.BackgroundTransparency = p
            glow.ImageTransparency = 0.6 + (p * 0.4)
        end
        ember:Destroy()
    end)
end

--====================================================
-- 🔘 MINI LOGO "CIPIK"
--====================================================
local MiniLogo = Instance.new("Frame", Gui)
MiniLogo.Name = "CipikOceanMini"
MiniLogo.Size = UDim2.fromOffset(60, 60); MiniLogo.Position = UDim2.new(0.02, 0, 0.4, 0)
MiniLogo.BackgroundColor3 = Theme.Main; MiniLogo.BackgroundTransparency = 0.3; MiniLogo.ClipsDescendants = true; Round(MiniLogo, 100)
MiniLogo.Visible = false 

local MiniStroke = Instance.new("UIStroke", MiniLogo); MiniStroke.Thickness = 2.5; MiniStroke.Color = Theme.Accent
local MiniSeaContainer = Instance.new("Frame", MiniLogo); MiniSeaContainer.Size = UDim2.fromScale(1, 1); MiniSeaContainer.BackgroundTransparency = 1
local IconText = Instance.new("TextLabel", MiniLogo)
IconText.Size = UDim2.fromScale(1, 1); IconText.Text = "CIPIK"; IconText.Font = Enum.Font.GothamBold; IconText.TextColor3 = Color3.new(1, 1, 1); IconText.TextSize = 10; IconText.BackgroundTransparency = 1; IconText.ZIndex = 5

local ClickBtn = Instance.new("TextButton", MiniLogo); ClickBtn.Size = UDim2.fromScale(1, 1); ClickBtn.BackgroundTransparency = 1; ClickBtn.Text = ""; ClickBtn.ZIndex = 10

--========================
-- MAIN INTERFACE
--========================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(540, 360)
Main.Position = UDim2.new(0.5, -270, 0.5, -180)
Main.BackgroundColor3 = Theme.Main
Main.BackgroundTransparency = Theme.GlassTrans
Main.Visible = true; Main.ClipsDescendants = true; Round(Main, 12)

local MainSeaContainer = Instance.new("Frame", Main)
MainSeaContainer.Size = UDim2.fromScale(1, 1); MainSeaContainer.BackgroundTransparency = 1

--====================================================
-- 🛠️ TOP BAR SYSTEM (X & -)
--====================================================
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 10

local TopBtnHolder = Instance.new("Frame", TopBar)
TopBtnHolder.Size = UDim2.new(0, 80, 1, 0)
TopBtnHolder.Position = UDim2.new(1, -85, 0, 0)
TopBtnHolder.BackgroundTransparency = 1

local TopList = Instance.new("UIListLayout", TopBtnHolder)
TopList.FillDirection = Enum.FillDirection.Horizontal
TopList.HorizontalAlignment = Enum.HorizontalAlignment.Right
TopList.VerticalAlignment = Enum.VerticalAlignment.Center
TopList.Padding = UDim.new(0, 12)

local function CreateTopBtn(symbol, color, action)
    local b = Instance.new("TextButton", TopBtnHolder)
    b.Size = UDim2.fromOffset(24, 24)
    b.BackgroundTransparency = 1
    b.Text = symbol
    b.Font = Enum.Font.GothamMedium
    b.TextColor3 = color or Theme.Text
    b.TextSize = 18
    b.MouseButton1Click:Connect(action)
    return b
end

local MiniBtn = CreateTopBtn("-", Theme.Accent, function() 
    Main.Visible = false 
    MiniLogo.Visible = true 
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
end)

local CloseBtn = CreateTopBtn("✕", Color3.fromRGB(255, 80, 80), function() 
    Gui:Destroy()
    if Blur then Blur:Destroy() end
end)

--========================
-- SIDEBAR & TABS
--========================
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.BackgroundTransparency = 0.1; Round(Sidebar, 12)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2; MainStroke.Color = Theme.Accent; MainStroke.Transparency = 0.5

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "CIPIK HUB 🌊"; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = Theme.Accent; Title.TextSize = 18; Title.BackgroundTransparency = 1

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -165, 1, -45); Container.Position = UDim2.fromOffset(160, 35); Container.BackgroundTransparency = 1

local TabHolder = Instance.new("ScrollingFrame", Sidebar)
TabHolder.Size = UDim2.new(1, -15, 1, -60); TabHolder.Position = UDim2.fromOffset(7, 55); TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local Pages = {}
local function NewTab(name, icon)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundTransparency = 1; btn.Text = "  " .. icon .. "  " .. name
    btn.Font = Enum.Font.GothamMedium; btn.TextColor3 = Theme.SubText; btn.TextSize = 12; btn.TextXAlignment = "Left"; Round(btn, 6)
    local page = Instance.new("ScrollingFrame", Container)
    page.Size = UDim2.fromScale(1, 1); page.BackgroundTransparency = 1; page.Visible = false; page.ScrollBarThickness = 0
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 6)
    Pages[name] = {btn = btn, page = page}
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.page.Visible = false; TweenService:Create(v.btn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Theme.SubText}):Play() end
        page.Visible = true; TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.1, TextColor3 = Theme.Accent}):Play()
    end)
    return page
end

-- UI HELPERS
local function AddToggle(parent, text, default, callback)
    local tgl = Instance.new("TextButton", parent); tgl.Size = UDim2.new(0.98, 0, 0, 40); tgl.BackgroundColor3 = Theme.InputBG; tgl.BackgroundTransparency = 0.4; tgl.Text = ""; Round(tgl, 8)
    local l = Instance.new("TextLabel", tgl); l.Size = UDim2.new(1, -50, 1, 0); l.Position = UDim2.fromOffset(12, 0); l.Text = text; l.Font = Enum.Font.Gotham; l.TextColor3 = Theme.Text; l.TextSize = 12; l.TextXAlignment = "Left"; l.BackgroundTransparency = 1
    local sw = Instance.new("Frame", tgl); sw.Size = UDim2.fromOffset(30, 16); sw.Position = UDim2.new(1, -42, 0.5, -8); sw.BackgroundColor3 = Color3.fromRGB(10, 30, 50); Round(sw, 8)
    local dot = Instance.new("Frame", sw); dot.Size = UDim2.fromOffset(12, 12); dot.Position = UDim2.fromOffset(2, 2); dot.BackgroundColor3 = Color3.new(1, 1, 1); Round(dot, 6)
    local active = default
    local function update()
        callback(active)
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(10, 30, 50)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = active and UDim2.fromOffset(16, 2) or UDim2.fromOffset(2, 2)}):Play()
    end
    tgl.MouseButton1Click:Connect(function() active = not active; update() end); update()
end

local function AddInput(parent, text, default, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.98, 0, 0, 45); frame.BackgroundColor3 = Theme.InputBG; frame.BackgroundTransparency = 0.4; Round(frame, 8)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.fromOffset(12, 0); label.Text = text; label.Font = Enum.Font.Gotham; label.TextColor3 = Theme.Text; label.TextSize = 12; label.TextXAlignment = "Left"; label.BackgroundTransparency = 1
    local ibox = Instance.new("TextBox", frame); ibox.Size = UDim2.new(0, 65, 0, 28); ibox.Position = UDim2.new(1, -75, 0.5, -14); ibox.BackgroundColor3 = Color3.fromRGB(5, 15, 25); ibox.Text = tostring(default); ibox.TextColor3 = Theme.Accent; ibox.Font = Enum.Font.GothamBold; ibox.TextSize = 12; Round(ibox, 6)
    ibox.FocusLost:Connect(function() local val = tonumber(ibox.Text) if val then callback(val) else ibox.Text = "ERR" end end)
end

local function AddButton(parent, text, callback)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.98, 0, 0, 35); b.BackgroundColor3 = Theme.Accent; b.BackgroundTransparency = 0.85; b.Text = text; b.Font = Enum.Font.GothamMedium; b.TextColor3 = Theme.Text; b.TextSize = 12; Round(b, 8)
    b.MouseButton1Click:Connect(function() callback(b) end); return b
end

-- TABS SETUP
local Tab1 = NewTab("Player", "👤")
local Tab2 = NewTab("Combat", "🔫")
local Tab3 = NewTab("Follow", "🎯")
local Tab4 = NewTab("Visuals", "👁️")
local Tab5 = NewTab("Utility", "⚙️")

AddToggle(Tab1, "Ocean WalkSpeed Master", false, function(v) SpeedOn = v end)
AddInput(Tab1, "Set WalkSpeed Value", 16, function(v) SpeedVal = v end)
AddToggle(Tab1, "Ocean JumpPower Master", false, function(v) JumpOn = v end)
AddInput(Tab1, "Set JumpPower Value", 50, function(v) JumpVal = v end)
AddToggle(Tab1, "NoClip (Pass Walls)", false, function(v) NoClip = v end)
AddToggle(Tab1, "Infinite Jump", false, function(v) InfJump = v end)
AddToggle(Tab2, "Aimlock (Visibility Check)", false, function(v) AimlockOn = v end)
AddButton(Tab3, "Select Target Player", function()
    local d = Instance.new("ScrollingFrame", Tab3); d.Size = UDim2.new(0.98,0,0,100); d.BackgroundColor3 = Color3.new(0,0,0); d.BackgroundTransparency = 0.5; Round(d, 8); Instance.new("UIListLayout", d)
    for _,p in pairs(Players:GetPlayers()) do if p ~= LP then AddButton(d, p.Name, function() SelectedTarget = p; d:Destroy() end).Size = UDim2.new(1,0,0,30) end end
end)
AddToggle(Tab3, "Teleport Follow", false, function(v) TPFollow = v end)
AddToggle(Tab3, "Smooth Body Lock", false, function(v) BodyLock = v end)
AddToggle(Tab4, "Master ESP Switch", false, function(v) ESP_Master = v end)
AddToggle(Tab4, "ESP Player Name", false, function(v) ESP_Name_On = v end)
AddToggle(Tab4, "ESP Premium Skeleton", false, function(v) ESP_Skeleton_On = v end)
AddToggle(Tab4, "ESP Health Bar", false, function(v) ESP_Health_On = v end)
AddToggle(Tab4, "ESP Distance Meter", false, function(v) ESP_Dist_On = v end)
AddToggle(Tab4, "Team Check", true, function(v) ESP_Team_Check = v end)
AddButton(Tab5, "AFEM MAX (ALPHA)", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))() end)
AddButton(Tab5, "PSHADE ULTIMATE", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-pshade-ultimate-25505"))() end)

-- HELPER: CHECK VISIBILITY
local function IsVisible(targetPart)
    local rayParam = RaycastParams.new()
    rayParam.FilterType = Enum.RaycastFilterType.Exclude
    rayParam.FilterDescendantsInstances = {LP.Character, Camera}
    local rayResult = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000, rayParam)
    if rayResult and rayResult.Instance:IsDescendantOf(targetPart.Parent) then return true end
    return false
end

--====================================================
-- 🦴 FIXED PREMIUM SKELETON ENGINE (R15 & R6)
--====================================================
local function CreateESP(plr)
    local NameTag = Drawing.new("Text"); NameTag.Visible = false; NameTag.Center = true; NameTag.Outline = true; NameTag.Size = 13; NameTag.Color = Theme.Accent
    local DistTag = Drawing.new("Text"); DistTag.Visible = false; DistTag.Center = true; DistTag.Outline = true; DistTag.Size = 11; DistTag.Color = Color3.new(1,1,1)
    local HealthBar = Drawing.new("Line"); HealthBar.Thickness = 2; HealthBar.Visible = false
    
    local Bones = {}
    local skeletonParts = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
        -- R6 Fallback Connections
        {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
    }

    for i=1, #skeletonParts do
        Bones[i] = Drawing.new("Line"); Bones[i].Thickness = 1.5; Bones[i].Color = Theme.Accent; Bones[i].Visible = false; Bones[i].Transparency = 1
    end

    RunService.RenderStepped:Connect(function()
        local char = plr.Character
        if ESP_Master and char and char:FindFirstChild("HumanoidRootPart") and plr ~= LP and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            if ESP_Team_Check and plr.Team == LP.Team then
                NameTag.Visible = false; DistTag.Visible = false; HealthBar.Visible = false
                for _,b in pairs(Bones) do b.Visible = false end return
            end

            local hrp = char.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                if ESP_Name_On then NameTag.Visible = true; NameTag.Text = plr.Name; NameTag.Position = Vector2.new(pos.X, pos.Y - 50) else NameTag.Visible = false end
                if ESP_Dist_On then 
                    local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    DistTag.Visible = true; DistTag.Text = "["..dist.."m]"; DistTag.Position = Vector2.new(pos.X, pos.Y + 30) 
                else DistTag.Visible = false end
                
                if ESP_Health_On then
                    HealthBar.Visible = true; local hp = char.Humanoid.Health / char.Humanoid.MaxHealth
                    HealthBar.Color = Color3.fromHSV(hp * 0.3, 1, 1)
                    HealthBar.From = Vector2.new(pos.X - 25, pos.Y + 25); HealthBar.To = Vector2.new(pos.X - 25 + (50 * hp), pos.Y + 25)
                else HealthBar.Visible = false end

                -- SKELETON LOGIC
                if ESP_Skeleton_On then
                    for i, pair in pairs(skeletonParts) do
                        local p1, p2 = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
                        if p1 and p2 then
                            local v1, os1 = Camera:WorldToViewportPoint(p1.Position)
                            local v2, os2 = Camera:WorldToViewportPoint(p2.Position)
                            if os1 and os2 then
                                Bones[i].Visible = true
                                Bones[i].From = Vector2.new(v1.X, v1.Y)
                                Bones[i].To = Vector2.new(v2.X, v2.Y)
                            else Bones[i].Visible = false end
                        else Bones[i].Visible = false end
                    end
                else for _,b in pairs(Bones) do b.Visible = false end end
            else
                NameTag.Visible = false; DistTag.Visible = false; HealthBar.Visible = false
                for _,b in pairs(Bones) do b.Visible = false end
            end
        else
            NameTag.Visible = false; DistTag.Visible = false; HealthBar.Visible = false
            for _,b in pairs(Bones) do b.Visible = false end
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- HEARTBEAT (SPEED, JUMP, AIMLOCK, ETC)
RunService.Heartbeat:Connect(function()
    local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then hum.WalkSpeed = SpeedOn and SpeedVal or 16; hum.JumpPower = JumpOn and JumpVal or 50 end
    if NoClip and char then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    
    if AimlockOn then
        local target = nil; local maxDist = 500
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                local p, os = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if os and IsVisible(v.Character.Head) then
                    local m = (Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y) - Vector2.new(p.X, p.Y)).Magnitude
                    if m < maxDist then maxDist = m; target = v end
                end
            end
        end
        if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
    end
    
    if SelectedTarget and SelectedTarget.Character and hrp then
        local thrp = SelectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if thrp then
            local cf = thrp.CFrame * CFrame.new(0, 0, FollowDistance)
            if TPFollow then hrp.CFrame = cf elseif BodyLock then hrp.CFrame = hrp.CFrame:Lerp(cf, 0.2) end
        end
    end
end)

UIS.JumpRequest:Connect(function() if InfJump and LP.Character then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

-- DRAGGABLE INITIALIZATION (PRESERVED)
MakeDraggable(MiniLogo, MiniLogo)
MakeDraggable(Main, TopBar) 

-- LOOP SEA PARTICLES
task.spawn(function()
    while task.wait(0.4) do 
        if Main.Visible then CreateSeaEmber(MainSeaContainer) end
        CreateSeaEmber(MiniSeaContainer)
    end
end)

ClickBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    MiniLogo.Visible = false 
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 18}):Play()
end)

Pages["Player"].page.Visible = true; Pages["Player"].btn.BackgroundTransparency = 0.1; Pages["Player"].btn.TextColor3 = Theme.Accent
print("CIPIK HUB | OCEAN EDITION LOADED 🌊")
