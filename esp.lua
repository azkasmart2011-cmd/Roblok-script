local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESP_Enabled = false
local Helper_Enabled = false

local Kamus = {
    ["a"] = {"Apel", "Ayam", "Angin", "Awan", "Abadi"},
    ["b"] = {"Buku", "Bola", "Bambu", "Bebek", "Bintang"},
    ["c"] = {"Cacing", "Cermin", "Cuka", "Catur", "Candi"},
    ["d"] = {"Dadu", "Dapur", "Dunia", "Domba", "Daging"},
    ["e"] = {"Emas", "Elang", "Ekor", "Empat", "Ember"},
    ["f"] = {"Fokus", "Fajar", "Fisik", "Foto", "Fakta"},
    ["g"] = {"Gajah", "Gelas", "Gitar", "Garam", "Gurun"},
    ["h"] = {"Hujan", "Hutan", "Hakim", "Hantu", "Handuk"},
    ["i"] = {"Ikan", "Intan", "Izin", "Ibu", "Istana"},
    ["j"] = {"Jeruk", "Jalan", "Jaring", "Jerapah", "Jambu"},
    ["k"] = {"Kuda", "Kapas", "Kasur", "Kancil", "Kamera"},
    ["l"] = {"Lampu", "Lari", "Lidah", "Langit", "Lemon"},
    ["m"] = {"Makan", "Mobil", "Madu", "Mawar", "Musang"},
    ["n"] = {"Nasi", "Naga", "Nomor", "Nanas", "Nyamuk"},
    ["o"] = {"Obat", "Orang", "Otot", "Obeng", "Ondel"},
    ["p"] = {"Pintu", "Pasir", "Paku", "Pohon", "Panda"},
    ["r"] = {"Roda", "Raja", "Rumah", "Rantai", "Rusa"},
    ["s"] = {"Sapi", "Sapu", "Susu", "Semut", "Sendok"},
    ["t"] = {"Tali", "Tebu", "Tikus", "Tangga", "Topi"},
    ["u"] = {"Ular", "Uang", "Unta", "Udang", "Ungu"},
    ["w"] = {"Wajah", "Warteg", "Warna", "Wajan", "Wortel"},
    ["y"] = {"Yatim", "Yakin", "Yoyo", "Yuyu", "Yodium"},
    ["ya"] = {"Yakin", "Yatim", "Yasin", "Yodium", "Yudisial", "Yuyu"}
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FANN_UI"; ScreenGui.Parent = game:GetService("CoreGui"); ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 260); MainFrame.Position = UDim2.new(0, 20, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); MainFrame.BorderSizePixel = 4
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255); MainFrame.Active = true; MainFrame.Draggable = true; MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "FANN"; Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.new(1, 1, 0); Title.TextSize = 30; Title.BackgroundTransparency = 1; Title.Parent = MainFrame

local function addFeature(name, yPos, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 130, 0, 30); lbl.Position = UDim2.new(0.05, 0, 0, yPos)
    lbl.Text = name; lbl.Font = Enum.Font.SourceSansBold; lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.BackgroundTransparency = 1; lbl.Parent = MainFrame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 65, 0, 25); btn.Position = UDim2.new(0.65, 0, 0, yPos + 2)
    btn.Text = "OFF"; btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); btn.Font = Enum.Font.SourceSansBold
    btn.TextColor3 = Color3.new(1, 1, 1); btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(function() local state = callback(); btn.Text = state and "ON" or "OFF"; btn.BackgroundColor3 = state and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(180, 0, 0) end)
end

addFeature("ESP", 55, function() ESP_Enabled = not ESP_Enabled return ESP_Enabled end)
addFeature("Game Lanjut Kata", 95, function() Helper_Enabled = not Helper_Enabled return Helper_Enabled end)

local SugBox = Instance.new("Frame")
SugBox.Size = UDim2.new(0.9, 0, 0, 100); SugBox.Position = UDim2.new(0.05, 0, 0, 140)
SugBox.BackgroundColor3 = Color3.new(0, 0, 0); SugBox.BorderSizePixel = 1; SugBox.BorderColor3 = Color3.new(1, 1, 0); SugBox.Parent = MainFrame

local SugTxt = Instance.new("TextLabel")
SugTxt.Size = UDim2.new(1, 0, 1, 0); SugTxt.Text = "Menunggu lawan..."; SugTxt.TextColor3 = Color3.fromRGB(0, 255, 255)
SugTxt.TextWrapped = true; SugTxt.TextScaled = true; SugTxt.BackgroundTransparency = 1; SugTxt.Parent = SugBox

game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
    if Helper_Enabled and data.FromSpeaker ~= LocalPlayer.Name then
        local msg = data.Message:lower()
        if msg:sub(-2) == "ya" then
            SugTxt.Text = "Lawan: "..msg.."\nSaran (YA):\n"..table.concat(Kamus["ya"], ", ")
        else
            local last = msg:match("%a$")
            if last and Kamus[last] then SugTxt.Text = "Lawan: "..msg.."\nSaran ("..last:upper().."):\n"..table.concat(Kamus[last], ", ") end
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("ESPHighlight") or Instance.new("Highlight", p.Character)
            h.Name = "ESPHighlight"; h.Enabled = ESP_Enabled; h.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end)
