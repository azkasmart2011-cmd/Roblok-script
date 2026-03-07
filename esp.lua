local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local _G = {
    AutoCollect = false,
    AntiAFK = false,
    AutoHunt = false,
    SelectedRarity = "mythic",
    MenuVisible = true
}

-- DATABASE RARITY
local Rarities = {"common", "uncommon", "rare", "mythic", "secret", "exclusive", "og"}
local rIndex = 4

-- 1. ANTI-AFK (High Reliability)
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- UI SETUP
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- TOMBOL BUKA/TUTUP (OPEN/CLOSE MENU)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 100, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Text = "TUTUP MENU"
ToggleBtn.TextColor3 = Color3.new(1, 1, 0)
ToggleBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

-- MAIN FRAME
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 400)
Main.Position = UDim2.new(0.5, -140, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)

-- BACKGROUND IMAGE
local Bg = Instance.new("ImageLabel", Main)
Bg.Size = UDim2.new(1, 0, 1, 0); Bg.Image = "rbxassetid://134015690327429"
Bg.BackgroundTransparency = 1; Bg.ImageTransparency = 0.7; Bg.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 25)

-- TOGGLE VISIBILITY LOGIC
ToggleBtn.MouseButton1Click:Connect(function()
    _G.MenuVisible = not _G.MenuVisible
    Main.Visible = _G.MenuVisible
    ToggleBtn.Text = _G.MenuVisible and "TUTUP MENU" or "BUKA MENU"
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "FANN V29 (AUTO-ROD)"; Title.TextColor3 = Color3.new(1, 1, 0)
Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

-- FUNGSI TOMBOL TOGGLE
local function CreateToggle(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40); Btn.Position = pos
    Btn.Text = name .. ": OFF"; Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 15)
    
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.Text = name .. (toggled and ": ON" or ": OFF")
        Btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(150, 0, 0)
        callback(toggled)
    end)
end

CreateToggle("AUTO COLLECT UANG", UDim2.new(0.05, 0, 0, 60), function(v) _G.AutoCollect = v end)
CreateToggle("ANTI AFK", UDim2.new(0.05, 0, 0, 110), function(v) _G.AntiAFK = v end)
CreateToggle("AUTO TELE-H
    
