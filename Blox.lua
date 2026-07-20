-- Blox Fruits Fruit ESP + Distance + Auto Collect by Grok
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local espEnabled = true
local autoCollect = false
local fruitESP = {}

local fruitNames = {"Rocket","Spin","Blade","Spring","Bomb","Smoke","Spike","Flame","Ice","Sand","Dark","Diamond","Light","Rubber","Ghost","Magma","Quake","Buddha","Love","Spider","Sound","Phoenix","Portal","Lightning","Pain","Blizzard","Gravity","Mammoth","T-Rex","Dough","Shadow","Venom","Gas","Spirit","Tiger","Yeti","Kitsune","Control","Dragon","Chop","Kilo","Revive","Falcon"}

-- GUI Menu
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitESPMenu"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 220)
Frame.Position = UDim2.new(0.5, -140, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "🍎 Blox Fruits Fruit ESP"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Parent = Frame

local ToggleESP = Instance.new("TextButton")
ToggleESP.Size = UDim2.new(0.9, 0, 0, 35)
ToggleESP.Position = UDim2.new(0.05, 0, 0.25, 0)
ToggleESP.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleESP.Text = "ESP: AÇIK"
ToggleESP.TextColor3 = Color3.new(1,1,1)
ToggleESP.TextScaled = true
ToggleESP.Parent = Frame

local ToggleAuto = Instance.new("TextButton")
ToggleAuto.Size = UDim2.new(0.9, 0, 0, 35)
ToggleAuto.Position = UDim2.new(0.05, 0, 0.45, 0)
ToggleAuto.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
ToggleAuto.Text = "Auto Collect: KAPALI"
ToggleAuto.TextColor3 = Color3.new(1,1,1)
ToggleAuto.TextScaled = true
ToggleAuto.Parent = Frame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.9, 0, 0, 35)
CloseBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "Menüyü Kapat"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Parent = Frame

-- ESP Oluşturma
local function createESP(fruit)
    if fruit:FindFirstChild("FruitESP") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "FruitESP"
    billboard.Adornee = fruit:FindFirstChild("Handle") or fruit.PrimaryPart or fruit:FindFirstChildWhichIsA("BasePart")
    billboard.Size = UDim2.new(0, 250, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fruit

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
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

    fruitESP[fruit] = {billboard = billboard, text = text}
end

-- Update ESP + Distance
local function updateESP()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("Part")) then
            for _, name in ipairs(fruitNames) do
                if string.find(obj.Name:lower(), name:lower()) then
                    if not obj:FindFirstChild("FruitESP") then
                        createESP(obj)
                    end
                    
                    local espData = fruitESP[obj]
                    if espData and espData.text then
                        local distance = (root.Position - obj:GetPivot().Position).Magnitude
                        espData.text.Text = obj.Name .. "\n📍 " .. math.floor(distance) .. " studs"
                    end
                    break
                end
            end
        end
    end
end

-- Auto Collect
local function autoCollectFunc()
    while autoCollect do
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("Part")) then
                for _, name in ipairs(fruitNames) do
                    if string.find(obj.Name:lower(), name:lower()) then
                        local dist = (root.Position - obj:GetPivot().Position).Magnitude
                        if dist < 500 then  -- 500 studs içinde ise
                            root.CFrame = obj:GetPivot() * CFrame.new(0, 5, 0)
                            wait(0.8)
                            -- Pickup denemesi (oyun mekaniklerine göre değişebilir)
                            if obj:FindFirstChild("Handle") then
                                firetouchinterest(root, obj.Handle, 0)
                                wait(0.1)
                                firetouchinterest(root, obj.Handle, 1)
                            end
                        end
                        break
                    end
                end
            end
        end
        wait(1.5)
    end
end

-- Butonlar
ToggleESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleESP.Text = "ESP: " .. (espEnabled and "AÇIK" or "KAPALI")
    ToggleESP.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
end)

ToggleAuto.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    ToggleAuto.Text = "Auto Collect: " .. (autoCollect and "AÇIK" or "KAPALI")
    ToggleAuto.BackgroundColor3 = autoCollect and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    if autoCollect then
        spawn(autoCollectFunc)
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    autoCollect = false
end)

-- Ana Loop
spawn(function()
    while true do
        if espEnabled and character and character:FindFirstChild("HumanoidRootPart") then
            root = character.HumanoidRootPart
            updateESP()
        end
        wait(1.2)
    end
end)

print("✅ Fruit ESP + Distance + Auto Collect Yüklendi!")
