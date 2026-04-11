local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MeknoyuGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- CHARACTER
local char, humanoid, root
local function loadChar()
	local c = player.Character or player.CharacterAdded:Wait()
	char = c
	humanoid = c:WaitForChild("Humanoid")
	root = c:WaitForChild("HumanoidRootPart")
end
loadChar()
player.CharacterAdded:Connect(function()
	task.wait(0.3)
	loadChar()
end)

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,340,0,380)
frame.Position = UDim2.new(0.1,0,0.3,0)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

-- GLOW
local glow = Instance.new("UIStroke", frame)
glow.Thickness = 2
RunService.RenderStepped:Connect(function()
	glow.Color = Color3.fromHSV((tick()*0.3)%1,1,1)
end)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "MEKNOYU GUI"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)

-- CLOSE + MINI
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-30,0,3)
close.Text = "X"

local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0,50,0,50)
mini.Position = UDim2.new(0.05,0,0.5,0)
mini.Text = "M"
mini.Visible = false
mini.Active = true
mini.Draggable = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

local function tween(obj,props)
	TweenService:Create(obj,TweenInfo.new(0.25),props):Play()
end

close.MouseButton1Click:Connect(function()
	tween(frame,{Size=UDim2.new(0,0,0,0)})
	task.wait(0.25)
	frame.Visible=false
	mini.Visible=true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible=true
	frame.Size=UDim2.new(0,0,0,0)
	tween(frame,{Size=UDim2.new(0,340,0,380)})
	mini.Visible=false
end)

-- GRID
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1,-8,1,-30)
container.Position = UDim2.new(0,4,0,30)
container.BackgroundTransparency = 1

local layout = Instance.new("UIGridLayout", container)
layout.CellSize = UDim2.new(0.48,0,0,30)
layout.CellPadding = UDim2.new(0.04,0,0.02,0)

local function createBtn(name)
	local b = Instance.new("TextButton")
	b.Text = name.." : OFF"
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.TextWrapped = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
	b.Parent = container
	return b
end

-- BUTTON
local godBtn = createBtn("God Mode")
local noclipBtn = createBtn("Noclip")
local espBtn = createBtn("ESP")
local gfxBtn = createBtn("FPS Boost")
local flingBtn = createBtn("Fling")
local jumpBtn = createBtn("Inf Jump")
local ragdollBtn = createBtn("Anti Ragdoll")
local speedBtn = createBtn("Speed")
local noclip2Btn = createBtn("Noclip2")

-- STATE
local god,noclip,esp,gfx,fling,inf,anti,speed,noclip2=false,false,false,false,false,false,false,false,false

local function toggle(btn,val,name)
	val = not val
	btn.Text = name.." : "..(val and "ON" or "OFF")
	return val
end

-- ESP
local espObjects = {}

local function removeESP()
	for _,data in pairs(espObjects) do
		if data.box then data.box:Destroy() end
		if data.bill then data.bill:Destroy() end
	end
	espObjects = {}
end

local function createESP(plr)
	if plr == player then return end
	
	local function add(c)
		if not esp then return end
		local hrp = c:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		
		local box = Instance.new("BoxHandleAdornment")
		box.Size = Vector3.new(4,6,2)
		box.Color3 = Color3.fromRGB(0,255,0)
		box.Transparency = 0.5
		box.AlwaysOnTop = true
		box.Adornee = c
		box.Parent = c
		
		local bill = Instance.new("BillboardGui", hrp)
		bill.Size = UDim2.new(0,90,0,35)
		bill.AlwaysOnTop = true
		
		local text = Instance.new("TextLabel", bill)
		text.Size = UDim2.new(1,0,1,0)
		text.BackgroundTransparency = 1
		text.TextColor3 = Color3.fromRGB(0,255,0)
		text.TextScaled = true
		
		espObjects[plr] = {box=box,bill=bill,text=text}
	end
	
	if plr.Character then add(plr.Character) end
	plr.CharacterAdded:Connect(function(c)
		task.wait(0.5)
		add(c)
	end)
end

espBtn.MouseButton1Click:Connect(function()
	esp = toggle(espBtn,esp,"ESP")
	removeESP()
	if esp then
		for _,p in pairs(Players:GetPlayers()) do
			createESP(p)
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if esp and root then
		for plr,data in pairs(espObjects) do
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
				data.text.Text = plr.Name.." ["..math.floor(dist).."]"
			end
		end
	end
end)

-- FPS BOOST
local original, savedParts = {}, {}

gfxBtn.MouseButton1Click:Connect(function()
	gfx = toggle(gfxBtn,gfx,"FPS Boost")
	if gfx then
		original.Brightness = Lighting.Brightness
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	else
		settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		Lighting.Brightness = original.Brightness or 2
	end
end)

-- ACTION
godBtn.MouseButton1Click:Connect(function() god=toggle(godBtn,god,"God Mode") end)
noclipBtn.MouseButton1Click:Connect(function() noclip=toggle(noclipBtn,noclip,"Noclip") end)
flingBtn.MouseButton1Click:Connect(function() fling=toggle(flingBtn,fling,"Fling") end)
jumpBtn.MouseButton1Click:Connect(function() inf=toggle(jumpBtn,inf,"Inf Jump") end)
ragdollBtn.MouseButton1Click:Connect(function() anti=toggle(ragdollBtn,anti,"Anti Ragdoll") end)
speedBtn.MouseButton1Click:Connect(function()
	speed=toggle(speedBtn,speed,"Speed")
	if humanoid then humanoid.WalkSpeed = speed and 60 or 16 end
end)
noclip2Btn.MouseButton1Click:Connect(function()
	noclip2 = toggle(noclip2Btn,noclip2,"Noclip2")
end)

UIS.JumpRequest:Connect(function()
	if inf and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- LOOP
RunService.Heartbeat:Connect(function()
	if god and humanoid then humanoid.Health=humanoid.MaxHealth end
	
	if noclip and char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
	
	if fling and root then root.RotVelocity=Vector3.new(0,1200,0) end
	
	if anti and humanoid and humanoid:GetState()==Enum.HumanoidStateType.Physics then
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
	
	-- Noclip2 (ANTI JATUH)
	if noclip2 and root then
		root.Velocity = Vector3.new(root.Velocity.X,0,root.Velocity.Z)
	end
end)
