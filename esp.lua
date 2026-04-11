-- Project Name: FANN (Killer Detector Only)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local isRunning = false

-- 1. TOMBOL ON/OFF
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "FANN_Detector"

local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 130, 0, 50)
btn.Position = UDim2.new(0, 10, 0.5, 0)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.Text = "DETECTOR: OFF"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)

btn.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    btn.Text = isRunning and "DETECTOR: ON" or "DETECTOR: OFF"
    btn.BackgroundColor3 = isRunning and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(50, 50, 50)
    
    -- Bersihkan efek saat dimatikan
    if not isRunning then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                if p.Character:FindFirstChild("FANN_Tag") then p.Character.FANN_Tag:Destroy() end
                if p.Character:FindFirstChild("FANN_Highlight") then p.Character.FANN_Highlight:Destroy() end
            end
        end
    end
end)

-- 2. LOGIKA DETEKSI KHUSUS PEMEGANG PISAU
RunService.RenderStepped:Connect(function()
    if not isRunning then return end
    
    local lp = Players.LocalPlayer
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
            local char = p.Character
            -- Cek apakah ada Tool (Pisau) di tangan karakter
            local holdsKnife = char:FindFirstChildOfClass("Tool")
            
            if holdsKnife then
                -- Jika pegang pisau, kasih tanda Merah
                local tag = char:FindFirstChild("FANN_Tag") or Instance.new("BillboardGui", char)
                if not char:FindFirstChild("FANN_Tag") then
                    tag.Name = "FANN_Tag"
                    tag.Size = UDim2.new(0, 100, 0, 40)
                    tag.Adornee = char.Head
                    tag.AlwaysOnTop = true
                    tag.ExtentsOffset = Vector3.new(0, 3, 0)
                    local txt = Instance.new("TextLabel", tag)
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.fromRGB(255, 0, 0)
                    txt.TextStrokeTransparency = 0
                    txt.Text = "⚠️ KILLER ⚠️"
                end
                
                local hl = char:FindFirstChild("FANN_Highlight") or Instance.new("Highlight", char)
                if not char:FindFirstChild("FANN_Highlight") then
                    hl.Name = "FANN_Highlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.FillOpacity = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            else
                -- Jika tidak pegang pisau, hapus efek (biar normal)
                if char:FindFirstChild("FANN_Tag") then char.FANN_Tag:Destroy() end
                if char:FindFirstChild("FANN_Highlight") then char.FANN_Highlight:Destroy() end
            end
        end
    end
end)
