local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Nama GUI disamarkan
local GUI_ID = "FANN_PREMIUM_UI" 
if CoreGui:FindFirstChild(GUI_ID) then CoreGui[GUI_ID]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_ID

-- DESAIN TOMBOL KOTAK MULUS
local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 140, 0, 40)
MainButton.Position = UDim2.new(0, 60, 0, 60)
MainButton.BorderSizePixel = 0
MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Hitam pekat modern
MainButton.Text = "ESP: OFF"
MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MainButton.Font = Enum.Font.GothamMedium
MainButton.TextSize = 14
MainButton.AutoButtonColor = true

-- UICorner untuk efek kotak mulus (Bukan bulat banget)
local Corner = Instance.new("UICorner", MainButton)
Corner.CornerRadius = UDim.new(0, 4) -- Radius kecil biar kotak tapi nggak tajam

-- Stroke (Garis tepi) agar lebih tegas
local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(255, 50, 50) -- Merah pas awal (OFF)
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ESP_ENABLED = false

-- FUNGSI DETEKSI KILLER
local function IsKiller(player)
    local char = player.Character
    if not char then return false end
    
    -- Cek Tool & Nama Rahasia
    local items = {char, player:FindFirstChild("Backpack")}
    local keywords = {"knife", "piso", "sword", "blade", "slasher", "murderer", "kill", "gun"}
    
    for _, loc in pairs(items) do
        if loc then
            for _, tool in pairs(loc:GetChildren()) do
                if tool:IsA("Tool") or tool:IsA("Model") then -- Deteksi Model jika dev pakai custom system
                    for _, word in pairs(keywords) do
                        if tool.Name:lower():find(word) then return true end
                    end
                end
            end
        end
    end
    return false
end

-- FUNGSI ESP
local function ApplyESP(player)
    RunService.RenderStepped:Connect(function()
        local char = player.Character
        if not ESP_ENABLED or not char or not char:FindFirstChild("HumanoidRootPart") then
            if char and char:FindFirstChild("FANN_High") then char.FANN_High:Destroy() end
            return
        end

        local statusKiller = IsKiller(player)
        local color = statusKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 170, 255)

        -- Highlight
        local high = char:FindFirstChild("FANN_High") or Instance.new("Highlight")
        high.Name = "FANN_High"
        high.Parent = char
        high.FillColor = color
        high.OutlineColor = Color3.new(1, 1, 1)
        high.FillTransparency = 0.5

        -- Tag Jarak
        local head = char:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("FANN_Tag") or Instance.new("BillboardGui", head)
            tag.Name = "FANN_Tag"
            tag.Size = UDim2.new(0, 100, 0, 50)
            tag.AlwaysOnTop = true
            tag.ExtentsOffset = Vector3.new(0, 3, 0)

            local label = tag:FindFirstChild("Label") or Instance.new("TextLabel", tag)
            label.Name = "Label"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = statusKiller and "⚠️ KILLER ⚠️" or player.Name
            label.TextColor3 = color
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
        end
    end)
end

-- LOGIKA TOMBOL
MainButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    if ESP_ENABLED then
        MainButton.Text = "ESP: ON"
        MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        Stroke.Color = Color3.fromRGB(0, 200, 255) -- Biru mulus saat nyala
    else
        MainButton.Text = "ESP: OFF"
        MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        Stroke.Color = Color3.fromRGB(255, 50, 50) -- Merah saat mati
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then 
                if p.Character:FindFirstChild("FANN_High") then p.Character.FANN_High:Destroy() end
            end
        end
    end
end)

-- Inisialisasi
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then ApplyESP(p) end
end
Players.PlayerAdded:Connect(ApplyESP)
