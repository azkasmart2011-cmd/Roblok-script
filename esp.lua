-- Partner Coding: ESP (Red = Killer, Blue = Normal) + Toggle Button
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

_G.ESP_Enabled = true 

-- 1. TOMBOL UI ON/OFF
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_Final_UI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 40)
btn.Position = UDim2.new(0, 20, 0.8, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Text = "ESP: ON"
btn.Parent = screenGui

btn.MouseButton1Click:Connect(function()
	_G.ESP_Enabled = not _G.ESP_Enabled
	btn.Text = _G.ESP_Enabled and "ESP: ON" or "ESP: OFF"
	btn.BackgroundColor3 = _G.ESP_Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 2. LOGIKA ESP WARNA
local function createESP(player)
	player.CharacterAdded:Connect(function(character)
		if player == LocalPlayer then return end
		local head = character:WaitForChild("Head", 10)
		local root = character:WaitForChild("HumanoidRootPart", 10)
		if not head or not root then return end

		-- Highlight (Garis Tepi)
		local highlight = Instance.new("Highlight")
		highlight.Parent = character
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

		-- Billboard (Teks Nama & Jarak)
		local billboard = Instance.new("BillboardGui")
		billboard.Adornee = head
		billboard.Size = UDim2.new(0, 150, 0, 50)
		billboard.AlwaysOnTop = true
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.Parent = head

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0
		label.Font = Enum.Font.RobotoMono
		label.TextSize = 14
		label.Parent = billboard

		-- Loop Update Warna & Status
		local connection
		connection = RunService.RenderStepped:Connect(function()
			if not character or not character:IsDescendantOf(workspace) then
				connection:Disconnect()
				return
			end

			-- Tampilkan/Sembunyikan berdasarkan tombol
			highlight.Enabled = _G.ESP_Enabled
			billboard.Enabled = _G.ESP_Enabled

			if _G.ESP_Enabled then
				-- Cek apakah pegang "Knife"
				local hasKnife = character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife")
				
				-- Hitung Jarak
				local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local distance = myRoot and math.floor((myRoot.Position - root.Position).Magnitude) or 0
				
				if hasKnife then
					-- JIKA KILLER: WARNA MERAH
					label.Text = "⚠️ [KILLER] ⚠️\n" .. player.Name .. "\n" .. distance .. "m"
					label.TextColor3 = Color3.fromRGB(255, 0, 0) 
					highlight.FillColor = Color3.fromRGB(255, 0, 0)
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				else
					-- JIKA BIASA: WARNA BIRU
					label.Text = player.Name .. "\n" .. distance .. "m"
					label.TextColor3 = Color3.fromRGB(0, 170, 255) -- Biru Cerah
					highlight.FillColor = Color3.fromRGB(0, 170, 255)
					highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				end
			end
		end)
	end)
end

-- Jalankan fungsi
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
