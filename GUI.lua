-- [[ BODRIO FRUIT - GUI DEFINITIVA CON MINIMIZAR/CERRAR ]]
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

-- Estado de minimizado
local minimized = false
local iconVisible = false

-- ==========================================
-- MAIN FRAME - Altura reducida (350x420)
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 420)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
mainFrame.Visible = true

-- Sombra
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.8
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame

-- ==========================================
-- BARRA DE TÍTULO CON BOTONES
-- ==========================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🥔 BODRIO FRUIT  v.LIVE"
title.TextColor3 = Color3.fromRGB(200, 180, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Botón Minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 1, -4)
minimizeBtn.Position = UDim2.new(1, -55, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeBtn.BackgroundTransparency = 0.3
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar

-- Botón Cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 1, -4)
closeBtn.Position = UDim2.new(1, -28, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.BackgroundTransparency = 0.3
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

-- ==========================================
-- ICONO FLOTANTE (cuando está minimizado)
-- ==========================================
local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.new(0, 50, 0, 50)
iconFrame.Position = UDim2.new(0.02, 0, 0.85, 0)
iconFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
iconFrame.BackgroundTransparency = 0.15
iconFrame.BorderSizePixel = 1
iconFrame.BorderColor3 = Color3.fromRGB(100, 80, 200)
iconFrame.Visible = false
iconFrame.Parent = gui

-- Icono de texto
local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "🥔"
iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
iconLabel.TextScaled = true
iconLabel.Font = Enum.Font.GothamBold
iconLabel.Parent = iconFrame

-- Botón para restaurar desde icono
iconFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        minimized = false
        mainFrame.Visible = true
        iconFrame.Visible = false
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.05}):Play()
    end
end)

-- Hacer icono arrastrable
local iconDragging = false
local iconDragStart, iconStartPos

iconFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = iconFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if iconDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - iconDragStart
        iconFrame.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = false
    end
end)

-- ==========================================
-- FUNCIONES DE MINIMIZAR Y CERRAR
-- ==========================================
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = true
    mainFrame.Visible = false
    iconFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ==========================================
-- NAVEGACIÓN (pestañas)
-- ==========================================
local navBar = Instance.new("Frame")
navBar.Size = UDim2.new(1, 0, 0, 28)
navBar.Position = UDim2.new(0, 0, 0, 30)
navBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
navBar.BackgroundTransparency = 0.2
navBar.BorderSizePixel = 0
navBar.Parent = mainFrame

local tabs = {"Home", "Sub", "Tasks", "Tele", "Comb", "Shop", "Config"}
local tabButtons = {}
local currentTab = "Home"

-- Contenedor de contenido con SCROLL
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -8, 1, -65)
contentFrame.Position = UDim2.new(0, 4, 0, 60)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
contentFrame.BackgroundTransparency = 0.5
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.Parent = mainFrame

-- Crear botones de pestaña
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

local xOffset = 3
for _, tab in pairs(tabs) do
    createTabButton(tab, xOffset)
    xOffset = xOffset + 48
end

-- ==========================================
-- FUNCIÓN PARA CARGAR CONTENIDO
-- ==========================================
function loadTabContent(tabName)
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    local yPos = 2
    local function addToggle(labelText, defaultState)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 24)
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
        toggle.Size = UDim2.new(0, 38, 0, 16)
        toggle.Position = UDim2.new(0.85, 0, 0.5, -8)
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
        yPos = yPos + 26
    end
    
    -- Contenido por pestaña
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
        addToggle("Auto Select Cards", false)
        addToggle("Auto Destroy Events", false)
        
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
        addToggle("Teleport to Ice", false)
        addToggle("Teleport to Sky", false)
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
        addToggle("Auto Buy Fighting", false)
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
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

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

print("🥔 Bodrio Fruit GUI definitiva con minimizar y cerrar.")