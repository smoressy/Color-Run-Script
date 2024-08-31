-- Create and configure the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatLogger"
screenGui.Parent = game.CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 220)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui

-- Add rounded corners to mainFrame
local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 10)
mainFrameCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 10)
titleBarCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "Chat Logger"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)  -- Fixed button position
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(230, 70, 70)
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.Parent = titleBar

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 8)
closeButtonCorner.Parent = closeButton

-- Close functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Username Input
local usernameInput = Instance.new("TextBox")
usernameInput.Size = UDim2.new(0, 360, 0, 35)
usernameInput.Position = UDim2.new(0, 30, 0, 50)
usernameInput.PlaceholderText = "Enter Username (type 3+ letters)"
usernameInput.Text = ""
usernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
usernameInput.BorderSizePixel = 0
usernameInput.Font = Enum.Font.Gotham
usernameInput.TextSize = 16
usernameInput.ClearTextOnFocus = false
usernameInput.Parent = mainFrame

local usernameInputCorner = Instance.new("UICorner")
usernameInputCorner.CornerRadius = UDim.new(0, 8)
usernameInputCorner.Parent = usernameInput

-- Copy Button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 360, 0, 35)
copyButton.Position = UDim2.new(0, 30, 0, 95)
copyButton.Text = "Copy Latest Message"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
copyButton.BorderSizePixel = 0
copyButton.Font = Enum.Font.Gotham
copyButton.TextSize = 16
copyButton.Parent = mainFrame

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 8)
copyButtonCorner.Parent = copyButton

-- Drop shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Message storage
local latestMessages = {}

-- Update autocomplete functionality
local function updateAutoComplete()
    while task.wait(0.1) do  -- Slight delay to prevent excessive processing
        local inputText = usernameInput.Text:lower()
        if #inputText >= 3 then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Name:lower():sub(1, #inputText) == inputText then
                    usernameInput.Text = player.Name
                    usernameInput.CursorPosition = #player.Name + 1
                    break
                end
            end
        end
    end
end

spawn(updateAutoComplete)

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    local playerName = usernameInput.Text
    local message = latestMessages[playerName]
    if message then
        setclipboard(message)
        print("Copied latest message from " .. playerName)
    else
        print("No message found for " .. playerName)
    end
end)

-- Chat event handler
local function onPlayerChatted(player, message)
    latestMessages[player.Name] = message
end

-- Connect chat events for all players
for _, player in ipairs(game.Players:GetPlayers()) do
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end

-- Handle new players joining
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)

-- Dragging functionality for the main frame
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
