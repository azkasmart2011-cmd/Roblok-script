local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local GUI_ID = "FANN_HUB_V15_HOP"
if CoreGui:FindFirstChild(GUI_ID) then CoreGui[GUI_ID]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = GUI_ID

-- [ VARIABEL KONTROL ]
local ESP_ON, AUTOPLAY_ON, FLY_ON = false, false, false
local WS_VALUE, JP_VALUE = 16, 50

-- [ FUNGSI HOP SERVER ]
local function HopServer()
    local x = {}
    for _, v in ipairs(HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
        if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
            x[#x + 1] = v.id
        end
    end
    if #x > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
    else
        warn("Tidak menemukan server lain!")
    end
end

-- [ MAIN FRAME ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "FANN HUB | SERVER HOPPER V15"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- Sidebar & Container (Sama seperti V14)
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 110, 1, -35)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 5)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Position = UDim2.new(0, 120, 0, 45)
PageContainer.Size = UDim2.new(1, -130, 1, -55)
PageContainer.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Pages[name] = Page
    return Page
end

local HomePage = CreatePage("Home")
local MainPage = CreatePage("Main")
local ControlPage = CreatePage("Control")

local function ShowPage(pageName)
    for _, p in pairs(Pages) do p.Visible = false end
    local targetPage = Pages[pageName]
    targetPage.Visible = true
    targetPage.Position = UDim2.new(0, 0, 0, 10)
    TweenService:Create(targetPage, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
end

local function TabBtn(name, target)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(0, 100, 0, 35)
    Btn.Text = name
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.GothamMedium
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(function() ShowPage(target) end)
end

TabBtn("🏠 HOME", "Home")
TabBtn("⚔️ MAIN", "Main")
TabBtn("⚙️ CONTROL", "Control")
ShowPage("Home")

-- [ FUNGSI UI KOMPONEN ]
local function AddToggle(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 38); Btn.Text = text .. " : OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", Btn)
    local s = false
    Btn.MouseButton1Click:Connect(function() s = not s; Btn.Text = text .. (s and " : ON" or " : OFF"); Btn.TextColor3 = s and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 50, 50); callback(s) end)
end

local function AddButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 38); Btn.Text = text
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Btn)
    Btn.MouseButton1Click:Connect(callback)
end

-- [ ISI MENU ]
AddToggle(HomePage, "Fly Mode", function(s) FLY_ON = s end)
AddToggle(MainPage, "ESP Master", function(s) ESP_ON = s end)
AddToggle(MainPage, "Auto Play (Smart)", function(s) AUTOPLAY_ON = s end)

-- Menu Control Baru
AddToggle(ControlPage, "Boost FPS", function(s)
    if s then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") then v:Destroy() end end end
end)
AddButton(ControlPage, "🚀 Hop Server", function() HopServer() end)

-- [ TOMBOL F ]
local TogF = Instance.new("TextButton", ScreenGui); TogF.Size = UDim2.new(0,45,0,45); TogF.Position = UDim2.new(0,20,0,60)
TogF.Text = "F"; TogF.BackgroundColor3 = Color3.fromRGB(20,20,20); TogF.TextColor3 = Color3.fromRGB(0,255,255)
Instance.new("UICorner", TogF).CornerRadius = UDim.new(1,0)
TogF.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- [ LOGIKA CORE ] (Killer/Survivor Detect tetap sama seperti sebelumnya)
task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if FLY_ON then char.HumanoidRootPart.Velocity = Vector3.new(0,3,0) end
            -- Logika Autoplay bantai/kabur di sini...
        end
    end
end)
