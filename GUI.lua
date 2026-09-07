-- [[ BODRIO FRUIT - GUI COMPACTA CON SCROLL ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Crear ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "BodrioGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- MAIN FRAME - Tamaño reducido (350x500)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Sombra sutil
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Título superior
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
title.BackgroundTransparency = 0.3
title.BorderSizePixel = 0
title.Text = "🥔 BODRIO FRUIT  v.LIVE"
title.TextColor3 = Color3.fromRGB(200, 180, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- ==========================================
-- PANEL DE ESTADÍSTICAS (nivel, dinero, salud, energía)
-- ==========================================
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, 0, 0, 70)
statsFrame.Position = UDim2.new(0, 0, 0, 30)
statsFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
statsFrame.BackgroundTransparency = 0.2
statsFrame.BorderSizePixel = 0
statsFrame.Parent = mainFrame

-- Función para crear una estadística
local function createStat(label, value, xPos, color)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 80, 0, 25)
    frame.Position = UDim2.new(0, xPos, 0, 5)
    frame.BackgroundTransparency = 1
    frame.Parent = statsFrame
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 12)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(150, 150, 180)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamMedium
    lbl.Parent = frame
    
    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1, 0, 0, 13)
    val.Position = UDim2.new(0, 0, 0, 12)
    val.BackgroundTransparency = 1
    val.Text = value
    val.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    val.TextScaled = true
    val.Font = Enum.Font.GothamBold
    val.Parent = frame
    return val
end

-- Crear estadísticas
local statLevel = createStat("Nivel", "2826", 5, Color3.fromRGB(100, 200, 255))
local statMoney = createStat("💰", "$124M", 90, Color3.fromRGB(255, 215, 100))
local statHealth = createStat("❤️ Salud", "8521/14580", 175, Color3.fromRGB(255, 100, 100))
local statEnergy = createStat("⚡ Energía", "15290/15290", 260, Color3.fromRGB(100, 255, 150))

-- Barra de navegación (pestañas) - más compacta
local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(1, 0, 0, 28)
navBar.Position = UDim2.new(0, 0, 0, 100)
navBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
navBar.BackgroundTransparency = 0.2
navBar.BorderSizePixel = 0
navBar.Parent = mainFrame

-- Lista de pestañas
local tabs = {"Home", "Sub", "Tasks", "Tele", "Comb", "Shop", "Config"}
local tabButtons = {}
local currentTab = "Home"

-- Contenedor de contenido con SCROLL
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -8, 1, -135)
contentFrame.Position = UDim2.new(0, 4, 0, 130)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
contentFrame.BackgroundTransparency = 0.5
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Se ajustará dinámicamente
contentFrame.Parent = mainFrame

-- Función para crear botones de pestaña (compactos)
local function createTabButton(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = navBar
    
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        contentFrame:ClearAllChildren()
        loadTabContent(name)
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end
        btn.BackgroundColor3 = Color3.fromRGB(80, 60, 160)
    end)
    
    table.insert(tabButtons, btn)
    return btn
end

-- Crear pestañas (distribución horizontal compacta)
local xOffset = 3
for _, tab in pairs(tabs) do
    createTabButton(tab, xOffset)
    xOffset = xOffset + 48
end

-- ==========================================
-- FUNCIÓN PARA CARGAR CONTENIDO CON SCROLL
-- ==========================================
function loadTabContent(tabName)
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    local yPos = 2
    local function addToggle(labelText, defaultState)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 26)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = contentFrame
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 5, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(200, 200, 230)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamMedium
        lbl.Parent = frame
        
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 40, 0, 18)
        toggle.Position = UDim2.new(0.85, 0, 0.5, -9)
        toggle.BackgroundColor3 = defaultState and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
        toggle.BorderSizePixel = 0
        toggle.Text = defaultState and "ON" or "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextScaled = true
        toggle.Font = Enum.Font.GothamBold
        toggle.Parent = frame
        
        local state = defaultState
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.BackgroundColor3 = state and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
            toggle.Text = state and "ON" or "OFF"
            print("Toggle " .. labelText .. " = " .. tostring(state))
        end)
        yPos = yPos + 28
    end
    
    -- ==========================================
    -- CONTENIDO POR PESTAÑA (más funciones)
    -- ==========================================
    if tabName == "Home" then
        addToggle("Auto Farm Level", false)
        addToggle("Auto Farm Nearest", false)
        addToggle("Auto Chest", false)
        addToggle("Auto Farm Bosses", false)
        addToggle("Auto Farm Materials", false)
        addToggle("Auto Farm Mastery", false)
        addToggle("Auto Second Sea", false)
        addToggle("Auto Unlock Saber", false)
        addToggle("Auto Pole V1", false)
        addToggle("Auto Saw Sword", false)
        addToggle("Auto Collect Berries", false)
        addToggle("Auto Berry Hop", false)
        addToggle("Auto Store Fruits", false)
        addToggle("Teleport to Fruits", false)
        addToggle("Auto Random Fruit", false)
        addToggle("Auto Stats", false)
        
    elseif tabName == "Sub" then
        addToggle("Auto Cursed Captain", false)
        addToggle("Auto Open Colors Plate", false)
        addToggle("Auto True Form Rip Indra", false)
        addToggle("Auto Complete Dungeon", false)
        addToggle("Auto Select Cards (Dungeon)", false)
        addToggle("Auto Destroy Events (Dungeon)", false)
        
    elseif tabName == "Tasks" then
        addToggle("Start Farm Observation", false)
        addToggle("Farm Observation Hopping", false)
        addToggle("Auto Mystery Swords", false)
        addToggle("Auto Observation V2", false)
        addToggle("Auto Eclaw", false)
        addToggle("Auto Superhuman", false)
        
    elseif tabName == "Tele" then
        addToggle("Teleport to Sea 1", false)
        addToggle("Teleport to Sea 2", false)
        addToggle("Teleport to Sea 3", false)
        addToggle("Teleport to Jungle", false)
        addToggle("Teleport to Ice Island", false)
        addToggle("Teleport to Sky Island", false)
        addToggle("Teleport to Castle", false)
        addToggle("Teleport to Mansion", false)
        
    elseif tabName == "Comb" then
        addToggle("Aimbot", false)
        addToggle("ESP Players", false)
        addToggle("ESP Fruits", false)
        addToggle("ESP Items", false)
        addToggle("ESP Bosses", false)
        addToggle("ESP Chests", false)
        addToggle("Hitbox Extender", false)
        addToggle("Auto Dodge", false)
        
    elseif tabName == "Shop" then
        addToggle("Auto Buy Sword", false)
        addToggle("Auto Buy Fighting Style", false)
        addToggle("Auto Buy Race", false)
        addToggle("Auto Buy Fruit", false)
        addToggle("Auto Buy Accessories", false)
        addToggle("Auto Buy All", false)
        
    elseif tabName == "Config" then
        addToggle("Configurable Auto Farm", false)
        addToggle("Anti-AFK", false)
        addToggle("Fly / Noclip", false)
        addToggle("Speed Boost", false)
        addToggle("Infinite Energy", false)
        addToggle("Auto Rejoin", false)
        addToggle("Debug Mode", false)
    end
    
    -- Ajustar altura del Canvas para scroll
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- Cargar pestaña inicial
loadTabContent("Home")

-- ==========================================
-- HACER GUI ARRASTRABLE
-- ==========================================
local dragging = false
local dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("🥔 Bodrio Fruit GUI compacta cargada con éxito.")