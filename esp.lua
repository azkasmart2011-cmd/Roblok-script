local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local GUI_ID = "FANN_PREMIUM_UI_DISTANCE" 
if CoreGui:FindFirstChild(GUI_ID) then CoreGui[GUI_ID]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_ID

local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 140, 0, 40)
MainButton.Position = UDim2.new(0, 60, 0, 60)
MainButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainButton.Text = "ESP: OFF"
MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MainButton.Font = Enum.Font.GothamMedium
MainButton.TextSize = 14
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 4)
local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 1.8
Stroke.Color = Color3.fromRGB(255, 50, 50) 

local ESP_ENABLED = false

-- FITUR PINTAR: Deteksi Lemari vs Tembok Biasa
local function CheckInsideLocker(targetChar)
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    -- Sensor laser ke 4 arah (Depan, Belakang, Kiri, Kanan)
    -- Jika di sekelilingnya ada objek sangat dekat, berarti dia di dalam lemari
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {targetChar}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local directions = {
        Vector3.new(0, 0, 2), Vector3.new(0, 0, -2), 
        Vector3.new(2, 0, 0), Vector3.new(-2, 0, 0)
    }
    
    local hitCount = 0
    for _, dir in pairs(directions) do
        local result = workspace:Raycast(hrp.Position, dir, rayParams)
        if result and result.Instance:IsA("BasePart") then
            hitCount = hitCount + 1
        end
    end
    
    -- Jika terdeteksi objek rapat di sekelilingnya, itu lemari
    return hitCount >= 2 
end

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
        
        -- LOGIKA WARNA:
        -- 1. Merah (Killer)
        -- 2. Kuning (Dalam Lemari)
        -- 3. Biru (Normal/Dalam Rumah/Luar)
        local color = Color3.fromRGB(0, 170, 255)
        local labelText = player.Name
        
        if statusKiller then
            color = Color3.fromRGB(255, 0, 0)
            labelText = "⚠️ KILLER ⚠️"
        elseif statusInLocker then
            color = Color3.fromRGB(255, 255, 0)
            labelText = "BERADA DALAM LEMARI"
        end

        local high = char:FindFirstChild("FANN_High") or Instance.new("Highlight", char)
        high.Name = "FANN_High"
        high.FillColor = color
        high.FillTransparency = 0.5
        high.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Tetap tembus pandang

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

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then ApplyESP(p) end end
Players.PlayerAdded:Connect(ApplyESP)
