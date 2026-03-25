-- Invisible GUI Fix 2026 - Loadstring Ready
-- https://raw.githubusercontent.com/USERNAME/invisible-gui/main/invisible.lua

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InvisibleGUI_Fix"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Settings Frame
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "Settings"
settingsFrame.Size = UDim2.new(0, 320, 0, 180)
settingsFrame.Position = UDim2.new(0.5, -160, 0.2, 0)
settingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
settingsFrame.BorderSizePixel = 0
settingsFrame.Parent = screenGui
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "-- SETTINGS --"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = settingsFrame

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(0.6, 0, 0, 30)
wsLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "Player:"
wsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.TextScaled = true
wsLabel.Font = Enum.Font.Gotham
wsLabel.Parent = settingsFrame

local wsValue = Instance.new("TextLabel")
wsValue.Size = UDim2.new(0.35, 0, 0, 30)
wsValue.Position = UDim2.new(0.65, 0, 0.3, 0)
wsValue.BackgroundTransparency = 1
wsValue.Text = player.Name
wsValue.TextColor3 = Color3.fromRGB(0, 255, 120)
wsValue.TextXAlignment = Enum.TextXAlignment.Right
wsValue.TextScaled = true
wsValue.Font = Enum.Font.Gotham
wsValue.Parent = settingsFrame

-- Ui Gui Frame
local uiFrame = Instance.new("Frame")
uiFrame.Name = "UiGui"
uiFrame.Size = UDim2.new(0, 240, 0, 160)
uiFrame.Position = UDim2.new(0.5, -120, 0.5, 0)
uiFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
uiFrame.BorderSizePixel = 0
uiFrame.Parent = screenGui
Instance.new("UICorner", uiFrame).CornerRadius = UDim.new(0, 12)

local uiTitle = Instance.new("TextLabel")
uiTitle.Size = UDim2.new(1, 0, 0, 35)
uiTitle.BackgroundTransparency = 1
uiTitle.Text = "-- Ui Gui --"
uiTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
uiTitle.TextScaled = true
uiTitle.Font = Enum.Font.GothamBold
uiTitle.Parent = uiFrame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0.9, 0, 0, 35)
status.Position = UDim2.new(0.05, 0, 0.35, 0)
status.BackgroundTransparency = 1
status.Text = "Invisible: OFF"
status.TextColor3 = Color3.fromRGB(255, 60, 60)
status.TextScaled = true
status.Font = Enum.Font.GothamBold
status.Parent = uiFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
toggleBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleBtn.Text = "TURN INVISIBLE"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = uiFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -33, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = uiFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Draggable
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(settingsFrame)
makeDraggable(uiFrame)

-- Toggle Invisible
local invisible = false
local character = player.Character or player.CharacterAdded:Wait()

local function toggleInvisible()
    invisible = not invisible
    if invisible then
        status.Text = "Invisible: ON"
        status.TextColor3 = Color3.fromRGB(0, 255, 100)
        toggleBtn.Text = "TURN VISIBLE"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name \~= "HumanoidRootPart" then
                    part.Transparency = 1
                    if part:FindFirstChild("Decal") then part.Decal.Transparency = 1 end
                end
            end
        end
    else
        status.Text = "Invisible: OFF"
        status.TextColor3 = Color3.fromRGB(255, 60, 60)
        toggleBtn.Text = "TURN INVISIBLE"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    if part:FindFirstChild("Decal") then part.Decal.Transparency = 0 end
                end
            end
        end
    end
end

toggleBtn.MouseButton1Click:Connect(toggleInvisible)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    if invisible then
        task.wait(0.8)
        toggleInvisible()
        toggleInvisible()
    end
end)

print("✅ Invisible GUI Fix dari GitHub berhasil di-load!")
