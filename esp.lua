local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Helper_Enabled = false
local Is_Clicking = false

-- DATABASE RARITY LENGKAP
local RarityTargets = {
    "SECRET", "MYTHIC", "LEGENDARY", "EXCLUSIVE", "OG", "RARE", "UNCOMMON", "COMMON"
}

-- 1. FITUR ANTI-AFK
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)

-- UI SETUP (SUPER MULUS V15)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 280) -- Tambah tinggi buat info baru
Main.Position = UDim2.new(0.5, -130, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.BackgroundTransparency = 0.1; Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)

local BgImage = Instance.new("ImageLabel", Main)
BgImage.Size = UDim2.new(1, 0, 1, 0); BgImage.Image = "rbxassetid://134015690327429" 
BgImage.BackgroundTransparency = 1; BgImage.ImageTransparency = 0.6; BgImage.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 25)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "FANN TYCOON GOD V15"; Title.TextColor3 = Color3.new(1, 1, 0)
Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

-- TOMBOL POWER
local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0.9, 0, 0, 50); Btn.Position = UDim2.new(0.05, 0, 0, 60)
Btn.Text = "GOD MODE: OFF"; Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 15)

-- STATUS KOTAK
local ResBox = Instance.new("Frame", Main)
ResBox.Size = UDim2.new(0.9, 0, 0, 140); ResBox.Position = UDim2.new(0.05, 0, 0, 120)
ResBox.BackgroundColor3 = Color3.new(0, 0, 0); ResBox.BackgroundTransparency = 0.6
Instance.new("UICorner", ResBox).CornerRadius = UDim.new(0, 15)

local Status = Instance.new("TextLabel", ResBox)
Status.Size = UDim2.new(1, 0, 1, 0); Status.Text = "Collecting & Hunting..."; Status.TextColor3 = Color3.new(1, 1, 1)
Status.TextScaled = true; Status.Font = Enum.Font.SourceSansBold; Status.BackgroundTransparency = 1

-- 2. FUNGSI AUTO COLLECT UANG (BASE)
local function AutoCollectMoney()
    -- Mencari objek bernama "Touch", "Collect", atau "Money" di sekitar base
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name:lower():find("collect") or obj.Name:lower():find("money") then
            if obj:IsA("TouchTransmitter") then
                -- Teleport kecil atau sentuh partnya
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 0)
                wait(0.01)
                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj.Parent, 1)
            end
        end
    end
end

-- FUNGSI HUNTER & CLICKER (Tetap Ada)
local function StartSpamClick()
    if Is_Clicking then return end
    Is_Clicking = true
    spawn(function()
        while Is_Clicking and Helper_Enabled do
            local vSize = game.Workspace.CurrentCamera.ViewportSize
            VirtualInputManager:SendMouseButtonEvent(vSize.X/2, vSize.Y/2, 0, true, game, 1)
            wait(0.01); VirtualInputManager:SendMouseButtonEvent(vSize.X/2, vSize.Y/2, 0, false, game, 1); wait(0.01)
        end
    end)
end

local function GodAction()
    AutoCollectMoney() -- Jalankan koleksi uang base
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextBox") then
            local txt = obj.Text:upper()
            for _, t in pairs(RarityTargets) do
                if txt:find(t) then
                    Status.Text = "MONEY & "..t.." DETECTED!"
                    
                    -- Auto Equip & Click (Logika Hunting)
                    local bp = LocalPlayer.Backpack; local char = LocalPlayer.Character
                    for _, item in pairs(bp:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:lower():find("rod") or item.Name:lower():find("pancing")) then
                            char.Humanoid:EquipTool(item)
                        end
                    end
                    
                    local part = obj:FindFirstAncestorOfClass("Part") or obj:FindFirstAncestorOfClass("MeshPart")
                    if part then
                        local pos, vis = game.Workspace.CurrentCamera:WorldToScreenPoint(part.Position)
                        if vis then
                            VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                            wait(0.05); VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
                            StartSpamClick()
                        end
                    end
                    return
                end
            end
        end
    end
    Is_Clicking = false; Status.Text = "Base Clean & Scanning..."; Status.TextColor3 = Color3.new(1, 1, 1)
end

Btn.MouseButton1Click:Connect(function()
    Helper_Enabled = not Helper_Enabled
    Btn.Text = Helper_Enabled and "TYCOON GOD: ACTIVE" or "GOD MODE: OFF"
    Btn.BackgroundColor3 = Helper_Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    if not Helper_Enabled then Is_Clicking = false end
end)

spawn(function()
    while wait(0.5) do if Helper_Enabled then GodAction() end end
end)
