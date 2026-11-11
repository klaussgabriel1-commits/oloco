--// Hub Blox Fruits Sea 3 - Remoto (MainV2.lua)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(charNovo)
	character = charNovo
	humanoid = charNovo:WaitForChild("Humanoid")
	rootPart = charNovo:WaitForChild("HumanoidRootPart")
end)

player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local autoFarmAtivo = false
local noclipAtivo = false
local hubVisivel = true

--// Tabela de Missões do Sea 3
local missoesSea3 = {
	{levelMin = 2450, questName = "PiratePortQuest", levelReq = 2450, npcName = "Pirate Port Quest Giver", enemyName = "Pirate Millionaire"},
	{levelMin = 2400, questName = "HauntedQuest2", levelReq = 2400, npcName = "Haunted Quest Giver 2", enemyName = "Demonic Soul"},
	{levelMin = 2350, questName = "HauntedQuest1", levelReq = 2350, npcName = "Haunted Quest Giver 1", enemyName = "Reborn Skeleton"},
	{levelMin = 2300, questName = "NutQuest2", levelReq = 2300, npcName = "Nut Quest Giver 2", enemyName = "Cocoa Warrior"},
	{levelMin = 2250, questName = "NutQuest1", levelReq = 2250, npcName = "Nut Quest Giver 1", enemyName = "Candy Rebel"},
	{levelMin = 2200, questName = "IceCreamQuest2", levelReq = 2200, npcName = "Ice Cream Quest Giver 2", enemyName = "Ice Cream Chef"},
	{levelMin = 2150, questName = "IceCreamQuest1", levelReq = 2150, npcName = "Ice Cream Quest Giver 1", enemyName = "Snow Demon"},
	{levelMin = 2100, questName = "PeanutQuest2", levelReq = 2100, npcName = "Peanut Quest Giver 2", enemyName = "Pistachio Investigator"},
	{levelMin = 2075, questName = "PeanutQuest1", levelReq = 2075, npcName = "Peanut Quest Giver 1", enemyName = "Peanut Scout"},
	{levelMin = 2050, questName = "MarineTreeQuest", levelReq = 2050, npcName = "Marine Tree Quest Giver", enemyName = "Sunken Skeleton"},
	{levelMin = 2000, questName = "HydraQuest2", levelReq = 2000, npcName = "Hydra Quest Giver 2", enemyName = "Giant Islander"},
	{levelMin = 1950, questName = "HydraQuest1", levelReq = 1950, npcName = "Hydra Quest Giver 1", enemyName = "Warrior Pirate"},
	{levelMin = 1900, questName = "JunglePirateQuest", levelReq = 1900, npcName = "Jungle Pirate Quest Giver", enemyName = "Musketeer Pirate"}
}

local function obterLevelAtual()
	local dataFolder = player:FindFirstChild("Data")
	return dataFolder and dataFolder:FindFirstChild("Level") and dataFolder.Level.Value or 1900
end

local function obterMissaoAtual()
	local level = obterLevelAtual()
	for _, missao in ipairs(missoesSea3) do
		if level >= missao.levelMin then
			return missao
		end
	end
	return missoesSea3[#missoesSea3]
end

--// Interface Gráfica (Hub)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitsSea3Hub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 275)
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "Blox Fruits Sea 3 Hub"
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0, 45)
statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
statusLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextWrapped = true
statusLabel.Text = "Status: Aguardando..."
statusLabel.Parent = mainFrame

local containerBotoes = Instance.new("Folder")
containerBotoes.Name = "ContainerBotoes"
containerBotoes.Parent = mainFrame

local btnMinimizar = Instance.new("TextButton")
btnMinimizar.Size = UDim2.new(0, 30, 0, 30)
btnMinimizar.Position = UDim2.new(1, -65, 0, 5)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnMinimizar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMinimizar.Text = "_"
btnMinimizar.TextSize = 16
btnMinimizar.Font = Enum.Font.SourceSansBold
btnMinimizar.Parent = titleLabel

btnMinimizar.MouseButton1Click:Connect(function()
	hubVisivel = not hubVisivel
	if hubVisivel then
		mainFrame.Size = UDim2.new(0, 240, 0, 275)
		btnMinimizar.Text = "_"
		statusLabel.Visible = true
		for _, filho in ipairs(containerBotoes:GetChildren()) do
			if filho:IsA("GuiObject") then filho.Visible = true end
		end
	else
		for _, filho in ipairs(containerBotoes:GetChildren()) do
			if filho:IsA("GuiObject") then filho.Visible = false end
		end
		statusLabel.Visible = false
		mainFrame.Size = UDim2.new(0, 240, 0, 40)
		btnMinimizar.Text = "+"
	end
end)

local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0, 30, 0, 30)
btnFechar.Position = UDim2.new(1, -30, 0, 5)
btnFechar.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
btnFechar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnFechar.Text = "X"
btnFechar.TextSize = 14
btnFechar.Font = Enum.Font.SourceSansBold
btnFechar.Parent = titleLabel

btnFechar.MouseButton1Click:Connect(function()
	autoFarmAtivo = false
	noclipAtivo = false
	if humanoid and humanoid.Parent then humanoid.JumpPower = 50 end
	screenGui:Destroy()
end)

local function criarBotao(nomeTexto, posicaoY, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 35)
	btn.Position = UDim2.new(0.05, 0, 0, posicaoY)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = nomeTexto .. ": [DESLIGADO]"
	btn.TextSize = 14
	btn.Font = Enum.Font.SourceSans
	btn.Parent = containerBotoes
	
	local ligado = false
	btn.MouseButton1Click:Connect(function()
		ligado = not ligado
		if ligado then
			btn.Text = nomeTexto .. ": [LIGADO]"
			btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		else
			btn.Text = nomeTexto .. ": [DESLIGADO]"
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end
		callback(ligado)
	end)
end

RunService.Stepped:Connect(function()
	if (autoFarmAtivo or noclipAtivo) and character then
		for _, parte in ipairs(character:GetDescendants()) do
			if parte:IsA("BasePart") then
				parte.CanCollide = false
			end
		end
	end
end)

local function voarAte(destinoCFrame)
	if not rootPart then return end
	local distancia = (rootPart.Position - destinoCFrame.Position).Magnitude
	local tempo = distancia / 300 
	if tempo < 0.5 then tempo = 0.5 end

	local infoTween = TweenInfo.new(tempo, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(rootPart, infoTween, {CFrame = destinoCFrame})
	tween:Play()
	
	local conn
	conn = RunService.Stepped:Connect(function()
		if not autoFarmAtivo or not rootPart then
			tween:Cancel()
			conn:Disconnect()
		end
	end)
	
	task.wait(tempo)
	if conn then conn:Disconnect() end
end

local function pegarMissao(questName, levelReq)
	local comms = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")
	if comms then
		comms:InvokeServer("StartQuest", questName, levelReq)
	end
end

local function buscarInimigo(nomeInimigo)
	local inimigos = workspace:FindFirstChild("Enemies")
	if inimigos then
		for _, mob in ipairs(inimigos:GetChildren()) do
			local mobHumanoid = mob:FindFirstChild("Humanoid")
			local mobRoot = mob:FindFirstChild("HumanoidRootPart")
			if mob.Name == nomeInimigo and mobHumanoid and mobHumanoid.Health > 0 and mobRoot then
				return mob
			end
		end
	end
	return nil
end

local function atacar()
	VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end

task.spawn(function()
	while true do
		task.wait(0.2)
		if autoFarmAtivo and character and rootPart then
			local missaoAtual = obterMissaoAtual()
			local levelAtual = obterLevelAtual()
			
			statusLabel.Text = string.format("Lvl: %d | Alvo: %s", levelAtual, missaoAtual.enemyName)
			
			local temMissao = player.PlayerGui:FindFirstChild("Main") 
				and player.PlayerGui.Main:FindFirstChild("Quest") 
				and player.PlayerGui.Main.Quest.Visible

			if not temMissao then
				statusLabel.Text = string.format("Voando para Quest: %s", missaoAtual.enemyName)
				local npc = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild(missaoAtual.npcName)
				if npc and npc:FindFirstChild("HumanoidRootPart") then
					voarAte(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3))
					task.wait(0.3)
					pegarMissao(missaoAtual.questName, missaoAtual.levelReq)
					task.wait(0.5)
				end
			else
				local alvo = buscarInimigo(missaoAtual.enemyName)
				if alvo then
					local mobRoot = alvo.HumanoidRootPart
					local mobHumanoid = alvo.Humanoid

					statusLabel.Text = string.format("Voando até o mob: %s", missaoAtual.enemyName)
					voarAte(mobRoot.CFrame * CFrame.new(0, 8, 0))

					statusLabel.Text = string.format("Farmando: %s", missaoAtual.enemyName)
					while autoFarmAtivo and mobHumanoid.Health > 0 and alvo.Parent do
						rootPart.CFrame = mobRoot.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-90), 0, 0)
						atacar()
						task.wait(0.1)
					end
				else
					statusLabel.Text = string.format("Procurando mob: %s...", missaoAtual.enemyName)
				end
			end
		else
			if not autoFarmAtivo then
				statusLabel.Text = "Status: [DESLIGADO]"
			end
		end
	end
end)

criarBotao("Auto Farm (Sea 3 Safe Fly)", 90, function(estado)
	autoFarmAtivo = estado
end)

criarBotao("Atravessar Paredes", 135, function(estado)
	noclipAtivo = estado
end)

criarBotao("Super Pulo", 180, function(estado)
	if estado then
		humanoid.JumpPower = 150
	else
		humanoid.JumpPower = 50
	end
end)

print("Hub Blox Fruits carregado com sucesso!")
