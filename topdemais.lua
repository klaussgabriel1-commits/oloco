--// HUB COMPLETO FINAL - Anti-Fog Profundo (Xeno Executor)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = Workspace.CurrentCamera

-- Bypass seguro para o Xeno Executor (gethui)
local guiParent
local success, result = pcall(function()
    return gethui()
end)
if success and result then
    guiParent = result
else
    guiParent = CoreGui
end

-- Salva valores originais do mapa
local origFogEnd     = Lighting.FogEnd
local origFogStart   = Lighting.FogStart
local origBrightness = Lighting.Brightness
local origClockTime  = Lighting.ClockTime
local origShadows    = Lighting.GlobalShadows

local states = {
    noclip     = false,
    superPulo  = false,
    boatFly    = false,
    fullbright = false,
    noFog      = false,
}

local jumpVal = 100
local boatVal = 150

-- Remove hub anterior se já existir
pcall(function()
    if guiParent:FindFirstChild("LightHubBypass") then
        guiParent.LightHubBypass:Destroy()
    end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "LightHubBypass"
sg.ResetOnSpawn = false
sg.Parent = guiParent

-- Botão Flutuante "HUB" para abrir/fechar o menu no mobile
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 48, 0, 48)
openBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Text = "HUB"
openBtn.TextSize = 13
openBtn.Font = Enum.Font.SourceSansBold
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = sg

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- Janela Principal do Menu
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 420)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = sg

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Barra de Título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local tFix = Instance.new("Frame")
tFix.Size = UDim2.new(1, 0, 0.5, 0)
tFix.Position = UDim2.new(0, 0, 0.5, 0)
tFix.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
tFix.BorderSizePixel = 0
tFix.Parent = titleBar

local tLabel = Instance.new("TextLabel")
tLabel.Size = UDim2.new(1, -40, 1, 0)
tLabel.Position = UDim2.new(0, 10, 0, 0)
tLabel.BackgroundTransparency = 1
tLabel.Text = "Cheat Hub - Blox Fruits"
tLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
tLabel.TextSize = 14
tLabel.Font = Enum.Font.SourceSansBold
tLabel.TextXAlignment = Enum.TextXAlignment.Left
tLabel.Parent = titleBar

local xBtn = Instance.new("TextButton")
xBtn.Size = UDim2.new(0, 26, 0, 26)
xBtn.Position = UDim2.new(1, -32, 0.5, -13)
xBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
xBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
xBtn.Text = "-"
xBtn.TextSize = 16
xBtn.Font = Enum.Font.SourceSansBold
xBtn.Parent = titleBar

Instance.new("UICorner", xBtn).CornerRadius = UDim.new(0, 6)

xBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0, 14)
info.Position = UDim2.new(0, 0, 0, 44)
info.BackgroundTransparency = 1
info.Text = "Clique em HUB para abrir/minimizar"
info.TextColor3 = Color3.fromRGB(110, 110, 140)
info.TextSize = 10
info.Font = Enum.Font.SourceSans
info.Parent = frame

-- Construtor de Toggles
local function toggle(nome, desc, posY, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -16, 0, 46)
    f.Position = UDim2.new(0, 8, 0, posY)
    f.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
    f.BorderSizePixel = 0
    f.Parent = frame

    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 7)

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

    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 16, 0, 16)
    ball.Position = UDim2.new(0, 3, 0.5, -8)
    ball.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
    ball.BorderSizePixel = 0
    ball.Parent = bg

    Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)

    local on = false
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    btn.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(bg, TweenInfo.new(0.15), {
            BackgroundColor3 = on and Color3.fromRGB(80, 40, 180) or Color3.fromRGB(50, 50, 70)
        }):Play()
        TweenService:Create(ball, TweenInfo.new(0.15), {
            Position = on and UDim2.new(0, 21, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
        }):Play()
        cb(on)
    end)
end

-- Construtor de Sliders com suporte a Toque (Mobile)
local activeDrag = nil
UserInputService.InputChanged:Connect(function(inp)
    if activeDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        activeDrag(inp.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
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

    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 7)

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

    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local rel0 = (defV - minV) / (maxV - minV)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(rel0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
    fill.BorderSizePixel = 0
    fill.Parent = track

    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(rel0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track

    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function update(x)
        local r = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local v = math.floor(minV + (maxV - minV) * r)
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, 0, 0.5, 0)
        lbl.Text = nome .. ": " .. v
        cb(v)
    end

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 3.5, 0)
    hitbox.Position = UDim2.new(0, 0, -1.2, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = track

    hitbox.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            activeDrag = update
            update(inp.Position.X)
        end
    end)
end

-- Loop Principal unificado de alta performance (Noclip, Boat Fly e Anti-Fog Profundo)
RunService.RenderStepped:Connect(function(dt)
    -- Noclip
    if states.noclip and character then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

    -- Boat Fly corrigido
    if states.boatFly and humanoid and humanoid.SeatPart then
        local seat = humanoid.SeatPart
        if seat:IsA("VehicleSeat") or seat:IsA("Seat") then
            local model = seat.Parent
            if model and model:IsA("Model") then
                local primary = model.PrimaryPart or seat
                model:PivotTo(primary.CFrame + (camera.CFrame.LookVector * boatVal * dt))
                primary.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end

    -- Anti-Fog Profundo por Frame (Limpa Lighting e Workspace de qualquer neblina)
    if states.noFog then
        Lighting.FogEnd = 9999999
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
        
        -- Remove qualquer atmosfera ou nuvem em Lighting
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("Clouds") then
                v:Destroy() -- Destrói o objeto para o jogo não conseguir recriar
            elseif v:IsA("ColorCorrectionEffect") then
                v.TintColor = Color3.fromRGB(255, 255, 255)
                v.Saturation = 0
            end
        end
    end
end)

player.CharacterAdded:Connect(function(c)
    character = c
    humanoid = c:WaitForChild("Humanoid")
    if states.superPulo then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = jumpVal
    end
end)

-- Montagem dos Itens do Hub
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
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = on and jumpVal or 50
    end
end)
Y = Y + 50

slider("Pulo", Y, 50, 300, jumpVal, function(v)
    jumpVal = v
    if states.superPulo and humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = v
    end
end)
Y = Y + 52

toggle("Boat Fly", "Faz o barco voar e acelerar", Y, function(on)
    states.boatFly = on
end)
Y = Y + 50

slider("Vel. Barco", Y, 50, 300, boatVal, function(v)
    boatVal = v
end)
Y = Y + 52

toggle("Fullbright", "Iluminacao maxima", Y, function(on)
    states.fullbright = on
    if on then
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = origBrightness
        Lighting.ClockTime = origClockTime
        Lighting.GlobalShadows = origShadows
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end) 
Y = Y + 50

toggle("Remover Fog", "Remove nevoa completamente", Y, function(on)
    states.noFog = on
    if not on then
        Lighting.FogEnd = origFogEnd
        Lighting.FogStart = origFogStart
    end
end)

print("Cheat Hub Definitivo com Anti-Fog Profundo Carregado!")
