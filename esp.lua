local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Nama Rahasia agar tidak mudah di-track developer dengan game:GetService("CoreGui"):FindFirstChild()
local GUI_NAME = "System_Internal_Buffer" 

if CoreGui:FindFirstChild(GUI_NAME) then
    CoreGui[GUI_NAME]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_NAME

-- UI Toggle
local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 160, 0, 45)
MainButton.Position = UDim2.new(0, 50, 0, 50)
MainButton.Text = "SYSTEM: READY"
MainButton.Draggable = true -- Bisa digeser kalau menutupi UI game

local ESP_ENABLED = false

-- FUNGSI PENDETEKSI PISAU (TAHAN PATCH)
local function IsDangerous(player)
    -- Mencari di karakter (sedang dipegang) dan di penyimpanan
    local locations = {player.Character, player:FindFirstChildOfClass("Backpack")}
    
    for _, loc in pairs(locations) do
        if loc then
            -- Cari semua objek yang bertipe "Tool"
            for _, item in pairs(loc:GetChildren()) do
                if item:IsA("Tool") then
                    -- Cek berdasarkan kata kunci (case insensitive) atau properti tertentu
                    local name = item.Name:lower()
                    if name:find("knife") or name:find("sword") or name:find("blade") or item:FindFirstChild("Slasher") then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- FUNGSI RECURSIVE UNTUK MENEMUKAN BAGIAN TUBUH (Jika R6/R15 diubah)
local function GetRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function CreateESP(player)
    RunService.RenderStepped:Connect(function()
        local char = player.Character
        local myChar = LocalPlayer.Character
        
        if not ESP_ENABLED or not char or not GetRoot(char) or not myChar or not GetRoot(myChar) then
            if char then 
                if char:FindFirstChild("FANN_Highlight") then char.FANN_Highlight:Destroy() end
            end
            return
        end

        -- Logika Warna
        local color = IsDangerous(player) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 150, 255)

        -- Highlight (Gunakan pcall agar jika error tidak menghentikan seluruh script)
        pcall(function()
            local high = char:FindFirstChild("FANN_Highlight") or Instance.new("Highlight")
            high.Name = "FANN_Highlight"
            high.Parent = char
            high.FillColor = color
            high.OutlineTransparency = 0
            high.FillTransparency = 0.5
        end)
    end)
end

-- AUTO-RECONNECT
Players.PlayerAdded:Connect(CreateESP)
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end

MainButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    MainButton.Text = ESP_ENABLED and "ESP: ACTIVE" or "ESP: READY"
    MainButton.TextColor3 = ESP_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)
