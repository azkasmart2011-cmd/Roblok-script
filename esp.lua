local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- HAPUS MENU LAMA
if CoreGui:FindFirstChild("FANN_ESP_KNIFE") then
    CoreGui.FANN_ESP_KNIFE:Destroy()
end

-- SETUP UI MENU
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FANN_ESP_KNIFE"

local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 160, 0, 45)
MainButton.Position = UDim2.new(0, 50, 0, 50)
MainButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainButton.Text = "FANN ESP: OFF"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Font = Enum.Font.GothamBold
MainButton.TextSize = 14
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", MainButton)
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Thickness = 2

local ESP_ENABLED = false

-- FUNGSI CEK PISAU
local function HasKnife(player)
    local char = player.Character
    local backpack = player:FindFirstChild("Backpack")
    
    -- Ganti "Knife" dengan nama tool pisau di game yang kamu mainkan (misal: "Slasher", "Dagger")
    local knifeName = "Knife" 
    
    if char and char:FindFirstChild(knifeName) then return true end
    if backpack and backpack:FindFirstChild(knifeName) then return true end
    
    return false
end

-- FUNGSI HAPUS EFEK
local function ClearESP(char)
    if char:FindFirstChild("FANN_Highlight") then char.FANN_Highlight:Destroy() end
    local head = char:FindFirstChild("Head")
    if head and head:FindFirstChild("FANN_Tag") then
        head.FANN_Tag:Destroy()
    end
end

-- FUNGSI UTAMA ESP
local function CreateESP(player)
    RunService.RenderStepped:Connect(function()
        local char = player.Character
        if not ESP_ENABLED or not char or not char:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if char then ClearESP(char) end
            return
        end

        -- Tentukan Warna (Merah jika punya pisau, Biru jika tidak)
        local isHazard = HasKnife(player)
        local targetColor = isHazard and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 120, 255)
        local labelText = isHazard and "[MEMBERBAHAYAKAN]" or ""

        -- 1. HIGHLIGHT
        local high = char:FindFirstChild("FANN_Highlight") or Instance.new("Highlight")
        high.Name = "FANN_Highlight"
        high.Parent = char
        high.FillColor = targetColor
        high.OutlineColor = Color3.fromRGB(255, 255, 255)
        high.FillTransparency = 0.5

        -- 2. NAME TAG
        local head = char:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("FANN_Tag") or Instance.new("BillboardGui", head)
            tag.Name = "FANN_Tag"
            tag.Size = UDim2.new(0, 120, 0, 60)
            tag.AlwaysOnTop = true
            tag.ExtentsOffset = Vector3.new(0, 3.5, 0)

            local label = tag:FindFirstChild("Label") or Instance.new("TextLabel", tag)
            label.Name = "Label"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
            
            -- Update Teks (Nama + Jarak + Status Pisau)
            label.Text = player.Name .. "\n[" .. dist .. "m]\n" .. labelText
            label.TextColor3 = targetColor
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.TextStrokeTransparency = 0.5
        end
    end)
end

-- TOMBOL AKTIVASI
MainButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    if ESP_ENABLED then
        MainButton.Text = "FANN ESP: ON"
        UIStroke.Color = Color3.fromRGB(0, 150, 255)
        MainButton.TextColor3 = Color3.fromRGB(0, 150, 255)
    else
        MainButton.Text = "FANN ESP: OFF"
        UIStroke.Color = Color3.fromRGB(255, 50, 50)
        MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then ClearESP(p.Character) end
        end
    end
end)

-- SCANNING
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    CreateESP(p)
end)
