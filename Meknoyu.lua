repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "OP_GUI"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 260)
frame.Position = UDim2.new(0.5, -125, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui
Instance.new("UICorner", frame)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "Fly + Noclip GUI"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Parent = frame

-- Status Texts
local flyText = Instance.new("TextLabel")
flyText.Size = UDim2.new(1,0,0,30)
flyText.Position = UDim2.new(0,0,0.25,0)
flyText.BackgroundTransparency = 1
flyText.Text = "Fly: OFF"
flyText.TextScaled = true
flyText.Parent = frame

local noclipText = Instance.new("TextLabel")
noclipText.Size = UDim2.new(1,0,0,30)
noclipText.Position = UDim2.new(0,0,0.4,0)
noclipText.BackgroundTransparency = 1
noclipText.Text = "Noclip: OFF"
noclipText.TextScaled = true
noclipText.Parent = frame

-- Buttons
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.9,0,0,40)
flyBtn.Position = UDim2.new(0.05,0,0.6,0)
flyBtn.Text = "TOGGLE FLY"
flyBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
flyBtn.TextScaled = true
flyBtn.Parent = frame
Instance.new("UICorner", flyBtn)

local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(0.9,0,0,40)
noclipBtn.Position = UDim2.new(0.05,0,0.78,0)
noclipBtn.Text = "TOGGLE NOCLIP"
noclipBtn.BackgroundColor3 = Color3.fromRGB(255,120,0)
noclipBtn.TextScaled = true
noclipBtn.Parent = frame
Instance.new("UICorner", noclipBtn)

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-32,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,0,0)
close.Parent = frame

-- Drag
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

frame.InputEnded:Connect(function()
    dragging = false
end)

-- Character
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- 🔥 FLY
local flying = false
local bv, bg

local function startFly()
    local char = getChar()
    local hrp = char:WaitForChild("HumanoidRootPart")

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.Parent = hrp

    flying = true

    task.spawn(function()
        while flying do
            task.wait()
            local cam = workspace.CurrentCamera
            bv.Velocity = cam.CFrame.LookVector * 60
            bg.CFrame = cam.CFrame
        end
    end)
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end

    flyText.Text = "Fly: " .. (flying and "ON" or "OFF")
end)

-- 👻 NOCLIP
local noclip = false

RunService.Stepped:Connect(function()
    if noclip then
        local char = getChar()
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipText.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

-- Close
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("✅ Fly + Noclip Loaded")
