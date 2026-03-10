local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local GUI_ID = "FANN_PREMIUM_UI_ULTIMATE" 
if CoreGui:FindFirstChild(GUI_ID) then CoreGui[GUI_ID]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_ID

-- [TABEL MENU BIAR RAPI]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 160, 0, 100)
MainFrame.Position = UDim2.new(0, 60, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
local UIList = Instance.new("UIListLayout", MainFrame)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center

-- [TOMBOL ESP - KODE ASLI]
local MainButton = Instance.new("TextButton", MainFrame)
MainButton.Size = UDim2.new(0, 140, 0, 35)
MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainButton.Text = "ESP: OFF"
MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MainButton.Font = Enum.Font.GothamMedium
MainButton.TextSize = 14
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 4)
local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 1.8
Stroke.Color = Color3.fromRGB(255, 50, 50) 

-- [TOMBOL AUTO KILL - BALIK LAGI]
local KillButton = Instance.new("TextButton", MainFrame)
KillButton.Size = UDim2.new(0, 140, 0, 35)
KillButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KillButton.Text = "AUTO KILL: OFF"
KillButton.TextColor3 = Color3.fromRGB(200, 200, 200)
KillButton.Font = Enum.Font.GothamMedium
KillButton.TextSize = 14
Instance.new("UICorner", KillButton).CornerRadius = UDim.new(0, 4)
local KillStroke = Instance.new("UIStroke", KillButton)
KillStroke.Thickness = 1.8
KillStroke.Color = Color3.fromRGB(255, 50, 50)

local ESP_ENABLED = false
local AUTOKILL_ENABLED = false

-- [FITUR DETEKSI LEMARI CERDAS]
local function CheckInsideLocker(targetChar)
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {targetChar}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local directions = {Vector3.new(0, 0, 2), Vector3.new(0, 0, -2), Vector3.new(2, 0, 0), Vector3.new(-2, 0, 0)}
    local hitCount = 0
    for _, dir in pairs(directions) do
        local result = workspace:Raycast(hrp.Position, dir, rayParams)
        if result and result.Instance:IsA("BasePart") and result.Distance < 2.5 then
            hitCount = hitCount + 1
        end
    end
    return hitCount >= 2 
end

-- [LOGIKA AUTO KILL - SAFE MODE]
task.spawn(function()
    while task.wait(0.7) do
        if AUTOKILL_ENABLED and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local myHrp = LocalPlayer.Character.HumanoidRootPart
                        myHrp.AssemblyLinearVelocity = Vector3.new(0,0,0) -- Anti-cheat bypass
                        myHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        task.wait(0.5)
                    end
                end
                if not AUTOKILL_ENABLED then break end
            end
        end
    end
end)

local function IsKiller(player)
    local char = player.Character
    if not char then return false end
    local items = {char, player:FindFirstChild("Backpack")}
    local keywords = {"knife", "piso", "sword", "blade", "slasher", "murderer", "kill", "gun"}
    for _, loc in pairs(items) do
        if loc then
            for _, tool in pairs(loc:GetChildren()) do
                if tool:IsA("Tool") or tool:IsA("Model") then
                    for _, word in pairs(keywords) do
                        if tool.Name:lower():find(word) then return true end
                    end
                end
            end
        end
    end
    return false
end

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

        local statusKiller = IsKiller(player)
        local statusInLocker = CheckInsideLocker(char)
        
        local color = Color3.fromRGB(0, 170, 255) -- Default Biru
        local labelText = player.Name
        
        if statusKiller then
            color = Color3.fromRGB(255, 0, 0) -- Merah
            labelText = "⚠️ KILLER ⚠️"
        elseif statusInLocker then
            color = Color3.fromRGB(255, 255, 0) -- Kuning
            labelText = "BERADA DALAM LEMARI"
        end

        local high = char:FindFirstChild("FANN_High") or Instance.new("Highlight", char)
        high.Name = "FANN_High"
        high.FillColor = color
        high.FillTransparency = 0.5
        high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- TEMBUS PANDANG X-RAY

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
            
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local dist = myHrp and math.floor((myHrp.Position - char.HumanoidRootPart.Position).Magnitude) or 0
            
            label.Text = labelText .. "\n[" .. dist .. "m]"
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
