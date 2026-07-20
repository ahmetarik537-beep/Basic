-- Delta Advanced ESP + Aimbot GUI (Tam Versiyon)
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local ESP_Enabled = false
local Aimbot_Enabled = false
local AimSmooth = 8
local AimFOV = 150

-- ESP Ayarları
local ShowBoxes = true
local ShowNames = true
local ShowDistance = true
local ShowHealth = true
local ShowTracers = true
local TeamCheck = true

local espObjects = {}
local currentTab = "ESP"

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ana Menü (Saydam Gri)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 420)
frame.Position = UDim2.new(0.5, -170, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 60, 120)
titleBar.BackgroundTransparency = 0.1
titleBar.Text = "🔧 Advanced Menu"
titleBar.TextColor3 = Color3.new(1,1,1)
titleBar.TextScaled = true
titleBar.Parent = frame

-- Tablar
local tabESP = Instance.new("TextButton")
tabESP.Size = UDim2.new(0.5, -5, 0, 35)
tabESP.Position = UDim2.new(0, 5, 0, 45)
tabESP.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tabESP.Text = "ESP"
tabESP.TextColor3 = Color3.new(1,1,1)
tabESP.TextScaled = true
tabESP.Parent = frame

local tabAimbot = Instance.new("TextButton")
tabAimbot.Size = UDim2.new(0.5, -5, 0, 35)
tabAimbot.Position = UDim2.new(0.5, 0, 0, 45)
tabAimbot.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
tabAimbot.Text = "Aimbot"
tabAimbot.TextColor3 = Color3.new(1,1,1)
tabAimbot.TextScaled = true
tabAimbot.Parent = frame

-- Minimize & Close
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,35,0,35)
minBtn.Position = UDim2.new(1,-75,0,3)
minBtn.BackgroundTransparency = 1
minBtn.Text = "─"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextScaled = true
minBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,35,0,35)
closeBtn.Position = UDim2.new(1,-40,0,3)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,0,0)
closeBtn.TextScaled = true
closeBtn.Parent = titleBar

-- ESP Frame
local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(1, -10, 1, -95)
espFrame.Position = UDim2.new(0, 5, 0, 85)
espFrame.BackgroundTransparency = 1
espFrame.Parent = frame

local toggleESPBtn = Instance.new("TextButton")
toggleESPBtn.Size = UDim2.new(0.9,0,0,50)
toggleESPBtn.Position = UDim2.new(0.05,0,0,0)
toggleESPBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
toggleESPBtn.Text = "ESP AÇ"
toggleESPBtn.TextColor3 = Color3.new(1,1,1)
toggleESPBtn.TextScaled = true
toggleESPBtn.Parent = espFrame

local function createESPToggle(text, y, enabled)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Position = UDim2.new(0.05,0,y,0)
    btn.BackgroundColor3 = enabled and Color3.fromRGB(0,160,0) or Color3.fromRGB(60,60,60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = espFrame
    return btn
end

local btnBox = createESPToggle("Box", 0.18, true)
local btnName = createESPToggle("İsim + Mesafe", 0.32, true)
local btnHealth = createESPToggle("Can Barı", 0.46, true)
local btnTracer = createESPToggle("Tracer", 0.6, true)
local btnTeam = createESPToggle("Takım Check", 0.74, true)

-- Aimbot Frame
local aimFrame = Instance.new("Frame")
aimFrame.Size = UDim2.new(1, -10, 1, -95)
aimFrame.Position = UDim2.new(0, 5, 0, 85)
aimFrame.BackgroundTransparency = 1
aimFrame.Visible = false
aimFrame.Parent = frame

local toggleAimBtn = Instance.new("TextButton")
toggleAimBtn.Size = UDim2.new(0.9,0,0,55)
toggleAimBtn.Position = UDim2.new(0.05,0,0.1,0)
toggleAimBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
toggleAimBtn.Text = "AIMBOT KAPALI"
toggleAimBtn.TextColor3 = Color3.new(1,1,1)
toggleAimBtn.TextScaled = true
toggleAimBtn.Parent = aimFrame

local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(0.9,0,0,30)
smoothLabel.Position = UDim2.new(0.05,0,0.35,0)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Text = "Smooth: 8"
smoothLabel.TextColor3 = Color3.new(1,1,1)
smoothLabel.TextScaled = true
smoothLabel.Parent = aimFrame

local smoothBox = Instance.new("TextBox")
smoothBox.Size = UDim2.new(0.9,0,0,40)
smoothBox.Position = UDim2.new(0.05,0,0.45,0)
smoothBox.BackgroundColor3 = Color3.fromRGB(45,45,50)
smoothBox.Text = "8"
smoothBox.TextColor3 = Color3.new(1,1,1)
smoothBox.TextScaled = true
smoothBox.Parent = aimFrame

-- Tab Sistemi
tabESP.MouseButton1Click:Connect(function()
    currentTab = "ESP"
    espFrame.Visible = true
    aimFrame.Visible = false
    tabESP.BackgroundColor3 = Color3.fromRGB(0,120,255)
    tabAimbot.BackgroundColor3 = Color3.fromRGB(50,50,55)
end)

tabAimbot.MouseButton1Click:Connect(function()
    currentTab = "Aimbot"
    espFrame.Visible = false
    aimFrame.Visible = true
    tabAimbot.BackgroundColor3 = Color3.fromRGB(0,120,255)
    tabESP.BackgroundColor3 = Color3.fromRGB(50,50,55)
end)

-- Sürükleme
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- Minimize & Close
minBtn.MouseButton1Click:Connect(function()
    frame.Size = frame.Size == UDim2.new(0,340,0,420) and UDim2.new(0,340,0,45) or UDim2.new(0,340,0,420)
end)
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

-- ==================== ESP Kodu ====================
local function createESP(plr)
    if plr == player then return end
    local box = Drawing.new("Square") box.Thickness = 2 box.Filled = false box.Transparency = 1
    local name = Drawing.new("Text") name.Size = 16 name.Center = true name.Outline = true
    local hbBG = Drawing.new("Square") hbBG.Filled = true hbBG.Color = Color3.new(0,0,0) hbBG.Transparency = 0.5
    local hb = Drawing.new("Square") hb.Filled = true hb.Transparency = 1
    local tracer = Drawing.new("Line") tracer.Thickness = 1.5 tracer.Transparency = 0.6
    espObjects[plr] = {box=box, name=name, hbBG=hbBG, hb=hb, tracer=tracer}
end

local function updateESP()
    for plr, d in pairs(espObjects) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
            local root = plr.Character.HumanoidRootPart
            local head = plr.Character.Head
            local hum = plr.Character.Humanoid
            local _, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local top = camera:WorldToViewportPoint(head.Position + Vector3.new(0,2,0))
                local bottom = camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
                local h = bottom.Y - top.Y
                local isEnemy = not TeamCheck or plr.Team ~= player.Team
                local col = isEnemy and Color3.fromRGB(255,50,50) or Color3.fromRGB(50,255,50)

                if ShowBoxes then d.box.Visible = true d.box.Color = col d.box.Size = Vector2.new(h/1.8, h) d.box.Position = Vector2.new(top.X - d.box.Size.X/2, top.Y) else d.box.Visible = false end
                if ShowNames then 
                    d.name.Visible = true 
                    d.name.Color = col 
                    local dist = math.floor((player.Character and player.Character:FindFirstChild("HumanoidRootPart") and (player.Character.HumanoidRootPart.Position - root.Position).Magnitude) or 0)
                    d.name.Text = ShowDistance and plr.Name.." ["..dist.."m]" or plr.Name
                    d.name.Position = Vector2.new(top.X, top.Y-20)
                else d.name.Visible = false end
                if ShowHealth then
                    local hp = hum.Health / hum.MaxHealth
                    d.hbBG.Visible = true d.hb.Visible = true
                    d.hbBG.Size = Vector2.new(5, h) d.hbBG.Position = Vector2.new(top.X - d.box.Size.X/2 - 10, top.Y)
                    d.hb.Size = Vector2.new(5, h * hp) d.hb.Position = Vector2.new(top.X - d.box.Size.X/2 - 10, top.Y + h*(1-hp))
                    d.hb.Color = Color3.fromHSV(hp*0.33,1,1)
                else d.hbBG.Visible = false d.hb.Visible = false end
                if ShowTracers then 
                    d.tracer.Visible = true 
                    d.tracer.Color = col 
                    d.tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y-10)
                    d.tracer.To = Vector2.new(top.X, top.Y)
                else d.tracer.Visible = false end
            else
                for _,v in pairs(d) do v.Visible = false end
            end
        end
    end
end

-- ==================== Aimbot ====================
local function getClosestPlayer()
    local closest, dist = nil, AimFOV
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local screenPos, visible = camera:WorldToViewportPoint(p.Character.Head.Position)
            if visible then
                local mousePos = uis:GetMouseLocation()
                local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if magnitude < dist then
                    dist = magnitude
                    closest = p
                end
            end
        end
    end
    return closest
end

runService.RenderStepped:Connect(function()
    if Aimbot_Enabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPos = camera:WorldToScreenPoint(target.Character.Head.Position)
            local mousePos = uis:GetMouseLocation()
            mousemoverel((targetPos.X - mousePos.X) / AimSmooth, (targetPos.Y - mousePos.Y) / AimSmooth)
        end
    end
end)

-- Buton Bağlantıları
toggleESPBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    toggleESPBtn.Text = ESP_Enabled and "ESP KAPAT" or "ESP AÇ"
    toggleESPBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(180,0,0) or Color3.fromRGB(0,180,0)
    if ESP_Enabled then
        for _, plr in pairs(game.Players:GetPlayers()) do createESP(plr) end
        runService:BindToRenderStep("ESP", 1, updateESP)
    else
        runService:UnbindFromRenderStep("ESP")
        for _, t in pairs(espObjects) do for _, d in pairs(t) do d:Remove() end end
        espObjects = {}
    end
end)

toggleAimBtn.MouseButton1Click:Connect(function()
    Aimbot_Enabled = not Aimbot_Enabled
    toggleAimBtn.Text = Aimbot_Enabled and "AIMBOT AÇIK" or "AIMBOT KAPALI"
    toggleAimBtn.BackgroundColor3 = Aimbot_Enabled and Color3.fromRGB(180,0,0) or Color3.fromRGB(0,180,0)
end)

smoothBox.FocusLost:Connect(function()
    local n = tonumber(smoothBox.Text)
    if n then AimSmooth = n smoothLabel.Text = "Smooth: "..n end
end)

-- Diğer ESP Butonları
btnBox.MouseButton1Click:Connect(function() ShowBoxes = not ShowBoxes btnBox.BackgroundColor3 = ShowBoxes and Color3.fromRGB(0,160,0) or Color3.fromRGB(60,60,60) end)
btnName.MouseButton1Click:Connect(function() ShowNames = not ShowNames btnName.BackgroundColor3 = ShowNames and Color3.fromRGB(0,160,0) or Color3.fromRGB(60,60,60) end)
btnHealth.MouseButton1Click:Connect(function() ShowHealth = not ShowHealth btnHealth.BackgroundColor3 = ShowHealth and Color3.fromRGB(0,160,0) or Color3.fromRGB(60,60,60) end)
btnTracer.MouseButton1Click:Connect(function() ShowTracers = not ShowTracers btnTracer.BackgroundColor3 = ShowTracers and Color3.fromRGB(0,160,0) or Color3.fromRGB(60,60,60) end)
btnTeam.MouseButton1Click:Connect(function() TeamCheck = not TeamCheck btnTeam.BackgroundColor3 = TeamCheck and Color3.fromRGB(0,160,0) or Color3.fromRGB(60,60,60) end)

game.Players.PlayerAdded:Connect(function(p) if ESP_Enabled then createESP(p) end end)

print("✅ Tam Advanced Menu Yüklendi! (ESP + Aimbot)")
