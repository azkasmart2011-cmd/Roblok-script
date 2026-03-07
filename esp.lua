loadstring(game:HttpGet("https://raw.githubusercontent.com/azkasmart2011-cm/Roblok-script/main/esp.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function ESP(player)
    if player ~= LocalPlayer then
        if player.Character then
            local h = Instance.new("Highlight")
            h.Parent = player.Character
            h.FillColor = Color3.fromRGB(255,0,0)
            h.OutlineColor = Color3.fromRGB(255,255,255)
            h.FillTransparency = 0.5
        end

        player.CharacterAdded:Connect(function(char)
            local h = Instance.new("Highlight")
            h.Parent = char
            h.FillColor = Color3.fromRGB(255,0,0)
            h.OutlineColor = Color3.fromRGB(255,255,255)
            h.FillTransparency = 0.5
        end)
    end
end

for _,v in pairs(Players:GetPlayers()) do
    ESP(v)
end

Players.PlayerAdded:Connect(ESP)
