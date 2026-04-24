local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
-- Mendukung berbagai fungsi clipboard executor
local Clipboard = setclipboard or (syn and syn.write_clipboard) or function(text)
    if not isrbxactive() then return end
    -- Fallback sederhana jika fungsi clipboard executor tidak tersedia
end

-- Bersihkan GUI lama jika ada
if CoreGui:FindFirstChild("Kovex_Executor") then CoreGui.Kovex_Executor:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "Kovex_Executor"

-- MAIN FRAME
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 400)
Main.Position = UDim2.new(0.5, -175, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true -- Bisa digeser
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Kovex Executor"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- INPUT BOXES
local function CreateInput(yPos, placeholder)
    local box = Instance.new("TextBox", Main)
    box.Size = UDim2.new(0, 330, 0, 140)
    box.Position = UDim2.new(0, 10, 0, yPos)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box)
    return box
end

local CodeBox = CreateInput(40, "Enter code here...")
local ScriptBox = CreateInput(190, "Script executor box...")

-- BUTTON CONTAINER
local BtnContainer = Instance.new("Frame", Main)
BtnContainer.Size = UDim2.new(1, 0, 0, 50)
BtnContainer.Position = UDim2.new(0, 0, 0, 340)
BtnContainer.BackgroundTransparency = 1

local function CreateBtn(name, xPos, color, callback)
    local btn = Instance.new("TextButton", BtnContainer)
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = UDim2.new(0, xPos, 0, 5)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- LOGIC BUTTONS
CreateBtn("EXECUTE", 20, Color3.fromRGB(0, 150, 0), function()
    local fullScript = CodeBox.Text .. "\n" .. ScriptBox.Text
    local success, err = pcall(function() loadstring(fullScript)() end)
    if not success then warn("Kovex Error: " .. tostring(err)) end
end)

CreateBtn("CLEAR", 125, Color3.fromRGB(150, 0, 0), function()
    CodeBox.Text = ""
    ScriptBox.Text = ""
end)

CreateBtn("CLIPBOARD", 230, Color3.fromRGB(0, 100, 200), function()
    local fullText = CodeBox.Text .. "\n" .. ScriptBox.Text
    Clipboard(fullText)
end)
