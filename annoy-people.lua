local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local Button = Instance.new("TextButton")
local TitleLabel = Instance.new("TextLabel")

ScreenGui.Name = "DarkModePanel"
ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.BorderSizePixel = 0
Frame.Visible = false

TitleBar.Parent = ScreenGui
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.Position = Frame.Position
TitleBar.Size = UDim2.new(0, 300, 0, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Draggable = true

TitleLabel.Parent = TitleBar
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Text = "Dark Mode Panel"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14

CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14

MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.TextSize = 14

Button.Parent = Frame
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.Position = UDim2.new(0.25, 0, 0.5, -25)
Button.Size = UDim2.new(0.5, 0, 0.5, 0)
Button.Text = "Start"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)

local running = false
local teleportLoop

local function startTeleporting()
    running = true
    Button.Text = "Stop"
    
    teleportLoop = coroutine.create(function()
        while running do
            local players = game.Players:GetPlayers()
            local randomPlayer = players[math.random(1, #players)]
            if randomPlayer and randomPlayer.Character then
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(randomPlayer.Character.PrimaryPart.CFrame)
            end
            task.wait()
        end
    end)
    
    coroutine.resume(teleportLoop)
end

local function stopTeleporting()
    running = false
    Button.Text = "Start"
end

Button.MouseButton1Click:Connect(function()
    if running then
        stopTeleporting()
    else
        startTeleporting()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

TitleBar:GetPropertyChangedSignal("Position"):Connect(function()
    Frame.Position = TitleBar.Position + UDim2.new(0, 0, 0, 30)
end)
