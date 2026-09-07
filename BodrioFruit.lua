-- [[ BODRIO FRUIT - NÚCLEO COMPLETO ]]
-- Versión 1.0 - Modo Dios Activado

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ======================================================
-- CONFIGURACIÓN GLOBAL (ajustable desde GUI después)
-- ======================================================
local Config = {
    AutoFarmLevel = false,
    AutoFarmNearest = false,
    AutoChest = false,
    AutoFarmBosses = false,
    AutoFarmMaterials = false,
    AutoFarmMastery = false,
    AutoSecondSea = false,
    AutoUnlockSaber = false,
    AutoPoleV1 = false,
    AutoSawSword = false,
    AutoCollectBerries = false,
    AutoBerryHop = false,
    AutoStoreFruits = false,
    TeleportToFruits = false,
    AutoRandomFruit = false,
    AutoStats = false,
    
    -- Sub Farm
    AutoCursedCaptain = false,
    AutoOpenColorsPlate = false,
    AutoTrueFormRipIndra = false,
    AutoCompleteDungeon = false,
    AutoSelectCards = false,
    AutoDestroyEvents = false,
    
    -- Tasks
    StartFarmObservation = false,
    FarmObservationHopping = false,
    AutoMysterySwords = false,
    
    -- Teleports
    TeleportsSeas = false,
    TeleportsIslands = false,
    
    -- Combat/Visual
    Aimbot = false,
    ESPPlayers = false,
    ESPFruits = false,
    ESPItems = false,
    ESPBosses = false,
    
    -- Shop
    ShopAllItems = false,
    
    -- Config
    AntiAFK = false,
    Fly = false,
    Noclip = false,
    HitboxExtender = false,
    FarmSpeed = 1.0,
    FarmRadius = 50,
}

-- ======================================================
-- FUNCIONES DE UTILIDAD (el verdadero poder)
-- ======================================================

-- Movimiento inteligente con Tween (evita detección)
local function moveTo(position, speed)
    if not rootPart then return end
    local tweenInfo = TweenInfo.new(
        (rootPart.Position - position).Magnitude / (speed * Config.FarmSpeed),
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = CFrame.new(position)})
    tween:Play()
    tween.Completed:Wait()
    return true
end

-- Función para atacar al NPC más cercano
local function attackNearestNPC()
    local enemies = {}
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= player.Name and v:FindFirstChild("Humanoid").Health > 0 then
                table.insert(enemies, v)
            end
        end
    end
    table.sort(enemies, function(a, b)
        return (rootPart.Position - a.HumanoidRootPart.Position).Magnitude < 
               (rootPart.Position - b.HumanoidRootPart.Position).Magnitude
    end)
    if #enemies > 0 then
        local target = enemies[1]
        local dist = (rootPart.Position - target.HumanoidRootPart.Position).Magnitude
        if dist > 10 then
            moveTo(target.HumanoidRootPart.Position, 25)
        end
        -- Simular ataque (aquí se pondría la lógica de enviar RemoteEvent)
        print("🔪 Atacando a: " .. target.Name)
        -- Simulación de golpe (reemplazar con evento real)
        local args = {target.HumanoidRootPart.Position}
        -- game:GetService("ReplicatedStorage").Remotes.Attack:FireServer(unpack(args))
    end
end

-- Función para recolectar cofres cercanos
local function collectChests()
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:lower():find("chest") then
            local dist = (rootPart.Position - v:FindFirstChild("HumanoidRootPart").Position).Magnitude
            if dist < 30 then
                moveTo(v.HumanoidRootPart.Position, 20)
                print("📦 Recolectando cofre: " .. v.Name)
            end
        end
    end
end

-- Función para farmear automáticamente (loop principal)
local function autoFarmLoop()
    while Config.AutoFarmLevel do
        attackNearestNPC()
        collectChests()
        task.wait(0.5)
    end
end

-- ======================================================
-- SISTEMA DE ESP (DIBUJAR EN PANTALLA)
-- ======================================================
local ESP = {}
local espObjects = {}

function ESP:DrawESP(object, color, text)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.Adornee = object
    billboard.AlwaysOnTop = true
    billboard.Parent = object
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text or object.Name
    label.TextColor3 = color or Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    table.insert(espObjects, billboard)
end

function ESP:Clear()
    for _, v in pairs(espObjects) do
        v:Destroy()
    end
    espObjects = {}
end

-- Loop de actualización de ESP
local function updateESP()
    while Config.ESPPlayers or Config.ESPFruits or Config.ESPItems or Config.ESPBosses do
        ESP:Clear()
        
        if Config.ESPPlayers then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character then
                    ESP:DrawESP(v.Character, Color3.fromRGB(0, 255, 0), v.Name .. " [PLAYER]")
                end
            end
        end
        
        if Config.ESPFruits then
            for _, v in pairs(Workspace:GetChildren()) do
                if v:IsA("Model") and v.Name:lower():find("fruit") then
                    ESP:DrawESP(v, Color3.fromRGB(255, 200, 0), "🍎 " .. v.Name)
                end
            end
        end
        
        task.wait(1)
    end
end

-- ======================================================
-- SISTEMA DE TELEPORT
-- ======================================================
local Teleports = {
    FirstSea = CFrame.new(-1000, 20, 500),
    SecondSea = CFrame.new(1000, 50, -500),
    ThirdSea = CFrame.new(0, 100, 0),
    Jungle = CFrame.new(-2000, 30, 200),
    Desert = CFrame.new(1500, 10, -1000),
}

function TeleportTo(destination)
    if rootPart then
        rootPart.CFrame = destination
        print("🚀 Teletransportado a: " .. tostring(destination))
    end
end

-- ======================================================
-- ANTI-AFK (mantiene la sesión activa)
-- ======================================================
local function antiAFK()
    while Config.AntiAFK do
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        task.wait(60)
    end
end

-- ======================================================
-- FLY / NOCLIP (movimiento libre)
-- ======================================================
local flyEnabled = false
local noclipEnabled = false

local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = rootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
        bodyGyro.Parent = rootPart
        
        UserInputService.InputChanged:Connect(function(input)
            if flyEnabled and input.UserInputType == Enum.UserInputType.Keyboard then
                local direction = Vector3.new()
                if input.KeyCode == Enum.KeyCode.W then direction = direction + Vector3.new(0, 0, -1) end
                if input.KeyCode == Enum.KeyCode.S then direction = direction + Vector3.new(0, 0, 1) end
                if input.KeyCode == Enum.KeyCode.A then direction = direction + Vector3.new(-1, 0, 0) end
                if input.KeyCode == Enum.KeyCode.D then direction = direction + Vector3.new(1, 0, 0) end
                if input.KeyCode == Enum.KeyCode.Space then direction = direction + Vector3.new(0, 1, 0) end
                if input.KeyCode == Enum.KeyCode.LeftShift then direction = direction + Vector3.new(0, -1, 0) end
                bodyVelocity.Velocity = (rootPart.CFrame:VectorToWorldSpace(direction) * 50)
            end
        end)
    else
        rootPart:FindFirstChild("BodyVelocity"):Destroy()
        rootPart:FindFirstChild("BodyGyro"):Destroy()
    end
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ======================================================
-- SHOP AUTOMÁTICO (compra de items)
-- ======================================================
local function shopAllItems()
    -- Simulación de compra (aquí se pondrían los eventos de compra)
    print("🛒 Comprando todos los items disponibles...")
    -- Ejemplo: game:GetService("ReplicatedStorage").Remotes.BuyItem:FireServer("Sword", "Katana")
end

-- ======================================================
-- CONEXIÓN CON LA GUI (eventos)
-- ======================================================
-- Esta función se llamará desde la GUI cuando se activen los toggles
function SetConfig(key, value)
    Config[key] = value
    print("⚙️ " .. key .. " = " .. tostring(value))
    
    -- Iniciar hilos según configuración
    if key == "AutoFarmLevel" and value then
        task.spawn(autoFarmLoop)
    end
    if key == "ESPPlayers" or key == "ESPFruits" or key == "ESPItems" or key == "ESPBosses" then
        task.spawn(updateESP)
    end
    if key == "AntiAFK" and value then
        task.spawn(antiAFK)
    end
    if key == "Fly" then
        toggleFly()
    end
    if key == "Noclip" then
        toggleNoclip()
    end
    if key == "ShopAllItems" and value then
        shopAllItems()
    end
end

-- ======================================================
-- INICIALIZACIÓN
-- ======================================================
print("🥔 Bodrio Fruit cargado con éxito. ¡A romper todo!")
print("💡 Usa la GUI para activar funciones.")

-- Cargar la GUI (si existe)
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jimeneznando50-cpu/BodrioFruit/main/GUI.lua"))()
end)
if not success then
    warn("❌ Error al cargar GUI: " .. tostring(err))
end

-- Mantener el script vivo
while true do
    task.wait(60)
end