local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS AWAL
local ESP_Active = false

-- 1. PEMBUATAN TOMBOL ON/OFF (SIMPEL DI POJOK)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local ToggleBtn = Instance.new("TextButton", ScreenGui)

ToggleBtn.Size = UDim2.new(0, 100, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10) -- Pojok kiri atas
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah (OFF)
ToggleBtn.Text = "ESP: OFF"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 18

-- Bikin sudut tombol agak mulus dikit
local Corner = Instance.new("UICorner", ToggleBtn)
Corner.CornerRadius = UDim.new(0, 8)

-- 2. LOGIKA TOMBOL
ToggleBtn.MouseButton1Click:Connect(function()
    ESP_Active = not ESP_Active
    if ESP_Active then
        ToggleBtn.Text = "ESP: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Hijau (ON)
    else
        ToggleBtn.Text = "ESP: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah (OFF)
    end
end)

-- 3. FUNGSI ESP (BOX & NAMA)
local function ApplyESP(Player)
    local function CreateESP()
        if Player == LocalPlayer then return end
        
        -- Kotak ESP (Highlight)
        local Highlight = Instance.new("Highlight")
        Highlight.Name = "ESP_Highlight"
        Highlight.FillTransparency = 0.5
        Highlight.OutlineColor = Color3.new(1, 1, 1) -- Garis Putih
        
        -- Nama Pemain
        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "ESP_Name"
        Billboard.Size = UDim2.new(0, 100, 0, 30)
        Billboard.AlwaysOnTop = true
        Billboard.ExtentsOffset = Vector3.new(0, 3, 0) -- Di atas kepala
        
        local Label = Instance.new("TextLabel", Billboard)
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.Text = Player.Name
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.SourceSansBold
        Label.TextSize = 14
        Label.TextStrokeTransparency = 0
        
        -- Loop Update
        RunService.RenderStepped:Connect(function()
            if ESP_Active and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                Highlight.Parent = Player.Character
                Billboard.Parent = Player.Character.HumanoidRootPart
                Billboard.Adornee = Player.Character.HumanoidRootPart
            else
                Highlight.Parent = nil
                Billboard.Parent = nil
            end
        end)
    end
    
    Player.CharacterAdded:Connect(CreateESP)
    if Player.Character then CreateESP() end
end

-- Jalankan untuk semua pemain
for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)
