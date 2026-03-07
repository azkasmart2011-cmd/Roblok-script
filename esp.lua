local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS INITIAL (Default Off)
local _G = {
    AutoCollect = false,
    AntiAFK = false,
    AutoHunt = false,
    SelectedRarity = "SECRET" -- Default target
}

-- 1. FUNGSI ANTI-AFK
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        wait(0.2)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- UI SETUP (SUPER MULUS & TABEL PILIHAN)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 350)
Main.Position = UDim2.new(0.5, -140, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)

-- BACKGROUND IMAGE
local Bg = Instance.new("ImageLabel", Main)
Bg.Size = UDim2.new(1, 0, 1, 0); Bg.Image = "rbxassetid://134015690327429"
Bg.BackgroundTransparency = 1; Bg.ImageTransparency = 0.7; Bg.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 25)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45); Title.Text = "FANN CONTROL V19"; Title.TextColor3 = Color3.new(1, 1, 0)
Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 20

-- FUNGSI BUAT TOMBOL (REUSABLE)
local function CreateToggle(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Position = pos
    Btn.Text = name .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)
    
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.Text = name .. (toggled and ": ON" or ": OFF")
        Btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(180, 0, 0)
        callback(toggled)
    end)
end

-- TOMBOL-TOMBOL FITUR
CreateToggle("AUTO COLLECT", UDim2.new(0.05, 0, 0, 55), function(v) _G.AutoCollect = v end)
CreateToggle("ANTI AFK", UDim2.new(0.05, 0, 0, 105), function(v) _G.AntiAFK = v end)
CreateToggle("AUTO HUNT", UDim2.new(0.05, 0, 0, 155), function(v) _G.AutoHunt = v end)

-- 2. SELECT RARITY (DROPDOWN/CYCLE)
local RarityBtn = Instance.new("TextButton", Main)
local Rarities = {"SECRET", "MYTHIC", "LEGENDARY", "RARE", "COMMON"}
local rIndex = 1

RarityBtn.Size = UDim2.new(0.9, 0, 0, 45)
RarityBtn.Position = UDim2.new(0.05, 0, 0, 215)
RarityBtn.Text = "TARGET: " .. Rarities[rIndex]
RarityBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RarityBtn.TextColor3 = Color3.new(1, 1, 0)
RarityBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", RarityBtn).CornerRadius = UDim.new(0, 12)

RarityBtn.MouseButton1Click:Connect(function()
    rIndex = rIndex + 1
    if rIndex > #Rarities then rIndex = 1 end
    _G.SelectedRarity = Rarities[rIndex]
    RarityBtn.Text = "TARGET: " .. _G.SelectedRarity
end)

-- STATUS KOTAK KECIL
local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(0.9, 0, 0, 50); Status.Position = UDim2.new(0.05, 0, 0, 275)
Status.BackgroundColor3 = Color3.new(0,0,0); Status.BackgroundTransparency = 0.5
Status.Text = "Menunggu..."; Status.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 10)

-- LOOP LOGIC
spawn(function()
    while wait(0.5) do
        -- 1. Auto Collect Money
        if _G.AutoCollect then
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if (obj.Name:lower():find("collect") or obj.Name:lower():find("money")) and obj:IsA("TouchTransmitter") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 0)
                    wait(0.01); firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 1)
                end
            end
        end

        -- 2. Auto Hunt Selected Rarity
        if _G.AutoHunt then
            for _, obj in pairs(game:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Text:upper():find(_G.SelectedRarity) then
                    Status.Text = "Target Found: " .. _G.SelectedRarity
                    -- (Auto Equip & Click logic)
                    local part = obj:FindFirstAncestorOfClass("Part") or obj:FindFirstAncestorOfClass("MeshPart")
                    if part then
                        local pos, vis = game.Workspace.CurrentCamera:WorldToScreenPoint(part.Position)
                        if vis then
                            VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                            wait(0.05); VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
                        end
                    end
                end
            end
        end
    end
end)
