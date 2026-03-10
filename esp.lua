local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Nama GUI disamarkan
local GUI_ID = "FANN_PREMIUM_UI_DISTANCE" 
if CoreGui:FindFirstChild(GUI_ID) then CoreGui[GUI_ID]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_ID

-- [TOMBOL BULAT BUKA/TUTUP]
local ToggleGui = Instance.new("TextButton", ScreenGui)
ToggleGui.Size = UDim2.new(0, 40, 0, 40)
ToggleGui.Position = UDim2.new(0, 15, 0, 60)
ToggleGui.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleGui.Text = "F"
ToggleGui.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGui.Font = Enum.Font.GothamBold
ToggleGui.TextSize = 18
ToggleGui.Draggable = true
local ToggleCorner = Instance.new("UICorner", ToggleGui)
ToggleCorner.CornerRadius = UDim.new(1, 0)

-- [TABEL MENU UTAMA]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 160, 0, 100) -- Ukuran kotak tabel
MainFrame.Position = UDim2.new(0, 65, 0, 60)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Visible = true

local FrameCorner = Instance.new("UICorner", MainFrame)
FrameCorner.CornerRadius = UDim.new(0, 6)

local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Thickness = 1.5
FrameStroke.Color = Color3.fromRGB(50, 50, 50)

local UIList = Instance.new("UIListLayout", MainFrame)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.VerticalAlignment = Enum.VerticalAlignment.Center

-- [TOMBOL ESP - KODE ASLI KAMU]
local MainButton = Instance.new("TextButton", MainFrame)
MainButton.Size = UDim2.new(0, 140, 0, 35)
MainButton.BorderSizePixel = 0
MainButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainButton.Text = "ESP: OFF"
MainButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MainButton.Font = Enum.Font.GothamMedium
MainButton.TextSize = 14
MainButton.AutoButtonColor = true

local Corner = Instance.new("UICorner", MainButton)
Corner.CornerRadius = UDim.new(0, 4)

local Stroke = Instance.new("UIStroke", MainButton)
Stroke.Thickness = 1.8
Stroke.Color = Color3.fromRGB(255, 50, 50) 
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- [TOMBOL AUTO KILL - FITUR BARU]
local KillButton = Instance.new("TextButton", MainFrame)
KillButton.Size = UDim2.new(0, 140, 0, 35)
KillButton.BorderSizePixel = 0
KillButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KillButton.Text = "AUTO KILL: OFF"
KillButton.TextColor3 = Color3.fromRGB(200, 200, 200)
KillButton.Font = Enum.Font.GothamMedium
KillButton.TextSize = 14

local KillCorner = Instance.new("UICorner", KillButton)
KillCorner.CornerRadius = UDim.new(0, 4)

local KillStroke = Instance.new("UIStroke", KillButton)
KillStroke.Thickness = 1.8
KillStroke.Color = Color3.fromRGB(255, 50, 50)

-- Variabel Status
local ESP_ENABLED = false
local AUTOKILL_ENABLED = false

-- Logika Buka/Tutup Tabel
ToggleGui.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleGui.Text = MainFrame.Visible and "X" or "F"
end)

-- [FUNGSI DETEKSI OBJEK/LEMARI]
local function IsInObject(targetChar)
    local myChar = LocalPlayer.Character
    if not myChar or not targetChar:FindFirstChild("HumanoidRootPart") then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {myChar, targetChar}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(myChar.HumanoidRootPart.Position, (targetChar.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position), params)
    return result ~= nil
end

-- [FUNGSI HAPUS SEMUA EFEK - KODE ASLI]
local function ClearAllESP(char)
    if char:FindFirstChild("FANN_High") then char.FANN_High:Destroy() end
    local head = char:FindFirstChild("Head")
    if head and head:FindFirstChild("FANN_Tag") then
        head.FANN_Tag:Destroy()
    end
end

-- [FUNGSI DETEKSI KILLER - KODE ASLI]
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

-- [LOGIKA AUTO KILL DENGAN DEFENSE]
task.spawn(function()
    while task.wait(0.8) do
        if AUTOKILL_ENABLED and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local myHrp = LocalPlayer.Character.HumanoidRootPart
                    myHrp.AssemblyLinearVelocity = Vector3.new(0,0,0) -- Defense: Bypass anti-speed
                    myHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    task.wait(0.5)
                end
                if not AUTOKILL_ENABLED then break end
            end
        end
    end
end)

-- [FUNGSI UTAMA RENDER - KODE ASLI]
local function ApplyESP(player)
    RunService.RenderStepped:Connect(function()
        local char = player.Character
        local myChar = LocalPlayer.Character
        if not ESP_ENABLED or not char or not char:FindFirstChild("HumanoidRootPart") or not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
            if char then ClearAllESP(char) end
            return
        end

        local statusKiller = IsKiller(player)
        local statusHidden = IsInObject(char)
        local color = statusKiller and Color3.fromRGB(255, 0, 0) or (statusHidden and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 170, 255))

        local high = char:FindFirstChild("FANN_High") or Instance.new("Highlight")
        high.Name = "FANN_High"
        high.Parent = char
        high.FillColor = color
        high.OutlineColor = Color3.new(1, 1, 1)
        high.FillTransparency = 0.5

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
            
            local distance = math.floor((myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
            local displayName = player.Name
            if statusKiller then displayName = "⚠️ KILLER ⚠️" 
            elseif statusHidden then displayName = "🕵️ HIDDEN 🕵️" end
            
            label.Text = displayName .. "\n[" .. distance .. "m]"
            label.TextColor3 = color
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.TextStrokeTransparency = 0.5
        end
    end)
end

-- [EVENT TOMBOL ESP - KODE ASLI]
MainButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    MainButton.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
    MainButton.TextColor3 = ESP_ENABLED and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    Stroke.Color = ESP_ENABLED and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 50, 50)
    if not ESP_ENABLED then
        for _, p in pairs(Players:GetPlayers()) do if p.Character then ClearAllESP(p.Character) end end
    end
end)

-- [EVENT TOMBOL AUTO KILL]
KillButton.MouseButton1Click:Connect(function()
    AUTOKILL_ENABLED = not AUTOKILL_ENABLED
    KillButton.Text = AUTOKILL_ENABLED and "AUTO KILL: ON" or "AUTO KILL: OFF"
    KillButton.TextColor3 = AUTOKILL_ENABLED and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    KillStroke.Color = AUTOKILL_ENABLED and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
end)

-- [INISIALISASI - KODE ASLI]
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then ApplyESP(p) end
end
Players.PlayerAdded:Connect(ApplyESP)
