-- Project Name: FANN (Toggle Version)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variabel status (Default: OFF)
local isRunning = false

-- 1. MEMBUAT UI TOMBOL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FANN_Menu"
screenGui.Parent = CoreGui -- Agar tidak hilang saat mati

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 50)
toggleBtn.Position = UDim2.new(0, 10, 0.5, 0) -- Posisi di kiri tengah
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Merah (OFF)
toggleBtn.Text = "FANN: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

-- 2. FUNGSI TOGGLE
toggleBtn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleBtn.Text = "FANN: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Hijau (ON)
    else
        toggleBtn.Text = "FANN: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        -- Bersihkan highlight saat OFF
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                if p.Character:FindFirstChild("FANN_Tag") then p.Character.FANN_Tag:Destroy() end
                if p.Character:FindFirstChild("FANN_Highlight") then p.Character.FANN_Highlight:Destroy() end
            end
        end
    end
end)

-- 3. LOGIKA DETEKSI (Hanya jalan jika isRunning == true)
RunService.RenderStepped:Connect(function()
    if not isRunning then return end
    
    local localPlayer = Players.LocalPlayer
    local localRoot = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local root = char.HumanoidRootPart
            
            local tag = char:FindFirstChild("FANN_Tag")
            local hl = char:FindFirstChild("FANN_Highlight")
            
            -- Jika belum ada tag/highlight, buat baru
            if not tag or not hl then
                -- Buat Tag
                local folder = Instance.new("BillboardGui", char)
                folder.Name = "FANN_Tag"
                folder.Size = UDim2.new(0, 150, 0, 50)
                folder.Adornee = char.Head
                folder.AlwaysOnTop = true
                folder.ExtentsOffset = Vector3.new(0, 3, 0)
                
                local text = Instance.new("TextLabel", folder)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.TextStrokeTransparency = 0
                
                -- Buat Highlight
                hl = Instance.new("Highlight", char)
                hl.Name = "FANN_Highlight"
            else
                -- Update Jarak dan Warna
                local dist = localRoot and math.floor((root.Position - localRoot.Position).Magnitude) or 0
                local holdsTool = char:FindFirstChildOfClass("Tool")
                
                if holdsTool then
                    tag.TextLabel.Text = "KILLER [" .. dist .. "m]"
                    tag.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                else
                    tag.TextLabel.Text = "SURVIVOR [" .. dist .. "m]"
                    tag.TextLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
                    hl.FillColor = Color3.fromRGB(0, 170, 255)
                end
            end
        end
    end
end)
