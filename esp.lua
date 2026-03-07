local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Helper_Enabled = false
local Is_Minimized = false

local UniversalBrain = {
    ["a"] = {"Antariksa", "Ambisi"}, ["b"] = {"Bakwan", "Bahari"},
    ["c"] = {"Cahaya", "Cerdas"}, ["d"] = {"Dinamis", "Dahsyat"},
    ["ng"] = {"Ngantuk", "Ngebut"}, ["ny"] = {"Nyanyi", "Nyaman"}
}

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 240) -- Ukuran lebih tinggi biar tombol gak ketutup
Main.Position = UDim2.new(0.5, -130, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true

-- LENGKUNGAN (SMOOTH CORNER)
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 20) -- Bikin ujung melengkung mulus

-- FOTO BACKGROUND (Foto Cewek Berkerudung)
local BgImage = Instance.new("ImageLabel", Main)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Image = "rbxassetid://134015690327429" -- PASTIKAN ID INI BENAR
BgImage.BackgroundTransparency = 1
BgImage.ImageTransparency = 0.5
BgImage.ScaleType = Enum.ScaleType.Crop
local ImgCorner = Instance.new("UICorner", BgImage)
ImgCorner.CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50); Title.Text = "FANN ULTIMATE"; Title.TextColor3 = Color3.new(1, 1, 0)
Title.BackgroundTransparency = 1; Title.TextSize = 22; Title.Font = Enum.Font.SourceSansBold

-- TOMBOL ON/OFF (Ditaruh di atas kotak jawaban)
local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0.9, 0, 0, 45); Btn.Position = UDim2.new(0.05, 0, 0, 60)
Btn.Text = "AI DETECT: OFF"; Btn.BackgroundColor3 = Color3.new(0.7, 0, 0)
Btn.TextColor3 = Color3.new(1, 1, 1); Btn.Font = Enum.Font.SourceSansBold
local BtnCorner = Instance.new("UICorner", Btn)
BtnCorner.CornerRadius = UDim.new(0, 12)

-- KOTAK JAWABAN (Lengkung & Transparan)
local ResBox = Instance.new("Frame", Main)
ResBox.Size = UDim2.new(0.9, 0, 0, 100); ResBox.Position = UDim2.new(0.05, 0, 0, 115)
ResBox.BackgroundColor3 = Color3.new(0, 0, 0); ResBox.BackgroundTransparency = 0.6
local ResCorner = Instance.new("UICorner", ResBox)
ResCorner.CornerRadius = UDim.new(0, 15)

local ResTxt = Instance.new("TextLabel", ResBox)
ResTxt.Size = UDim2.new(1, 0, 1, 0); ResTxt.Text = "Ready to Play!"; ResTxt.TextColor3 = Color3.new(0, 1, 1)
ResTxt.BackgroundTransparency = 1; ResTxt.TextScaled = true; ResTxt.Font = Enum.Font.SourceSansBold

-- FUNGSI DETEKSI
Btn.MouseButton1Click:Connect(function()
    Helper_Enabled = not Helper_Enabled
    Btn.Text = Helper_Enabled and "AI: ON (AUTO COPY)" or "AI DETECT: OFF"
    Btn.BackgroundColor3 = Helper_Enabled and Color3.new(0, 0.6, 0) or Color3.new(0.7, 0, 0)
end)

game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
    if Helper_Enabled and data.FromSpeaker ~= LocalPlayer.Name then
        local msg = data.Message:lower():gsub("%s+", "")
        local last = msg:sub(-1)
        local pil = UniversalBrain[last]
        if pil then
            local hasil = pil[math.random(1, #pil)]
            ResTxt.Text = "JAWAB: "..hasil:upper()
            if setclipboard then setclipboard(hasil) end
        end
    end
end)
