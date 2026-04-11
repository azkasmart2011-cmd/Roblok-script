-- Script ESP Survive the Killer dengan Tombol On/Off
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP_Enabled = false -- Status awal mati

-- 1. Membuat UI Tombol
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillerTrackerGui"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0.5, 0) -- Posisi di kiri tengah layar
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.Text = "ESP: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Parent = screenGui

-- Membuat sudut tombol melengkung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleBtn

-- 2. Fungsi Utama ESP
local function createESP(player)
    if player == LocalPlayer then return end

    local function setupESP(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        
        -- Hapus ESP lama jika ada
        if head:FindFirstChild("KillerESP") then head.KillerESP:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "KillerESP"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = head
        billboard.Enabled = ESP_Enabled -- Mengikuti status tombol

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = billboard

        -- Koneksi Update
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not billboard or not billboard.Parent then
                connection:Disconnect()
                return
            end

            billboard.Enabled = ESP_Enabled -- Update visibility berdasarkan tombol

            if ESP_Enabled and character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                
                -- Deteksi Killer (Cek folder 'Role' atau item Knife)
                local isKiller = character:FindFirstChild("Knife") or player:FindFirstChild("IsKiller")
                
                if isKiller then
                    label.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah
                    label.Text = string.format("[KILLER] %s\n%.1fm", player.Name, distance)
                else
                    label.TextColor3 = Color3.fromRGB(0, 170, 255) -- Biru
                    label.Text = string.format("%s\n%.1fm", player.Name, distance)
                end
            end
        end)
    end

    player.CharacterAdded:Connect(setupESP)
    if player.Character then setupESP(player.Character) end
end

-- 3. Inisialisasi & Logika Tombol
toggleBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    
    if ESP_Enabled then
        toggleBtn.Text = "ESP: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Hijau saat aktif
    else
        toggleBtn.Text = "ESP: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Merah saat mati
    end
end)

-- Jalankan untuk semua pemain
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end
Players.PlayerAdded:Connect(createESP)
