--// MENU DO AÇAÍ COM ESP PLAYERS - Xeno Executor
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
    espPlayers = false,
}

local jumpVal = 100
local boatVal = 150
local fovVal = camera.FieldOfView

-- Remove hub anterior se já existir
pcall(function()
    if guiParent:FindFirstChild("MenuDoAcaiHub") then
        guiParent.MenuDoAcaiHub:Destroy()
    end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "MenuDoAcaiHub"
sg.ResetOnSpawn = false
sg.Parent = guiParent

-- Botão Flutuante "AÇAÍ" para abrir/fechar o menu no mobile
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 48, 0, 48)
openBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Text = "AÇAÍ"
openBtn.TextSize = 12
openBtn.Font = Enum.Font.SourceSansBold
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = sg

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- Janela Principal do Menu
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 440, 0, 310)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = sg

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Barra Superior (Título)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
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
tLabel.Position = UDim2.new(0, 12, 0, 0)
tLabel.BackgroundTransparency = 1
tLabel.Text = "Menu do Açaí"
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

-- Painel Lateral esquerdo (Abas)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -38)
sidebar.Position = UDim2.new(0, 0, 0, 38)
sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame

-- Título da Aba Ativa na Direita
local tabTitle = Instance.new("TextLabel")
tabTitle.Size = UDim2.new(1, -145, 0, 28)
tabTitle.Position = UDim2.new(0, 140, 0, 44)
tabTitle.BackgroundTransparency = 1
tabTitle.Text = "Principal"
tabTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
tabTitle.TextSize = 14
tabTitle.Font = Enum.Font.SourceSansBold
tabTitle.TextXAlignment = Enum.TextXAlignment.Left
tabTitle.Parent = frame

-- Container de Conteúdo com Rolagem
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -145, 1, -85)
container.Position = UDim2.new(0, 140, 0, 75)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 3
container.Parent = frame

local tabs = {}
local function createTab(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.Position = UDim2.new(0, 6, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    btn.TextColor3 = Color3.fromRGB(180, 180, 210)
    btn.Text = name
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = container

    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 8)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = page

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabs) do p.Visible = false end
        page.Visible = true
        tabTitle.Text = name
    end)

    tabs[name] = page
    return page
end

-- Criando as 4 Abas Laterais
local tabPrincipal = createTab("Principal", 10)
local tabVeiculo = createTab("Veículo", 52)
local tabVisual = createTab("Visual", 94)
local tabOpcoes = createTab("Opções", 136)

tabPrincipal.Visible = true

-- Funções Auxiliares
local function addToggle(parentPage, nome, desc, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -5, 0, 48)
    f.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    f.BorderSizePixel = 0
    f.Parent = parentPage
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)

    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(0.65, 0, 0, 20)
    n.Position = UDim2.new(0, 10, 0, 6)
    n.BackgroundTransparency = 1
    n.Text = nome
    n.TextColor3 = Color3.fromRGB(220, 220, 255)
    n.TextSize = 12
    n.Font = Enum.Font.SourceSansBold
    n.TextXAlignment = Enum.TextXAlignment.Left
    n.Parent = f

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(0.65, 0, 0, 16)
    d.Position = UDim2.new(0, 10, 0, 26)
    d.BackgroundTransparency = 1
    d.Text = desc
    d.TextColor3 = Color3.fromRGB(130, 130, 160)
    d.TextSize = 10
    d.Font = Enum.Font.SourceSans
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = f

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 42, 0, 22)
    bg.Position = UDim2.new(1, -50, 0.5, -11)
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
            Position = on and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
        }):Play()
        cb(on)
    end)
end

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

local function addSlider(parentPage, nome, minV, maxV, defV, cb)
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1, -5, 0, 50)
    c.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    c.BorderSizePixel = 0
    c.Parent = parentPage
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 20)
    lbl.Position = UDim2.new(0, 8, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = nome .. ": " .. defV
    lbl.TextColor3 = Color3.fromRGB(220, 220, 255)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = c

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 7)
    track.Position = UDim2.new(0, 8, 0, 32)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    track.BorderSizePixel = 0
    track.Parent = c
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local rel0 = math.clamp((defV - minV) / (maxV - minV), 0, 1)
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

-- === SISTEMA DE ESP PLAYERS ===
local espFolder = Instance.new("Folder")
espFolder.Name = "MenuDoAcaiESP"
espFolder.Parent = CoreGui

local function removeESP(p)
    if p.Character then
        local h = p.Character:FindFirstChild("AcaiHighlight")
        if h then h:Destroy() end
        local t = p.Character:FindFirstChild("AcaiTag")
        if t then t:Destroy() end
    end
end

local function addESP(p)
    if p == player then return end
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if states.espPlayers then
            removeESP(p)
            local highlight = Instance.new("Highlight")
            highlight.Name = "AcaiHighlight"
            highlight.Adornee = char
            highlight.FillColor = Color3.fromRGB(138, 43, 226) -- Roxo Açaí
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.Parent = char

            local head = char:WaitForChild("Head", 3)
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "AcaiTag"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = head
                billboard.Parent = char

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = p.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 12
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextStrokeTransparency = 0.3
                nameLabel.Parent = billboard
            end
        end
    end)
    
    if p.Character and states.espPlayers then
        local char = p.Character
        local highlight = Instance.new("Highlight")
        highlight.Name = "AcaiHighlight"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(138, 43, 226)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.Parent = char

        local head = char:FindFirstChild("Head")
        if head then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "AcaiTag"
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Adornee = head
            billboard.Parent = char

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = p.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 12
            nameLabel.Font = Enum.Font.SourceSansBold
            nameLabel.TextStrokeTransparency = 0.3
            nameLabel.Parent = billboard
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    addESP(p)
end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

-- === ADICIONANDO OS ITENS NAS ABAS ===

-- Aba Principal
addToggle(tabPrincipal, "Noclip", "Atravessa paredes", function(on)
    states.noclip = on
    if not on and character then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end)

addToggle(tabPrincipal, "Super Pulo", "Ativa pulo alto", function(on)
    states.superPulo = on
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = on and jumpVal or 50
    end
end)

addSlider(tabPrincipal, "Força do Pulo", 50, 300, jumpVal, function(v)
    jumpVal = v
    if states.superPulo and humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = v
    end
end)

-- Aba Veículo
addToggle(tabVeiculo, "Boat Fly", "Faz o barco voar e acelerar", function(on)
    states.boatFly = on
end)

addSlider(tabVeiculo, "Velocidade do Barco", 50, 300, boatVal, function(v)
    boatVal = v
end)

-- Aba Visual (Com ESP Players incluído)
addToggle(tabVisual, "ESP Players", "Mostra jogadores através das paredes", function(on)
    states.espPlayers = on
    if on then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                addESP(p)
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            removeESP(p)
        end
    end
end)

addToggle(tabVisual, "Fullbright", "Iluminação máxima", function(on)
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

addToggle(tabVisual, "Remover Fog", "Remove névoa completamente", function(on)
    states.noFog = on
    if not on then
        Lighting.FogEnd = origFogEnd
        Lighting.FogStart = origFogStart
    end
end)

-- Aba Opções (FOV e Unload)
addSlider(tabOpcoes, "Ajustar FOV", 70, 120, math.floor(camera.FieldOfView), function(v)
    camera.FieldOfView = v
end)

local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, -5, 0, 44)
unloadBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.Text = "Fechar / Unload Menu"
unloadBtn.TextSize = 12
unloadBtn.Font = Enum.Font.SourceSansBold
unloadBtn.Parent = tabOpcoes
Instance.new("UICorner", unloadBtn).CornerRadius = UDim.new(0, 6)

unloadBtn.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
    sg:Destroy()
    print("Menu do Açaí fechado com sucesso!")
end)

-- Loop Global de Alta Performance
RunService.RenderStepped:Connect(function(dt)
    if states.noclip and character then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

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

    if states.noFog then
        Lighting.FogEnd = 9999999
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("Clouds") then
                v:Destroy()
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

print("Menu do Açaí carregado com sucesso!")
