local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- SETTINGS
local _G = {
    AutoHunt = false,
    AutoCollect = false,
    SelectedRarity = "mythic",
    IsFishing = false
}

local Rarities = {"common", "uncommon", "rare", "mythic", "secret", "exclusive", "og"}
local rIndex = 4

-- UI CLEAN & PRO
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 320); Main.Position = UDim2.new(0.5, -120, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45); Title.Text = "FISHZAR V3 REBORN"; Title.TextColor3 = Color3.new(0, 1, 0.5)
Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 18

-- FUNGSI TOGGLE PRO
local function CreateBtn(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 45); Btn.Position = pos; Btn.Text = name .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 12)
    local t = false
    Btn.MouseButton1Click:Connect(function()
        t = not t; Btn.Text = name .. (t and ": ON" or ": OFF")
        Btn.BackgroundColor3 = t and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(30, 30, 30)
        callback(t)
    end)
end

CreateBtn("AUTO TELE-HUNT", UDim2.new(0.05, 0, 0, 60), function(v) _G.AutoHunt = v end)
CreateBtn("AUTO COLLECT CASH", UDim2.new(0.05, 0, 0, 120), function(v) _G.AutoCollect = v end)

-- RARITY SELECTOR
local RarityBtn = Instance.new("TextButton", Main)
RarityBtn.Size = UDim2.new(0.9, 0, 0, 45); RarityBtn.Position = UDim2.new(0.05, 0, 0, 180)
RarityBtn.Text = "TARGET: " .. Rarities[rIndex]:upper()
RarityBtn.BackgroundColor3 = Color3.fromRGB(45, 0, 90); RarityBtn.TextColor3 = Color3.new(1, 1, 1); RarityBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RarityBtn).CornerRadius = UDim.new(0, 12)

RarityBtn.MouseButton1Click:Connect(function()
    rIndex = rIndex + 1; if rIndex > #Rarities then rIndex = 1 end
    _G.SelectedRarity = Rarities[rIndex]; RarityBtn.Text = "TARGET: " .. _G.SelectedRarity:upper()
end)

local Status = Instance.new("TextLabel", Main)
Status.Size = UDim2.new(0.9, 0, 0, 40); Status.Position = UDim2.new(0.05, 0, 0, 240); Status.Text = "READY"; Status.TextColor3 = Color3.new(0.7, 0.7, 0.7); Status.BackgroundTransparency = 1; Status.Font = Enum.Font.Gotham

-- SYSTEM FISHZAR LOGIC
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoHunt and not _G.IsFishing then
            for _, v in pairs(game:GetDescendants()) do
                if (v:IsA("TextLabel") or v:IsA("TextBox")) and v.Text:lower():find(_G.SelectedRarity) then
                    local p = v:FindFirstAncestorOfClass("Part") or v:FindFirstAncestorOfClass("MeshPart")
                    if p then
                        _G.IsFishing = true
                        Status.Text = "LOCKED: " .. _G.SelectedRarity:upper()
                        
                        -- 1. FORCE EQUIP
                        local char = LocalPlayer.Character
                        if not char:FindFirstChildOfClass("Tool") then
                            for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                                if t.Name:lower():find("rod") or t.Name:lower():find("pancing") then
                                    char.Humanoid:EquipTool(t); break
                                end
                            end
                        end

                        -- 2. TELEPORT KE DEPAN IKAN
                        char.HumanoidRootPart.CFrame = p.CFrame * CFrame.new(0, 8, 8)
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Position)
                        task.wait(0.3)
                        
                        -- 3. SMART CLICK (Center Screen)
                        local view = Camera.ViewportSize
                        VirtualInputManager:SendMouseButtonEvent(view.X/2, view.Y/2, 0, true, game, 1)
                        task.wait(1.0) -- Tahan klik lemparan
                        VirtualInputManager:SendMouseButtonEvent(view.X/2, view.Y/2, 0, false, game, 1)
                        
                        task.wait(4) -- Waktu tunggu narik ikan
                        _G.IsFishing = false
                        break
                    end
                end
            end
            if not _G.IsFishing then Status.Text = "SCANNING..." end
        end

        -- AUTO COLLECT (TELE-COLLECTOR)
        if _G.AutoCollect then
            for _, o in pairs(game.Workspace:GetDescendants()) do
                if (o.Name:lower():find("collect") or o.Name:lower():find("money")) and o:IsA("BasePart") then
                    if (LocalPlayer.Character.HumanoidRootPart.Position - o.Position).Magnitude < 100 then
                        local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                        LocalPlayer.Character.HumanoidRootPart.CFrame = o.CFrame
                        task.wait(0.2)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
                        break
                    end
                end
            end
        end
    end
end)
