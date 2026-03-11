local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- [ DATABASE ]
local FannHub = {
    AutoKill = false,
    ESP = false,
    Visible = true
}

-- [ FUNGSI ESP TEMBUS LEMARI (ASLI KEMARIN) ]
local function ApplyESP(v)
    if v ~= Players.LocalPlayer and v.Character then
        -- Logika deteksi Highlight (Tetap nempel meski di dalam lemari/objek)
        local h = v.Character:FindFirstChild("FannHighlight") or Instance.new("Highlight")
        h.Name = "FannHighlight"
        h.Parent = v.Character
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- INI KUNCINYA (TEMBUS LEMARI)

        -- Warna Merah (Killer), Biru (Biasa)
        if v.Backpack:FindFirstChild("Knife") or v.Character:FindFirstChild("Knife") or v.Backpack:FindFirstChild("Weapon") then
            h.FillColor = Color3.fromRGB(255, 0, 0)
        else
            h.FillColor = Color3.fromRGB(0, 0, 255)
        end
    end
end

-- [ LOOPING AKTIF ]
RunService.RenderStepped:Connect(function()
    if FannHub.AutoKill then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    break
                end
            end
        end
    end
    
    if FannHub.ESP then
        for _, v in pairs(Players:GetPlayers()) do ApplyESP(v) end
    end
end)

-- [ UI CONSTRUCTION - SISTEM TAB ]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FannHub_V19_CabinetCheck"

-- Tombol Open/Close
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 60, 0, 35)
Toggle.Position = UDim2.new(0, 10, 0.4, 0)
Toggle.Text = "MENU"
Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Toggle)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "FANN HUB"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

local TabBtn = Instance.new("TextButton", Sidebar)
TabBtn.Size = UDim2.new(1, -10, 0, 40)
TabBtn.Position = UDim2.new(0, 5, 0, 60)
TabBtn.Text = "Main Menu"
TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TabBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TabBtn)

-- Container Fitur
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -145, 1, -20)
Content.Position = UDim2.new(0, 140, 0, 10)
Content.BackgroundTransparency = 1

-- Tombol Auto Kill
local KillBtn = Instance.new("TextButton", Content)
KillBtn.Size = UDim2.new(1, 0, 0, 50)
KillBtn.Text = "AUTO KILL: OFF"
KillBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KillBtn.TextColor3 = Color3.new(1, 1, 1)
KillBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", KillBtn)

-- Tombol ESP
local ESPBtn = Instance.new("TextButton", Content)
ESPBtn.Size = UDim2.new(1, 0, 0, 50)
ESPBtn.Position = UDim2.new(0, 0, 0, 60)
ESPBtn.Text = "ESP (CABINET CHECK): OFF"
ESPBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", ESPBtn)

-- [ EVENT HANDLER ]
Toggle.MouseButton1Click:Connect(function()
    FannHub.Visible = not FannHub.Visible
    MainFrame.Visible = FannHub.Visible
end)

KillBtn.MouseButton1Click:Connect(function()
    FannHub.AutoKill = not FannHub.AutoKill
    KillBtn.Text = "AUTO KILL: " .. (FannHub.AutoKill and "ON" or "OFF")
    KillBtn.BackgroundColor3 = FannHub.AutoKill and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(45, 45, 45)
end)

ESPBtn.MouseButton1Click:Connect(function()
    FannHub.ESP = not FannHub.ESP
    ESPBtn.Text = "ESP: " .. (FannHub.ESP and "ON" or "OFF")
    ESPBtn.BackgroundColor3 = FannHub.ESP and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(45, 45, 45)
    if not FannHub.ESP then
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("FannHighlight") then
                v.Character.FannHighlight:Destroy()
            end
        end
    end
end)
