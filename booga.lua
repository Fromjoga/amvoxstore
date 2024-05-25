-- Local settings
local Heal = "Bloodfruit"
local buttonTextOn = "AutoHeal: On"
local buttonTextOff = "AutoHeal: Off"

-- Create the GUI button
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = buttonTextOff
button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSans
button.TextSize = 14
button.BorderSizePixel = 0
button.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = button

-- Function to change button color
local function setButtonColor(isActive)
    if isActive then
        button.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Green
    else
        button.BorderColor3 = Color3.fromRGB(255, 0, 0) -- Red
    end
end

-- Script logic
local Humanoid = player.Character:WaitForChild("Humanoid")
local Toggle = false

game:GetService("RunService").Heartbeat:Connect(function()
    if Toggle then
        if Humanoid.Health < 99 then
            game:GetService("ReplicatedStorage").Events.UseBagItem:FireServer(Heal)
        end
    end
end)

button.MouseButton1Click:Connect(function()
    Toggle = not Toggle
    button.Text = Toggle and buttonTextOn or buttonTextOff
    setButtonColor(Toggle)
    print("AutoHeal toggled: " .. tostring(Toggle))
end)

-- Enable dragging the button
local UIS = game:GetService("UserInputService")

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)