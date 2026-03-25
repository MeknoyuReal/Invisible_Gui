-- Invisible GUI (Delta Fix - Universal)

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
repeat task.wait() until player

-- GUI (COREGUI FIX)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InvisibleGUI_Fix"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)

if not screenGui.Parent then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Frame
local uiFrame = Instance.new("Frame")
uiFrame.Size = UDim2.new(0, 240, 0, 160)
uiFrame.Position = UDim2.new(0.5, -120, 0.5, 0)
uiFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
uiFrame.Parent = screenGui

Instance.new("UICorner", uiFrame).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "Invisible GUI"
title.TextColor3 = Color3.fromRGB(255,80,80)
title.TextScaled = true
title.Parent = uiFrame

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,0,0,30)
status.Position = UDim2.new(0,0,0.35,0)
status.BackgroundTransparency = 1
status.Text = "Invisible: OFF"
status.TextScaled = true
status.Parent = uiFrame

-- Button
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0.9,0,0,45)
btn.Position = UDim2.new(0.05,0,0.6,0)
btn.Text = "TURN INVISIBLE"
btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
btn.TextScaled = true
btn.Parent = uiFrame

Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-33,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.Parent = uiFrame

-- Drag
local function dragify(frame)
    local dragToggle, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = false
        end
    end)
end

dragify(uiFrame)

-- Invisible
local invisible = false

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

-- 🔥 SUPER INVISIBLE FIX
local function setInvisible(state)
    local char = getChar()

    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name ~= "HumanoidRootPart" then
                v.Transparency = state and 1 or 0
                v.LocalTransparencyModifier = state and 1 or 0
                v.CastShadow = not state
                v.Material = Enum.Material.SmoothPlastic
            end
        end

        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = state and 1 or 0
        end
    end
end

btn.MouseButton1Click:Connect(function()
    invisible = not invisible

    if invisible then
        status.Text = "Invisible: ON"
        btn.Text = "TURN VISIBLE"
        btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        status.Text = "Invisible: OFF"
        btn.Text = "TURN INVISIBLE"
        btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    end

    setInvisible(invisible)
end)

close.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Respawn Fix
player.CharacterAdded:Connect(function()
    if invisible then
        task.wait(1)
        setInvisible(true)
    end
end)

print("✅ Invisible GUI Universal Loaded (MAX INVISIBLE)!")
