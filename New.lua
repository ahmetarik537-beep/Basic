-- Universal Fly GUI v2 - Draggable + Minimize + Mobile
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local speed = 50
local connection

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileFlyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ana Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 240)
frame.Position = UDim2.new(0.5, -140, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title Bar (Sürüklemek için)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
titleBar.Text = "🚀 Mobile Fly GUI"
titleBar.TextColor3 = Color3.new(1,1,1)
titleBar.TextScaled = true
titleBar.Parent = frame

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 2)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
minBtn.Text = "─"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextScaled = true
minBtn.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -70, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Parent = titleBar

-- İçerik
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 55)
toggleBtn.Position = UDim2.new(0.075, 0, 0.22, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
toggleBtn.Text = "FLY AÇ"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.85, 0, 0, 30)
speedLabel.Position = UDim2.new(0.075, 0, 0.52, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Hız: 50"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextScaled = true
speedLabel.Parent = frame

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.85, 0, 0, 35)
speedBox.Position = UDim2.new(0.075, 0, 0.67, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedBox.Text = "50"
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.TextScaled = true
speedBox.Parent = frame

-- Sürükleme Fonksiyonu
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Minimize & Close
local minimized = false
local originalSize = frame.Size

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.new(0, 280, 0, 40)
        toggleBtn.Visible = false
        speedLabel.Visible = false
        speedBox.Visible = false
        minBtn.Text = "+"
    else
        frame.Size = originalSize
        toggleBtn.Visible = true
        speedLabel.Visible = true
        speedBox.Visible = true
        minBtn.Text = "─"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Fly Fonksiyonları
local function startFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    flying = true
    
    local root = char.HumanoidRootPart
    local camera = workspace.CurrentCamera
    
    connection = runService.RenderStepped:Connect(function()
        if not flying then return end
        local move = Vector3.new()
        
        if uis:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        
        if move.Magnitude > 0 then
            root.CFrame = root.CFrame + (move.Unit * speed * 0.1)
        end
    end)
end

local function stopFly()
    flying = false
    if connection then connection:Disconnect() end
end

toggleBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        toggleBtn.Text = "FLY AÇ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    else
        startFly()
        toggleBtn.Text = "FLY KAPAT"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    end
end)

speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then speed = num; speedLabel.Text = "Hız: " .. speed end
end)

-- Sağ tıkla gizle/göster
uis.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

print("✅ Güncellenmiş Fly GUI Yüklendi! (Sürüklenebilir + Minimize)")
