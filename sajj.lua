-- Put this LocalScript inside StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Skip if user already chose "Don't show again"
if player:FindFirstChild("DeltaReminderDisabled") then
    return
end

-- Prevent showing more than once per execution
if player:FindFirstChild("DeltaReminderShown") then
    return
end

local shownTag = Instance.new("BoolValue")
shownTag.Name = "DeltaReminderShown"
shownTag.Parent = player

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame (main box)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 1
frame.Active = true -- needed for dragging
frame.Draggable = true -- simple drag support
frame.Parent = screenGui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Drop shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0.25, 0)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚠ Reminder"
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextTransparency = 1
title.Parent = frame

-- Message
local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -20, 0.45, 0)
message.Position = UDim2.new(0, 10, 0.25, 0)
message.BackgroundTransparency = 1
message.Text = "Please disable Anti-Scam\nand Anti-Teleport in Delta Settings\nbefore running this script."
message.TextColor3 = Color3.fromRGB(230, 230, 230)
message.TextScaled = true
message.Font = Enum.Font.Gotham
message.TextWrapped = true
message.TextTransparency = 1
message.Parent = frame

-- Checkbox ("Don't show again")
local checkbox = Instance.new("TextButton")
checkbox.Size = UDim2.new(0.8, 0, 0.15, 0)
checkbox.Position = UDim2.new(0.1, 0, 0.72, 0)
checkbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
checkbox.Text = "☐ Don't show again"
checkbox.TextColor3 = Color3.fromRGB(200, 200, 200)
checkbox.TextScaled = true
checkbox.Font = Enum.Font.Gotham
checkbox.TextTransparency = 1
checkbox.Parent = frame

local cbCorner = Instance.new("UICorner")
cbCorner.CornerRadius = UDim.new(0, 8)
cbCorner.Parent = checkbox

local checked = false
checkbox.MouseButton1Click:Connect(function()
    checked = not checked
    checkbox.Text = checked and "☑ Don't show again" or "☐ Don't show again"
end)

-- Close button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.4, 0, 0.15, 0)
button.Position = UDim2.new(0.3, 0, 0.9, 0)
button.Text = "OK"
button.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.TextTransparency = 1
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = button

-- Fade animations
local function fadeIn()
    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(title, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
    TweenService:Create(message, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
    TweenService:Create(checkbox, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
    TweenService:Create(button, TweenInfo.new(0.7), {TextTransparency = 0}):Play()
end

local function fadeOut()
    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(message, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(checkbox, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(button, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    wait(0.6)
    screenGui:Destroy()
end

-- Show reminder
fadeIn()

-- Button closes reminder
button.MouseButton1Click:Connect(function()
    if checked then
        local disableTag = Instance.new("BoolValue")
        disableTag.Name = "DeltaReminderDisabled"
        disableTag.Parent = player
    end

    -- Create blur effect
    local blur = Instance.new("BlurEffect", game.Lighting)
    blur.Size = 15

    -- Loading UI
    local loading = Instance.new("TextLabel")
    loading.Size = UDim2.new(1, 0, 0.2, 0)
    loading.Position = UDim2.new(0, 0, 0.4, 0)
    loading.BackgroundTransparency = 1
    loading.Text = "Loading..."
    loading.TextColor3 = Color3.fromRGB(255, 255, 255)
    loading.TextScaled = true
    loading.Font = Enum.Font.GothamBold
    loading.Parent = frame

    -- Progress bar background
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0.8, 0, 0.05, 0)
    barBg.Position = UDim2.new(0.1, 0, 0.65, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.Parent = frame

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    barFill.Parent = barBg

    -- Gradient
    local grad = Instance.new("UIGradient", barFill)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
    }
    grad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0.2)
    }

    -- Animate Fill
    TweenService:Create(barFill, TweenInfo.new(5, Enum.EasingStyle.Sine), {
        Size = UDim2.new(1, 0, 1, 0)
    }):Play()

    -- Soft chime sound
    local sound = Instance.new("Sound", frame)
    sound.SoundId = "rbxassetid://9118823106"
    sound.Volume = 0.5
    sound:Play()

    -- Fade out and cleanup after 5s
    task.delay(5, function()
        TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(message, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(loading, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(barFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(shadow, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        wait(0.6)
        blur:Destroy()
        screenGui:Destroy()

        -- Load Rayfield after exit
        loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    end)
end)
