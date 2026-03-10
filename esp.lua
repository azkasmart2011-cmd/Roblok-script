local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local GUI_ID = "FANN_HUB_V19_COMPLETE"
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
        if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then x[#x + 1] = v.id end
    end
    if #x > 0 then TeleportService:TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)]) end
end

-- [ FUNGSI CARI EXIT ]
local function GetExit()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:upper():find("EXIT") or obj.Name:upper():find("ESCAPE")) then
            if obj.Transparency < 1 then return obj end
        end
    end
    return nil
end

-- [ MAIN FRAME UI ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 5); SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Page Container
local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Position = UDim2.new(0, 120, 0, 40)
PageContainer.Size = UDim2.new(1, -130, 1, -50)
PageContainer.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", PageContainer)
    Page.Name = name; Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 1.5, 0); Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Pages[name] = Page
    return Page
end

local HomePage = CreatePage("Home")
local MainPage = CreatePage("Main")
local ControlPage = CreatePage("Control")

local function ShowPage(name)
    for _, p in pairs(Pages) do
        if p.Visible then p.Visible = false end
    end
    local target = Pages[name]
    target.Visible = true
    target.Position = UDim2.new(0, 0, 0, 15)
    TweenService:Create(target, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
end

local function TabBtn(txt, target)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0, 100, 0, 35); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.GothamBold; b.TextSize = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() ShowPage(target) end)
end

TabBtn("🏠 HOME", "Home"); TabBtn("⚡ MAIN", "Main"); TabBtn("⚙️ CONTROL", "Control")
ShowPage("Home")

-- [ UI ELEMENTS ]
local function AddToggle(parent, txt, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -10, 0, 38); b.Text = txt .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.fromRGB(255, 50, 50); Instance.new("UICorner", b)
    local s = false
    b.MouseButton1Click:Connect(function()
        s = not s; callback(s)
        b.Text = txt .. (s and " : ON" or " : OFF")
        TweenService:Create(b, TweenInfo.new(0.3), {TextColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)}):Play()
    end)
end

local function AddInput(parent, text, default, callback)
    local Frame = Instance.new("Frame", parent); Frame.Size = UDim2.new(1, -10, 0, 50); Frame.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Text = text; Lbl.Size = UDim2.new(1,0,0,20); Lbl.TextColor3 = Color3.fromRGB(200,200,200); Lbl.BackgroundTransparency = 1; Lbl.TextXAlignment = Enum.TextXAlignment.Left
    local Box = Instance.new("TextBox", Frame); Box.Position = UDim2.new(0,0,0,22); Box.Size = UDim2.new(1,0,0,25); Box.Text = tostring(default); Box.BackgroundColor3 = Color3.fromRGB(25,25,25); Box.TextColor3 = Color3.fromRGB(0,255,255)
    Instance.new("UICorner", Box); Box.FocusLost:Connect(function() callback(tonumber(Box.Text) or default) end)
end

-- Home Content
AddToggle(HomePage, "Fly Mode", function(s) FLY_ON = s end)
AddInput(HomePage, "Speed", 16, function(v) WS_VALUE = v end)
AddInput(HomePage, "Jump", 50, function(v) JP_VALUE = v end)

-- Main Content
AddToggle(MainPage, "ESP Master", function(s) ESP_ON = s end)
AddToggle(MainPage, "Auto Play (Smart)", function(s) AUTOPLAY_ON = s end)

-- Control Content
AddToggle(ControlPage, "Boost FPS", function(s)
    if s then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic elseif v:IsA("Decal") then v:Destroy() end end end
end)
local HopBtn = Instance.new("TextButton", ControlPage); HopBtn.Size = UDim2.new(1, -10, 0, 38); HopBtn.Text = "🚀 Hop Server"; HopBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); HopBtn.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", HopBtn); HopBtn.MouseButton1Click:Connect(HopServer)

-- [ TOMBOL F ]
local TogF = Instance.new("TextButton", ScreenGui); TogF.Size = UDim2.new(0,45,0,45); TogF.Position = UDim2.new(0,20,0,60); TogF.Text = "F"; TogF.BackgroundColor3 = Color3.fromRGB(20,20,20); TogF.TextColor3 = Color3.fromRGB(0,255,255); Instance.new("UICorner", TogF).CornerRadius = UDim.new(1,0)
TogF.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.3) MainFrame.Visible = false
    else
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 280)}):Play()
    end
end)

-- [ LOGIKA INTI ]
local function IsKiller(p)
    if not p or not p.Character then return false end
    local k = {"knife","piso","sword","blade","murderer","killer","weapon"}
    for _, t in pairs(p.Character:GetChildren()) do if t:IsA("Tool") then for _, word in pairs(k) do if t.Name:lower():find(word) then return true end end end end
    return false
end

task.spawn(function()
    while task.wait(0.05) do
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if char and hrp then
            char.Humanoid.WalkSpeed = WS_VALUE
            char.Humanoid.JumpPower = JP_VALUE
            if FLY_ON then hrp.Velocity = Vector3.new(0,2,0) end
            
            if AUTOPLAY_ON then
                if IsKiller(LocalPlayer) then
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1.5)
                            VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                        end
                    end
                else
                    local exit = GetExit()
                    if exit then 
                        hrp.CFrame = hrp.CFrame:Lerp(exit.CFrame, 0.2)
                    else
                        local kPos = nil
                        for _, p in pairs(Players:GetPlayers()) do if IsKiller(p) and p.Character then kPos = p.Character.HumanoidRootPart.Position; break end end
                        if kPos then
                            local dir = (hrp.Position - kPos).Unit
                            local tPos = hrp.Position + (dir * 60)
                            hrp.CFrame = CFrame.new(tPos.X, math.clamp(tPos.Y, 35, 120), tPos.Z)
                        end
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("FANN_ESP")
            if ESP_ON then
                if not h then h = Instance.new("Highlight", p.Character); h.Name = "FANN_ESP" end
                h.FillColor = IsKiller(p) and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,255)
            elseif h then h:Destroy() end
        end
    end
end)
