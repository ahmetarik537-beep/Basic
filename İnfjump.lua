-- Delta Optimized Infinite Jump GUI
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local infJumpEnabled = false
local jumpHeight = 50  -- Normalden yüksek zıplama

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InfJumpGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ana Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 220)
frame.Position = UDim2.new(0.5, -140, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Title Bar (Sürüklenebilir)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
titleBar.Text = "🔥 Infinite Jump GUI"
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

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 55)
toggleBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
toggleBtn.Text = "INFINITE JUMP AÇ"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Parent = frame

local heightLabel = Instance.new("TextLabel")
heightLabel.Size = UDim2.new(0.85, 0, 0, 30)
heightLabel.Position = UDim2.new(0.075, 0, 0.52, 0)
heightLabel.BackgroundTransparency = 1
heightLabel.Text = "Zıplama Gücü: 50"
heightLabel.TextColor3 = Color3.new(1,1,1)
heightLabel.TextScaled = true
heightLabel.Parent = frame

local heightBox = Instance.new("TextBox")
heightBox.Size = UDim2.new(0.85, 0, 0, 35)
heightBox.Position = UDim2.new(0.075, 0, 0.67, 0)
heightBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
heightBox.Text = "50"
heightBox.TextColor3 = Color3.new(1,1,1)
heightBox.TextScaled = true
heightBox.Parent = frame

-- Sürükleme
local dragging = false
local dragStart, startPos

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
        heightLabel.Visible = false
        heightBox.Visible = false
        minBtn.Text = "+"
    else
        frame.Size = originalSize
        toggleBtn.Visible = true
        heightLabel.Visible = true
        heightBox.Visible = true
        minBtn.Text = "─"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Infinite Jump Sistemi (Delta'da çok stabil)
toggleBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    
    if infJumpEnabled then
        toggleBtn.Text = "INFINITE JUMP KAPAT"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        
        -- Jump bağlantısı
        local connection
        connection = uis.JumpRequest:Connect(function()
            if infJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        
        -- Değer sakla
        getgenv().InfJumpConnection = connection
    else
        toggleBtn.Text = "INFINITE JUMP AÇ"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        if getgenv().InfJumpConnection then
            getgenv().InfJumpConnection:Disconnect()
            getgenv().InfJumpConnection = nil
        end
    end
end)

heightBox.FocusLost:Connect(function()
    local num = tonumber(heightBox.Text)
    if num then
        jumpHeight = num
        heightLabel.Text = "Zıplama Gücü: " .. jumpHeight
        -- Humanoid JumpPower da güncelle
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = jumpHeight
        end
    end
end)

-- Sağ tıklama ile gizle/göster
uis.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

print("✅ Delta Infinite Jump GUI Yüklendi! (Sürüklenebilir + Minimize)")

-- Karakter yenilendiğinde JumpPower güncelle
player.CharacterAdded:Connect(function(char)
    wait(1)
    local hum = char:WaitForChild("Humanoid")
    hum.JumpPower = jumpHeight
end)
