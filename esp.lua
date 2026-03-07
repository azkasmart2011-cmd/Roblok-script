local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Helper_Enabled = false
local Is_Minimized = false

-- DATABASE KATA (A-Z + Akhiran)
local UniversalBrain = {
    ["a"] = {"Antariksa", "Aspirasi", "Ambisi"}, ["b"] = {"Bakwan", "Brutal", "Bahari"},
    ["c"] = {"Cahaya", "Cemara", "Cendekia"}, ["d"] = {"Dinamis", "Drakula", "Dahsyat"},
    ["e"] = {"Eksotis", "Evolusi", "Empati"}, ["f"] = {"Fenomena", "Fantastis", "Fiksi"},
    ["g"] = {"Galaksi", "Gelora", "Gemerlap"}, ["h"] = {"Harmoni", "Histeris", "Hakikat"},
    ["i"] = {"Ilusi", "Inspirasi", "Inovasi"}, ["j"] = {"Jelajah", "Jendela", "Jelita"},
    ["k"] = {"Kristal", "Kharisma", "Kompleks"}, ["l"] = {"Lentera", "Legenda", "Lestari"},
    ["m"] = {"Misteri", "Metamorfosa", "Militan"}, ["n"] = {"Nurani", "Nostalgia", "Narasi"},
    ["o"] = {"Optimis", "Obsesi", "Otentik"}, ["p"] = {"Paradoks", "Pesona", "Prestige"},
    ["r"] = {"Radiasi", "Revolusi", "Resonansi"}, ["s"] = {"Spektakuler", "Simfoni", "Sinergi"},
    ["t"] = {"Tragedi", "Transparansi", "Teori"}, ["u"] = {"Utopia", "Universal", "Unik"},
    ["w"] = {"Wawasan", "Wahyu", "Wujud"}, ["y"] = {"Yurisdiksi", "Yudisial", "Yakin"},
    ["z"] = {"Zodiak", "Zaman", "Zeni"},
    ["ng"] = {"Ngantuk", "Nganggur", "Ngebut"}, ["ny"] = {"Nyanyi", "Nyaman", "Nyata"}
}

-- UI SETUP (INSTAN / TANPA ANIMASI)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "FANN_NO_ANIM"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 220) -- Langsung ukuran penuh
Main.Position = UDim2.new(0.5, -130, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BackgroundTransparency = 0.2
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.new(1, 1, 0)
Main.Active = true; Main.Draggable = true
Main.ClipsDescendants = true

-- BACKGROUND IMAGE (Foto Kerudung)
local BgImage = Instance.new("ImageLabel", Main)
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Image = "rbxassetid://134015690327429" -- Masukkan ID fotomu di sini
BgImage.BackgroundTransparency = 1
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ImageTransparency = 0.6

-- TOMBOL CLOSE (INSTAN)
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "X"; MinBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MinBtn.TextColor3 = Color3.new(1, 1, 1); MinBtn.Font = Enum.Font.SourceSansBold

MinBtn.MouseButton1Click:Connect(function()
    if not Is_Minimized then
        Main.Size = UDim2.new(0, 100, 0, 40) -- Langsung berubah ukuran
        MinBtn.Text = "+"; MinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        Is_Minimized = true
    else
        Main.Size = UDim2.new(0, 260, 0, 220) -- Langsung kembali normal
        MinBtn.Text = "X"; MinBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        Is_Minimized = false
    end
end)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0.8,0,0,45); Title.Text = "FANN V7"; Title.TextColor3 = Color3.new(1,1,0); Title.BackgroundTransparency = 1; Title.TextSize = 22; Title.Font = Enum.Font.SourceSansBold

local ResTxt = Instance.new("TextLabel", Main)
ResTxt.Size = UDim2.new(0.9,0,0,90); ResTxt.Position = UDim2.new(0.05,0,0,110)
ResTxt.Text = "Instan Mode..."; ResTxt.TextColor3 = Color3.new(1,1,1); ResTxt.BackgroundColor3 = Color3.new(0,0,0); ResTxt.BackgroundTransparency = 0.5; ResTxt.TextScaled = true; ResTxt.Font = Enum.Font.SourceSansBold

-- FUNGSI CARI KATA
local function CariJawaban(teks)
    if not teks or teks == "" then return end
    local kata = teks:lower():gsub("%s+", "")
    local lastTwo = kata:sub(-2); local lastOne = kata:sub(-1)
    local pilihan = UniversalBrain[lastTwo] or UniversalBrain[lastOne]
    if pilihan then
        local hasil = pilihan[math.random(1, #pilihan)]
        ResTxt.Text = "JAWAB: "..hasil:upper()
        if setclipboard then setclipboard(hasil) end
    end
end

-- DETEKSI CHAT
game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
    if Helper_Enabled and data.FromSpeaker ~= LocalPlayer.Name then CariJawaban(data.Message) end
end)

-- TOMBOL ON/OFF (TANPA ANIMASI)
local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0.9,0,0,45); Btn.Position = UDim2.new(0.05,0,0,55)
Btn.Text = "START AI: OFF"; Btn.BackgroundColor3 = Color3.new(0.6,0,0)
Btn.TextColor3 = Color3.new(1,1,1); Btn.Font = Enum.Font.SourceSansBold

Btn.MouseButton1Click:Connect(function()
    Helper_Enabled = not Helper_Enabled
    Btn.Text = Helper_Enabled and "AI: ON (COPY)" or "START AI: OFF"
    Btn.BackgroundColor3 = Helper_Enabled and Color3.new(0,0.6,0) or Color3.new(0.6,0,0)
end)
