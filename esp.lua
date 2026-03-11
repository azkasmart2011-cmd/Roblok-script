local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- [ SETTING & FLAGS ]
local FannHub = {
    AutoKill = false,
    ESP = false,
    CurrentTab = "Main"
}

-- [ FUNGSI ESP ASLI (GAK BOLEH BEDA) ]
local function ApplyESP(v)
    if v ~= Players.LocalPlayer and v.Character then
        if not v.Character:FindFirstChild("FannHighlight") then
            local h = Instance.new("Highlight")
            h.Name = "FannHighlight"
            h.FillColor = Color3.fromRGB(255, 0, 0) -- Merah berani
            h.FillTransparency = 0.5
            h.OutlineColor = Color3.new(1, 1, 1)
            h.OutlineTransparency = 0
            h.Parent = v.Character
        end
    end
end

-- [ LOGIKA AUTO KILL ]
RunService.RenderStepped:Connect(function()
    if FannHub.AutoKill then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    -- Nempel ke musuh buat bantai
                    Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    break
                end
            end
        end
    end
    
    -- Refresh ESP terus biar gak ilang pas respawn
    if FannHub.ESP then
        for _, v in pairs(Players:GetPlayers()) do ApplyESP(v) end
    end
end)

-- [ UI CONSTRUCTION - TABEL TETEP ADA ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FANN_HUB_V19_FIX"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0

-- Sidebar (Tabel Kiri)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BorderSizePixel = 0

-- Container Tab
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -130, 1, -10)
TabContainer.Position = UDim2.new(0, 125, 0, 5)
TabContainer.BackgroundTransparency = 1

-- [ TOMBOL-TOMBOL DI DALAM TAB ]

-- 1. Tombol Auto Kill (Di Tab Main)
local KillBtn = Instance.new("TextButton", TabContainer)
KillBtn.Size = UDim2.new(1, -10, 0, 45)
KillBtn.Position = UDim2.new(0, 5, 0, 10)
KillBtn.Text = "AUTO KILL (BANTAI)"
KillBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
KillBtn.TextColor3 = Color3.new(1, 1, 1)
KillBtn.Font = Enum.Font.SourceSansBold
KillBtn.TextSize = 18

KillBtn.MouseButton1Click:Connect(function()
    FannHub.AutoKill = not FannHub.AutoKill
    KillBtn.BackgroundColor3 = FannHub.AutoKill and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 0, 0)
    KillBtn.Text = FannHub.AutoKill and "AUTO KILL: ON" or "AUTO KILL: OFF"
end)

-- 2. Tombol ESP (Di Tab Main)
local ESPBtn = Instance.new("TextButton", TabContainer)
ESPBtn.Size = UDim2.new(1, -10, 0, 45)
ESPBtn.Position = UDim2.new(0, 5, 0, 65)
ESPBtn.Text = "ACTIVATE ESP"
ESPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Font = Enum.Font.SourceSansBold
ESPBtn.TextSize = 18

ESPBtn.MouseButton1Click:Connect(function()
    FannHub.ESP = not FannHub.ESP
    ESPBtn.BackgroundColor3 = FannHub.ESP and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(40, 40, 40)
    
    if not FannHub.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("FannHighlight") then
                v.Character.FannHighlight:Destroy()
            end
        end
    end
end)

-- Notif Sukses
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FANN HUB",
    Text = "V19 Fixed Loaded!",
    Duration = 3
})
