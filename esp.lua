local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local button = script.Parent -- Tombol untuk buka/tutup
local menuFrame = button.Parent:WaitForChild("MainFrame") -- Ganti "MainFrame" sesuai nama UI-mu
local toggleKey = Enum.KeyCode.RightControl -- Tombol shortcut di keyboard

local isOpen = false

-- Fungsi untuk animasi Buka/Tutup
local function toggleMenu()
    isOpen = not isOpen
    
    local targetTransparency = isOpen and 0 or 1
    local targetPosition = isOpen and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, -1, 0)

    -- Animasi perpindahan menu
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(menuFrame, tweenInfo, {
        Position = targetPosition,
        BackgroundTransparency = targetTransparency
    })
    
    menuFrame.Visible = true
    tween:Play()
    
    -- Update teks tombol
    button.Text = isOpen and "Close Menu" or "Open Menu"
end

-- Klik Tombol
button.MouseButton1Click:Connect(toggleMenu)

-- Shortcut Keyboard (Contoh: Klik Right Control)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == toggleKey then
        toggleMenu()
    end
end)
