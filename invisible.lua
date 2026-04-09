repeat task.wait() until game:IsLoaded()
task.wait(1.2)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaPanel_" .. math.random(100000, 999999)
gui.ResetOnSpawn = false
gui.Enabled = true
gui.DisplayOrder = 9999
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 280)
frame.Position = UDim2.new(0.5, -130, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "DELTA PANEL"
title.TextColor3 = Color3.fromRGB(255,80,80)
title.TextScaled = true
title.Parent = frame

-- BUTTON CREATOR
local function makeBtn(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,45)
    btn.Position = UDim2.new(0.05,0,posY,0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = frame
    Instance.new("UICorner", btn)
    return btn
end

local invBtn   = makeBtn("Invisible: OFF", 0.20)
local godBtn   = makeBtn("God Mode: OFF", 0.38)
local aimBtn   = makeBtn("Aimbot: OFF", 0.56)
local espBtn   = makeBtn("ESP: OFF", 0.74)

-- CLOSE & MINI
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-32,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180,0,0)
close.Parent = frame
Instance.new("UICorner", close)

local mini = Instance.new("TextButton")
mini.Size = UDim2.new(0,50,0,50)
mini.Position = UDim2.new(0,20,0.5,0)
mini.Text = "●"
mini.BackgroundColor3 = Color3.fromRGB(0,170,255)
mini.Visible = false
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

-- DRAG
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function() dragging = false end)

close.MouseButton1Click:Connect(function()
    frame.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    frame.Visible = true
    mini.Visible = false
end)

-- CHARACTER HELPER
local function getChar() return player.Character or player.CharacterAdded:Wait() end

-- ================== INVISIBLE ==================
local invis = false
local savedProps = {}

local function setInvis(state)
    local char = getChar()
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Decal") then
            if state then
                if not savedProps[v] then savedProps[v] = {Transparency = v.Transparency, CanCollide = v.CanCollide} end
                v.Transparency = 1
                if v:IsA("BasePart") and v.Name \~= "HumanoidRootPart" then v.CanCollide = false end
            else
                if savedProps[v] then
                    v.Transparency = savedProps[v].Transparency
                    if v:IsA("BasePart") then v.CanCollide = savedProps[v].CanCollide end
                end
            end
        end
    end
end

-- ================== GOD MODE ==================
local god = false
local godConnection

local function startGodMode()
    if godConnection then godConnection:Disconnect() end
    godConnection = RunService.Heartbeat:Connect(function()
        if not god then return end
        local char = getChar()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            hum.MaxHealth = math.huge
        end
    end)
end

-- ================== SIMPLE AIMBOT (Hold mouse or toggle) ==================
local aimbot = false
local aimConnection

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p \~= player and p.Character and p.Character:FindFirstChild("Head") then
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local d = (camera.CFrame.Position - p.Character.Head.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = p.Character.Head
                end
            end
        end
    end
    return closest
end

aimBtn.MouseButton1Click:Connect(function()
    aimbot = not aimbot
    aimBtn.Text = "Aimbot: " .. (aimbot and "ON" or "OFF")
    
    if aimbot then
        if aimConnection then aimConnection:Disconnect() end
        aimConnection = RunService.RenderStepped:Connect(function()
            if not aimbot then return end
            local target = getClosestEnemy()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end)
    else
        if aimConnection then aimConnection:Disconnect() end
    end
end)

-- ================== ESP ==================
local esp = false
local espDrawings = {}

local function createESP(plr)
    if plr == player then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Transparency = 1
    
    local name = Drawing.new("Text")
    name.Size = 16
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255, 255, 255)
    
    espDrawings[plr] = {Box = box, Name = name}
end

local function updateESP()
    for plr, drawings in pairs(espDrawings) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
            local root = plr.Character.HumanoidRootPart
            local head = plr.Character.Head
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            
            local vector, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen and humanoid and humanoid.Health > 0 then
                local top = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                local bottom = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                
                local height = (top.Y - bottom.Y)
                local width = height / 2
                
                drawings.Box.Size = Vector2.new(width, height)
                drawings.Box.Position = Vector2.new(vector.X - width/2, vector.Y - height/2 + 20)
                drawings.Box.Visible = true
                
                drawings.Name.Text = plr.Name .. " [" .. math.floor(humanoid.Health) .. "]"
                drawings.Name.Position = Vector2.new(vector.X, vector.Y - height/2 - 10)
                drawings.Name.Visible = true
            else
                drawings.Box.Visible = false
                drawings.Name.Visible = false
            end
        else
            drawings.Box.Visible = false
            drawings.Name.Visible = false
        end
    end
end

espBtn.MouseButton1Click:Connect(function()
    esp = not esp
    espBtn.Text = "ESP: " .. (esp and "ON" or "OFF")
    
    if esp then
        for _, p in pairs(Players:GetPlayers()) do
            if not espDrawings[p] then createESP(p) end
        end
        Players.PlayerAdded:Connect(function(p) createESP(p) end)
        
        if not espConnection then
            espConnection = RunService.RenderStepped:Connect(updateESP)
        end
    else
        for _, drawings in pairs(espDrawings) do
            if drawings.Box then drawings.Box:Remove() end
            if drawings.Name then drawings.Name:Remove() end
        end
        espDrawings = {}
        if espConnection then espConnection:Disconnect() espConnection = nil end
    end
end)

-- ================== TOGGLE INVISIBLE & GOD ==================
invBtn.MouseButton1Click:Connect(function()
    invis = not invis
    setInvis(invis)
    invBtn.Text = "Invisible: " .. (invis and "ON" or "OFF")
end)

godBtn.MouseButton1Click:Connect(function()
    god = not god
    godBtn.Text = "God Mode: " .. (god and "ON" or "OFF")
    if god then startGodMode() else if godConnection then godConnection:Disconnect() end end
end)

-- RESPAWN FIX
player.CharacterAdded:Connect(function()
    task.wait(1.5)
    savedProps = {}
    if invis then 
        task.wait(0.3)
        setInvis(true)
        invBtn.Text = "Invisible: ON"
    end
    if god then 
        task.wait(0.3)
        startGodMode()
        godBtn.Text = "God Mode: ON"
    end
end)

print("✅ DELTA PANEL LOADED dengan Aimbot + ESP")
print("Klik tombol di GUI untuk ON/OFF")
