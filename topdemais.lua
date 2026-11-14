--// MENU DO AÇAÍ [GOD-TIER UI CUSTOMIZER EDITION] - Xeno Executor
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local SoundService = game:GetService("SoundService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Bypass seguro para o Xeno Executor (gethui)
local guiParent
pcall(function() guiParent = gethui() end)
guiParent = guiParent or CoreGui

-- Salva valores originais do mapa
local origFogEnd     = Lighting.FogEnd
local origFogStart   = Lighting.FogStart
local origBrightness = Lighting.Brightness
local origClockTime  = Lighting.ClockTime
local origShadows    = Lighting.GlobalShadows

local states = {
    noclip          = false,
    superPulo       = false,
    walkSpeed       = false,
    infiniteJump    = false,
    waterWalk       = false,
    boatFly         = false,
    fullbright      = false,
    noFog           = false,
    espPlayers      = false,
    espBoss         = false,
    bossDistLimit   = true,
    notifyBoss      = true,
    notifyFruit     = true,
    hitbox          = false,
    aimbot          = false,
    autoFarm        = false,
    spectating      = false,
    vehicleBounce   = false,
    following       = false,
    menuDraggable   = true,
    showOpenButton  = true,
    autoSaveUI      = true,
}

local toggleCallbacks = {}
local themeElements = {}
local bgElements = {}
local cornerElements = {}

local jumpVal = 100
local speedVal = 16
local boatVal = 150
local bossDistVal = 1000

-- Valores de Customização do Menu
local menuTransVal = 0
local menuWidthVal = 460
local menuHeightVal = 330
local menuCornerVal = 10
local openBtnSizeVal = 48
local currentThemeColor = Color3.fromRGB(80, 40, 180)
local currentBgColor = Color3.fromRGB(22, 22, 32)

local spectateTarget = nil
local followTarget = nil
local toggleKey = Enum.KeyCode.Delete

local configFileName = "MenuDoAcai_GodTierUI.json"

local function sendNotification(title, text)
    task.spawn(function()
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title;
                Text = text;
                Duration = 3;
            })
        end)
    end)
end

local function saveConfig(silent)
    pcall(function()
        if writefile then
            local data = {
                states = states,
                jumpVal = jumpVal,
                speedVal = speedVal,
                boatVal = boatVal,
                bossDistVal = bossDistVal,
                menuTransVal = menuTransVal,
                menuWidthVal = menuWidthVal,
                menuHeightVal = menuHeightVal,
                menuCornerVal = menuCornerVal,
                openBtnSizeVal = openBtnSizeVal,
                themeColor = {currentThemeColor.R, currentThemeColor.G, currentThemeColor.B},
                bgColor = {currentBgColor.R, currentBgColor.G, currentBgColor.B},
                toggleKey = toggleKey.Name
            }
            writefile(configFileName, HttpService:JSONEncode(data))
            if not silent then
                sendNotification("Menu do Açaí", "Configurações e Layout salvos!")
            end
        end
    end)
end

local function triggerAutoSave()
    if states.autoSaveUI then
        saveConfig(true)
    end
end

local function loadConfig()
    pcall(function()
        if readfile and isfile and isfile(configFileName) then
            local content = readfile(configFileName)
            local data = HttpService:JSONDecode(content)
            if data then
                if data.states then
                    for k, v in pairs(data.states) do
                        if states[k] ~= nil then states[k] = v end
                    end
                end
                if data.jumpVal then jumpVal = data.jumpVal end
                if data.speedVal then speedVal = data.speedVal end
                if data.boatVal then boatVal = data.boatVal end
                if data.bossDistVal then bossDistVal = data.bossDistVal end
                if data.menuTransVal then menuTransVal = data.menuTransVal end
                if data.menuWidthVal then menuWidthVal = data.menuWidthVal end
                if data.menuHeightVal then menuHeightVal = data.menuHeightVal end
                if data.menuCornerVal then menuCornerVal = data.menuCornerVal end
                if data.openBtnSizeVal then openBtnSizeVal = data.openBtnSizeVal end
                if data.themeColor then
                    currentThemeColor = Color3.new(data.themeColor[1], data.themeColor[2], data.themeColor[3])
                end
                if data.bgColor then
                    currentBgColor = Color3.new(data.bgColor[1], data.bgColor[2], data.bgColor[3])
                end
                if data.toggleKey then
                    pcall(function() toggleKey = Enum.KeyCode[data.toggleKey] end)
                end
            end
        end
    end)
end

local function deleteConfig()
    pcall(function()
        if delfile and isfile and isfile(configFileName) then
            delfile(configFileName)
            sendNotification("Menu do Açaí", "Save apagado! Reabra o menu para resetar.")
        end
    end)
end

loadConfig()

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
openBtn.Size = UDim2.new(0, openBtnSizeVal, 0, openBtnSizeVal)
openBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
openBtn.BackgroundColor3 = currentThemeColor
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Text = "AÇAÍ"
openBtn.TextSize = 12
openBtn.Font = Enum.Font.SourceSansBold
openBtn.Active = true
openBtn.Draggable = true
openBtn.Visible = states.showOpenButton
openBtn.Parent = sg
table.insert(themeElements, {obj = openBtn, type = "bg"})

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

-- Janela Principal do Menu
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, menuWidthVal, 0, menuHeightVal)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = currentBgColor
frame.BackgroundTransparency = menuTransVal
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = states.menuDraggable
frame.Visible = false
frame.Parent = sg
table.insert(bgElements, frame)

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, menuCornerVal)
table.insert(cornerElements, frameCorner)

local function toggleMenu()
    frame.Visible = not frame.Visible
end

openBtn.MouseButton1Click:Connect(toggleMenu)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey then
        toggleMenu()
    end
end)

-- Barra Superior (Título)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = currentThemeColor
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
table.insert(themeElements, {obj = titleBar, type = "bg"})

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, menuCornerVal)
table.insert(cornerElements, titleCorner)

local tLabel = Instance.new("TextLabel")
tLabel.Size = UDim2.new(1, -40, 1, 0)
tLabel.Position = UDim2.new(0, 12, 0, 0)
tLabel.BackgroundTransparency = 1
tLabel.Text = "Menu do Açaí [God-Tier UI]"
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
local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 120, 1, -68)
sidebar.Position = UDim2.new(0, 0, 0, 38)
sidebar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
sidebar.BackgroundTransparency = math.clamp(menuTransVal, 0, 0.5)
sidebar.BorderSizePixel = 0
sidebar.ScrollBarThickness = 2
sidebar.Parent = frame

local sidebarList = Instance.new("UIListLayout")
sidebarList.Padding = UDim.new(0, 4)
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Parent = sidebar

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

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -135, 1, -85)
container.Position = UDim2.new(0, 130, 0, 72)
container.BackgroundTransparency = 1
container.Parent = frame

local tabs = {}
local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
    btn.TextColor3 = Color3.fromRGB(180, 180, 210)
    btn.Text = name
    btn.TextSize = 11
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.Visible = false
    page.Parent = container

    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 8)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = page

    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
    end)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabs) do p.Visible = false end
        page.Visible = true
        tabTitle.Text = name
    end)

    tabs[name] = page
    return page
end

local tabPlayer   = createTab("Player")
local tabVeiculo  = createTab("Veículo")
local tabVisual   = createTab("Visual")
local tabPvp      = createTab("PvP")
local tabFarm     = createTab("Farm")
local tabSpectate = createTab("Spectate")
local tabMenu     = createTab("Menu")
local tabOpcoes   = createTab("Opções")

tabPlayer.Visible = true
sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarList.AbsoluteContentSize.Y + 10)

local function applyThemeColor(color)
    currentThemeColor = color
    for _, item in ipairs(themeElements) do
        if item.type == "bg" and item.obj and item.obj.Parent then
            item.obj.BackgroundColor3 = color
        elseif item.type == "toggleBg" and item.obj and item.obj.Parent and item.getStatus() then
            item.obj.BackgroundColor3 = color
        end
    end
end

local function applyBgColor(color)
    currentBgColor = color
    for _, obj in ipairs(bgElements) do
        if obj and obj.Parent then
            obj.BackgroundColor3 = color
        end
    end
end

local function applyCornerRadius(radius)
    menuCornerVal = radius
    for _, c in ipairs(cornerElements) do
        if c and c.Parent then
            c.CornerRadius = UDim.new(0, radius)
        end
    end
end

local function addToggle(parentPage, stateKey, nome, desc, cb)
    local initialVal = states[stateKey] or false
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

    local on = initialVal

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 42, 0, 22)
    bg.Position = UDim2.new(1, -50, 0.5, -11)
    bg.BackgroundColor3 = on and currentThemeColor or Color3.fromRGB(50, 50, 70)
    bg.BorderSizePixel = 0
    bg.Parent = f
    table.insert(themeElements, {obj = bg, type = "toggleBg", getStatus = function() return on end})
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local ball = Instance.new("Frame")
    ball.Size = UDim2.new(0, 16, 0, 16)
    ball.Position = on and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    ball.BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
    ball.BorderSizePixel = 0
    ball.Parent = bg
    Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f

    local function updateVisual(status)
        on = status
        TweenService:Create(bg, TweenInfo.new(0.15), {
            BackgroundColor3 = on and currentThemeColor or Color3.fromRGB(50, 50, 70)
        }):Play()
        TweenService:Create(ball, TweenInfo.new(0.15), {
            Position = on and UDim2.new(0, 23, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 180)
        }):Play()
    end

    btn.MouseButton1Click:Connect(function()
        on = not on
        states[stateKey] = on
        updateVisual(on)
        cb(on)
        triggerAutoSave()
    end)

    if stateKey then
        toggleCallbacks[stateKey] = updateVisual
    end

    if on then
        task.spawn(function()
            task.wait(0.5)
            cb(true)
        end)
    end
end

local activeDrag = nil
UserInputService.InputChanged:Connect(function(inp)
    if activeDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        activeDrag(inp.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        if activeDrag then
            activeDrag = nil
            triggerAutoSave()
        end
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
    fill.BackgroundColor3 = currentThemeColor
    fill.BorderSizePixel = 0
    fill.Parent = track
    table.insert(themeElements, {obj = fill, type = "bg"})
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
    local function apply(char)
        task.wait(0.5)
        if states.espPlayers and char then
            removeESP(p)
            local highlight = Instance.new("Highlight")
            highlight.Name = "AcaiHighlight"
            highlight.Adornee = char
            highlight.FillColor = Color3.fromRGB(138, 43, 226)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.Parent = char

            local head = char:WaitForChild("Head", 2)
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
    p.CharacterAdded:Connect(apply)
    if p.Character then apply(p.Character) end
end

Players.PlayerAdded:Connect(addESP)
Players.PlayerRemoving:Connect(removeESP)
for _, p in ipairs(Players:GetPlayers()) do addESP(p) end

-- === LOOP LEVE PARA BOSSES E FRUTAS ===
local notifiedBosses = {}
local notifiedFruits = {}

task.spawn(function()
    while true do
        task.wait(2)
        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head")
                    
                    if hum and hrp and hum.MaxHealth >= 40000 and hum.Health > 0 then
                        if states.notifyBoss and not notifiedBosses[obj] then
                            notifiedBosses[obj] = true
                            sendNotification("CHEFE SPAWNADO!", "Boss: " .. obj.Name)
                        end

                        if states.espBoss then
                            local inDist = true
                            if states.bossDistLimit and root then
                                if (root.Position - hrp.Position).Magnitude > bossDistVal then
                                    inDist = false
                                end
                            end

                            if inDist then
                                local hl = obj:FindFirstChild("BossHighlight")
                                if not hl then
                                    hl = Instance.new("Highlight")
                                    hl.Name = "BossHighlight"
                                    hl.Adornee = obj
                                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    hl.FillTransparency = 0.3
                                    hl.Parent = obj

                                    local bb = Instance.new("BillboardGui")
                                    bb.Name = "BossTag"
                                    bb.Size = UDim2.new(0, 150, 0, 50)
                                    bb.StudsOffset = Vector3.new(0, 3.5, 0)
                                    bb.AlwaysOnTop = true
                                    bb.Adornee = hrp
                                    bb.Parent = obj

                                    local lbl = Instance.new("TextLabel")
                                    lbl.Size = UDim2.new(1, 0, 1, 0)
                                    lbl.BackgroundTransparency = 1
                                    lbl.Text = "[BOSS 40k+] " .. obj.Name
                                    lbl.TextColor3 = Color3.fromRGB(255, 60, 60)
                                    lbl.TextSize = 13
                                    lbl.Font = Enum.Font.SourceSansBold
                                    lbl.TextStrokeTransparency = 0.2
                                    lbl.Parent = bb
                                end
                            else
                                local hl = obj:FindFirstChild("BossHighlight")
                                if hl then hl:Destroy() end
                                local tag = obj:FindFirstChild("BossTag")
                                if tag then tag:Destroy() end
                            end
                        else
                            local hl = obj:FindFirstChild("BossHighlight")
                            if hl then hl:Destroy() end
                            local tag = obj:FindFirstChild("BossTag")
                            if tag then tag:Destroy() end
                        end
                    end
                elseif obj:IsA("Tool") and string.find(obj.Name, "Fruit") then
                    if states.notifyFruit and not notifiedFruits[obj] then
                        notifiedFruits[obj] = true
                        sendNotification("FRUTA SPAWNADA!", "Fruta: " .. obj.Name)
                    end
                end
            end
        end)
    end
end)

local function getLevelAppropriateMob()
    local bestMobPart = nil
    local shortestDist = math.huge
    local charRef = player.Character
    local rootRef = charRef and charRef:FindFirstChild("HumanoidRootPart")
    if not rootRef then return nil end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj ~= charRef and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local dist = (rootRef.Position - hrp.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    bestMobPart = hrp
                end
            end
        end
    end
    return bestMobPart
end

local function getClosestQuestNPC()
    local closestNPC = nil
    local shortestDist = math.huge
    local charRef = player.Character
    local rootRef = charRef and charRef:FindFirstChild("HumanoidRootPart")
    if not rootRef then return nil end

    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Parent and desc.Parent:IsA("BasePart") then
            local dist = (rootRef.Position - desc.Parent.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closestNPC = desc
            end
        end
    end
    return closestNPC
end

local function getClosestPlayerHead()
    local closestTarget = nil
    local shortestDist = math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local head = p.Character:FindFirstChild("Head")
            if hum and hum.Health > 0 and head then
                local pos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = head
                    end
                end
            end
        end
    end
    return closestTarget
end

-- === POPULANDO AS ABAS ===
addToggle(tabPlayer, "noclip", "Noclip", "Atravessa paredes", function(on) states.noclip = on end)
addToggle(tabPlayer, "superPulo", "Super Pulo", "Ativa pulo alto", function(on)
    states.superPulo = on
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.UseJumpPower = true hum.JumpPower = on and jumpVal or 50 end
end)
addSlider(tabPlayer, "Força do Pulo", 50, 300, jumpVal, function(v)
    jumpVal = v
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if states.superPulo and hum then hum.JumpPower = v end
end)
addToggle(tabPlayer, "walkSpeed", "WalkSpeed", "Aumenta a velocidade", function(on) states.walkSpeed = on end)
addSlider(tabPlayer, "Velocidade", 16, 300, speedVal, function(v) speedVal = v end)
addToggle(tabPlayer, "infiniteJump", "Pulo Infinito", "Pula várias vezes no ar", function(on) states.infiniteJump = on end)

addToggle(tabVeiculo, "boatFly", "Boat Fly", "Faz o barco voar e acelerar", function(on) states.boatFly = on end)
addSlider(tabVeiculo, "Velocidade do Barco", 50, 300, boatVal, function(v) boatVal = v end)
addToggle(tabVeiculo, "vehicleBounce", "Impulso de Veículo", "Faz o veículo pular/destravar", function(on) states.vehicleBounce = on end)

addToggle(tabVisual, "espPlayers", "ESP Players", "Mostra jogadores nas paredes", function(on)
    states.espPlayers = on
    if on then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= player and p.Character then addESP(p) end end
    else
        for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
    end
end)
addToggle(tabVisual, "espBoss", "ESP Boss (40k+ HP)", "Destaca chefes com 40k+ de vida", function(on) states.espBoss = on end)
addToggle(tabVisual, "bossDistLimit", "Limitar Distância ESP Boss", "Ativa limite de distância para o ESP", function(on) states.bossDistLimit = on end)
addSlider(tabVisual, "Distância Máx Boss", 100, 5000, bossDistVal, function(v) bossDistVal = v end)
addToggle(tabVisual, "fullbright", "Fullbright", "Iluminação máxima", function(on)
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
addToggle(tabVisual, "noFog", "Remover Fog", "Remove névoa completamente", function(on) states.noFog = on end)

addToggle(tabPvp, "aimbot", "Aimbot", "Trava a câmera na cabeça do alvo", function(on) states.aimbot = on end)
addToggle(tabPvp, "hitbox", "Aumentar Hitbox", "Facilita acertar inimigos", function(on)
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

local followLabel = Instance.new("TextLabel")
followLabel.Size = UDim2.new(1, -5, 0, 22)
followLabel.BackgroundTransparency = 1
followLabel.Text = "--- SEGUIR JOGADOR ---"
followLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
followLabel.TextSize = 11
followLabel.Font = Enum.Font.SourceSansBold
followLabel.Parent = tabPvp

local function refreshFollowList()
    task.spawn(function()
        for _, child in ipairs(tabPvp:GetChildren()) do
            if child:IsA("TextButton") and child.Name ~= "StopFollow" then child:Destroy() end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local pBtn = Instance.new("TextButton")
                pBtn.Size = UDim2.new(1, -5, 0, 32)
                pBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                pBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
                pBtn.Text = "Seguir: " .. p.Name
                pBtn.TextSize = 11
                pBtn.Font = Enum.Font.SourceSansBold
                pBtn.Parent = tabPvp
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
                pBtn.MouseButton1Click:Connect(function()
                    followTarget = p
                    states.following = true
                end)
            end
        end
    end)
end

local stopFollowBtn = Instance.new("TextButton")
stopFollowBtn.Name = "StopFollow"
stopFollowBtn.Size = UDim2.new(1, -5, 0, 32)
stopFollowBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
stopFollowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopFollowBtn.Text = "Parar de Seguir"
stopFollowBtn.TextSize = 11
stopFollowBtn.Font = Enum.Font.SourceSansBold
stopFollowBtn.Parent = tabPvp
Instance.new("UICorner", stopFollowBtn).CornerRadius = UDim.new(0, 6)
stopFollowBtn.MouseButton1Click:Connect(function()
    states.following = false
    followTarget = nil
end)

refreshFollowList()
Players.PlayerAdded:Connect(refreshFollowList)
Players.PlayerRemoving:Connect(refreshFollowList)

addToggle(tabFarm, "autoFarm", "Auto-Farm por Nível", "Pega missão e farma mobs adequados ao seu nível", function(on)
    states.autoFarm = on
    task.spawn(function()
        while states.autoFarm do
            task.wait(0.3)
            pcall(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if char and hrp and hum and hum.Health > 0 then
                    local questPrompt = getClosestQuestNPC()
                    if questPrompt and (questPrompt.Parent.Position - hrp.Position).Magnitude < 35 then
                        fireproximityprompt(questPrompt)
                    end

                    local targetMob = getLevelAppropriateMob()
                    if targetMob then
                        hrp.CFrame = targetMob.CFrame * CFrame.new(0, 4, 2)
                        hum:MoveTo(targetMob.Position)

                        VirtualUser:Button1Down(Vector2.new(0, 0), camera.CFrame)
                        task.wait(0.05)
                        VirtualUser:Button1Up(Vector2.new(0, 0), camera.CFrame)
                    end
                end
            end)
        end
    end)
end)

local function refreshSpectateList()
    task.spawn(function()
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
    end)
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
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then camera.CameraSubject = hum end
end)

refreshSpectateList()
Players.PlayerAdded:Connect(refreshSpectateList)
Players.PlayerRemoving:Connect(refreshSpectateList)

-- === ABA MENU (CUSTOMIZAÇÃO GOD-TIER) ===
addToggle(tabMenu, "autoSaveUI", "Auto-Save Layout", "Salva mudanças do menu automaticamente", function(on)
    states.autoSaveUI = on
end)

addToggle(tabMenu, "menuDraggable", "Menu Arrastável", "Permite mover a janela livremente", function(on)
    states.menuDraggable = on
    frame.Draggable = on
end)

addToggle(tabMenu, "showOpenButton", "Botão Flutuante (Açaí)", "Mostra ou oculta a bolinha da tela", function(on)
    states.showOpenButton = on
    openBtn.Visible = on
end)

local centerBtn = Instance.new("TextButton")
centerBtn.Size = UDim2.new(1, -5, 0, 32)
centerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
centerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
centerBtn.Text = "Centralizar Janela na Tela"
centerBtn.TextSize = 11
centerBtn.Font = Enum.Font.SourceSansBold
centerBtn.Parent = tabMenu
Instance.new("UICorner", centerBtn).CornerRadius = UDim.new(0, 6)
centerBtn.MouseButton1Click:Connect(function()
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    openBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
    sendNotification("Menu do Açaí", "Posição centralizada!")
end)

addSlider(tabMenu, "Transparência do Fundo", 0, 80, math.floor(menuTransVal * 100), function(v)
    menuTransVal = v / 100
    frame.BackgroundTransparency = menuTransVal
    sidebar.BackgroundTransparency = math.clamp(menuTransVal, 0, 0.5)
end)

addSlider(tabMenu, "Largura da Janela", 380, 650, menuWidthVal, function(v)
    menuWidthVal = v
    frame.Size = UDim2.new(0, menuWidthVal, 0, menuHeightVal)
end)

addSlider(tabMenu, "Altura da Janela", 260, 480, menuHeightVal, function(v)
    menuHeightVal = v
    frame.Size = UDim2.new(0, menuWidthVal, 0, menuHeightVal)
end)

addSlider(tabMenu, "Arredondamento Bordas", 0, 24, menuCornerVal, function(v)
    applyCornerRadius(v)
end)

addSlider(tabMenu, "Tamanho Botão Flutuante", 32, 75, openBtnSizeVal, function(v)
    openBtnSizeVal = v
    openBtn.Size = UDim2.new(0, v, 0, v)
end)

-- Seção de Cor de Fundo
local bgLabel = Instance.new("TextLabel")
bgLabel.Size = UDim2.new(1, -5, 0, 22)
bgLabel.BackgroundTransparency = 1
bgLabel.Text = "--- COR DE FUNDO DO PAINEL ---"
bgLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
bgLabel.TextSize = 11
bgLabel.Font = Enum.Font.SourceSansBold
bgLabel.Parent = tabMenu

local bgThemes = {
    {Name = "Escuro Padrão", Color = Color3.fromRGB(22, 22, 32)},
    {Name = "Preto OLED Puro", Color = Color3.fromRGB(8, 8, 12)},
    {Name = "Cinza Chumbo", Color = Color3.fromRGB(38, 38, 46)},
    {Name = "Azul Meia-Noite", Color = Color3.fromRGB(15, 22, 38)}
}

for _, bg in ipairs(bgThemes) do
    local bBtn = Instance.new("TextButton")
    bBtn.Size = UDim2.new(1, -5, 0, 30)
    bBtn.BackgroundColor3 = bg.Color
    bBtn.TextColor3 = Color3.fromRGB(230, 230, 255)
    bBtn.Text = "Fundo: " .. bg.Name
    bBtn.TextSize = 11
    bBtn.Font = Enum.Font.SourceSansBold
    bBtn.Parent = tabMenu
    Instance.new("UICorner", bBtn).CornerRadius = UDim.new(0, 6)
    
    bBtn.MouseButton1Click:Connect(function()
        applyBgColor(bg.Color)
        triggerAutoSave()
    end)
end

-- Seção de Cor de Destaque (Temas)
local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, -5, 0, 22)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "--- COR DE DESTAQUE (TEMA) ---"
themeLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
themeLabel.TextSize = 11
themeLabel.Font = Enum.Font.SourceSansBold
themeLabel.Parent = tabMenu

local themes = {
    {Name = "Roxo Açaí", Color = Color3.fromRGB(80, 40, 180)},
    {Name = "Azul Escuro", Color = Color3.fromRGB(30, 100, 200)},
    {Name = "Ciano Neon", Color = Color3.fromRGB(0, 160, 180)},
    {Name = "Verde Matrix", Color = Color3.fromRGB(40, 160, 80)},
    {Name = "Vermelho Fogo", Color = Color3.fromRGB(180, 40, 40)},
    {Name = "Rosa Choque", Color = Color3.fromRGB(200, 40, 120)},
    {Name = "Dourado Luxo", Color = Color3.fromRGB(200, 150, 30)}
}

for _, t in ipairs(themes) do
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(1, -5, 0, 30)
    tBtn.BackgroundColor3 = t.Color
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.Text = "Tema: " .. t.Name
    tBtn.TextSize = 11
    tBtn.Font = Enum.Font.SourceSansBold
    tBtn.Parent = tabMenu
    Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
    
    tBtn.MouseButton1Click:Connect(function()
        applyThemeColor(t.Color)
        triggerAutoSave()
        sendNotification("Menu do Açaí", "Tema alterado para " .. t.Name)
    end)
end

-- === ABA OPÇÕES ===
addSlider(tabOpcoes, "Ajustar FOV", 70, 120, math.floor(camera.FieldOfView), function(v) camera.FieldOfView = v end)

addToggle(tabOpcoes, "notifyBoss", "Notificar Boss", "Avisa quando um chefe (40k+) spawna", function(on) states.notifyBoss = on end)
addToggle(tabOpcoes, "notifyFruit", "Notificar Fruta", "Avisa quando uma fruta spawna no mapa", function(on) states.notifyFruit = on end)

local saveCfgBtn = Instance.new("TextButton")
saveCfgBtn.Size = UDim2.new(1, -5, 0, 34)
saveCfgBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 80)
saveCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveCfgBtn.Text = "Salvar Configurações Manualmente"
saveCfgBtn.TextSize = 11
saveCfgBtn.Font = Enum.Font.SourceSansBold
saveCfgBtn.Parent = tabOpcoes
Instance.new("UICorner", saveCfgBtn).CornerRadius = UDim.new(0, 6)
saveCfgBtn.MouseButton1Click:Connect(function() saveConfig(false) end)

local loadCfgBtn = Instance.new("TextButton")
loadCfgBtn.Size = UDim2.new(1, -5, 0, 34)
loadCfgBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 160)
loadCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadCfgBtn.Text = "Carregar Configurações Salvas"
loadCfgBtn.TextSize = 11
loadCfgBtn.Font = Enum.Font.SourceSansBold
loadCfgBtn.Parent = tabOpcoes
Instance.new("UICorner", loadCfgBtn).CornerRadius = UDim.new(0, 6)
loadCfgBtn.MouseButton1Click:Connect(loadConfig)

local resetCfgBtn = Instance.new("TextButton")
resetCfgBtn.Size = UDim2.new(1, -5, 0, 34)
resetCfgBtn.BackgroundColor3 = Color3.fromRGB(160, 80, 40)
resetCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetCfgBtn.Text = "Apagar Save / Resetar Padrão"
resetCfgBtn.TextSize = 11
resetCfgBtn.Font = Enum.Font.SourceSansBold
resetCfgBtn.Parent = tabOpcoes
Instance.new("UICorner", resetCfgBtn).CornerRadius = UDim.new(0, 6)
resetCfgBtn.MouseButton1Click:Connect(deleteConfig)

local panicBtn = Instance.new("TextButton")
panicBtn.Size = UDim2.new(1, -5, 0, 38)
panicBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
panicBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
panicBtn.Text = "PANIC (Desativar Tudo)"
panicBtn.TextSize = 12
panicBtn.Font = Enum.Font.SourceSansBold
panicBtn.Parent = tabOpcoes
Instance.new("UICorner", panicBtn).CornerRadius = UDim.new(0, 6)

panicBtn.MouseButton1Click:Connect(function()
    for key, _ in pairs(states) do
        if key ~= "notifyBoss" and key ~= "notifyFruit" and key ~= "menuDraggable" and key ~= "showOpenButton" and key ~= "autoSaveUI" then
            states[key] = false
        end
    end
    
    for _, updateFunc in pairs(toggleCallbacks) do
        pcall(function() updateFunc(false) end)
    end
    
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
        camera.CameraSubject = hum
    end

    for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Highlight") and (obj.Name == "BossHighlight" or obj.Name == "AcaiHighlight") then
                obj:Destroy()
            elseif obj:IsA("BillboardGui") and (obj.Name == "BossTag" or obj.Name == "AcaiTag") then
                obj:Destroy()
            end
        end
    end)
end)

local bindFrame = Instance.new("Frame")
bindFrame.Size = UDim2.new(1, -5, 0, 48)
bindFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
bindFrame.BorderSizePixel = 0
bindFrame.Parent = tabOpcoes
Instance.new("UICorner", bindFrame).CornerRadius = UDim.new(0, 6)

local bindLabel = Instance.new("TextLabel")
bindLabel.Size = UDim2.new(0.55, 0, 0, 20)
bindLabel.Position = UDim2.new(0, 10, 0, 14)
bindLabel.BackgroundTransparency = 1
bindLabel.Text = "Tecla Menu (Bind)"
bindLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
bindLabel.TextSize = 12
bindLabel.Font = Enum.Font.SourceSansBold
bindLabel.TextXAlignment = Enum.TextXAlignment.Left
bindLabel.Parent = bindFrame

local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(0, 100, 0, 26)
bindBtn.Position = UDim2.new(1, -110, 0.5, -13)
bindBtn.BackgroundColor3 = currentThemeColor
bindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bindBtn.Text = toggleKey.Name
bindBtn.TextSize = 11
bindBtn.Font = Enum.Font.SourceSansBold
bindBtn.Parent = bindFrame
table.insert(themeElements, {obj = bindBtn, type = "bg"})
Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 6)

local listeningForKey = false
bindBtn.MouseButton1Click:Connect(function()
    if not listeningForKey then
        listeningForKey = true
        bindBtn.Text = "Pressione..."
        bindBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 60)
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                toggleKey = input.KeyCode
                bindBtn.Text = toggleKey.Name
                bindBtn.BackgroundColor3 = currentThemeColor
                listeningForKey = false
                connection:Disconnect()
                triggerAutoSave()
            end
        end)
    end
end)

local soundBtn = Instance.new("TextButton")
soundBtn.Size = UDim2.new(1, -5, 0, 34)
soundBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
soundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
soundBtn.Text = "Tocar Som de Alerta"
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
    for _, p in ipairs(Players:GetPlayers()) do removeESP(p) end
    sg:Destroy()
end)

-- Rodapé
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
RunService.RenderStepped:Connect(function() frameCount = frameCount + 1 end)
task.spawn(function()
    while true do
        task.wait(1)
        fps = frameCount
        frameCount = 0
    end
end)

RunService.RenderStepped:Connect(function(dt)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if states.noclip and char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if states.walkSpeed and hum then hum.WalkSpeed = speedVal end

    if states.boatFly and hum and hum.SeatPart then
        local seat = hum.SeatPart
        if seat:IsA("VehicleSeat") or seat:IsA("Seat") then
            local model = seat.Parent
            if model and model:IsA("Model") then
                local primary = model.PrimaryPart or seat
                model:PivotTo(primary.CFrame + (camera.CFrame.LookVector * boatVal * dt))
                primary.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end
    end

    if states.vehicleBounce and hum and hum.SeatPart then
        local seat = hum.SeatPart
        if seat.Parent:IsA("Model") then
            local primary = seat.Parent.PrimaryPart or seat
            primary.AssemblyLinearVelocity = primary.AssemblyLinearVelocity + Vector3.new(0, 35, 0)
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

    if states.aimbot then
        local targetHead = getClosestPlayerHead()
        if targetHead then camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position) end
    end

    if states.following and followTarget and followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") then
        if hum and hum.Health > 0 then
            hum:MoveTo(followTarget.Character.HumanoidRootPart.Position)
        end
    end

    if states.spectating and spectateTarget then
        if spectateTarget.Character and spectateTarget.Character:FindFirstChildOfClass("Humanoid") then
            camera.CameraSubject = spectateTarget.Character:FindFirstChildOfClass("Humanoid")
        end
    end

    local elapsed = math.floor(tick() - startTime)
    local mins = math.floor(elapsed / 60)
    local secs = elapsed % 60
    local pingVal = 0
    pcall(function() pingVal = math.floor(player:GetNetworkPing() * 1000) end)
    
    infoLabel.Text = string.format("FPS: %d | Ping: %dms | Tempo: %02d:%02d", fps, pingVal, mins, secs)
end)

UserInputService.JumpRequest:Connect(function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if states.infiniteJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Aplica todas as configurações visuais salvas na inicialização
applyThemeColor(currentThemeColor)
applyBgColor(currentBgColor)
applyCornerRadius(menuCornerVal)
frame.Size = UDim2.new(0, menuWidthVal, 0, menuHeightVal)
frame.BackgroundTransparency = menuTransVal
sidebar.BackgroundTransparency = math.clamp(menuTransVal, 0, 0.5)
frame.Draggable = states.menuDraggable
openBtn.Visible = states.showOpenButton
openBtn.Size = UDim2.new(0, openBtnSizeVal, 0, openBtnSizeVal)

print("Menu do Açaí [God-Tier UI] Carregado com Sucesso!")
