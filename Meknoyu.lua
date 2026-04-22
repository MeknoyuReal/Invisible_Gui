-- ==================== MEKNOYU GUI ====================
local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")

-- Notification Paten
starterGui:SetCore("SendNotification", {
    Title = "Meknoyu GUI",
    Text = "Meknoyu System Loaded!",
    Duration = 5
})

-- Parent GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mekno_Clean_Final"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

local char, hum, hrp
local godConnection = nil
local forceField = nil
local originalMaxHealth = 100
local flingConnection = nil

local function setupChar(c)
    char = c
    hum = c:WaitForChild("Humanoid", 10)
    hrp = c:WaitForChild("HumanoidRootPart", 10)
end
if plr.Character then setupChar(plr.Character) end
plr.CharacterAdded:Connect(setupChar)

-- Frame UI
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 360, 0, 540)
main.Position = UDim2.new(0.5, -180, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2.5
rs.RenderStepped:Connect(function() stroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) end)

-- Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 45)
header.Text = "MEKNOYU GUI"
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.TextColor3 = Color3.new(1,1,1)
header.Font = Enum.Font.GothamBold; header.TextSize = 18
Instance.new("UICorner", header)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 7)
closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", closeBtn)

local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 45, 0, 45); miniBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
miniBtn.Text = "M"; miniBtn.Visible = false; miniBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); miniBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1,0)

closeBtn.MouseButton1Click:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true; miniBtn.Visible = false end)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -70); scroll.Position = UDim2.new(0, 10, 0, 55); scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,2.5,0); scroll.ScrollBarThickness = 2
local grid = Instance.new("UIGridLayout", scroll); grid.CellSize = UDim2.new(0.48, 0, 0, 40); grid.CellPadding = UDim2.new(0.02, 0, 0.02, 0)

-- State & Toggle
local states = {god=false, noclip=false, esp=false, fling=false, infJump=false, speed=false, check=false, title=false, fps=false, fog=false, antirag=false, antijail=false, bypass=false}

-- Fling Functions (No Spin - No Forward - Noclip Player)
local function stopFling() 
    states.fling = false 
    if flingConnection then flingConnection:Disconnect(); flingConnection = nil end 
    if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0) end 
end 

local function startFling() 
    if not hrp or not hum then return end 
    states.fling = true 
    flingConnection = rs.Heartbeat:Connect(function() 
        if not states.fling or not hrp then stopFling(); return end 
        for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanTouch = false end end 
        for _, other in pairs(players:GetPlayers()) do 
            if other ~= plr and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then 
                local otherRoot = other.Character.HumanoidRootPart 
                if (hrp.Position - otherRoot.Position).Magnitude < 8 then 
                    local pushDir = (otherRoot.Position - hrp.Position).Unit 
                    otherRoot.AssemblyLinearVelocity = pushDir * 110 + Vector3.new(0, 55, 0) 
                end 
            end 
        end 
    end) 
end 

local function createBtn(name, key) 
    local b = Instance.new("TextButton", scroll) 
    b.Text = name .. " : OFF" 
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1) 
    b.Font = Enum.Font.GothamSemibold; b.TextSize = 10 
    Instance.new("UICorner", b) 
    b.MouseButton1Click:Connect(function() 
        states[key] = not states[key] 
        b.Text = name .. " : " .. (states[key] and "ON" or "OFF") 
        b.BackgroundColor3 = states[key] and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(30, 30, 35) 
        if key == "god" then 
            if states.god then 
                if hum then 
                    originalMaxHealth = hum.MaxHealth 
                    hum.MaxHealth = math.huge; hum.Health = math.huge 
                    hum.BreakJointsOnDeath = false 
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) 
                    if char and not forceField then forceField = Instance.new("ForceField"); forceField.Visible = false; forceField.Parent = char end 
                    godConnection = rs.Heartbeat:Connect(function() if hum and states.god then hum.Health = math.huge; hum.MaxHealth = math.huge end end) 
                end 
            else 
                if godConnection then godConnection:Disconnect(); godConnection = nil end 
                if forceField then forceField:Destroy(); forceField = nil end 
                if hum then 
                    hum.MaxHealth = originalMaxHealth; hum.Health = originalMaxHealth 
                    hum.BreakJointsOnDeath = true; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) 
                end 
            end 
        elseif key == "fling" then if states.fling then startFling() else stopFling() end 
        elseif key == "noclip" and not states[key] and char then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end end 
    end) 
    return b 
end

-- Tombol
createBtn("God Mode", "god")
createBtn("Noclip", "noclip")
createBtn("ESP", "esp")
createBtn("Fling", "fling")
createBtn("Anti Jail", "antijail")
createBtn("Bypass AC", "bypass")
createBtn("Inf Jump", "infJump")
createBtn("Speed", "speed")
createBtn("Check Account", "check")
createBtn("Custom Title", "title")
createBtn("FPS Boost", "fps")
createBtn("Remove Fog", "fog")
createBtn("Anti Ragdoll", "antirag")

local dexBtn = Instance.new("TextButton", scroll) 
dexBtn.Text = "Dark Dex"; dexBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); dexBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", dexBtn); dexBtn.TextSize = 10 
dexBtn.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)

-- ==================== SYSTEM LOGIC ====================
local function applyVisuals(p) 
    if p == plr then return end 
    local function setup(c) 
        if not c then return end 
        rs.RenderStepped:Connect(function() 
            if states.esp and c.Parent then 
                local h = c:FindFirstChild("MeknoH") or Instance.new("Highlight", c) 
                h.Name = "MeknoH"; h.FillColor = Color3.new(1,0,0); h.OutlineColor = Color3.new(1,1,1); h.FillTransparency = 0.5 
            else 
                if c:FindFirstChild("MeknoH") then c.MeknoH:Destroy() end 
            end 
            if states.check and c:FindFirstChild("Head") then 
                local head = c.Head 
                local tag = head:FindFirstChild("MeknoCheck") or Instance.new("BillboardGui", head) 
                tag.Name = "MeknoCheck"; tag.Size = UDim2.new(0,160,0,50); tag.AlwaysOnTop = true; tag.ExtentsOffset = Vector3.new(0,3,0) 
                local txt = tag:FindFirstChild("TextLabel") or Instance.new("TextLabel", tag) 
                txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.new(1,1,0); txt.Font = Enum.Font.GothamBold; txt.TextSize = 12; txt.TextStrokeTransparency = 0 
                txt.Text = "User: "..p.Name.."\nAge: "..p.AccountAge.."d" 
            else 
                if c:FindFirstChild("Head") and c.Head:FindFirstChild("MeknoCheck") then c.Head.MeknoCheck:Destroy() end 
            end 
        end) 
    end 
    p.CharacterAdded:Connect(setup); if p.Character then setup(p.Character) end 
end 

rs.Stepped:Connect(function() 
    if not char or not hum or not hrp then return end 
    if states.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end 
    if states.speed and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.5) end 
    if states.antirag and hum:GetState() == Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end 
    if states.fps then settings().Rendering.QualityLevel = 1 else settings().Rendering.QualityLevel = 0 end 
    if states.fog then game.Lighting.FogEnd = 100000 else game.Lighting.FogEnd = 1000 end 
    
    -- Added: Anti Jail & Bypass AC
    if states.antijail then
        for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Model") and (v.Name:lower():find("jail") or v.Name:lower():find("cage")) then v:Destroy() end end
    end
    if states.bypass then
        sethiddenproperty(plr, "MaximumSimulationRadius", math.huge)
    end

    if states.title and char:FindFirstChild("Head") then 
        local head = char.Head 
        local tTag = head:FindFirstChild("MeknoTitle") or Instance.new("BillboardGui", head) 
        tTag.Name = "MeknoTitle"; tTag.Size = UDim2.new(0,250,0,50); tTag.AlwaysOnTop = true; tTag.ExtentsOffset = Vector3.new(0,3,0) 
        local tTxt = tTag:FindFirstChild("TextLabel") or Instance.new("TextLabel", tTag) 
        tTxt.Size = UDim2.new(1,0,1,0); tTxt.BackgroundTransparency = 1; tTxt.TextColor3 = Color3.new(1,0,0); tTxt.Font = Enum.Font.GothamBold; tTxt.TextSize = 18; tTxt.Text = "Meknoyu Here" 
    elseif char:FindFirstChild("Head") and char.Head:FindFirstChild("MeknoTitle") then char.Head.MeknoTitle:Destroy() end 
end) 

game:GetService("UserInputService").JumpRequest:Connect(function() if states.infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end) 
plr.CharacterAdded:Connect(function() task.wait(0.4); if states.fling then stopFling(); startFling() end end) 
for _, v in pairs(players:GetPlayers()) do applyVisuals(v) end 
players.PlayerAdded:Connect(applyVisuals)
