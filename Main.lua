--// HUB LEVE - Versão com Boat Speed (Xeno Executor)
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local origFogEnd      = Lighting.FogEnd
local origFogStart    = Lighting.FogStart
local origBrightness  = Lighting.Brightness
local origClockTime   = Lighting.ClockTime
local origShadows     = Lighting.GlobalShadows

local states = {
    noclip    = false,
    superPulo = false,
    boatSpeed = false,
    fullbright = false,
    noFog     = false,
}

local jumpVal  = 100
local boatVal  = 250 -- Velocidade padrão do barco modificada
local playerGui = player:WaitForChild("PlayerGui")

pcall(function()
    local old = playerGui:FindFirstChild("LightHub")
    if old then old:Destroy() end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "LightHub"
sg.ResetOnSpawn = false
sg.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 420)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local fc = Instance.new("UICorner")
fc.CornerRadius = UDim.new(0, 10)
fc.Parent = frame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 10)
tc.Parent = titleBar

local tFix = Instance.new("Frame")
tFix.Size = UDim2.new(1, 0, 0.5, 0)
tFix.Position = UDim2.new(0, 0, 0.5, 0)
tFix.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
tFix.BorderSizePixel = 0
tFix.Parent = titleBar

local tLabel = Instance.new("TextLabel")
tLabel.Size = UDim2.new(1, -40, 1, 0)
tLabel.BackgroundTransparency = 1
tLabel.Text = "Cheat Hub - Blox Fruits"
tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tLabel.TextSize = 14
tLabel.Font = Enum.Font.SourceSansBold
tLabel.Parent = titleBar

local xBtn = Instance.new("TextButton")
xBtn.Size = UDim2.new(0, 26, 0, 26)
xBtn.Position = UDim2.new(1, -32, 0.5, -13)
xBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
xBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
xBtn.Text = "X"
xBtn.TextSize = 12
xBtn.Font = Enum.Font.SourceSansBold
xBtn.Parent = titleBar

local xc = Instance.new("UICorner")
xc.CornerRadius = UDim.new(0, 6)
xc.Parent = xBtn

xBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0, 14)
info.Position = UDim2.new(0, 0, 0, 44)
info.BackgroundTransparency = 1
info.Text = "Arraste pelo título para mover"
info.TextColor3 = Color3.fromRGB(110, 110, 140)
info.TextSize = 10
info.Font = Enum.Font.SourceSans
info.Parent = frame

local function toggle(nome, desc, posY, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -16, 0, 46)
    f.Position = UDim2.new(0, 8, 0, posY)
    f.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
    f.BorderSizePixel = 0
    f.Parent = frame

    local fc2 = Instance.new("UICorner")
    fc2.CornerRadius = UDim.new(0, 7)
    fc2.Parent = f

    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(0.65, 0, 0.55, 0)
    n.Position = UDim2.new(0, 8, 0, 3)
    n.BackgroundTransparency = 1
    n.Text = nome
    n.TextColor3 = Color3.fromRGB(220, 220, 255)
    n.TextSize = 12
    n.Font = Enum.Font.SourceSansBold
    n.TextXAlignment = Enum.TextXAlignment.Left
    n.Parent = f

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(0.65, 0, 0.4, 0)
    d.Position = UDim2.new(0, 8, 0.56, 0)
    d.BackgroundTransparency = 1
    d.Text = desc
    d.TextColor3 = Color3.fromRGB(110, 110, 140)
    d.TextSize = 9
    d.Font = Enum.Font.SourceSans
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 40, 0, 22)
    bg.Position = UDim2.new(1, -48, 0.5, -11)
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    bg.BorderSizePixel = 0
    bg.Parent = f

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = bg

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 16, 0, 16)
    ball.Position = UDim2.new(0, 3, 0.5, -8)
    ball.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    ball.BorderSizePixel = 0
    ball.Parent = bg

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = ball

    local on = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    btn.MouseButton1Click:Connect(function()
        on = not on
        local TS = game:GetService("TweenService")
        TS:Create(bg, TweenInfo.new(0.15), {
            BackgroundColor3 = on and Color3.fromRGB(80,40,180) or Color3.fromRGB(50,50,70)
        }):Play()
        TS:Create(ball, TweenInfo.new(0.15), {
            Position = on and UDim2.new(0,21,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,180)
        }):Play()
        cb(on)
    end)
end

local activeDrag = nil
UserInputService.InputChanged:Connect(function(inp)
    if activeDrag and inp.UserInputType == Enum.UserInputType.MouseMovement then
        activeDrag(inp.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        activeDrag = nil
    end
end)

local function slider(nome, posY, minV, maxV, defV, cb)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1, -16, 0, 48)
    c.Position = UDim2.new(0, 8, 0, posY)
    c.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
    c.BorderSizePixel = 0
    c.Parent = frame

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 7)
    cc.Parent = c

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = UDim2.new(0, 8, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = nome .. ": " .. defV
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = c

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 7)
    track.Position = UDim2.new(0, 8, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    track.BorderSizePixel = 0
    track.Parent = c

    local trc = Instance.new("UICorner")
    trc.CornerRadius = UDim.new(1, 0)
    trc.Parent = track

    local rel0 = (defV - minV) / (maxV - minV)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(rel0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillc = Instance.new("UICorner")
    fillc.CornerRadius = UDim.new(1, 0)
    fillc.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(rel0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local function update(x)
        local r = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(minV + (maxV - minV) * r)
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, 0, 0.5, 0)
        lbl.Text = nome .. ": " .. v
        cb(v)
    end

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 3, 0)
    hitbox.Position = UDim2.new(0, 0, -1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = track

    hitbox.MouseButton1Down:Connect(function()
        activeDrag = update
    end)
end

-- Lógica do Noclip leve
task.spawn(function()
    while true do
        task.wait(0.1)
        if states.noclip and character then
            for _, p in ipairs(character:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end
end)

-- Lógica da Velocidade do Barco (Boat Speed)
task.spawn(function()
    while true do
        task.wait(0.2)
        if states.boatSpeed then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") or v.Name:lower():find("boat") or v.Name:lower():find("ship") then
                    if v.AssemblyLinearVelocity.Magnitude > 5 then
                        v.AssemblyLinearVelocity = v.CFrame.LookVector * boatVal
                    end
                end
            end
        end
    end
end)

player.CharacterAdded:Connect(function(c)
    character = c
    humanoid = c:WaitForChild("Humanoid")
    if states.superPulo then humanoid.JumpPower = jumpVal end
end)

local Y = 62

toggle("Noclip", "Atravessa paredes", Y, function(on)
    states.noclip = on
    if not on and character then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end) 
Y = Y + 50

toggle("Super Pulo", "Ajuste o valor abaixo", Y, function(on)
    states.superPulo = on
    if humanoid then humanoid.JumpPower = on and jumpVal or 50 end
end) 
Y = Y + 50

slider("Pulo", Y, 50, 300, jumpVal, function(v)
    jumpVal = v
    if states.superPulo and humanoid then humanoid.JumpPower = v end
end) 
Y = Y + 52

toggle("Boat Speed", "Acelera qualquer barco", Y, function(on)
    states.boatSpeed = on
end) 
Y = Y + 50

slider("Vel. Barco", Y, 50, 500, boatVal, function(v)
    boatVal = v
end) 
Y = Y + 52

toggle("Fullbright", "Iluminacao maxima", Y, function(on)
    states.fullbright = on
    if on then
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness = origBrightness
        Lighting.ClockTime = origClockTime
        Lighting.GlobalShadows = origShadows
        Lighting.Ambient = Color3.fromRGB(0,0,0)
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
    end
end) 
Y = Y + 50

toggle("Remover Fog", "Remove nevoa do mapa", Y, function(on)
    states.noFog = on
    Lighting.FogEnd   = on and 1e9 or origFogEnd
    Lighting.FogStart = on and 1e9 or origFogStart
end)

print("Hub com Boat Speed carregado com sucesso!")
