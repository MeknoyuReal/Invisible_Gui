repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "InvGodGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)
if not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 220)
frame.Position = UDim2.new(0.5, -130, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,36)
title.BackgroundTransparency = 1
title.Text = "Invisible + God GUI"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,80,80)
title.Parent = frame

-- Status
local invText = Instance.new("TextLabel")
invText.Size = UDim2.new(1,0,0,28)
invText.Position = UDim2.new(0,0,0.25,0)
invText.BackgroundTransparency = 1
invText.Text = "Invisible: OFF"
invText.TextScaled = true
invText.Parent = frame

local godText = Instance.new("TextLabel")
godText.Size = UDim2.new(1,0,0,28)
godText.Position = UDim2.new(0,0,0.40,0)
godText.BackgroundTransparency = 1
godText.Text = "God Mode: OFF"
godText.TextScaled = true
godText.Parent = frame

-- Buttons
local invBtn = Instance.new("TextButton")
invBtn.Size = UDim2.new(0.9,0,0,40)
invBtn.Position = UDim2.new(0.05,0,0.60,0)
invBtn.Text = "TOGGLE INVISIBLE"
invBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
invBtn.TextScaled = true
invBtn.Parent = frame
Instance.new("UICorner", invBtn)

local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(0.9,0,0,40)
godBtn.Position = UDim2.new(0.05,0,0.78,0)
godBtn.Text = "TOGGLE GOD MODE"
godBtn.BackgroundColor3 = Color3.fromRGB(0,170,100)
godBtn.TextScaled = true
godBtn.Parent = frame
Instance.new("UICorner", godBtn)

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-32,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,0,0)
close.Parent = frame

-- ✅ DRAG FIX (bisa mouse + touch)
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Character helper
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- 🔥 INVISIBLE
local invisible = false
local function setInvisible(state)
    local char = getChar()
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = state and 1 or 0
            v.LocalTransparencyModifier = state and 1 or 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = state and 1 or 0
        end
    end
end

invBtn.MouseButton1Click:Connect(function()
    invisible = not invisible
    setInvisible(invisible)
    invText.Text = "Invisible: " .. (invisible and "ON" or "OFF")
end)

-- 🛡️ GOD MODE (client-side)
local god = false
local godConn

local function enableGod()
    local char = getChar()
    local hum = char:WaitForChild("Humanoid")

    -- jaga HP terus
    godConn = RunService.Heartbeat:Connect(function()
        if hum and hum.Parent then
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)

    -- cegah reset state mati
    hum.Died:Connect(function()
        if god then
            task.wait()
            hum.Health = hum.MaxHealth
        end
    end)
end

local function disableGod()
    if godConn then
        godConn:Disconnect()
        godConn = nil
    end
    local char = getChar()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
    end
end

godBtn.MouseButton1Click:Connect(function()
    god = not god

    if god then
        enableGod()
    else
        disableGod()
    end

    godText.Text = "God Mode: " .. (god and "ON" or "OFF")
end)

-- Close
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Respawn fix
player.CharacterAdded:Connect(function()
    task.wait(1)
    if invisible then setInvisible(true) end
    if god then enableGod() end
end)

print("✅ GUI Loaded (Drag + Invisible + God Mode)")
