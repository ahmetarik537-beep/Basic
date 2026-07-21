-- TR SCRIPTS - Universal Weapon Game ESP + Arrow Indicator
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local espEnabled = true
local arrowEnabled = true
local menuVisible = true

local ESPs = {}
local Arrows = {}

-- Sürüklebilir Kalın Menü
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TRScripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 680, 0, 110) -- Daha kalın ve geniş
MainFrame.Position = UDim2.new(0.5, -340, 0.08, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Sürükleme
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 70, 140)
Title.Text = "TR SCRIPTS"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local function createBtn(text, xPos, defaultColor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 50) -- Kalın butonlar
    btn.Position = UDim2.new(0, xPos, 0, 45)
    btn.BackgroundColor3 = defaultColor
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local espBtn = createBtn("ESP: AÇIK", 30, Color3.fromRGB(0, 180, 0), function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "AÇIK" or "KAPALI")
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
end)

local arrowBtn = createBtn("OK İNDICATOR: AÇIK", 200, Color3.fromRGB(0, 180, 0), function()
    arrowEnabled = not arrowEnabled
    arrowBtn.Text = "OK İNDICATOR: " .. (arrowEnabled and "AÇIK" or "KAPALI")
    arrowBtn.BackgroundColor3 = arrowEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
end)

-- Küçük TR Dairesi
local MiniCircle = Instance.new("TextButton")
MiniCircle.Size = UDim2.new(0, 60, 0, 60)
MiniCircle.Position = UDim2.new(0.96, -70, 0.5, -30)
MiniCircle.BackgroundColor3 = Color3.fromRGB(0, 70, 140)
MiniCircle.Text = "TR"
MiniCircle.TextColor3 = Color3.new(1,1,1)
MiniCircle.TextScaled = true
MiniCircle.Font = Enum.Font.GothamBold
MiniCircle.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = MiniCircle

MiniCircle.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

-- ESP + Arrow
local function createESP(plr)
    if ESPs[plr] then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 2)
    box.Transparency = 0.6
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.AlwaysOnTop = true
    
    local nameTag = Instance.new("BillboardGui")
    nameTag.Size = UDim2.new(0, 200, 0, 50)
    nameTag.StudsOffset = Vector3.new(0, 4, 0)
    nameTag.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1,1,1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = nameTag
    
    ESPs[plr] = {box = box, nameTag = nameTag, nameLabel = nameLabel}
end

local function updateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character
            local root = char.HumanoidRootPart
            local head = char.Head
            
            if not ESPs[plr] then createESP(plr) end
            local data = ESPs[plr]
            
            -- Box
            data.box.Parent = root
            data.box.Adornee = root
            
            -- Name + Distance
            data.nameTag.Adornee = head
            local distance = (camera.CFrame.Position - root.Position).Magnitude
            data.nameLabel.Text = plr.Name .. "\n" .. math.floor(distance) .. " studs"
            
            -- Arrow Indicator (Ekranın üstünden)
            if arrowEnabled then
                if not Arrows[plr] then
                    local arrow = Instance.new("TextLabel")
                    arrow.Size = UDim2.new(0, 40, 0, 30)
                    arrow.BackgroundTransparency = 1
                    arrow.Text = "↑"
                    arrow.TextColor3 = Color3.fromRGB(255, 50, 50)
                    arrow.TextScaled = true
                    arrow.Font = Enum.Font.GothamBold
                    arrow.Parent = ScreenGui
                    Arrows[plr] = arrow
                end
                
                local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    Arrows[plr].Position = UDim2.new(0, screenPos.X - 20, 0, 20) -- Ekranın üst kısmı
                    Arrows[plr].Visible = true
                else
                    Arrows[plr].Visible = false
                end
            end
        end
    end
end

-- Temizlik
local function cleanupESP()
    for plr, data in pairs(ESPs) do
        if not (plr and plr.Character) then
            if data.box then data.box:Destroy() end
            if data.nameTag then data.nameTag:Destroy() end
            ESPs[plr] = nil
        end
    end
end

-- Ana Loop
RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
        cleanupESP()
    end
end)

print("✅ TR SCRIPTS - Silah Oyunu ESP Yüklendi! (Sürüklenebilir Menü)")

-- İlk durum
MainFrame.Visible = true
MiniCircle.Visible = true
