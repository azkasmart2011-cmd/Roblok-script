-- Script ESP Survive the Killer (Updated Detection)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP_Enabled = false

-- UI Tombol (Sama seperti sebelumnya)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FannTracker"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0.5, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.Text = "ESP: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
toggleBtn.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleBtn

-- Fungsi Deteksi Role Killer yang Lebih Akurat
local function checkIsKiller(player)
    -- Cara 1: Cek dari folder Role (Umum di STK)
    local role = player:FindFirstChild("Role") or player:FindFirstChild("Status")
    if role and (role.Value == "Killer" or role.Value == "The Killer") then
        return true
    end

    -- Cara 2: Cek apakah ada senjata Killer di karakter
    if player.Character and (player.Character:FindFirstChild("Knife") or player.Character:FindFirstChild("Weapon")) then
        return true
    end
    
    -- Cara 3: Cek Backpack (Jika killer belum memegang pisaunya)
    if player.Backpack:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Weapon") then
        return true
    end

    return false
end

local function createESP(player)
    if player == LocalPlayer then return end

    local function setupESP(character)
        local head = character:WaitForChild("Head", 10)
        if not head then return end
        
        if head:FindFirstChild("KillerESP") then head.KillerESP:Destroy() end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "KillerESP"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.Adornee = head
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = head
        billboard.Enabled = ESP_Enabled

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = billboard

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not billboard or not billboard.Parent then
                connection:Disconnect()
                return
            end

            billboard.Enabled = ESP_Enabled

            if ESP_Enabled and character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
                
                -- Gunakan fungsi deteksi baru
                local isKiller = checkIsKiller(player)
                
                if isKiller then
                    label.TextColor3 = Color3.fromRGB(255, 0, 0) -- Merah
                    label.Text = string.format("⚠️ KILLER ⚠️\n%s\n[%.1fm]", player.Name, distance)
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

toggleBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    toggleBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    toggleBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
end)

for _, player in pairs(Players:GetPlayers()) do createESP(player) end
Players.PlayerAdded:Connect(createESP)
