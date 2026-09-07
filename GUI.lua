-- [[ BODRIO FRUIT - GUI OSCURA ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Crear ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "BodrioGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Frame principal (oscuro, bordes redondeados)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Sombra exterior (efecto glassmorphism)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.BackgroundTransparency = 0.3
title.BorderSizePixel = 0
title.Text = "🥔 BODRIO FRUIT  v.LIVE"
title.TextColor3 = Color3.fromRGB(200, 180, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Barra de navegación (pestañas)
local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(1, 0, 0, 40)
navBar.Position = UDim2.new(0, 0, 0, 40)
navBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
navBar.BackgroundTransparency = 0.2
navBar.BorderSizePixel = 0
navBar.Parent = mainFrame

-- Lista de pestañas (nombres)
local tabs = {"Home", "Sub Farm", "Tasks", "Teleports", "Combat", "Shop", "Config"}
local tabButtons = {}
local currentTab = "Home"

-- Contenedor de contenido (cambia según pestaña)
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -10, 1, -100)
contentFrame.Position = UDim2.new(0, 5, 0, 85)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
contentFrame.BackgroundTransparency = 0.5
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
contentFrame.Parent = mainFrame

-- Función para crear botones de pestaña
local function createTabButton(name, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 1, 0)
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
        -- Cambiar pestaña
        currentTab = name
        contentFrame:ClearAllChildren()
        loadTabContent(name)
        -- Resaltar botón
        for _, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end
        btn.BackgroundColor3 = Color3.fromRGB(80, 60, 160)
    end)
    
    table.insert(tabButtons, btn)
    return btn
end

-- Crear pestañas (distribución horizontal)
local xOffset = 5
for _, tab in pairs(tabs) do
    createTabButton(tab, xOffset)
    xOffset = xOffset + 65
end

-- ==========================================
-- FUNCIÓN PARA CARGAR CONTENIDO DE CADA PESTAÑA
-- ==========================================
function loadTabContent(tabName)
    -- Limpiar frame
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    local yPos = 5
    local function addToggle(labelText, defaultState)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
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
        toggle.Size = UDim2.new(0, 50, 0, 22)
        toggle.Position = UDim2.new(0.85, 0, 0.5, -11)
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
            -- Aquí puedes ejecutar función de activación/desactivación
            print("Toggle " .. labelText .. " = " .. tostring(state))
        end)
        yPos = yPos + 35
    end
    
    -- ==========================================
    -- CONTENIDO POR PESTAÑA
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
        
    elseif tabName == "Sub Farm" then
        addToggle("Auto Cursed Captain", false)
        addToggle("Auto Open Colors Plate", false)
        addToggle("Auto True Form Rip Indra", false)
        addToggle("Auto Complete Dungeon", false)
        addToggle("Auto Select Cards (Dungeon)", false)
        addToggle("Auto Destroy Events (Dungeon)", false)
        
    elseif tabName == "Tasks" then
        addToggle("Start Farm Observation", false)
        addToggle("Farm Observation Hopping", false)
        addToggle("Auto Mystery Swords (Fully)", false)
        
    elseif tabName == "Teleports" then
        addToggle("Teleports for Seas", false)
        addToggle("Teleports for Islands", false)
        -- Aquí puedes añadir lista desplegable de islas
        
    elseif tabName == "Combat" then
        addToggle("Aimbot", false)
        addToggle("ESP Players", false)
        addToggle("ESP Fruits", false)
        addToggle("ESP Items", false)
        addToggle("ESP Bosses", false)
        
    elseif tabName == "Shop" then
        addToggle("Shop All Items", false)
        -- Botón para abrir shop
        
    elseif tabName == "Config" then
        addToggle("Configurable Auto Farm", false)
        addToggle("Anti-AFK", false)
        addToggle("Fly / Noclip", false)
        addToggle("Hitbox Extender", false)
    end
    
    -- Ajustar altura del ScrollingFrame
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
end

-- Cargar pestaña inicial
loadTabContent("Home")

-- Hacer GUI arrastrable
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

print("🥔 Bodrio Fruit GUI cargada correctamente.")