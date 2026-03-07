local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESP_Enabled = false
local Helper_Enabled = false

-- 1. SETUP UI (Panel Menu)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GameHelperMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0, 15, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa kamu geser di layar
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Judul Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "MENU HELPER"
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- --- FITUR 1: ESP ---
local EspLabel = Instance.new("TextLabel")
EspLabel.Size = UDim2.new(0, 100, 0, 30)
EspLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
EspLabel.Text = "ESP"
EspLabel.Font = Enum.Font.SourceSansBold
EspLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
EspLabel.TextXAlignment = Enum.TextXAlignment.Left
EspLabel.BackgroundTransparency = 1
EspLabel.Parent = MainFrame

local EspBtn = Instance.new("TextButton")
EspBtn.Size = UDim2.new(0, 80, 0, 25)
EspBtn.Position = UDim2.new(0.55, 0, 0.32, 0)
EspBtn.Text = "OFF"
EspBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.Font = Enum.Font.SourceSansBold
EspBtn.Parent = MainFrame

-- --- FITUR 2: GAME LANJUT KATA ---
local GameLabel = Instance.new("TextLabel")
GameLabel.Size = UDim2.new(0, 120, 0, 30)
GameLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
GameLabel.Text = "Game Lanjut Kata"
GameLabel.Font = Enum.Font.SourceSansBold
GameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameLabel.BackgroundTransparency = 1
GameLabel.Parent = MainFrame

local GameBtn = Instance.new("TextButton")
GameBtn.Size = UDim2.new(0, 80, 0, 25)
GameBtn.Position = UDim2.new(0.55, 0, 0.62, 0)
GameBtn.Text = "OFF"
GameBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
GameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GameBtn.Font = Enum.Font.SourceSansBold
GameBtn.Parent = MainFrame

-- 2. LOGIKA FITUR
local function applyESP(char, p)
    local h = char:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
    h.Name = "ESPHighlight"
    h.Parent = char
    h.Enabled = ESP_Enabled
    
    local head = char:WaitForChild("Head", 5)
    if head then
        local bill = char:FindFirstChild("ESPName") or Instance.new("BillboardGui")
        bill.Name = "ESPName"
        bill.Adornee = head
        bill.Size = UDim2.new(0, 100, 0, 30)
        bill.AlwaysOnTop = true
        bill.Enabled = ESP_Enabled
        bill.Parent = char
        local lab = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel")
        lab.BackgroundTransparency = 1; lab.Size = UDim2.new(1,0,1,0)
        lab.Text = p.Name; lab.TextColor3 = Color3.new(1,1,1)
        lab.TextStrokeTransparency = 0; lab.TextScaled = true; lab.Parent = bill
    end
end

-- Tombol ESP Click
EspBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    EspBtn.Text = ESP_Enabled and "ON" or "OFF"
    EspBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight.Enabled = ESP_Enabled end
            if p.Character:FindFirstChild("ESPName") then p.Character.ESPName.Enabled = ESP_Enabled end
        end
    end
end)

-- Tombol Game Lanjut Kata Click
GameBtn.MouseButton1Click:Connect(function()
    Helper_Enabled = not Helper_Enabled
    GameBtn.Text = Helper_Enabled and "ON" or "OFF"
    GameBtn.BackgroundColor3 = Helper_Enabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    
    if Helper_Enabled then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Game Lanjut Kata",
            Text = "Fitur Aktif! Siap menebak kata.",
            Duration = 3
        })
    end
end)

-- Inisialisasi Player
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        if p.Character then applyESP(p.Character, p) end
        p.CharacterAdded:Connect(function(c) applyESP(c, p) end)
    end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(c) task.wait(1); applyESP(c, p) end)
end)
