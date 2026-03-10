local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local GUI_ID = "FANN_PREMIUM_V4_FIXED" 
if CoreGui:FindFirstChild(GUI_ID) then CoreGui[GUI_ID]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_ID

-- [TOMBOL BULAT F]
local ToggleGui = Instance.new("TextButton", ScreenGui)
ToggleGui.Size = UDim2.new(0, 40, 0, 40)
ToggleGui.Position = UDim2.new(0, 15, 0, 60)
ToggleGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleGui.Text = "F"
ToggleGui.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGui.Font = Enum.Font.GothamBold
ToggleGui.Draggable = true
Instance.new("UICorner", ToggleGui).CornerRadius = UDim.new(1, 0)

-- [TABEL MENU]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 100)
MainFrame.Position = UDim2.new(0, 65, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

local UIList = Instance.new("UIListLayout", MainFrame)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center

ToggleGui.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleGui.Text = MainFrame.Visible and "X" or "F"
end)

-- [TOMBOL ESP]
local MainButton = Instance.new("TextButton", MainFrame)
MainButton.Size = UDim2.new(0, 140, 0, 35)
MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainButton.Text = "ESP: OFF"
MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MainButton.Font = Enum.Font.GothamMedium
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 4)
local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 1.8
Stroke.Color = Color3.fromRGB(255, 50, 50) 

-- [TOMBOL AUTO KILL]
local KillButton = Instance.new("TextButton", MainFrame)
KillButton.Size = UDim2.new(0, 140, 0, 35)
KillButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KillButton.Text = "AUTO KILL: OFF"
KillButton.TextColor3 = Color3.fromRGB(200, 200, 200)
KillButton.Font = Enum.Font.GothamMedium
Instance.new("UICorner", KillButton).CornerRadius = UDim.new(0, 4)
local KillStroke = Instance.new("UIStroke", KillButton)
KillStroke.Thickness = 1.8
KillStroke.Color = Color3.fromRGB(255, 50, 50)

local ESP_ENABLED = false
local AUTOKILL_ENABLED = false

-- [SENSOR LEMARI LEBIH PEKA]
local function IsInsideLocker(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    -- Pakai Region3 buat cek apakah di posisi dia ada objek Part lain (Lemari)
    local min = hrp.Position - Vector3.new(1.5, 2, 1.5)
    local max = hrp.Position + Vector3.new(1.5, 2, 1.5)
    local region = Region3.new(min, max)
    
    local parts = workspace:FindPartsInRegion3WithIgnoreList(region, {char, LocalPlayer.Character}, 10)
    
    for _, part in pairs(parts) do
        -- Jika part itu namanya mengandung "Locker", "Closet", "Wardrobe" atau dia sangat dekat
        if part.CanCollide == true or part.Name:lower():find("lock") or part.Name:lower():find("closet") then
            return true
        end
    end
    return false
end

local function IsKiller(player)
    local char = player.Character
    if not char then return false end
    local keywords = {"knife", "piso", "sword", "blade", "slasher", "murderer", "kill", "gun"}
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, word in pairs(keywords) do
                if tool.Name:lower():find(word) then return true end
            end
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, tool in pairs(bp:GetChildren()) do
            for _, word in pairs(keywords) do
                if tool.Name:lower():find(word) then return true end
            end
        end
    end
    return false
end

-- [LOGIKA AUTO KILL]
task.spawn(function()
    while task.wait(0.6) do
        if AUTOKILL_ENABLED and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        task.wait(0.4)
                    end
                end
            end
        end
    end
end)

local function ApplyESP(player)
    RunService.RenderStepped:Connect(function()
        local char = player.Character
        if not ESP_ENABLED or not char or not char:FindFirstChild("HumanoidRootPart") then
            if char then 
                if char:FindFirstChild("FANN_High") then char.FANN_High:Destroy() end
                if char:FindFirstChild("Head") and char.Head:FindFirstChild("FANN_Tag") then char.Head.FANN_Tag:Destroy() end
            end
            return
        end

        local killer = IsKiller(player)
        local hidden = IsInsideLocker(char)
        
        local color = Color3.fromRGB(0, 170, 255)
        local txt = player.Name
        
        if killer then
            color = Color3.fromRGB(255, 0, 0)
            txt = "⚠️ KILLER ⚠️"
        elseif hidden then
            color = Color3.fromRGB(255, 255, 0)
            txt = "BERADA DALAM LEMARI"
        end

        local high = char:FindFirstChild("FANN_High") or Instance.new("Highlight", char)
        high.Name = "FANN_High"
        high.FillColor = color
        high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- PASTI TEMBUS PANDANG

        local head = char:FindFirstChild("Head")
        if head then
            local tag = head:FindFirstChild("FANN_Tag") or Instance.new("BillboardGui", head)
            tag.Name = "FANN_Tag"
            tag.Size = UDim2.new(0, 100, 0, 50)
            tag.AlwaysOnTop = true
            tag.ExtentsOffset = Vector3.new(0, 3, 0)
            local label = tag:FindFirstChild("Label") or Instance.new("TextLabel", tag)
            label.Name = "Label"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
            label.Text = txt .. "\n[" .. dist .. "m]"
            label.TextColor3 = color
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
        end
    end)
end

MainButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    MainButton.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
    Stroke.Color = ESP_ENABLED and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 50, 50)
end)

KillButton.MouseButton1Click:Connect(function()
    AUTOKILL_ENABLED = not AUTOKILL_ENABLED
    KillButton.Text = AUTOKILL_ENABLED and "AUTO KILL: ON" or "AUTO KILL: OFF"
    KillStroke.Color = AUTOKILL_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
end)

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end
Players.PlayerAdded:Connect(ApplyESP)
