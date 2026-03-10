local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Nama GUI disamarkan
local GUI_ID = "FANN_PREMIUM_UI_DISTANCE" 
if CoreGui:FindFirstChild(GUI_ID) then CoreGui[GUI_ID]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_ID

-- DESAIN TOMBOL KOTAK MULUS
local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 140, 0, 40)
MainButton.Position = UDim2.new(0, 60, 0, 60)
MainButton.BorderSizePixel = 0
MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainButton.Text = "ESP: OFF"
MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MainButton.Font = Enum.Font.GothamMedium
MainButton.TextSize = 14
MainButton.AutoButtonColor = true

local Corner = Instance.new("UICorner", MainButton)
Corner.CornerRadius = UDim.new(0, 4) -- Efek Kotak Mulus

local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 1.8
Stroke.Color = Color3.fromRGB(255, 50, 50) -- Merah saat OFF
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ESP_ENABLED = false

-- FUNGSI HAPUS SEMUA EFEK
local function ClearAllESP(char)
    if char:FindFirstChild("FANN_High") then char.FANN_High:Destroy() end
    local head = char:FindFirstChild("Head")
    if head and head:FindFirstChild("FANN_Tag") then
        head.FANN_Tag:Destroy()
    end
end

-- FUNGSI DETEKSI KILLER
local function IsKiller(player)
    local char = player.Character
    if not char then return false end
    
    local items = {char, player:FindFirstChild("Backpack")}
    local keywords = {"knife", "piso", "sword", "blade", "slasher", "murderer", "kill", "gun"}
    
    for _, loc in pairs(items) do
        if loc then
            for _, tool in pairs(loc:GetChildren()) do
                if tool:IsA("Tool") or tool:IsA("Model") then
                    for _, word in pairs(keywords) do
                        if tool.Name:lower():find(word) then return true end
                    end
                end
            end
        end
    end
    return false
end

-- FUNGSI UTAMA RENDER
local function ApplyESP(player)
    RunService.RenderStepped:Connect(function()
        local char = player.Character
        local myChar = LocalPlayer.Character
        
        -- Jika ESP OFF atau player tidak valid, bersihkan layar
        if not ESP_ENABLED or not char or not char:FindFirstChild("HumanoidRootPart") or not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
            if char then ClearAllESP(char) end
            return
        end

        local statusKiller = IsKiller(player)
        local color = statusKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 170, 255)

        -- 1. HIGHLIGHT (BODY GLOW)
        local high = char:FindFirstChild("FANN_High") or Instance.new("Highlight")
        high.Name = "FANN_High"
        high.Parent = char
        high.FillColor = color
        high.OutlineColor = Color3.new(1, 1, 1)
        high.FillTransparency = 0.5

        -- 2. NAME TAG & JARAK (Hanya muncul saat ON)
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
            
            -- HITUNG JARAK REAL-TIME
            local distance = math.floor((myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
            
            -- Format Teks: [Nama/Status] + [Jarak]
            local displayName = statusKiller and "⚠️ KILLER ⚠️" or player.Name
            label.Text = displayName .. "\n[" .. distance .. "m]"
            
            label.TextColor3 = color
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.TextStrokeTransparency = 0.5
        end
    end)
end

-- LOGIKA TOMBOL ON/OFF
MainButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    
    if ESP_ENABLED then
        MainButton.Text = "ESP: ON"
        MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        Stroke.Color = Color3.fromRGB(0, 200, 255) -- Biru saat ON
    else
        MainButton.Text = "ESP: OFF"
        MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        Stroke.Color = Color3.fromRGB(255, 50, 50) -- Merah saat OFF
        
        -- Hapus semua tag seketika saat dimatikan
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then ClearAllESP(p.Character) end
        end
    end
end)

-- Inisialisasi Player
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then ApplyESP(p) end
end
Players.PlayerAdded:Connect(ApplyESP)
