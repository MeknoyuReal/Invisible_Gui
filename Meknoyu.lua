repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaCleanGUI"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)
if not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 200)
frame.Position = UDim2.new(0.5, -120, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "DELTA GUI"
title.TextColor3 = Color3.fromRGB(255,80,80)
title.TextScaled = true
title.Parent = frame

-- STATUS
local invStatus = Instance.new("TextLabel")
invStatus.Size = UDim2.new(1,0,0,20)
invStatus.Position = UDim2.new(0,0,0.3,0)
invStatus.BackgroundTransparency = 1
invStatus.Text = "Invisible: OFF"
invStatus.TextScaled = true
invStatus.Parent = frame

local godStatus = Instance.new("TextLabel")
godStatus.Size = UDim2.new(1,0,0,20)
godStatus.Position = UDim2.new(0,0,0.45,0)
godStatus.BackgroundTransparency = 1
godStatus.Text = "God Mode: OFF"
godStatus.TextScaled = true
godStatus.Parent = frame

-- BUTTON FUNCTION
local function makeBtn(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
    btn.Position = UDim2.new(0.05,0,posY,0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = frame
    Instance.new("UICorner", btn)
    return btn
end

local invBtn = makeBtn("INVISIBLE", 0.6)
local godBtn = makeBtn("GOD MODE", 0.78)

-- CLOSE
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-32,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,0,0)
close.Parent = frame
Instance.new("UICorner", close)

-- MINI BUTTON
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0,50,0,50)
mini.Position = UDim2.new(0,20,0.8,0)
mini.Text = "●"
mini.BackgroundColor3 = Color3.fromRGB(0,170,255)
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

-- DRAG (HP + PC)
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function()
    dragging = false
end)

-- TOGGLE GUI
close.MouseButton1Click:Connect(function()
    frame.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    frame.Visible = true
    mini.Visible = false
end)

-- CHARACTER
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- INVISIBLE
local invis = false
local saved = {}

local function setInvis(state)
    local char = getChar()
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            if state then
                saved[v] = v.Transparency
                v.Transparency = 0.7
            else
                if saved[v] then
                    v.Transparency = saved[v]
                end
            end
        end
    end
end

invBtn.MouseButton1Click:Connect(function()
    invis = not invis
    setInvis(invis)
    invStatus.Text = "Invisible: " .. (invis and "ON" or "OFF")
    invBtn.BackgroundColor3 = invis and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
end)

-- GOD MODE
local god = false
local godConn

local function startGod()
    if godConn then godConn:Disconnect() end
    godConn = RunService.Heartbeat:Connect(function()
        if god then
            local hum = getChar():FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

godBtn.MouseButton1Click:Connect(function()
    god = not god
    godStatus.Text = "God Mode: " .. (god and "ON" or "OFF")
    godBtn.BackgroundColor3 = god and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)

    if god then
        startGod()
    else
        if godConn then godConn:Disconnect() end
    end
end)

-- RESPAWN FIX
player.CharacterAdded:Connect(function()
    task.wait(1)
    if invis then setInvis(true) end
    if god then startGod() end
end)

print("✅ CLEAN DELTA GUI LOADED")
