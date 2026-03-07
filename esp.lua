local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- SETTINGS
local _G = {
    AutoCollect = false,
    AntiAFK = false,
    AutoHunt = false,
    SelectedRarity = "mythic",
    MenuVisible = true
}

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

-- UI SETUP (TETAP MULUS & ADA TOMBOL BUKA/TUTUP)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 100, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); ToggleBtn.Text = "TUTUP MENU"; ToggleBtn.TextColor3 = Color3.new(1, 1, 0)
ToggleBtn.Font = Enum.Font.SourceSansBold; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 400); Main.Position = UDim2.new(0.5, -140, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)

local Bg = Instance.new("ImageLabel", Main)
Bg.Size = UDim2.new(1, 0, 1, 0); Bg.Image = "rbxassetid://134015690327429"; Bg.BackgroundTransparency = 1; Bg.ImageTransparency = 0.7; Bg.ScaleType = Enum.ScaleType.Crop; Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 25)

ToggleBtn.MouseButton1Click:Connect(function()
    _G.MenuVisible = not _G.MenuVisible
    Main.Visible = _G.MenuVisible; ToggleBtn.Text = _G.MenuVisible and "TUTUP MENU" or "BUKA MENU"
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "FANN V30 (CAST FIX)"; Title.TextColor3 = Color3.new(1, 1, 0); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18

local function CreateToggle(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40); Btn.Position = pos; Btn.Text = name .. ": OFF"; Btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0); Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 15)
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.Text = name .. (toggled and ": ON" or ": OFF"); Btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(150, 0, 0); callback(toggled)
    end)
end

CreateToggle("AUTO COLLECT UANG", UDim2.new(0.05, 0, 0, 60), function(v) _G.AutoCollect = v end)
CreateToggle("ANTI AFK", UDim2.new(0.05, 0, 0, 110), function(v) _G.AntiAFK = v end)
CreateToggle("AUTO TELE-HUNT", UDim2.new(0.05, 0, 0, 160), function(v) _G.AutoHunt = v end)

local RarityBtn = Instance.new("TextButton", Main)
RarityBtn.Size = UDim2.new(0.9, 0, 0, 45); RarityBtn.Position = UDim2.new(0.05, 0, 0, 215); RarityBtn.Text = "TARGET: " .. Rarities[rIndex]:upper(); RarityBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); RarityBtn.TextColor3 = Color3.new(0, 1, 1); Instance.new("UICorner", RarityBtn).CornerRadius = UDim.new(0, 15)

RarityBtn.MouseButton1Click:Connect(function()
    rIndex = rIndex + 1; if rIndex > #Rarities then rIndex = 1 end
    _G.SelectedRarity = Rarities[rIndex]; RarityBtn.Text = "TARGET: " .. _G.SelectedRarity:upper()
end)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(0.9, 0, 0, 50); Status.Position = UDim2.new(0.05, 0, 0, 275); Status.BackgroundColor3 = Color3.new(0,0,0); Status.BackgroundTransparency = 0.6; Status.Text = "READY"; Status.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 12)

-- LOOP UTAMA (SISTEM MANCING SAKTI)
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoHunt then
            local targetFound = false
            for _, obj in pairs(game:GetDescendants()) do
                if (obj:IsA("TextLabel") or obj:IsA("TextBox")) and obj.Text:lower():find(_G.SelectedRarity) then
                    local part = obj:FindFirstAncestorOfClass("Part") or obj:FindFirstAncestorOfClass("MeshPart")
                    if part then
                        targetFound = true
                        Status.Text = "BLING TO: " .. _G.SelectedRarity:upper()
                        
                        -- 1. AUTO EQUIP ROD
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("Humanoid") then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if not tool or (not tool.Name:lower():find("rod") and not tool.Name:lower():find("pancing")) then
                                for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                                    if t.Name:lower():find("rod") or t.Name:lower():find("pancing") then
                                        char.Humanoid:EquipTool(t); task.wait(0.3); break
                                    end
                                end
                            end
                        end

                        -- 2. TELEPORT + FOCUS KAMERA
                        char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 5, 5) -- Jarak sedikit biar pancingan bisa dilempar
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position) -- Kamera liat ke target
                        task.wait(0.2)
                        
                        -- 3. AUTO CAST (KLIK TAHAN)
                        local pos = Camera:WorldToScreenPoint(part.Position)
                        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1) -- Tekan (Hold)
                        task.wait(0.6) -- Tahan setengah detik biar melempar
                        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1) -- Lepas
                        
                        task.wait(1.5) -- Tunggu bentar sebelum cek lagi biar gak spam
                        break
                    end
                end
            end
            if not targetFound then Status.Text = "MENCARI " .. _G.SelectedRarity:upper() end
        end

        -- AUTO COLLECT UANG (Hanya jalan kalau gak lagi hunt)
        if _G.AutoCollect and not targetFound then
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if (obj.Name:lower():find("collect") or obj.Name:lower():find("giver")) and obj:IsA("BasePart") then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude < 50 then
                        local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                        LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                        task.wait(0.2); LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos; break
                    end
                end
            end
        end
    end
end)
