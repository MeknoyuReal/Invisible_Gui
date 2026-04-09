repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ================== GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalGUI"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 220)
frame.Position = UDim2.new(0.5, -120, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Universal GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Status labels
local invisStatus = Instance.new("TextLabel")
invisStatus.Size = UDim2.new(0.9,0,0,20)
invisStatus.Position = UDim2.new(0.05,0,0.25,0)
invisStatus.BackgroundTransparency = 1
invisStatus.Text = "Invisible: OFF"
invisStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
invisStatus.TextScaled = true
invisStatus.Parent = frame

local godStatus = Instance.new("TextLabel")
godStatus.Size = UDim2.new(0.9,0,0,20)
godStatus.Position = UDim2.new(0.05,0,0.35,0)
godStatus.BackgroundTransparency = 1
godStatus.Text = "God Mode: OFF"
godStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
godStatus.TextScaled = true
godStatus.Parent = frame

-- Button Invisible
local invBtn = Instance.new("TextButton")
invBtn.Size = UDim2.new(0.9,0,0,40)
invBtn.Position = UDim2.new(0.05,0,0.48,0)
invBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
invBtn.Text = "Toggle Invisible"
invBtn.TextColor3 = Color3.new(1,1,1)
invBtn.TextScaled = true
invBtn.Parent = frame
Instance.new("UICorner", invBtn)

-- Button God Mode
local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(0.9,0,0,40)
godBtn.Position = UDim2.new(0.05,0,0.68,0)
godBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
godBtn.Text = "Toggle God Mode"
godBtn.TextColor3 = Color3.new(1,1,1)
godBtn.TextScaled = true
godBtn.Parent = frame
Instance.new("UICorner", godBtn)

-- Mini button & Close
local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0, 50, 0, 50)
mini.Position = UDim2.new(0, 20, 0.5, 0)
mini.BackgroundColor3 = Color3.fromRGB(30,30,30)
mini.Text = "●"
mini.TextColor3 = Color3.new(1,0,0)
mini.TextScaled = true
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1,0,0)
closeBtn.TextScaled = true
closeBtn.Parent = frame

-- Drag GUI
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    frame.Visible = true
    mini.Visible = false
end)

-- ================== FUNCTIONS ==================
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function updateCharacter()
    character = getChar()
end
player.CharacterAdded:Connect(updateCharacter)

-- ================== INVISIBLE ==================
local invis = false
local originalTransparency = {}

invBtn.MouseButton1Click:Connect(function()
    invis = not invis
    local char = getChar()
    
    if invis then
        -- Simpan transparency asli
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name \~= "HumanoidRootPart" then
                originalTransparency[v] = v.Transparency
                v.Transparency = 0.75          -- agak transparan biar masih keliatan sendiri
            elseif v:IsA("Decal") then
                v.Transparency = 1
            end
        end
        
        -- NetworkOwnership trick (bikin agak susah keliatan di beberapa game)
        pcall(function()
            char.HumanoidRootPart:SetNetworkOwner(nil)
        end)
        
        invisStatus.Text = "Invisible: ON"
        invisStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        -- Kembalikan ke semula
        for part, trans in pairs(originalTransparency) do
            if part and part.Parent then
                part.Transparency = trans
            end
        end
        originalTransparency = {}
        
        invisStatus.Text = "Invisible: OFF"
        invisStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- ================== GOD MODE (lebih kuat) ==================
local god = false

RunService.Heartbeat:Connect(function()
    if not god then return end
    
    local char = getChar()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    -- Heal pelan + anti one-shot
    if hum.Health < hum.MaxHealth then
        hum.Health = math.min(hum.MaxHealth, hum.Health + 4)
    end
    
    -- Anti fall damage & forcefield-like
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
end)

-- Extra protection (jika ada damage mendadak)
player.CharacterAdded:Connect(function(char)
    if god then
        task.wait(0.5)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
        end
    end
end)

godBtn.MouseButton1Click:Connect(function()
    god = not god
    if god then
        godStatus.Text = "God Mode: ON"
        godStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
        
        -- Heal sekali langsung
        local hum = getChar():FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    else
        godStatus.Text = "God Mode: OFF"
        godStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

print("✅ UNIVERSAL SCRIPT LOADED - Invisible + God Mode Improved")

-- Auto update character
player.CharacterAdded:Connect(function()
    task.wait(1)
    if invis then
        -- re-apply invisible kalau respawn
        invBtn.MouseButton1Click:Fire() -- off dulu
        task.wait(0.1)
        invBtn.MouseButton1Click:Fire() -- on lagi
    end
end)
