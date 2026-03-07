local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function CreateESP(Player)
    -- Membuat Highlight (Kotak Tembus Pandang)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "ESP_Highlight"
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0
    Highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Warna Isi (Merah)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Warna Garis (Putih)

    -- Membuat Nama di Atas Kepala
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESP_Name"
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.Adornee = nil
    Billboard.AlwaysOnTop = true
    Billboard.ExtentsOffset = Vector3.new(0, 3, 0)

    local NameLabel = Instance.new("TextLabel", Billboard)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.Text = Player.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextStrokeTransparency = 0
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextSize = 14

    -- Update Posisi & Cek Karakter
    RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Highlight.Parent = Player.Character
            Billboard.Parent = Player.Character.HumanoidRootPart
            Billboard.Adornee = Player.Character.HumanoidRootPart
        else
            Highlight.Parent = nil
            Billboard.Parent = nil
        end
    end)
end

-- Jalankan untuk semua pemain yang masuk
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then CreateESP(p) end
end)
