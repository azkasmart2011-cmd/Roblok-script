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

-- ANTI-AFK
LocalPlayer.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

-- UI SETUP (OPEN/CLOSE)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 100, 0, 35); ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); ToggleBtn.Text = "TUTUP MENU"; ToggleBtn.TextColor3 = Color3.new(1, 1, 0)
ToggleBtn.Font = Enum.Font.SourceSansBold; Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 280, 0, 400); Main.Position = UDim2.new(0.5, -140, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)

ToggleBtn.MouseButton1Click:Connect(function()
    _G.MenuVisible = not _G.MenuVisible
    Main.Visible = _G.MenuVisible; ToggleBtn.Text = _G.MenuVisible and "TUTUP MENU" or "BUKA MENU"
end)

local function CreateToggle(name, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.9, 0, 0, 40); Btn.Position = pos; Btn.Text = name .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0); Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 15)
    local toggled = false
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Btn.Text = name .. (toggled and ": ON" or ": OFF"); Btn.BackgroundColor3 = toggled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(170, 0, 0); callback(toggled)
    end)
end

CreateToggle("AUTO COLLECT UANG", UDim2.new(0.05, 0, 0, 60), function(v) _G.AutoCollect = v end)
CreateToggle("ANTI AFK", UDim2.new(0.05, 0, 0, 110), function(v) _G.AntiAFK = v end)
CreateToggle("AUTO TELE-HUNT", UDim2.new(0.05, 0, 0, 160), function(v) _G.AutoHunt = v end)

local RarityBtn = Instance.new("TextButton", Main)
RarityBtn.Size = UDim2.new(0.9, 0, 0, 45); RarityBtn.Position = UDim2.new(0.05, 0, 0, 215); RarityBtn.Text = "TARGET: " .. Rarities[rIndex]:upper()
RarityBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); RarityBtn.TextColor3 = Color3.new(0, 1, 1); Instance.new("UICorner", RarityBtn).CornerRadius = UDim.new(0, 15)

RarityBtn.MouseButton1Click:Connect(function()
    rIndex = rIndex + 1; if rIndex > #Rarities then rIndex = 1 end
        
