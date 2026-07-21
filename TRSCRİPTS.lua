-- Blox Fruits TR SCRIPTS - ESP + Auto Collect + Silent Aim
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local espEnabled = true
local autoCollect = false
local silentAimEnabled = false
local menuVisible = true

local fruitNames = {"Rocket","Spin","Blade","Spring","Bomb","Smoke","Spike","Flame","Ice","Sand","Dark","Diamond","Light","Rubber","Ghost","Magma","Quake","Buddha","Love","Spider","Sound","Phoenix","Portal","Lightning","Pain","Blizzard","Gravity","Mammoth","T-Rex","Dough","Shadow","Venom","Gas","Spirit","Tiger","Yeti","Kitsune","Control","Dragon","Chop","Kilo","Revive","Falcon"}

-- Ana GUI (Yatay)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TRScripts"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 90)  -- Yatay geniş
MainFrame.Position = UDim2.new(0.5, -310, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
Title.Text = "TR SCRIPTS"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Butonlar
local function createButton(text, posX, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = UDim2.new(0, posX, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local espBtn = createButton("ESP: AÇIK", 20, Color3.fromRGB(0, 170, 0), function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "AÇIK" or "KAPALI")
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

local autoBtn = createButton("Auto Collect: KAPALI", 170, Color3.fromRGB(170, 0, 0), function()
    autoCollect = not autoCollect
    autoBtn.Text = "Auto Collect: " .. (autoCollect and "AÇIK" or "KAPALI")
    autoBtn.BackgroundColor3 = autoCollect and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

local silentBtn = createButton("Silent Aim: KAPALI", 320, Color3.fromRGB(170, 0, 0), function()
    silentAimEnabled = not silentAimEnabled
    silentBtn.Text = "Silent Aim: " .. (silentAimEnabled and "AÇIK" or "KAPALI")
    silentBtn.BackgroundColor3 = silentAimEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

-- Küçük TR Dairesi (Gizle/Göster)
local MiniCircle = Instance.new("TextButton")
MiniCircle.Size = UDim2.new(0, 50, 0, 50)
MiniCircle.Position = UDim2.new(0.95, -60, 0.5, -25)
MiniCircle.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
MiniCircle.Text = "TR"
MiniCircle.TextColor3 = Color3.new(1,1,1)
MiniCircle.TextScaled = true
MiniCircle.Font = Enum.Font.GothamBold
MiniCircle.Parent = ScreenGui
MiniCircle.Visible = false

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = MiniCircle

-- ESP Fonksiyonları (Önceki versiyondan)
local fruitESP = {}
local function createESP(fruit)
    if fruit:FindFirstChild("FruitESP") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FruitESP"
    billboard.Adornee = fruit:FindFirstChild("Handle") or fruit.PrimaryPart
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fruit

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 215, 0)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 140, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.7
    highlight.Parent = fruit

    fruitESP[fruit] = {text = text}
end

local function updateESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Part") then
            for _, name in ipairs(fruitNames) do
                if string.find(obj.Name:lower(), name:lower()) then
                    if not obj:FindFirstChild("FruitESP") then createESP(obj) end
                    local espData = fruitESP[obj]
                    if espData then
                        local dist = (root.Position - obj:GetPivot().Position).Magnitude
                        espData.text.Text = obj.Name .. "\n📍 " .. math.floor(dist) .. " studs"
                    end
                    break
                end
            end
        end
    end
end

-- Silent Aim (Basit versiyon - yakın oyunculara yönelme)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if silentAimEnabled and method == "FireServer" and (self.Name == "ShootGun" or self.Name:find("Bullet") or args[1] == "Shoot") then
        local closest = nil
        local shortest = math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local d = (root.Position - p.Character.Head.Position).Magnitude
                if d < shortest and d < 300 then
                    shortest = d
                    closest = p.Character.Head
                end
            end
        end
        if closest then
            args[2] = closest.Position  -- Hedef pozisyonunu değiştir (oyununa göre ayarlanabilir)
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- Auto Collect Loop
spawn(function()
    while true do
        if autoCollect and root then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if (obj:IsA("Model") or obj:IsA("Part")) then
                    for _, name in ipairs(fruitNames) do
                        if string.find(obj.Name:lower(), name:lower()) then
                            local dist = (root.Position - obj:GetPivot().Position).Magnitude
                            if dist < 400 then
                                root.CFrame = obj:GetPivot() * CFrame.new(0, 4, 0)
                                wait(0.7)
                            end
                            break
                        end
                    end
                end
            end
        end
        wait(1.3)
    end
end)

-- Ana Loop
spawn(function()
    while true do
        if espEnabled and root then
            updateESP()
        end
        wait(1)
    end
end)

-- Menü Gizle/Göster
MiniCircle.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

print("✅ TR SCRIPTS Yüklendi! (Yatay Menü + Silent Aim)")

-- İlk açılışta daire gizli, menü açık
MiniCircle.Visible = true
