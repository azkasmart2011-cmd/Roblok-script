local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI UTAMA
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- 1. TOMBOL BUKA/TUTUP (MULUS)
local Toggle = Instance.new("TextButton", ScreenGui)
Toggle.Size = UDim2.new(0, 100, 0, 35)
Toggle.Position = UDim2.new(0, 15, 0, 15)
Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Toggle.Text = "MENU"
Toggle.TextColor3 = Color3.fromRGB(0, 255, 255)
Toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)
local TStroke = Instance.new("UIStroke", Toggle)
TStroke.Color = Color3.fromRGB(0, 255, 255)
TStroke.Thickness = 1.5

-- 2. PANEL MENU (KOTAK MULUS)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 200)
Main.Position = UDim2.new(0.5, -120, 0.5, -100)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true -- Biar bisa digeser

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
local MStroke = Instance.new("UIStroke", Main)
MStroke.Color = Color3.fromRGB(0, 255, 150) -- Hijau Neon
MStroke.Thickness = 2

-- FUNGSI BUKA TUTUP
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- JUDUL
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "FISHZAR NEW"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- TOMBOL FITUR (CONTOH DASAR)
local function AddButton(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Position = pos
    Btn.Text = name .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    
    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        Btn.Text = name .. (active and ": ON" or ": OFF")
        Btn.BackgroundColor3 = active and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(30, 30, 30)
        callback(active)
    end)
end

-- Masukkan fungsi di sini
AddButton("AUTO FISH", UDim2.new(0.05, 0, 0, 60), function(v)
    print("Auto Fish is now:", v)
end)

AddButton("AUTO COLLECT", UDim2.new(0.05, 0, 0, 110), function(v)
    print("Auto Collect is now:", v)
end)
