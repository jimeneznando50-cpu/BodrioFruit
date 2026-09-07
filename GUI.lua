-- [[ BODRIO FRUIT - ICONO FLOTANTE SIEMPRE VISIBLE Y ARRASTRE CORREGIDO ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "BodrioGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local minimized = false

-- ==========================================
-- MAIN FRAME (ventana principal)
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

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 12, 1, 12)
shadow.Position = UDim2.new(0, -6, 0, -6)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.75
shadow.BorderSizePixel = 0
shadow.Parent = mainFrame
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 14)
shadowCorner.Parent = shadow

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
local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

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
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeBtn

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
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- ==========================================
-- ICONO FLOTANTE (SIEMPRE VISIBLE, ARRASTRE CORREGIDO)
-- ==========================================
local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.new(0, 50, 0, 50)
iconFrame.Position = UDim2.new(0.02, 0, 0.85, 0)
iconFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
iconFrame.BackgroundTransparency = 0.15
iconFrame.BorderSizePixel = 1
iconFrame.BorderColor3 = Color3.fromRGB(100, 80, 200)
iconFrame.Visible = true  -- Siempre visible
iconFrame.Parent = gui
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 12)
iconCorner.Parent = iconFrame

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 1, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = "🥔"
iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
iconLabel.TextScaled = true
iconLabel.Font = Enum.Font.GothamBold
iconLabel.Parent = iconFrame

-- ==========================================
-- SISTEMA DE ARRASTRE PARA EL ICONO (CORREGIDO)
-- ==========================================
local iconDragging = false
local iconDragStart = nil
local iconStartPos = nil
local isClick = false

iconFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = true
        isClick = true
        iconDragStart = input.Position
        iconStartPos = iconFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if iconDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - iconDragStart
        -- Si el mouse se movió más de 3 píxeles, no es click
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            isClick = false
        end
        -- Mover el icono
        iconFrame.Position = UDim2.new(
            iconStartPos.X.Scale,
            iconStartPos.X.Offset + delta.X,
            iconStartPos.Y.Scale,
            iconStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        iconDragging = false
        -- Solo si fue un click (no arrastre) y el mouse no se movió
        if isClick then
            -- Alternar visibilidad de la GUI
            minimized = not minimized
            mainFrame.Visible = not minimized
            -- Si se minimiza, el icono sigue visible; si se maximiza, también
            iconFrame.Visible = true
            if not minimized then
                TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.05}):Play()
            end
        end
        isClick = false
    end
end)

-- ==========================================
-- FUNCIONES DE MINIMIZAR Y CERRAR (DESDE BARRA)
-- ==========================================
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = true
    mainFrame.Visible = false
    iconFrame.Visible = true  -- El icono siempre visible
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
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

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
-- FUNCIÓN PARA CARGAR CONTENIDO (TODAS LAS FUNCIONES)
-- ==========================================
function loadTabContent(tabName)
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    
    local yPos = 2

    -- Función toggle ON/OFF (clásica)
    local function addToggle(labelText, defaultState)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 24)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = contentFrame
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 4)
        frameCorner.Parent = frame
        
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
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 3)
        toggleCorner.Parent = toggle
        
        local state = defaultState
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.BackgroundColor3 = state and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(200, 80, 80)
            toggle.Text = state and "ON" or "OFF"
            print("Toggle " .. labelText .. " = " .. tostring(state))
        end)
        yPos = yPos + 26
    end

    -- ==========================================
    -- FUNCIÓN DROPDOWN (para seleccionar entre varias opciones)
    -- ==========================================
    local function addDropdown(labelText, options, defaultIndex)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 28)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = contentFrame
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 4)
        frameCorner.Parent = frame
        
        -- Label
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 5, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(200, 200, 230)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamMedium
        lbl.Parent = frame
        
        -- Botón del dropdown (muestra la opción seleccionada)
        local dropBtn = Instance.new("TextButton")
        dropBtn.Size = UDim2.new(0, 120, 0, 20)
        dropBtn.Position = UDim2.new(0.5, 10, 0.5, -10)
        dropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        dropBtn.BorderSizePixel = 0
        dropBtn.Text = options[defaultIndex or 1]
        dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropBtn.TextScaled = true
        dropBtn.Font = Enum.Font.GothamMedium
        dropBtn.Parent = frame
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 4)
        dropCorner.Parent = dropBtn
        
        -- Lista desplegable (oculta inicialmente)
        local listFrame = Instance.new("Frame")
        listFrame.Size = UDim2.new(0, 120, 0, #options * 22)
        listFrame.Position = UDim2.new(0.5, 10, 0, 28)
        listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        listFrame.BackgroundTransparency = 0.1
        listFrame.BorderSizePixel = 1
        listFrame.BorderColor3 = Color3.fromRGB(80, 60, 160)
        listFrame.Visible = false
        listFrame.Parent = frame
        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 4)
        listCorner.Parent = listFrame
        
        local selectedIndex = defaultIndex or 1
        local selectedValue = options[selectedIndex]
        
        -- Crear cada opción como botón
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 22)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 22)
            optBtn.BackgroundColor3 = (i == selectedIndex) and Color3.fromRGB(80, 60, 160) or Color3.fromRGB(30, 30, 50)
            optBtn.BackgroundTransparency = 0.3
            optBtn.BorderSizePixel = 0
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
            optBtn.TextScaled = true
            optBtn.Font = Enum.Font.GothamMedium
            optBtn.Parent = listFrame
            
            optBtn.MouseButton1Click:Connect(function()
                selectedIndex = i
                selectedValue = opt
                dropBtn.Text = opt
                listFrame.Visible = false
                print("📦 " .. labelText .. " seleccionado: " .. opt)
                -- Aquí luego pondremos la lógica real de compra/equipado
            end)
        end
        
        -- Mostrar/ocultar dropdown al hacer clic en el botón principal
        dropBtn.MouseButton1Click:Connect(function()
            listFrame.Visible = not listFrame.Visible
        end)
        
        yPos = yPos + 30
        return selectedValue
    end

    -- ==========================================
    -- CONTENIDO DE CADA PESTAÑA
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
        addToggle("Auto Select Cards", false)
        addToggle("Auto Destroy Events", false)
        
    elseif tabName == "Tasks" then
        addToggle("Start Farm Observation", false)
        addToggle("Farm Observation Hopping", false)
        addToggle("Auto Mystery Swords", false)
        addToggle("Auto Observation V2", false)
        addToggle("Auto Eclaw", false)
        addToggle("Auto Superhuman", false)
        addToggle("Auto Get Rengoku", false)
        addToggle("Auto Get TTK", false)
        addToggle("Auto Evolve DarkBlade", false)
        addToggle("Auto Get Skull Guitar", false)
        
    elseif tabName == "Tele" then
        addToggle("Teleport to Sea 1", false)
        addToggle("Teleport to Sea 2", false)
        addToggle("Teleport to Sea 3", false)
        addToggle("Teleport to Jungle", false)
        addToggle("Teleport to Ice", false)
        addToggle("Teleport to Sky", false)
        addToggle("Teleport to Castle", false)
        addToggle("Teleport to Mansion", false)
        addToggle("Teleport to Fruits", false)
        
    elseif tabName == "Comb" then
        addToggle("Aimbot", false)
        addToggle("ESP Players", false)
        addToggle("ESP Fruits", false)
        addToggle("ESP Items", false)
        addToggle("ESP Bosses", false)
        addToggle("ESP Chests", false)
        addToggle("Hitbox Extender", false)
        addToggle("Auto Dodge", false)
        addToggle("Speed Hack", false)
        addToggle("Fly / Noclip", false)
        
    elseif tabName == "Shop" then
        -- Reemplazamos los toggles simples por dropdowns donde corresponda
        addToggle("Auto Buy Sword", false)
        addDropdown("Auto Buy Fighting Style", {
            "Dark Step", "Water Kung Fu", "Dragon Claw", 
            "Superhuman", "Death Step", "Sharkman Karate", 
            "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art"
        }, 1)
        addDropdown("Auto Buy Race", {
            "Human", "Rabbit", "Shark", "Angel", "Cyborg", "Ghoul", "Draco"
        }, 1)
        addToggle("Auto Buy Fruit", false)
        addToggle("Auto Buy Accessories", false)
        addToggle("Auto Buy All", false)
        addToggle("Shop All Items", false)
        
    elseif tabName == "Config" then
        addToggle("Configurable Auto Farm", false)
        addToggle("Anti-AFK", false)
        addToggle("Fly / Noclip", false)
        addToggle("Speed Boost", false)
        addToggle("Infinite Energy", false)
        addToggle("Auto Rejoin", false)
        addToggle("Debug Mode", false)
        addToggle("Hitbox Extender Config", false)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

loadTabContent("Home")

-- ==========================================
-- ARRASTRE DE LA VENTANA PRINCIPAL
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

print("🥔 Bodrio Fruit GUI con icono siempre visible, arrastre corregido y dropdowns integrados.")