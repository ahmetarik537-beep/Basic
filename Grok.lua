-- Universal Fly GUI - MOBILE FRIENDLY
local player = game.Players.LocalPlayer
local flying = false
local speed = 50
local bv, bg

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 220)
frame.Position = UDim2.new(0.5, -140, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.Text = "🚀 Mobile Fly GUI"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 55)
toggleBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
toggleBtn.Text = "FLY AÇ"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.85, 0, 0, 30)
speedLabel.Position = UDim2.new(0.075, 0, 0.55, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Hız: 50"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextScaled = true
speedLabel.Parent = frame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.85, 0, 0, 35)
speedBox.Position = UDim2.new(0.075, 0, 0.7, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedBox.Text = "50"
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.TextScaled = true
speedBox.Parent = frame

-- Fly Başlat
local function startFlying()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    flying = true
    local root = char.HumanoidRootPart
    
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = root
    
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 10000
    bg.Parent = root
end

local function stopFlying()
    flying = false
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

toggleBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
        toggleBtn.Text = "FLY AÇ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        startFlying()
        toggleBtn.Text = "FLY KAPAT"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then
        speed = val
        speedLabel.Text = "Hız: " .. speed
    end
end)

-- Uçuş Kontrol (Mobil + PC uyumlu)
game:GetService("RunService").RenderStepped:Connect(function()
    if not flying then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local camera = workspace.CurrentCamera
    
    local move = Vector3.new(0, 0, 0)
    local uis = game:GetService("UserInputService")
    
    if uis:IsKeyDown(Enum.KeyCode.W) or uis:IsKeyDown(Enum.KeyCode.Up) then move = move + camera.CFrame.LookVector end
    if uis:IsKeyDown(Enum.KeyCode.S) or uis:IsKeyDown(Enum.KeyCode.Down) then move = move - camera.CFrame.LookVector end
    if uis:IsKeyDown(Enum.KeyCode.A) or uis:IsKeyDown(Enum.KeyCode.Left) then move = move - camera.CFrame.RightVector end
    if uis:IsKeyDown(Enum.KeyCode.D) or uis:IsKeyDown(Enum.KeyCode.Right) then move = move + camera.CFrame.RightVector end
    if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
    if uis:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
    
    if move.Magnitude > 0 then
        bv.Velocity = move.Unit * speed
    else
        bv.Velocity = Vector3.new(0,0,0)
    end
    
    bg.CFrame = camera.CFrame
end)

print("✅ Mobile Fly GUI Yüklendi! Menü otomatik açıldı.")
