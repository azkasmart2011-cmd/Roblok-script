local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS AWAL
local _G = {
    AutoCollect = false,
    AntiAFK = false,
    AutoHunt = false,
    SelectedRarity = "mythic"
}

-- 1. DATABASE LENGKAP (HURUF KECIL UNTUK SISTEM)
local Rarities = {"secret", "mythic", "legendary", "exclusive", "og", "rare", "common"}
local rIndex = 2 -- Mulai dari Mythic

-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        wait(0.2)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- UI SETUP (SUPER MULUS V23)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.BackgroundTransparency = 0.1; Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)

local Bg = Instance.new("ImageLabel", Main)
Bg.Size = UDim2.new(1, 0, 1, 0); Bg.Image = "rbxassetid://134015690327429"
Bg.BackgroundTransparency = 1; Bg.ImageTransparency = 0.7; Bg.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 25)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "FANN ALL-RARITY V23"; Title.TextColor3 = Color3.new(1, 1, 0)
Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

-- FUNGSI TOMBOL ON/OFF
local function CreateToggle(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40); Btn.Position = pos
    Btn.Text = name .. ": OFF"; Btn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
    Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 15)
    
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.Text = name .. (toggled and ": ON" or ": OFF")
        Btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 140, 0) or Color3.fromRGB(160, 0, 0)
        callback(toggled)
    end)
end

CreateToggle("AUTO COLLECT", UDim2.new(0.05, 0, 0, 60), function(v) _G.AutoCollect = v end)
CreateToggle("ANTI AFK", UDim2.new(0.05, 0, 0, 110), function(v) _G.AntiAFK = v end)
CreateToggle("AUTO HUNT (TELE)", UDim2.new(0.05, 0, 0, 160
        
