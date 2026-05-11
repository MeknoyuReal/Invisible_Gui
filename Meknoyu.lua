-- ==================== MEKNOYU GUI (LOCKED) ====================
local plr = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local players = game:GetService("Players")
local starterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local mps = game:GetService("MarketplaceService")
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

--// BYPASS ANTICHEAT CORE (ULTRA) //--
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "Kick" or method == "kick" or method == "BreakJoints") then
        return nil 
    end
    return old(self, unpack({...}))
end)
setreadonly(mt, true)

-- Block Deteksi Zona & Objek Anticheat
workspace.DescendantAdded:Connect(function(v)
    if states.bypassac and (v.Name:lower():find("anticheat") or v.Name:lower():find("detector")) then
        if v:IsA("BasePart") then v.CanTouch = false; v.CanQuery = false end
    end
end)

starterGui:SetCore("SendNotification", { Title = "Meknoyu GUI", Text = "System Fully Loaded!", Duration = 5 })

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Mekno_Clean_Final"; screenGui.ResetOnSpawn = false
screenGui.Parent = (gethui and gethui()) or plr:WaitForChild("PlayerGui")

local char, hum, hrp
local godConnection, lastPos, savedPos = nil, nil, nil
local states = {god=false, noclip=false, esp=false, fling=false, antifling=false, infJump=false, speed=false, fps=false, title=false, antirag=false, antijail=false, bypassac=false, tooltp=false, antitel=false, aimbot=false, aimActive=false, antirobux=false, savepos=false}

local function setupChar(c)
    char = c; hum = c:WaitForChild("Humanoid", 10); hrp = c:WaitForChild("HumanoidRootPart", 10)
    if hrp then lastPos = hrp.CFrame end
end
if plr.Character then setupChar(plr.Character) end
plr.CharacterAdded:Connect(setupChar)

--// TELEPORT BACK GUI //--
local tpBackGui = Instance.new("Frame", screenGui); tpBackGui.Size = UDim2.new(0, 160, 0, 100); tpBackGui.Position = UDim2.new(0.8, 0, 0.5, 0); tpBackGui.BackgroundColor3 = Color3.fromRGB(20,20,20); tpBackGui.Visible = false; tpBackGui.Active = true; tpBackGui.Draggable = true; Instance.new("UICorner", tpBackGui)
local saveBtn = Instance.new("TextButton", tpBackGui); saveBtn.Size = UDim2.new(0.9, 0, 0.4, 0); saveBtn.Position = UDim2.new(0.05, 0, 0.05, 0); saveBtn.Text = "Save Pos : OFF"; saveBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); saveBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", saveBtn)
local clickTpBtn = Instance.new("TextButton", tpBackGui); clickTpBtn.Size = UDim2.new(0.9, 0, 0.4, 0); clickTpBtn.Position = UDim2.new(0.05, 0, 0.55, 0); clickTpBtn.Text = "Click TP Back"; clickTpBtn.BackgroundColor3 = Color3.fromRGB(60,20,20); clickTpBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", clickTpBtn)

saveBtn.MouseButton1Click:Connect(function()
    states.savepos = not states.savepos
    saveBtn.Text = "Save Pos : " .. (states.savepos and "ON" or "OFF")
    if states.savepos and hrp then savedPos = hrp.CFrame end
end)
clickTpBtn.MouseButton1Click:Connect(function()
    if savedPos and hrp then wait(0.1); hrp.CFrame = savedPos end
end)

--// TOOL TP LOGIC //--
local tpTool = Instance.new("Tool"); tpTool.Name = "Mekno TP Tool"; tpTool.RequiresHandle = false
tpTool.Activated:Connect(function() if mouse.Hit and hrp then hrp.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0)) end end)

--// MAIN UI STRUCTURE //--
local main = Instance.new("Frame", screenGui); main.Size = UDim2.new(0, 360, 0, 540); main.Position = UDim2.new(0.5, -180, 0.2, 0); main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.Active = true; main.Draggable = true; Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main); stroke.Thickness = 2.5; rs.RenderStepped:Connect(function() stroke.Color = Color3.fromHSV((tick() * 0.2) % 1, 0.8, 1) end)

local header = Instance.new("TextLabel", main); header.Size = UDim2.new(1, 0, 0, 45); header.Text = "MEKNOYU GUI"; header.BackgroundColor3 = Color3.fromRGB(25, 25, 25); header.TextColor3 = Color3.new(1,1,1); header.Font = Enum.Font.GothamBold; header.TextSize = 18; Instance.new("UICorner", header)

-- Tombol X dan M
local closeBtn = Instance.new("TextButton", main); closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 7); closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); Instance.new("UICorner", closeBtn)
local miniBtn = Instance.new("TextButton", screenGui); miniBtn.Size = UDim2.new(0, 45, 0, 45); miniBtn.Position = UDim2.new(0.02, 0, 0.1, 0); miniBtn.Text = "M"; miniBtn.Visible = false; miniBtn.BackgroundColor3 = Color3.fromRGB(20,20,20); miniBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1,0); miniBtn.Draggable = true

closeBtn.MouseButton1Click:Connect(function() main.Visible = false; miniBtn.Visible = true end)
miniBtn.MouseButton1Click:Connect(function() main.Visible = true; miniBtn.Visible = false end)

local scroll = Instance.new("ScrollingFrame", main); scroll.Size = UDim2.new(1, -20, 1, -70); scroll.Position = UDim2.new(0, 10, 0, 55); scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,3,0); scroll.ScrollBarThickness = 2; Instance.new("UIGridLayout", scroll).CellSize = UDim2.new(0.48, 0, 0, 40)

local function createBtn(name, key)
    local b = Instance.new("TextButton", scroll); b.Text = name .. " : OFF"; b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamSemibold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        states[key] = not states[key]
        b.Text = name .. " : " .. (states[key] and "ON" or "OFF")
        b.BackgroundColor3 = states[key] and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(30, 30, 35)
        
        -- Logic Reset pas OFF
        if key == "god" then
            if states.god then
                godConnection = rs.Heartbeat:Connect(function() 
                    if hum then hum.Health = 1e9; hum.MaxHealth = 1e9; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end
                    for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanTouch = false end end
                end)
            elseif godConnection then 
                godConnection:Disconnect() 
                if hum then hum.MaxHealth = 100; hum.Health = 100; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end
            end
        elseif key == "noclip" and not states.noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = true end end
        elseif key == "esp" and not states.esp then
            for _, p in pairs(players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("MeknoHighlight") then p.Character.MeknoHighlight:Destroy() end
            end
        elseif key == "title" and not states.title then
            if char:FindFirstChild("Head") and char.Head:FindFirstChild("MeknoTitle") then char.Head.MeknoTitle:Destroy() end
        end
    end)
end

createBtn("Bypass AntiCheat", "bypassac"); createBtn("God Mode", "god"); createBtn("Noclip", "noclip"); createBtn("ESP", "esp"); createBtn("Fling", "fling"); createBtn("Anti Fling", "antifling"); createBtn("Anti Teleport", "antitel"); createBtn("Inf Jump", "infJump"); createBtn("Speed", "speed")

local tpBackBtn = Instance.new("TextButton", scroll); tpBackBtn.Text = "Teleport Back"; tpBackBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); tpBackBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpBackBtn); tpBackBtn.TextSize = 10
tpBackBtn.MouseButton1Click:Connect(function() tpBackGui.Visible = not tpBackGui.Visible end)

createBtn("Anti Robux", "antirobux"); createBtn("Custom Title", "title"); createBtn("Anti Ragdoll", "antirag")

--// AIMBOT GUI & FOV //--
local aimGui = Instance.new("Frame", screenGui); aimGui.Size = UDim2.new(0, 120, 0, 60); aimGui.Position = UDim2.new(0.1, 0, 0.5, 0); aimGui.BackgroundColor3 = Color3.fromRGB(20,20,20); aimGui.Visible = false; aimGui.Draggable = true; Instance.new("UICorner", aimGui)
local aimMainBtn = Instance.new("TextButton", scroll); aimMainBtn.Text = "Aimbot GUI"; aimMainBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); aimMainBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", aimMainBtn); aimMainBtn.TextSize = 10
aimMainBtn.MouseButton1Click:Connect(function() states.aimbot = not states.aimbot; aimGui.Visible = states.aimbot end)
local innerAimBtn = Instance.new("TextButton", aimGui); innerAimBtn.Size = UDim2.new(0.9,0,0.7,0); innerAimBtn.Position = UDim2.new(0.05,0,0.15,0); innerAimBtn.Text = "Smart Aim : OFF"; innerAimBtn.BackgroundColor3 = Color3.fromRGB(40,40,40); innerAimBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", innerAimBtn)
innerAimBtn.MouseButton1Click:Connect(function() states.aimActive = not states.aimActive; innerAimBtn.Text = "Smart Aim : " .. (states.aimActive and "ON" or "OFF") end)

-- DARK DEX & TOOL TP
local dexBtn = Instance.new("TextButton", scroll); dexBtn.Text = "Dark Dex"; dexBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40); dexBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", dexBtn); dexBtn.TextSize = 10
dexBtn.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
local tpBtn = Instance.new("TextButton", scroll); tpBtn.Text = "Tool TP : OFF"; tpBtn.BackgroundColor3 = Color3.fromRGB(30,30,35); tpBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", tpBtn); tpBtn.TextSize = 10
tpBtn.MouseButton1Click:Connect(function() states.tooltp = not states.tooltp; tpBtn.Text = "Tool TP : " .. (states.tooltp and "ON" or "OFF"); tpTool.Parent = states.tooltp and plr.Backpack or nil end)

--// JUMP & RENDER LOOP //--
UIS.JumpRequest:Connect(function() if states.infJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)
rs.RenderStepped:Connect(function()
    if not char or not hum or not hrp then return end
    if states.god and hum.Health < 1e9 then hum.Health = 1e9 end
    if (states.bypassac or states.antitel) and lastPos and (hrp.Position - lastPos.Position).Magnitude > 45 and not (states.speed or states.tooltp) then hrp.CFrame = lastPos end
    lastPos = hrp.CFrame

    if states.aimActive then
        local target = nil; local dist = 200
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head; local pos, onScreen = cam:WorldToScreenPoint(head.Position)
                if onScreen then
                    local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                    if mouseDist < dist then
                        local ray = Ray.new(cam.CFrame.Position, (head.Position - cam.CFrame.Position).Unit * 500)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char, p.Character})
                        if not hit then target = head; dist = mouseDist end
                    end
                end
            end
        end
        if target then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position) end
    end

    if states.esp then
        for _, p in pairs(players:GetPlayers()) do
            if p ~= plr and p.Character and not p.Character:FindFirstChild("MeknoHighlight") then
                local h = Instance.new("Highlight", p.Character); h.Name = "MeknoHighlight"; h.AlwaysOnTop = true
            end
        end
    end

    if states.title and char:FindFirstChild("Head") then
        local head = char.Head; local t = head:FindFirstChild("MeknoTitle") or Instance.new("BillboardGui", head)
        t.Name = "MeknoTitle"; t.Size = UDim2.new(0,200,0,50); t.AlwaysOnTop = true; t.ExtentsOffset = Vector3.new(0,3,0)
        local txt = t:FindFirstChild("TextLabel") or Instance.new("TextLabel", t)
        txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.new(1,0,0); txt.Font = Enum.Font.GothamBold; txt.TextSize = 18; txt.Text = "Meknoyu Here"
    end

    if states.noclip then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if states.speed and hum.MoveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (hum.MoveDirection * 1.5) end
end)
