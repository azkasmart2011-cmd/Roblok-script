local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- SETTINGS
local _G = {
    AutoFishing = false,
    AutoCollect = false,
    AntiAFK = true
}

-- UI MINIMALIS (Gak menuhin layar)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 250); Main.Position = UDim2.new(0.5, -110, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "BRAINROT HELPER V1"; Title.TextColor3 = Color3.new(0, 1, 1); Title.BackgroundTransparency = 1; Title.Font = Enum.Font.SourceSansBold

-- FUNGSI TOMBOL
local function CreateBtn(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.8, 0, 0, 45); Btn.Position = pos; Btn.Text = name .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 10)
    
    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        Btn.Text = name .. (active and ": ON" or ": OFF")
        Btn.BackgroundColor3 = active and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(180, 0, 0)
        callback(active)
    end)
end

CreateBtn("AUTO FISHING", UDim2.new(0.1, 0, 0, 60), function(v) _G.AutoFishing = v end)
CreateBtn("AUTO COLLECT", UDim2.new(0.1, 0, 0, 120), function(v) _G.AutoCollect = v end)
CreateBtn("ANTI AFK", UDim2.new(0.1, 0, 0, 180), function(v) _G.AntiAFK = v end)

-- LOOP UTAMA
task.spawn(function()
    while task.wait(0.5) do
        -- 1. AUTO FISHING (Klik Layar Terus)
        if _G.AutoFishing then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                -- Auto Equip Rod
                if not char:FindFirstChildOfClass("Tool") then
                    for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if t.Name:lower():find("rod") or t.Name:lower():find("pancing") then
                            char.Humanoid:EquipTool(t); break
                        end
                    end
                end
                -- Cast (Klik)
                local view = game.Workspace.CurrentCamera.ViewportSize
                VirtualInputManager:SendMouseButtonEvent(view.X/2, view.Y/2, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(view.X/2, view.Y/2, 0, false, game, 1)
                task.wait(2) -- Jeda biar animasinya gak bug
            end
        end

        -- 2. AUTO COLLECT (Teleport ke tombol duit)
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

-- ANTI AFK
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1); VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)
