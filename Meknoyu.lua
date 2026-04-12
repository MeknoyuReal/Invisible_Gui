-- ==================== MEKNOYU GUI ====================
local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local starterGui = game:GetService("StarterGui")

-- Notifikasi Konsisten
starterGui:SetCore("SendNotification", {
    Title = "Meknoyu GUI",
    Text = "Meknoyu Gui Loaded!!",
    Duration = 5
})

local function playPop()
    local s = Instance.new("Sound", workspace)
    s.SoundId = "rbxassetid://6895079853"
    s.Volume = 0.5
    s:Play()
    game.Debris:AddItem(s, 1)
end

-- GUI Parent
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Meknoyu_Stable_Final"
screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

local char, hum, hrp
local function setupChar(c)
    char = c
    hum = c:WaitForChild("Humanoid", 10)
    hrp = c:WaitForChild("HumanoidRootPart", 10)
end
if plr.Character then setupChar(plr.Character) end
plr.CharacterAdded:Connect(setupChar)

-- Main Frame
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 360, 0, 540)
main.Position = UDim2.new(0.5, -180, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2.5
rs.RenderStepped:Connect(function()
    stroke.Color = Color3.fromHSV((tick() * 0.25) % 1, 0.8, 1)
end)

-- Header
local header = Instance.new("TextLabel", main)
header.Size = UDim2.new(1, 0, 0, 45)
header.Text = "MEKNOYU GUI"
header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
header.TextColor3 = Color3.new(1,1,1)
header.Font = Enum.Font.GothamBold
header.TextSize = 18
Instance.new("UICorner", header)

local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 7)
closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", closeBtn)

local miniBtn = Instance.new("TextButton", screenGui)
miniBtn.Size = UDim2.new(0, 45, 0, 45)
miniBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
miniBtn.Text = "M"; miniBtn.Visible = false; miniBtn.BackgroundColor3 = Color3.fromRGB(25,25,25); miniBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1,0)

closeBtn.MouseButton1Click:Connect(function() playPop(); main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() playPop(); main.Visible = true; miniBtn.Visible = false end)

-- Scrolling Frame
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 55)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,2.5,0)
scroll.ScrollBarThickness = 2

local grid = Instance.new("UIGridLayout", scroll)
grid.CellSize = UDim2.new(0.48, 0, 0, 40)
grid.CellPadding = UDim2.new(0.02, 0, 0.02, 0)

local function createBtn(name, isToggle)
    local b = Instance.new("TextButton", scroll)
    b.Text = isToggle and (name .. " : OFF") or name
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamSemibold; b.TextSize = 12
    Instance.new("UICorner", b)
    return b
end

-- SEMUA TOMBOL
local states = {god=false, noclip=false, esp=false, fps=false, fling=false, infJump=false, antiRag=false, speed=false, fog=false, check=false, title=false}

local godBtn = createBtn("God Mode", true)
local noclipBtn = createBtn("Noclip", true)
local espBtn = createBtn("ESP", true)
local fpsBtn = createBtn("FPS Boost", true)
local flingBtn = createBtn("Fling", true)
local infJumpBtn = createBtn("Inf Jump", true)
local antiRagBtn = createBtn("Anti Ragdoll", true)
local speedBtn = createBtn("Speed", true)
local fogBtn = createBtn("Remove Fog", true)
local checkBtn = createBtn("Check Account", true)
local titleBtn = createBtn("Custom Title", true)
local dexBtn = createBtn("Dark Dex", false)

-- ==================== CORE FUNCTIONS ====================

local function addVisuals(p)
    if p == plr then return end
    local c = p.Character
    if not c then return end
    local h = c:WaitForChild("Head", 5)
    local hrpP = c:WaitForChild("HumanoidRootPart", 5)

    if states.check and h and not h:FindFirstChild("MeknoCheck") then
        local b = Instance.new("BillboardGui", h); b.Name = "MeknoCheck"; b.Size = UDim2.new(0,180,0,80); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,5,0)
        local t = Instance.new("TextLabel", b); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 0.5; t.BackgroundColor3 = Color3.new(0,0,0); t.TextColor3 = Color3.new(1,1,0); t.TextSize = 11
        t.Text = "User: "..p.Name.."\nID: "..p.UserId.."\nAge: "..p.AccountAge.."d"
        Instance.new("UICorner", t)
    end

    if states.esp and hrpP then
        if not c:FindFirstChild("MeknoBox") then
            local box = Instance.new("BoxHandleAdornment", c); box.Name = "MeknoBox"; box.Size = Vector3.new(4,6,2); box.AlwaysOnTop = true; box.ZIndex = 5; box.Color3 = Color3.new(1,0,0); box.Transparency = 0.6; box.Adornee = c
        end
        if not hrpP:FindFirstChild("MeknoTracer") then
            local tb = Instance.new("BillboardGui", hrpP); tb.Name = "MeknoTracer"; tb.Size = UDim2.new(0,1.5,2000,0); tb.AlwaysOnTop = true; tb.ExtentsOffset = Vector3.new(0,-1000,0)
            local f = Instance.new("Frame", tb); f.Size = UDim2.new(1,0,1,0); f.BackgroundColor3 = Color3.new(1,1,1); f.BorderSizePixel = 0; f.BackgroundTransparency = 0.4
        end
    end
end

-- Tombol Actions
checkBtn.MouseButton1Click:Connect(function()
    states.check = not states.check
    checkBtn.Text = "Check Account : " .. (states.check and "ON" or "OFF")
    if states.check then for _, v in pairs(players:GetPlayers()) do addVisuals(v) end 
    else for _, v in pairs(players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("MeknoCheck") then v.Character.Head.MeknoCheck:Destroy() end end end
end)

espBtn.MouseButton1Click:Connect(function()
    states.esp = not states.esp
    espBtn.Text = "ESP : " .. (states.esp and "ON" or "OFF")
    if states.esp then for _, v in pairs(players:GetPlayers()) do addVisuals(v) end
    else for _, v in pairs(players:GetPlayers()) do if v.Character then if v.Character:FindFirstChild("MeknoBox") then v.Character.MeknoBox:Destroy() end if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("MeknoTracer") then v.Character.HumanoidRootPart.MeknoTracer:Destroy() end end end end
end)

godBtn.MouseButton1Click:Connect(function() states.god = not states.god; godBtn.Text = "God Mode : " .. (states.god and "ON" or "OFF") end)
noclipBtn.MouseButton1Click:Connect(function() states.noclip = not states.noclip; noclipBtn.Text = "Noclip : " .. (states.noclip and "ON" or "OFF") end)
speedBtn.MouseButton1Click:Connect(function() states.speed = not states.speed; speedBtn.Text = "Speed : " .. (states.speed and "ON" or "OFF") end)
flingBtn.MouseButton1Click:Connect(function() states.fling = not states.fling; flingBtn.Text = "Fling : " .. (states.fling and "ON" or "OFF") end)
infJumpBtn.MouseButton1Click:Connect(function() states.infJump = not states.infJump; infJumpBtn.Text = "Inf Jump : " .. (states.infJump and "ON" or "OFF") end)
antiRagBtn.MouseButton1Click:Connect(function() states.antiRag = not states.antiRag; antiRagBtn.Text = "Anti Ragdoll : " .. (states.antiRag and "ON" or "OFF") end)
fpsBtn.MouseButton1Click:Connect(function() states.fps = not states.fps; fpsBtn.Text = "FPS Boost : " .. (states.fps and "ON" or "OFF"); settings().Rendering.QualityLevel = states.fps and 1 or 0 end)
fogBtn.MouseButton1Click:Connect(function() states.fog = not states.fog; fogBtn.Text = "Remove Fog : " .. (states.fog and "ON" or "OFF"); lighting.FogEnd = states.fog and 100000 or 1000 end)
dexBtn.MouseButton1Click:Connect(function() playPop(); loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)

titleBtn.MouseButton1Click:Connect(function()
    states.title = not states.title
    titleBtn.Text = "Custom Title : " .. (states.title and "ON" or "OFF")
    if states.title and char:FindFirstChild("Head") then
        local b = Instance.new("BillboardGui", char.Head); b.Name = "MeknoTitle"; b.Size = UDim2.new(0,250,0,50); b.StudsOffset = Vector3.new(0,3,0); b.AlwaysOnTop = true
        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.Text = "you scared but noob hahaha"; l.TextColor3 = Color3.new(1,0,0); l.Font = Enum.Font.GothamBold; l.TextSize = 20
    elseif char:FindFirstChild("Head") and char.Head:FindFirstChild("MeknoTitle") then char.Head.MeknoTitle:Destroy() end
end)

-- ==================== LOOPS ====================
game:GetService("UserInputService").JumpRequest:Connect(function()
    if states.infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

rs.Heartbeat:Connect(function()
    if not char or not hrp or not hum then return end
    if states.god then hum.Health = hum.MaxHealth end
    if states.speed and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.4) end
    if states.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if states.antiRag and hum:GetState() == Enum.HumanoidStateType.Physics then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    
    -- FIXED FLING (STABLE)
    if states.fling then
        local oldVelocity = hrp.Velocity
        hrp.Velocity = oldVelocity * Vector3.new(0, 0, 0) + Vector3.new(0, 0.5, 0) -- Jaga ketinggian sedikit biar ga nyungsep
        hrp.RotVelocity = Vector3.new(0, 10000, 0) -- Hanya putar super cepat
        
        -- Deteksi lawan terdekat buat di-fling
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = p.Character.HumanoidRootPart
                if (hrp.Position - targetHrp.Position).Magnitude < 8 then
                    -- Berikan gaya dorong ke lawan saat bersentuhan
                    targetHrp.Velocity = Vector3.new(10000, 10000, 10000)
                end
            end
        end
    end
end)

players.PlayerAdded:Connect(function(p)
    if states.esp or states.check then addVisuals(p) end
end)
