local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- SETTINGS
local _G = {
    AutoHunt = false,
    AutoCollect = false,
    SelectedRarity = "mythic"
}

local Rarities = {"common", "uncommon", "rare", "mythic", "secret", "exclusive", "og"}
local rIndex = 4

-- UI SETUP
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 320); Main.Position = UDim2.new(0.5, -120, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45); Title.Text = "BRAINROT V2 (RARITY)"; Title.TextColor3 = Color3.new(1, 1, 0); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold

-- TOMBOL TOGGLE
local function CreateBtn(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 45); Btn.Position = pos; Btn.Text = name .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0); Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    local t = false
    Btn.MouseButton1Click:Connect(function()
        t = not t; Btn.Text = name .. (t and ": ON" or ": OFF")
        Btn.BackgroundColor3 = t and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(170, 0, 0)
        callback(t)
    end)
end

CreateBtn("AUTO TELE-HUNT", UDim2.new(0.05, 0, 0, 55), function(v) _G.AutoHunt = v end)
CreateBtn("AUTO COLLECT", UDim2.new(0.05, 0, 0, 110), function(v) _G.AutoCollect = v end)

-- TOMBOL PILIH RARITY
local RarityBtn = Instance.new("TextButton", Main)
RarityBtn.Size = UDim2.new(0.9, 0, 0, 45); RarityBtn.Position = UDim2.new(0.05, 0, 0, 165)
RarityBtn.Text = "TARGET: " .. Rarities[rIndex]:upper()
RarityBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); RarityBtn.TextColor3 = Color3.new(0, 1, 1); RarityBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", RarityBtn).CornerRadius = UDim.new(0, 10)

RarityBtn.MouseButton1Click:Connect(function()
    rIndex = rIndex + 1; if rIndex > #Rarities then rIndex = 1 end
    _G.SelectedRarity = Rarities[rIndex]; RarityBtn.Text = "TARGET: " .. _G.SelectedRarity:upper()
end)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(0.9, 0, 0, 40); Status.Position = UDim2.new(0.05, 0, 0, 220); Status.Text = "WAITING..."; Status.TextColor3 = Color3.new(1,1,1); Status.BackgroundTransparency = 1

-- LOOP CORE
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoHunt then
            local found = false
            for _, obj in pairs(game:GetDescendants()) do
                if (obj:IsA("TextLabel") or obj:IsA("TextBox")) and obj.Text:lower():find(_G.SelectedRarity) then
                    local part = obj:FindFirstAncestorOfClass("Part") or obj:FindFirstAncestorOfClass("MeshPart")
                    if part then
                        found = true
                        Status.Text = "SNIPING: " .. _G.SelectedRarity:upper()
                        
                        -- 1. AUTO EQUIP
                        local char = LocalPlayer.Character
                        if not char:FindFirstChildOfClass("Tool") then
                            for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                                if t.Name:lower():find("rod") or t.Name:lower():find("pancing") then
                                    char.Humanoid:EquipTool(t); break
                                end
                            end
                        end

                        -- 2. TELEPORT + FOCUS
                        char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 6, 8)
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                        task.wait(0.3)
                        
                        -- 3. AUTO CAST (HOLD CLICK)
                        local view = Camera.ViewportSize
                        VirtualInputManager:SendMouseButtonEvent(view.X/2, view.Y/2, 0, true, game, 1)
                        task.wait(0.8)
                        VirtualInputManager:SendMouseButtonEvent(view.X/2, view.Y/2, 0, false, game, 1)
                        
                        task.wait(3) -- Jeda antar lemparan
                        break
                    end
                end
            end
            if not found then Status.Text = "SCANNING " .. _G.SelectedRarity:upper() end
        end

        -- AUTO COLLECT (TELEPORT MONEY)
        if _G.AutoCollect then
            for _, o in pairs(game.Workspace:GetDescendants()) do
                if (o.Name:lower():find("collect") or o.Name:lower():find("money")) and o:IsA("BasePart") then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - o.Position).Magnitude < 100 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = o.CFrame
                        task.wait(0.1)
                        break
                    end
                end
            end
        end
    end
end)
