local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ModMenu"
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local startLoopButton = Instance.new("TextButton")
startLoopButton.Size = UDim2.new(0, 200, 0, 50)
startLoopButton.Position = UDim2.new(0.5, -100, 0.2, 0)
startLoopButton.Text = "Start Loop"
startLoopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startLoopButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
startLoopButton.BorderSizePixel = 0
startLoopButton.Parent = frame

local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0, 200, 0, 50)
stopButton.Position = UDim2.new(0.5, -100, 0.4, 0)
stopButton.Text = "Stop Loops"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
stopButton.BorderSizePixel = 0
stopButton.Parent = frame

local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        frame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

local loops = {}
local loopIndex = 0

local function startTeleportLoop()
    loopIndex = loopIndex + 1
    local currentIndex = loopIndex
    local loopActive = true
    table.insert(loops, {index = currentIndex, active = loopActive})

    local function teleport()
        while loops[currentIndex].active do
            local players = Players:GetPlayers()
            if #players > 1 then
                local randomPlayer = players[math.random(1, #players)]
                if randomPlayer ~= LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
                end
            end
            RunService.Stepped:Wait()
        end
    end

    coroutine.wrap(teleport)()
end

local function stopAllLoops()
    for _, loop in pairs(loops) do
        loop.active = false
    end
    loops = {}
end

startLoopButton.MouseButton1Click:Connect(startTeleportLoop)
stopButton.MouseButton1Click:Connect(stopAllLoops)

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function animateButton(button)
    local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 200, 255)})
    tween:Play()
    tween.Completed:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end)
end

startLoopButton.MouseEnter:Connect(function()
    animateButton(startLoopButton)
end)

stopButton.MouseEnter:Connect(function()
    animateButton(stopButton)
end)
