-- ==================== MEKNOYU GUI ====================
local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

starterGui:SetCore("SendNotification", { Title = "Meknoyu GUI", Text = "Meknoyu System Loaded!", Duration = 5 })

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mekno_Clean_Final"; screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

local char, hum, hrp
local godConnection, flingConnection, lastPos = nil, nil, nil

local tpTool = Instance.new("Tool"); tpTool.Name = "Mekno TP Tool"; tpTool.RequiresHandle = false
tpTool.Activated:Connect(function() local mouse = plr:GetMouse() if mouse.Hit and hrp then hrp.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0)) end end)

local states = {god=false, noclip=false, esp=false, fling=false, antifling=false, infJump=false, speed=false, fps=false, title=false, antirag=false, antijail=false, bypass=false, tooltp=false, antitel=false, aimbot=false, aimActive=false}

local function setupChar(c)
    char = c; hum = c:WaitForChild("Humanoid", 10); hrp = c:WaitForChild("HumanoidRootPart", 10)
    lastPos = hrp.CFrame
    if states.tooltp then tpTool.Parent = plr.Backpack end
end
if plr.Character then setupChar(plr.Character) end
plr.CharacterAdded:Connect(setupChar)

local main = Instance.new("Frame", screenGui); main.Size = UDim2.new(0, 360, 0, 540); main.Position = UDim2.new(0.5, -180, 0.2, 0); main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.Active = true; main.Draggable = true; Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main); stroke.Thickness = 2.5; rs.RenderStepped:Connect(function() stroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) end)

local header = Instance.new("TextLabel", main); header.Size = UDim2.new(1, 0, 0, 45); header.Text = "MEKNOYU GUI"; header.BackgroundColor3 = Color3.fromRGB(25, 25, 25); header.TextColor3 = Color3.new(1,1,1); header.Font = Enum.Font.GothamBold; header.TextSize = 18; Instance.new("UICorner", header)
local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 7); closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); Instance.new("UICorner", closeBtn)
local miniBtn = Instance.new("TextButton", screenGui); miniBtn.Size = UDim2.new(0, 45, 0, 45); miniBtn.Position = UDim2.new(0.02, 0, 0.1, 0); miniBtn.Text = "M"; miniBtn.Visible = false; miniBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); miniBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1,0); miniBtn.Draggable = true
closeBtn.MouseButton1Click:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true; miniBtn.Visible = false end)

local scroll = Instance.new("ScrollingFrame", main); scroll.Size = UDim2.new(1, -20, 1, -70); scroll.Position = UDim2.new(0, 10, 0, 55); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,2.5,0); scroll.ScrollBarThickness = 2; Instance.new("UIGridLayout", scroll).CellSize = UDim2.new(0.48, 0, 0, 40)

local aimGui = Instance.new("Frame", screenGui); aimGui.Size = UDim2.new(0, 120, 0, 60); aimGui.Position = UDim2.new(0.1, 0, 0.5, 0); aimGui.BackgroundColor3 = Color3.fromRGB(20,20,20); aimGui.Visible = false; aimGui.Active = true; aimGui.Draggable = true; Instance.new("UICorner", aimGui)
local fovCircle = Instance.new("Frame", screenGui); fovCircle.Size = UDim2.new(0, 150, 0, 150); fovCircle.Position = UDim2.new(0.5, -75, 0.5, -75); fovCircle.BackgroundTransparency = 1; fovCircle.Visible = false; Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1,0); local fovStroke = Instance.new("UIStroke", fovCircle); fovStroke.Color = Color3.new(1,1,1); fovStroke.Thickness = 2

local function stopFling() states.fling = false; if flingConnection then flingConnection:Disconnect(); flingConnection = nil end end 
local function startFling() 
    states.fling = true
    flingConnection = rs.Heartbeat:Connect(function()
        if not states.fling or not hrp then return end
        for _, other in pairs(players:GetPlayers()) do
            if other ~= plr and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                local oHrp = other.Character.HumanoidRootPart
                if (hrp.Position - oHrp.Position).Magnitude < 15 then oHrp.AssemblyLinearVelocity = Vector3.new(0, 1000, 0) end
            end
        end
    end)
end

local function createBtn(name, key) 
    local b = Instance.new("TextButton", scroll); b.Text = name .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamSemibold; b.TextSize = 10; Instance.new("UICorner", b) 
    b.MouseButton1Click:Connect(function() 
        states[key] = not states[key]; b.Text = name .. " : " .. (states[key] and "ON" or "OFF"); b.BackgroundColor3 = states[key] and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(30, 30, 35) 
        if key == "god" then
            if states.god then godConnection = rs.Heartbeat:Connect(function() if hum then hum.Health = math.huge; hum.MaxHealth = math.huge; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false); hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false); hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end end)
            else if godConnection then godConnection:Disconnect() end; if hum then hum.MaxHealth = 100; hum.Health = 100; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true); hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true) end end
        elseif key == "fling" then if states.fling then startFling() else stopFling() end 
        elseif key == "noclip" and not states[key] and char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end end 
    end) 
end

createBtn("God Mode", "god"); createBtn("Noclip", "noclip"); createBtn("ESP", "esp"); createBtn("Fling", "fling"); createBtn("Anti Fling", "antifling"); createBtn("Anti Jail", "antijail"); createBtn("Anti Teleport", "antitel"); createBtn("Bypass AC", "bypass"); createBtn("Inf Jump", "infJump"); createBtn("Speed", "speed"); createBtn("FPS Boost", "fps"); createBtn("Custom Title", "title"); createBtn("Anti Ragdoll", "antirag")

local aimMainBtn = Instance.new("TextButton", scroll); aimMainBtn.Text = "Aimbot GUI"; aimMainBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); aimMainBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimMainBtn); aimMainBtn.TextSize = 10
aimMainBtn.MouseButton1Click:Connect(function() states.aimbot = not states.aimbot; aimGui.Visible = states.aimbot; fovCircle.Visible = states.aimbot end)
local innerAimBtn = Instance.new("TextButton", aimGui); innerAimBtn.Size = UDim2.new(0.8, 0, 0.6, 0); innerAimBtn.Position = UDim2.new(0.1, 0, 0.2, 0); innerAimBtn.Text = "Aimbot : OFF"; innerAimBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); innerAimBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", innerAimBtn); innerAimBtn.TextSize = 10
innerAimBtn.MouseButton1Click:Connect(function() states.aimActive = not states.aimActive; innerAimBtn.Text = "Aimbot : " .. (states.aimActive and "ON" or "OFF"); innerAimBtn.BackgroundColor3 = states.aimActive and Color3.fromRGB(50,50,70) or Color3.fromRGB(30,30,35) end)

local dexBtn = Instance.new("TextButton", scroll); dexBtn.Text = "Dark Dex"; dexBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40); dexBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", dexBtn); dexBtn.TextSize = 10
dexBtn.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)

local tpBtn = Instance.new("TextButton", scroll); tpBtn.Text = "Tool TP : OFF"; tpBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); tpBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpBtn); tpBtn.TextSize = 10
tpBtn.MouseButton1Click:Connect(function() states.tooltp = not states.tooltp; tpBtn.Text = "Tool TP : " .. (states.tooltp and "ON" or "OFF"); tpBtn.BackgroundColor3 = states.tooltp and Color3.fromRGB(50,50,70) or Color3.fromRGB(30,30,35); tpTool.Parent = states.tooltp and plr.Backpack or nil end)

UIS.JumpRequest:Connect(function() if states.infJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

rs.RenderStepped:Connect(function()
    if states.aimActive then
        local target = nil; local dist = math.huge
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local headPos = p.Character.Head.Position
                local pos = cam:WorldToScreenPoint(headPos)
                local mDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if mDist < 800 then target = p.Character.Head; dist = mDist end
            end
        end
        if target then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end
    end
    
    if not char or not hum or not hrp then return end
    if states.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if states.speed and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.5) end
    if states.antifling then hrp.AssemblyAngularVelocity = Vector3.zero end
    if states.antitel then if (hrp.Position - lastPos.Position).Magnitude > 50 then hrp.CFrame = lastPos end else lastPos = hrp.CFrame end
    if states.fps then settings().Rendering.QualityLevel = 1; workspace.GraphicsQuality = 1 end
    
    if states.title then 
        local t = char.Head:FindFirstChild("MeknoTitle") or Instance.new("BillboardGui", char.Head)
        t.Name = "MeknoTitle"; t.Size = UDim2.new(0,250,0,50); t.AlwaysOnTop = true; t.ExtentsOffset = Vector3.new(0,3,0); local txt = t:FindFirstChild("TextLabel") or Instance.new("TextLabel", t)
        txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.new(1,0,0); txt.Font = Enum.Font.GothamBold; txt.TextSize = 18; txt.Text = "Meknoyu Here"
    elseif char:FindFirstChild("Head") and char.Head:FindFirstChild("MeknoTitle") then char.Head.MeknoTitle:Destroy() end
    
    for _, p in pairs(players:GetPlayers()) do
        if p ~= plr and p.Character then
            if states.esp then 
                local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
                h.FillColor = Color3.new(1,0,0); h.FillTransparency = 0.5
            elseif p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
        end
    end
    if states.antijail then for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Model") and (v.Name:lower():find("jail") or v.Name:lower():find("cage")) then v:Destroy() end end end
    if states.bypass then pcall(function() sethiddenproperty(plr, "MaximumSimulationRadius", math.huge) end) end
end)
