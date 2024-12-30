local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperPowerGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame
MainFrame.Parent = ScreenGui

local Blur = Instance.new("BlurEffect")
Blur.Size = 20
Blur.Parent = game:GetService("Lighting")

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
Gradient.Rotation = 45
Gradient.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TitleBar.BorderSizePixel = 0
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "✨ SUPER POWERS ✨"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = TitleBar

local CloseButton = Instance.new("ImageButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.ImageTransparency = 1
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton
CloseButton.Parent = TitleBar

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
Content.Parent = MainFrame

local function CreateSlider(name, min, max, default, yPos)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 60)
    SliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    SliderFrame.Parent = Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, -20, 0, 6)
    SliderBG.Position = UDim2.new(0, 10, 0, 40)
    SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    local SliderBGCorner = Instance.new("UICorner")
    SliderBGCorner.CornerRadius = UDim.new(1, 0)
    SliderBGCorner.Parent = SliderBG
    SliderBG.Parent = SliderFrame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(90, 140, 255)
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    SliderFill.Parent = SliderBG

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -60, 0, 5)
    ValueLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.TextSize = 14
    ValueLabel.Font = Enum.Font.GothamBold
    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 4)
    ValueCorner.Parent = ValueLabel
    ValueLabel.Parent = SliderFrame

    local function updateValue(input)
        local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (pos * (max - min)))
        TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        ValueLabel.Text = tostring(value)
        return value
    end

    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local value = updateValue(input)
            if name == "Walk Speed" then
                LocalPlayer.Character.Humanoid.WalkSpeed = value
            elseif name == "Jump Power" then
                LocalPlayer.Character.Humanoid.JumpPower = value
            elseif name == "Fly Speed" then
                _G.flySpeed = value
            elseif name == "Field of View" then
                workspace.CurrentCamera.FieldOfView = value
            elseif name == "Gravity" then
                workspace.Gravity = value
            end

            local dragging
            dragging = UserInputService.InputChanged:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseMovement then
                    local value = updateValue(input2)
                    if name == "Walk Speed" then
                        LocalPlayer.Character.Humanoid.WalkSpeed = value
                    elseif name == "Jump Power" then
                        LocalPlayer.Character.Humanoid.JumpPower = value
                    elseif name == "Fly Speed" then
                        _G.flySpeed = value
                    elseif name == "Field of View" then
                        workspace.CurrentCamera.FieldOfView = value
                    elseif name == "Gravity" then
                        workspace.Gravity = value
                    end
                end
            end)

            UserInputService.InputEnded:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseButton1 then
                    if dragging then
                        dragging:Disconnect()
                    end
                end
            end)
        end
    end)

    return SliderFrame
end

local function CreateToggle(name, yPos)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 50)
    ToggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    ToggleFrame.Parent = Content

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 70, 0, 30)
    Button.Position = UDim2.new(1, -80, 0.5, -15)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Button.Text = "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    Button.Parent = ToggleFrame

    local toggled = false
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = toggled and Color3.fromRGB(90, 140, 255) or Color3.fromRGB(40, 40, 45)
        }):Play()
        Button.Text = toggled and "ON" or "OFF"
        
        if name == "Fly Mode" then
            if toggled then
                local bp = Instance.new("BodyPosition")
                bp.Name = "FlyBodyPosition"
                bp.Parent = LocalPlayer.Character.HumanoidRootPart
                bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                
                game:GetService("RunService").RenderStepped:Connect(function()
                    if LocalPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FlyBodyPosition") then
                        local bp = LocalPlayer.Character.HumanoidRootPart.FlyBodyPosition
                        bp.Position = LocalPlayer.Character.HumanoidRootPart.Position +
                            ((UserInputService:IsKeyDown(Enum.KeyCode.W) and (workspace.CurrentCamera.CFrame.LookVector * _G.flySpeed)) or Vector3.new(0,0,0)) +
                            ((UserInputService:IsKeyDown(Enum.KeyCode.S) and (workspace.CurrentCamera.CFrame.LookVector * -_G.flySpeed)) or Vector3.new(0,0,0)) +
                            ((UserInputService:IsKeyDown(Enum.KeyCode.D) and (workspace.CurrentCamera.CFrame.RightVector * _G.flySpeed)) or Vector3.new(0,0,0)) +
                            ((UserInputService:IsKeyDown(Enum.KeyCode.A) and (workspace.CurrentCamera.CFrame.RightVector * -_G.flySpeed)) or Vector3.new(0,0,0)) +
                            ((UserInputService:IsKeyDown(Enum.KeyCode.Space) and Vector3.new(0, _G.flySpeed, 0)) or Vector3.new(0,0,0)) +
                            ((UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and Vector3.new(0, -_G.flySpeed, 0)) or Vector3.new(0,0,0))
                    end
                end)
            else
                if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyBodyPosition") then
                    LocalPlayer.Character.HumanoidRootPart.FlyBodyPosition:Destroy()
                end
            end
        end
    end)
end

local dragging
local dragInput
local dragStart
local startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)

_G.flySpeed = 50

local function AnimateUI()
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Blur.Size = 0
    
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 320, 0, 450),
        Position = UDim2.new(0.5, -160, 0.5, -225)
    }):Play()
    
    TweenService:Create(Blur, TweenInfo.new(0.5), {Size = 20}):Play()
end

AnimateUI()

local yOffset = 20
local spacing = 70

CreateSlider("Walk Speed", 5, 500, 16, yOffset)
yOffset = yOffset + spacing
CreateSlider("Jump Power", 30, 500, 50, yOffset)
yOffset = yOffset + spacing
CreateSlider("Fly Speed", 5, 200, 50, yOffset)
yOffset = yOffset + spacing
CreateSlider("Field of View", 30, 120, 70, yOffset)
yOffset = yOffset + spacing
CreateSlider("Gravity", 0, 196, 196, yOffset)
yOffset = yOffset + spacing
CreateToggle("Fly Mode", yOffset)

Content.CanvasSize = UDim2.new(0, 0, 0, yOffset + spacing)
