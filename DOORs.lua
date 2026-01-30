--====================================================
-- ❄️ CIPSHUB | PREMIUM ICE EDITION 2026 ❄️
-- STYLE: CIRCLE MINI LOGO & LOCAL SNOW EFFECT
-- NO FEATURES REMOVED | ALL SYSTEMS PROTECTED
-- FIXED: 100% WORKING AIMLOCK (VISIBLE ONLY)
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

-- PREMIUM ICE THEME
local Theme = {
    Main = Color3.fromRGB(10, 20, 30),
    Sidebar = Color3.fromRGB(15, 25, 35),
    Accent = Color3.fromRGB(0, 225, 255), -- Ice Blue
    Text = Color3.fromRGB(240, 250, 255),
    SubText = Color3.fromRGB(160, 180, 200),
    InputBG = Color3.fromRGB(25, 40, 50),
    GlassTrans = 0.1
}

-- Global Variables (PROTECTED)
local SpeedOn, JumpOn, NoClip, InfJump = false, false, false, false
local SpeedVal, JumpVal = 16, 50
local SelectedTarget = nil
local TPFollow, BodyLock = false, false
local FollowDistance = 4
local AimlockOn = false

-- ESP States (PROTECTED)
local ESP_Master = false
local ESP_Name_On = false
local ESP_Skeleton_On = false
local ESP_Health_On = false
local ESP_Dist_On = false
local ESP_Team_Check = true

local function Round(obj, rad)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, rad)
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--========================
-- INTERFACE BUILDER
--========================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromOffset(540, 350)
Main.Position = UDim2.new(0.5, -270, 0.5, -175)
Main.BackgroundColor3 = Theme.Main
Main.BackgroundTransparency = Theme.GlassTrans
Main.Visible = false
Round(Main, 12)

-- Snow Effect Container
local SnowContainer = Instance.new("Frame", Main)
SnowContainer.Size = UDim2.fromScale(1, 1)
SnowContainer.BackgroundTransparency = 1
SnowContainer.ClipsDescendants = true

local function CreateSnowflake(parent)
    local flake = Instance.new("TextLabel", parent)
    flake.BackgroundTransparency = 1
    flake.Text = "."
    flake.TextColor3 = Color3.new(1, 1, 1)
    flake.TextSize = math.random(10, 15)
    flake.Position = UDim2.new(math.random(), 0, -0.1, 0)
    local speed = math.random(2, 5)
    task.spawn(function()
        local t = 0
        while flake and flake.Parent and t < speed do
            t = t + RunService.RenderStepped:Wait()
            flake.Position = UDim2.new(flake.Position.X.Scale, 0, t / speed, 0)
            flake.TextTransparency = t / speed
        end
        flake:Destroy()
    end)
end

task.spawn(function()
    while task.wait(0.3) do if Main.Visible then CreateSnowflake(SnowContainer) end end
end)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2; MainStroke.Color = Theme.Accent; MainStroke.Transparency = 0.5

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BackgroundTransparency = 0.1
Round(Sidebar, 12)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "CIPSHUB ❄️"
Title.Font = Enum.Font.GothamBlack; Title.TextColor3 = Theme.Accent; Title.TextSize = 18; Title.BackgroundTransparency = 1

local TabHolder = Instance.new("ScrollingFrame", Sidebar)
TabHolder.Size = UDim2.new(1, -15, 1, -60); TabHolder.Position = UDim2.fromOffset(7, 55); TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
Instance.new("UIListLayout", TabHolder).Padding = UDim.new(0, 5)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -165, 1, -20); Container.Position = UDim2.fromOffset(160, 10); Container.BackgroundTransparency = 1

local Pages = {}
local function NewTab(name, icon)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(1, 0, 0, 32); btn.BackgroundTransparency = 1; btn.Text = "  " .. icon .. "  " .. name
    btn.Font = Enum.Font.GothamMedium; btn.TextColor3 = Theme.SubText; btn.TextSize = 11; btn.TextXAlignment = "Left"; Round(btn, 6)
    local page = Instance.new("ScrollingFrame", Container)
    page.Size = UDim2.fromScale(1, 1); page.BackgroundTransparency = 1; page.Visible = false; page.ScrollBarThickness = 2
    Instance.new("UIListLayout", page).Padding = UDim.new(0, 6)
    Pages[name] = {btn = btn, page = page}
    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.page.Visible = false; TweenService:Create(v.btn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Theme.SubText}):Play() end
        page.Visible = true; TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.1, TextColor3 = Theme.Accent}):Play()
    end)
    return page
end

local function AddToggle(parent, text, default, callback)
    local tgl = Instance.new("TextButton", parent); tgl.Size = UDim2.new(0.98, 0, 0, 38); tgl.BackgroundColor3 = Color3.fromRGB(30, 45, 60); tgl.BackgroundTransparency = 0.5; tgl.Text = ""; Round(tgl, 8)
    local l = Instance.new("TextLabel", tgl); l.Size = UDim2.new(1, -50, 1, 0); l.Position = UDim2.fromOffset(12, 0); l.Text = text; l.Font = Enum.Font.Gotham; l.TextColor3 = Theme.Text; l.TextSize = 12; l.TextXAlignment = "Left"; l.BackgroundTransparency = 1
    local sw = Instance.new("Frame", tgl); sw.Size = UDim2.fromOffset(28, 14); sw.Position = UDim2.new(1, -40, 0.5, -7); sw.BackgroundColor3 = Color3.fromRGB(50, 70, 90); Round(sw, 7)
    local dot = Instance.new("Frame", sw); dot.Size = UDim2.fromOffset(10, 10); dot.Position = UDim2.fromOffset(2, 2); dot.BackgroundColor3 = Color3.new(1, 1, 1); Round(dot, 5)
    local active = default
    local function update()
        callback(active)
        TweenService:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = active and Theme.Accent or Color3.fromRGB(50, 70, 90)}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = active and UDim2.fromOffset(16, 2) or UDim2.fromOffset(2, 2)}):Play()
    end
    tgl.MouseButton1Click:Connect(function() active = not active; update() end); update()
end

local function AddInput(parent, text, default, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(0.98, 0, 0, 45); frame.BackgroundColor3 = Theme.InputBG; frame.BackgroundTransparency = 0.5; Round(frame, 8)
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(0.6, 0, 1, 0); label.Position = UDim2.fromOffset(12, 0); label.Text = text; label.Font = Enum.Font.Gotham; label.TextColor3 = Theme.Text; label.TextSize = 12; label.TextXAlignment = "Left"; label.BackgroundTransparency = 1
    local ibox = Instance.new("TextBox", frame); ibox.Size = UDim2.new(0, 60, 0, 25); ibox.Position = UDim2.new(1, -72, 0.5, -12.5); ibox.BackgroundColor3 = Color3.fromRGB(15, 25, 35); ibox.Text = tostring(default); ibox.TextColor3 = Theme.Accent; ibox.Font = Enum.Font.GothamBold; ibox.TextSize = 12; Round(ibox, 5)
    local stroke = Instance.new("UIStroke", ibox); stroke.Color = Theme.Accent; stroke.Transparency = 0.7; stroke.Thickness = 1
    ibox.FocusLost:Connect(function() local val = tonumber(ibox.Text) if val then callback(val) else ibox.Text = "ERR" end end)
end

local function AddButton(parent, text, callback)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.98, 0, 0, 32); b.BackgroundColor3 = Theme.Accent; b.BackgroundTransparency = 0.9; b.Text = text; b.Font = Enum.Font.GothamMedium; b.TextColor3 = Theme.Accent; b.TextSize = 11; Round(b, 8)
    local s = Instance.new("UIStroke", b); s.Thickness = 1; s.Color = Theme.Accent; s.Transparency = 0.8
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

-- TABS SETUP
local Tab1 = NewTab("Player", "👤")
local Tab2 = NewTab("Combat", "🔫")
local Tab3 = NewTab("Follow", "🎯")
local Tab4 = NewTab("Visuals", "👁️")
local Tab5 = NewTab("Utility", "⚙️")

-- Player Fitur
AddToggle(Tab1, "Premium WalkSpeed Master", false, function(v) SpeedOn = v end)
AddInput(Tab1, "Set WalkSpeed Value", 16, function(v) SpeedVal = v end)
AddToggle(Tab1, "Premium JumpPower Master", false, function(v) JumpOn = v end)
AddInput(Tab1, "Set JumpPower Value", 50, function(v) JumpVal = v end)
AddToggle(Tab1, "NoClip (Pass Walls)", false, function(v) NoClip = v end)
AddToggle(Tab1, "Infinite Jump", false, function(v) InfJump = v end)

-- Combat Fitur (FIXED 100% WORK)
AddToggle(Tab2, "Aimlock (Legit Visible)", false, function(v) AimlockOn = v end)

-- Target & Visuals
AddButton(Tab3, "Select Target", function()
    local d = Instance.new("ScrollingFrame", Tab3); d.Size = UDim2.new(0.98,0,0,80); d.BackgroundColor3 = Color3.new(0,0,0); d.BackgroundTransparency = 0.5; Round(d, 8); Instance.new("UIListLayout", d)
    for _,p in pairs(Players:GetPlayers()) do if p ~= LP then AddButton(d, p.Name, function() SelectedTarget = p; d:Destroy() end).Size = UDim2.new(1,0,0,25) end end
end)
AddToggle(Tab3, "Teleport Follow", false, function(v) TPFollow = v end)
AddToggle(Tab3, "Smooth Body Lock", false, function(v) BodyLock = v end)
AddToggle(Tab4, "Master ESP Switch", false, function(v) ESP_Master = v end)
AddToggle(Tab4, "ESP Player Name", false, function(v) ESP_Name_On = v end)
AddToggle(Tab4, "ESP Premium Skeleton", false, function(v) ESP_Skeleton_On = v end)
AddToggle(Tab4, "ESP Health Bar", false, function(v) ESP_Health_On = v end)
AddToggle(Tab4, "ESP Distance Meter", false, function(v) ESP_Dist_On = v end)
AddToggle(Tab4, "Team Check (Hide Friend)", true, function(v) ESP_Team_Check = v end)
AddButton(Tab5, "AFEM MAX (ALPHA)", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))() end)
AddButton(Tab5, "PSHADE ULTIMATE", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-pshade-ultimate-25505"))() end)

--========================
-- CORE FUNCTIONS
--========================

-- CHECK IF TARGET IS VISIBLE (RAYCAST SYSTEM)
local function IsTargetVisible(targetPart)
    if not targetPart then return false end
    local char = LP.Character
    if not char then return false end
    
    local ray = Ray.new(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000)
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {char, Camera})
    
    if hit and hit:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

-- ESP LOGIC
local function CreateESP(plr)
    local NameTag = Drawing.new("Text"); NameTag.Visible = false; NameTag.Center = true; NameTag.Outline = true; NameTag.Size = 13; NameTag.Color = Theme.Accent
    local DistTag = Drawing.new("Text"); DistTag.Visible = false; DistTag.Center = true; DistTag.Outline = true; DistTag.Size = 11; DistTag.Color = Color3.new(1,1,1)
    local HealthBar = Drawing.new("Line"); HealthBar.Thickness = 2; HealthBar.Visible = false
    local Lines = {}
    for i=1, 6 do Lines[i] = Drawing.new("Line"); Lines[i].Thickness = 1.5; Lines[i].Color = Theme.Accent end

    RunService.RenderStepped:Connect(function()
        local char = plr.Character
        if ESP_Master and char and char:FindFirstChild("HumanoidRootPart") and plr ~= LP and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            if ESP_Team_Check and plr.Team == LP.Team then
                NameTag.Visible = false; DistTag.Visible = false; HealthBar.Visible = false; for _,l in pairs(Lines) do l.Visible = false end
                return
            end
            local hrp = char.HumanoidRootPart; local head = char:FindFirstChild("Head")
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local distance = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                if ESP_Name_On then NameTag.Visible = true; NameTag.Text = plr.Name; NameTag.Position = Vector2.new(pos.X, pos.Y - 45) else NameTag.Visible = false end
                if ESP_Dist_On then DistTag.Visible = true; DistTag.Text = "["..distance.."m]"; DistTag.Position = Vector2.new(pos.X, pos.Y + 25) else DistTag.Visible = false end
                if ESP_Health_On then
                    HealthBar.Visible = true; local hPercent = char.Humanoid.Health / char.Humanoid.MaxHealth
                    HealthBar.Color = Color3.fromHSV(hPercent * 0.3, 1, 1)
                    HealthBar.From = Vector2.new(pos.X - 25, pos.Y + 20); HealthBar.To = Vector2.new(pos.X - 25 + (50 * hPercent), pos.Y + 20)
                else HealthBar.Visible = false end
                if ESP_Skeleton_On and head and char:FindFirstChild("Left Arm") then
                    local H = Camera:WorldToViewportPoint(head.Position); local T = Camera:WorldToViewportPoint(hrp.Position)
                    local LA = Camera:WorldToViewportPoint(char["Left Arm"].Position); local RA = Camera:WorldToViewportPoint(char["Right Arm"].Position)
                    local LL = Camera:WorldToViewportPoint(char:FindFirstChild("Left Leg") and char["Left Leg"].Position or hrp.Position)
                    local RL = Camera:WorldToViewportPoint(char:FindFirstChild("Right Leg") and char["Right Leg"].Position or hrp.Position)
                    Lines[1].Visible = true; Lines[1].From = Vector2.new(H.X, H.Y); Lines[1].To = Vector2.new(T.X, T.Y)
                    Lines[2].Visible = true; Lines[2].From = Vector2.new(T.X, T.Y); Lines[2].To = Vector2.new(LA.X, LA.Y)
                    Lines[3].Visible = true; Lines[3].From = Vector2.new(T.X, T.Y); Lines[3].To = Vector2.new(RA.X, RA.Y)
                    Lines[4].Visible = true; Lines[4].From = Vector2.new(T.X, T.Y); Lines[4].To = Vector2.new(LL.X, LL.Y)
                    Lines[5].Visible = true; Lines[5].From = Vector2.new(T.X, T.Y); Lines[5].To = Vector2.new(RL.X, RL.Y)
                else for _,l in pairs(Lines) do l.Visible = false end end
            else NameTag.Visible = false; DistTag.Visible = false; HealthBar.Visible = false; for _,l in pairs(Lines) do l.Visible = false end end
        else NameTag.Visible = false; DistTag.Visible = false; HealthBar.Visible = false; for _,l in pairs(Lines) do l.Visible = false end end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    local char = LP.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hum then hum.WalkSpeed = SpeedOn and SpeedVal or 16; hum.JumpPower = JumpOn and JumpVal or 50 end
    if NoClip and char then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    
    -- 100% WORK AIMLOCK (VISIBLE ONLY)
    if AimlockOn then
        local target = nil
        local shortestDistance = math.huge
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                -- Team Check logic for Aimlock
                if ESP_Team_Check and v.Team == LP.Team then continue end
                
                local head = v.Character.Head
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    -- VALIDASI TEMBOK (RAYCAST)
                    if IsTargetVisible(head) then
                        local mousePos = Vector2.new(UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y)
                        local screenPos = Vector2.new(pos.X, pos.Y)
                        local distance = (mousePos - screenPos).Magnitude
                        
                        if distance < shortestDistance then
                            shortestDistance = distance
                            target = head
                        end
                    end
                end
            end
        end
        
        if target then
            -- Smooth lock to target position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
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

--====================================================
-- PREMIUM MINI LOGO (CIRCLE & DRAGGABLE SNOW)
--====================================================
local MiniLogo = Instance.new("Frame", Gui)
MiniLogo.Name = "CipikMiniLogo"
MiniLogo.Size = UDim2.fromOffset(55, 55)
MiniLogo.Position = UDim2.new(0.02, 0, 0.4, 0)
MiniLogo.BackgroundColor3 = Theme.Main
MiniLogo.BackgroundTransparency = 0.2
MiniLogo.ClipsDescendants = true
Round(MiniLogo, 100)
MakeDraggable(MiniLogo, MiniLogo)

local MiniSnowContainer = Instance.new("Frame", MiniLogo)
MiniSnowContainer.Size = UDim2.fromScale(1, 1)
MiniSnowContainer.BackgroundTransparency = 1

local MiniStroke = Instance.new("UIStroke", MiniLogo)
MiniStroke.Thickness = 2; MiniStroke.Color = Theme.Accent; MiniStroke.Transparency = 0.4

local IconText = Instance.new("TextLabel", MiniLogo)
IconText.Size = UDim2.fromScale(1, 1); IconText.BackgroundTransparency = 1; IconText.Text = "CIPIK"; IconText.Font = Enum.Font.GothamBlack; IconText.TextColor3 = Color3.new(1, 1, 1); IconText.TextSize = 11; IconText.ZIndex = 5

local ClickBtn = Instance.new("TextButton", MiniLogo)
ClickBtn.Size = UDim2.fromScale(1, 1); ClickBtn.BackgroundTransparency = 1; ClickBtn.Text = ""; ClickBtn.ZIndex = 10

task.spawn(function()
    while task.wait(0.4) do CreateSnowflake(MiniSnowContainer) end
end)

ClickBtn.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = Main.Visible and 15 or 0}):Play()
    TweenService:Create(MiniLogo, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.fromOffset(50, 50)}):Play()
    task.wait(0.1)
    TweenService:Create(MiniLogo, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.fromO
