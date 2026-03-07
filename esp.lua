local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function ESP(player)
    if player ~= LocalPlayer then
        local function applyESP(char)
            -- 1. Tambahkan Highlight (Warna Tubuh)
            local h = char:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
            h.Name = "ESPHighlight"
            h.Parent = char
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.5

            -- 2. Tambahkan Nama di Atas Kepala
            local head = char:WaitForChild("Head", 5)
            if head then
                local bill = Instance.new("BillboardGui")
                bill.Name = "ESPName"
                bill.Adornee = head
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.StudsOffset = Vector3.new(0, 2, 0) -- Posisi di atas kepala
                bill.AlwaysOnTop = true
                bill.Parent = char

                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = player.Name
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0 -- Agar ada bayangan hitam di teksnya
                label.TextScaled = true
                label.Parent = bill
            end
        end

        -- Jalankan saat karakter muncul
        player.CharacterAdded:Connect(applyESP)
        
        -- Jalankan jika karakter sudah ada
        if player.Character then
            applyESP(player.Character)
        end
    end
end

-- Setup awal untuk semua player
for _, v in pairs(Players:GetPlayers()) do
    ESP(v)
end

Players.PlayerAdded:Connect(ESP)
