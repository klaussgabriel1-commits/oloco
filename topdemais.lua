--// MENU DO AÇAÍ COMPLETO (UPGRADED V2) - Xeno Executor
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")

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
    noclip       = false,
    superPulo    = false,
    walkSpeed    = false,
    infiniteJump = false,
    waterWalk    = false,
    boatFly      = false,
    fullbright   = false,
    noFog        = false,
    espPlayers   = false,
    espFruits    = false,
    espChests    = false,
    espIslands   = false,
    hitbox       = false,
    aimbot       = false,
    antiAfk      = false,
    autoFarm     = false,
    spectating   = false,
    vehicleBounce= false,
}

local jumpVal = 100
local speedVal = 16
local boatVal = 150
local fovVal = camera.FieldOfView
local spectateTarget = nil

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

-- Botão Flutuante "AÇAÍ"
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
frame.Size = UDim2.new(0, 460, 0, 330)
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
tLabel.Text = "Menu do Açaí [Pro Edition]"
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
sidebar.Size = UDim2.new(0, 120, 1, -68)
sidebar.Position = UDim2.new(0, 0, 0, 38)
sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame

-- Título da Aba Ativa na Direita
local tabTitle = Instance.new("TextLabel")
tabTitle.Size = UDim2.new(1, -135, 0, 28)
tabTitle.Position = UDim2.new(0, 130, 0, 44)
tabTitle.BackgroundTransparency = 1
tabTitle.Text = "Player"
tabTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
tabTitle.TextSize = 14
tabTitle.Font = Enum.Font.SourceSansBold
tabTitle.TextXAlignment = Enum.TextXAlignment.Left
tabTitle.Parent = frame

-- Container de Conteúdo com Rolagem
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -135, 1, -105)
container.Position = UDim2.new(0, 130, 0, 75)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 3
container.Parent = frame

local tabs = {}
local function createTab(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    btn.TextColor3 = Color3.fromRGB(180, 180, 210)
    btn.Text = name
    btn.TextSize = 11
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

-- Criando as Abas (Com a nova aba "Farm" e sem teleporte)
local tabPlayer   = createTab("Player", 5)
local tabVeiculo  = createTab("Veículo", 36)
local tabVisual   = createTab("Visual", 67)
local tabPvp      = createTab("PvP", 98)
local tabFarm     = createTab("Farm", 129)
local tabSpectate = createTab("Spectate", 160)
local tabOpcoes   = createTab("Opções", 191)

tabPlayer.Visible = true

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
        lbl.Text = nome .. ": " + v
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

-- Funções ESP básicas
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
            highlight.FillColor = Color3.fromRGB(138, 43, 226)
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
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)

-- Aimbot Target Finder
local function getClosestPlayer()
    local closestTarget = nil
    local shortestDist = math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local pos, onScreen = camera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = p.Character.Head
                    end
                end
            end
        end
    end
    return closestTarget
end

-- === POPULANDO AS ABAS ===

-- 1. Aba Player
addToggle(tabPlayer, "Noclip", "Atravessa paredes", function(on)
    states.noclip = on
end)

addToggle(tabPlayer, "Super Pulo", "Ativa pulo alto", function(on)
    states.superPulo = on
    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = on and jumpVal or 50
    end
end)

addSlider(tabPlayer, "Força do Pulo", 50, 300, jumpVal, function(v)
    jumpVal = v
    if states.superPulo and humanoid then humanoid.JumpPower = v end
end)

addToggle(tabPlayer, "WalkSpeed", "Aumenta a velocidade", function(on)
    states.walkSpeed = on
end)

addSlider(tabPlayer, "Velocidade", 16, 300, speedVal, function(v)
    speedVal = v
end)

addToggle(tabPlayer, "Pulo Infinito", "Pula várias vezes no ar", function(on)
    states.infiniteJump = on
end)

-- 2. Aba Veículo
addToggle(tabVeiculo, "Boat Fly", "Faz o barco voar e acelerar", function(on)
    states.boatFly = on
end)

addSlider(tabVeiculo, "Velocidade do Barco", 50, 300, boatVal, function(v)
    boatVal = v
end)

addToggle(tabVeiculo, "Impulso de Veículo", "Faz o veículo pular/destravar", function(on)
    states.vehicleBounce = on
end)

-- 3. Aba Visual
addToggle(tabVisual, "ESP Players", "Mostra jogadores nas paredes", function(on)
    states.espPlayers = on
end)

addToggle(tabVisual, "Fullbright", "Iluminação máxima", function(on)
    states.fullbright = on
    if on then
        Lighting.Brightness = 5
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = origBrightness
        Lighting.ClockTime = origClockTime
        Lighting.GlobalShadows = origShadows
    end
end)

addToggle(tabVisual, "Remover Fog", "Remove névoa completamente", function(on)
    states.noFog = on
end)

-- 4. Aba PvP
addToggle(tabPvp, "Aimbot", "Trava a câmera no alvo mais próximo", function(on)
    states.aimbot = on
end)

addToggle(tabPvp, "Aumentar Hitbox", "Facilita acertar inimigos", function(on)
    states.hitbox = on
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            hrp.Size = on and Vector3.new(6, 6, 6) or Vector3.new(2, 2, 1)
            hrp.Transparency = on and 0.7 or 1
            hrp.CanCollide = false
        end
    end
end)

-- 5. Aba Farm (Auto-Farm / Aura movido para cá)
addToggle(tabFarm, "Auto-Farm / Aura", "Ataca alvos próximos automaticamente", function(on)
    states.autoFarm = on
end)

-- 6. Aba Spectate Corrigida
local function refreshSpectateList()
    for _, child in ipairs(tabSpectate:GetChildren()) do
        if child:IsA("TextButton") and child.Name ~= "StopSpec" then child:Destroy() end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -5, 0, 32)
            pBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            pBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
            pBtn.Text = "Espiar: " .. p.Name
            pBtn.TextSize = 11
            pBtn.Font = Enum.Font.SourceSansBold
            pBtn.Parent = tabSpectate
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)

            pBtn.MouseButton1Click:Connect(function()
                spectateTarget = p
                states.spectating = true
            end)
        end
    end
end

local stopSpecBtn = Instance.new("TextButton")
stopSpecBtn.Name = "StopSpec"
stopSpecBtn.Size = UDim2.new(1, -5, 0, 32)
stopSpecBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
stopSpecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopSpecBtn.Text = "Parar de Espiar"
stopSpecBtn.TextSize = 11
stopSpecBtn.Font = Enum.Font.SourceSansBold
stopSpecBtn.Parent = tabSpectate
Instance.new("UICorner", stopSpecBtn).CornerRadius = UDim.new(0, 6)

stopSpecBtn.MouseButton1Click:Connect(function()
    states.spectating = false
    spectateTarget = nil
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
    end
end)

refreshSpectateList()
Players.PlayerAdded:Connect(refreshSpectateList)
Players.PlayerRemoving:Connect(refreshSpectateList)

-- 7. Aba Opções
addSlider(tabOpcoes, "Ajustar FOV", 70, 120, math.floor(camera.FieldOfView), function(v)
    camera.FieldOfView = v
end)

addToggle(tabOpcoes, "Anti-AFK", "Evita timeout por inatividade", function(on)
    states.antiAfk = on
    if on then
        local vu = game:GetService("VirtualUser")
        player.Idled:Connect(function()
            if states.antiAfk then
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
    end
end)

local soundBtn = Instance.new("TextButton")
soundBtn.Size = UDim2.new(1, -5, 0, 34)
soundBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
soundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
soundBtn.Text = "Tocar Som de Alerta (Soundboard)"
soundBtn.TextSize = 11
soundBtn.Font = Enum.Font.SourceSansBold
soundBtn.Parent = tabOpcoes
Instance.new("UICorner", soundBtn).CornerRadius = UDim.new(0, 6)

soundBtn.MouseButton1Click:Connect(function()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://9060864272"
    s.Volume = 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end)

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(1, -5, 0, 34)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Text = "Reconectar no Servidor"
rejoinBtn.TextSize = 11
rejoinBtn.Font = Enum.Font.SourceSansBold
rejoinBtn.Parent = tabOpcoes
Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0, 6)
rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

local unloadBtn = Instance.new("TextButton")
unloadBtn.Size = UDim2.new(1, -5, 0, 34)
unloadBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
unloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadBtn.Text = "Fechar / Unload Menu"
unloadBtn.TextSize = 11
unloadBtn.Font = Enum.Font.SourceSansBold
unloadBtn.Parent = tabOpcoes
Instance.new("UICorner", unloadBtn).CornerRadius = UDim.new(0, 6)
unloadBtn.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

-- === RODAPÉ DE STATUS (FPS, Ping, Tempo Online) ===
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 26)
footer.Position = UDim2.new(0, 0, 1, -26)
footer.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
footer.BorderSizePixel = 0
footer.Parent = frame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -12, 1, 0)
infoLabel.Position = UDim2.new(0, 6, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
infoLabel.TextSize = 10
infoLabel.Font = Enum.Font.Code
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = footer

local startTime = tick()
local frameCount = 0
local fps = 60
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
end)

task.spawn(function()
    while true do
        task.wait(1)
        fps = frameCount
        frameCount = 0
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if states.noclip and character then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if states.walkSpeed and humanoid then
        humanoid.WalkSpeed = speedVal
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

    if states.vehicleBounce and humanoid and humanoid.SeatPart then
        local seat = humanoid.SeatPart
        if seat.Parent:IsA("Model") then
            local primary = seat.Parent.PrimaryPart or seat
            primary.AssemblyLinearVelocity = primary.AssemblyLinearVelocity + Vector3.new(0, 35, 0)
        end
    end

    if states.noFog then
        Lighting.FogEnd = 9999999
        Lighting.FogStart = 0
        Lighting.GlobalShadows = false
    end

    if states.aimbot then
        local targetHead = getClosestPlayer()
        if targetHead then
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)
        end
    end

    -- Lógica corrigida do Spectate para fixar perfeitamente no alvo
    if states.spectating and spectateTarget then
        if spectateTarget.Character and spectateTarget.Character:FindFirstChildOfClass("Humanoid") then
            camera.CameraSubject = spectateTarget.Character:FindFirstChildOfClass("Humanoid")
        end
    end

    -- Atualiza o painel de status
    local elapsed = math.floor(tick() - startTime)
    local mins = math.floor(elapsed / 60)
    local secs = elapsed % 60
    local pingVal = 0
    pcall(function() pingVal = math.floor(player:GetNetworkPing() * 1000) end)
    
    infoLabel.Text = string.format("FPS: %d | Ping: %dms | Tempo: %02d:%02d", fps, pingVal, mins, secs)
end)

UserInputService.JumpRequest:Connect(function()
    if states.infiniteJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

player.CharacterAdded:Connect(function(c)
    character = c
    humanoid = c:WaitForChild("Humanoid")
    if states.superPulo then humanoid.UseJumpPower = true humanoid.JumpPower = jumpVal end
    if states.walkSpeed then humanoid.WalkSpeed = speedVal end
end)

print("Menu do Açaí [Pro Edition V2] Carregado com Sucesso!")
