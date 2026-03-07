local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESP_Enabled = false
local Helper_Enabled = false
local Is_Minimized = false

local CreativeBrain = {
    ["a"] = {"Antariksa", "Aspirasi", "Ambisi"},
    ["b"] = {"Bakwan", "Brutal", "Bahari"},
    ["c"] = {"Cahaya", "Cemara", "Cendekia"},
    ["d"] = {"Dinamis", "Drakula", "Dahsyat"},
    ["e"] = {"Eksotis", "Evolusi", "Empati"},
    ["f"] = {"Fenomena", "Fantastis", "Fiksi"},
    ["g"] = {"Galaksi", "Gelora", "Gemerlap"},
    ["h"] = {"Harmoni", "Histeris", "Hakikat"},
    ["i"] = {"Ilusi", "Inspirasi", "Inovasi"},
    ["j"] = {"Jelajah", "Jendela", "Jelita"},
    ["k"] = {"Kristal", "Kharisma", "Kompleks"},
    ["l"] = {"Lentera", "Legenda", "Lestari"},
    ["m"] = {"Misteri", "Metamorfosa", "Militan"},
    ["n"] = {"Nurani", "Nostalgia", "Narasi"},
    ["o"] = {"Optimis", "Obsesi", "Otentik"},
    ["p"] = {"Paradoks", "Pesona", "Prestige"},
    ["r"] = {"Radiasi", "Revolusi", "Resonansi"},
    ["s"] = {"Spektakuler", "Simfoni", "Sinergi"},
    ["t"] = {"Tragedi", "Transparansi", "Teori"},
    ["u"] = {"Utopia", "Universal", "Unik"},
    ["w"] = {"Wawasan", "Wahyu", "Wujud"},
    ["y"] = {"Yurisdiksi", "Yudisial", "Yakin"},
    ["z"] = {"Zodiak", "Zaman", "Zeni"},
    ["ng"] = {"Ngantuk", "Nganggur", "Ngebut"},
    ["ya"] = {"Yakin", "Yatama", "Yasin"},
    ["ny"] = {"Nyanyi", "Nyaman", "Nyata"}
}

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 280)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(1, 1, 0)
MainFrame.Active = true; MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

MainFrame:TweenSize(UDim2.new(0, 250, 0, 280), "Out", "Back", 0.6, true)

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 30, 0, 30); MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "X"; MinBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MinBtn.TextColor3 = Color3.new(1, 1, 1); MinBtn.Font = Enum.Font.SourceSansBold

MinBtn.MouseButton1Click:Connect(function()
    if not Is_Minimized then
        MainFrame:TweenSize(UDim2.new(0, 100, 0, 40), "Out", "Quad", 0.4, true)
        MinBtn.Text = "+"; MinBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0); Is_Minimized = true
    else
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 280), "Out", "Back", 0.5, true)
        MinBtn.Text = "X"; MinBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0); Is_Minimized = false
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(0.8, 0, 0, 45); Title.Text = "FANN V2"; Title.TextColor3 = Color3.new(1, 1, 0)
Title.TextSize = 25; Title.Font = Enum.Font.SourceSansBold; Title.BackgroundTransparency = 1

local function addBtn(name, y, callback)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = name..": OFF"; b.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.SourceSansBold
    b.MouseButton1Click:Connect(function()
        local s = callback(); b.Text = name..(s and ": ON" or ": OFF")
        b.BackgroundColor3 = s and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)
end

addBtn("ESP PLAYER", 55, function() ESP_Enabled = not ESP_Enabled return ESP_Enabled end)
addBtn("AI BRAIN", 100, function() Helper_Enabled = not Helper_Enabled return Helper_Enabled end)

local ResBox = Instance.new("Frame", MainFrame)
ResBox.Size = UDim2.new(0.9, 0, 0, 100); ResBox.Position = UDim2.new(0.05, 0, 0, 150)
ResBox.BackgroundColor3 = Color3.new(0, 0, 0); ResBox.BorderColor3 = Color3.new(1, 1, 0)

local ResTxt = Instance.new("TextLabel", ResBox)
ResTxt.Size = UDim2.new(1, 0, 1, 0); ResTxt.Text = "Menunggu..."; ResTxt.TextColor3 = Color3.new(0, 1, 1)
ResTxt.TextScaled = true; ResTxt.BackgroundTransparency = 1

local function GetCreativeAnswer(msg)
    msg = msg:lower():gsub("%s+", "")
    local lastTwo = msg:sub(-2); local lastOne = msg:sub(-1)
    local pilihan = CreativeBrain[lastTwo] or CreativeBrain[lastOne]
    if pilihan then
        local kata = pilihan[math.random(1, #pilihan)]
        ResTxt.Text = "Jawab: "..kata:upper()
        if setclipboard then setclipboard(kata) end
    end
end

game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
    if Helper_Enabled and data.FromSpeaker ~= LocalPlayer.Name then GetCreativeAnswer(data.Message) end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("FANN_ESP") or Instance.new("Highlight", p.Character)
            h.Name = "FANN_ESP"; h.Enabled = ESP_Enabled; h.FillColor = Color3.new(1, 1, 0)
        end
    end
end)
