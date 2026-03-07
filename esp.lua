local button = script.Parent -- Asumsi script ada di dalam TextButton
local menuFrame = button.Parent.Frame -- Ganti "Frame" dengan nama UI menu kamu
local isOpen = false

button.MouseButton1Click:Connect(function()
    if isOpen then
        -- Menutup Menu
        menuFrame.Visible = false
        button.Text = "Buka Menu"
        isOpen = false
    else
        -- Membuka Menu
        menuFrame.Visible = true
        button.Text = "Tutup Menu"
        isOpen = true
    end
end)
