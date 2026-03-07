local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function ESP(player)
    if player ~= LocalPlayer then
        local function applyESP(char)
            -- 1. Tambahkan Highlight (Warna Tubuh)
            local h = char:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
            h.Name = "ESPHighlight"
            h.Parent = char
            h.FillColor = Color3.fromRGB(255, 0, 0) -- Merah
            h.OutlineColor = Color3.fromRGB(255, 255, 255) -- Putih
            h.FillTransparency = 0.5
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Tembus pandang tembok

            -- 2. Tambahkan Nama di Atas Kepala
            local head = char:WaitForChild("Head", 10)
            if head then
                -- Hapus yang lama kalau ada biar tidak tumpuk
                if char:FindFirstChild("ESPName") then char.ESPName:Destroy() end
                
                local bill = Instance.new("BillboardGui")
                bill.Name = "ESPName"
                bill.Adornee = head
                bill.Size = UDim2.new(0, 100, 0, 30)
                bill.StudsOffset = Vector3.new(0, 3, 0)
                bill.AlwaysOnTop = true
                bill.Parent = char

                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = player.Name
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0 -- Garis tepi hitam di teks
                label.TextScaled = true
                label.Font = Enum.Font.SourceSansBold
                label.Parent = bill
            end
        end

        -- Pantau saat karakter muncul/reset
        player.CharacterAdded:Connect(applyESP)
        if player.Character then
            applyESP(player.Character)
        end
    end
end

-- Jalankan untuk semua player di server
for _, v in pairs(Players:GetPlayers()) do
    ESP(v)
end

Players.PlayerAdded:Connect(ESP)
print("ESP Berhasil Dijalankan!")
