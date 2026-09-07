-- [[ BODRIO FRUIT - GUI V2 (Élite) ]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ======================================================
-- CREAR GUI PRINCIPAL
-- ======================================================
local gui = Instance.new("ScreenGui")
gui.Name = "BodrioGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- ======================================================
-- VARIABLES GLOBALES
-- ======================================================
local minimized = false
local dragging = false
local dragStart, startPos
local mainFrame = nil
local floatingIcon = nil

-- ======================================================
-- FUNCIÓN PARA CREAR LA VENTANA PRINCIPAL
-- ======================================================
local function createMainWindow()
    -- Frame principal (oscuro con glassmorphism)
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 520, 0, 620)
    mainFrame.Position = UDim2.new(0.5, -260, 0.5, -310)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = gui

    -- Sombra exterior
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.Position = UDim2.new(0, -6, 0, -6)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.BorderSizePixel = 0
    shadow.Parent = mainFrame

    -- Borde decorativo (neon)
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 0, 2)
    border.Position = UDim2.new(0, 0, 0, 0)
    border.BackgroundColor3 = Color3.fromRGB(120, 80, 255)
    border.BorderSizePixel = 0
    border.Parent = mainFrame

    -- ==========================================
    -- BARRA DE TÍTULO (con botones minimizar/cerrar)
    -- ==========================================
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    titleBar.BackgroundTransparency = 0.3
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🥔 BODRIO FRUIT  v.LIVE"
    titleLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar

    -- Botón minimizar (—)
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 1, 0)
    minBtn.Position = UDim2.new(1, -70, 0, 0)
    minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    minBtn.BackgroundTransparency = 0.5
    minBtn.BorderSizePixel = 0
    minBtn.Text = "─"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextScaled = true
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleBar

    minBtn.MouseButton1Click:Connect(function()
        toggleMinimize()
    end)

    -- Botón cerrar (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar

    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        if floatingIcon then floatingIcon:Destroy() end
    end)

    -- ==========================================
    -- PESTAÑAS (NAVEGACIÓN)
    -- ==========================================
    local tabNames = {"Home", "Sub Farm", "Tasks", "Teleports", "Combat", "Shop", "Config"}
    local tabButtons = {}
    local currentTab = "Home"

    local navBar = Instance.new("Frame")
    navBar.Size = UDim2.new(1, 0, 0, 36)
    navBar.Position = UDim2.new(0, 0, 0, 40)
    navBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    navBar.BackgroundTransparency = 0.2
    navBar.BorderSizePixel = 0
    navBar.Parent = mainFrame

    -- Contenedor de contenido (con ScrollBar)
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -10, 1, -90)
    contentFrame.Position = UDim2.new(0, 5, 0, 80)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    contentFrame.BackgroundTransparency = 0.4
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 5
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 80, 200)
    contentFrame.ScrollBarImageTransparency = 0.3
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.Parent = mainFrame

    -- ==========================================
    -- FUNCIÓN PARA CREAR BOTONES DE PESTAÑA
    -- ==========================================
    local function createTabButton(name, xPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 65, 1, 0)
        btn.Position = UDim2.new(0, xPos, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        btn.BackgroundTransparency = 0.4
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 230)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.Parent = navBar

        btn.MouseButton1Click:Connect(function()
            currentTab = name
            contentFrame:ClearAllChildren()
            loadTabContent(name)
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                b.BackgroundTransparency = 0.4
            end
            btn.BackgroundColor3 = Color3.fromRGB(90, 60, 200)
            btn.BackgroundTransparency = 0.2
        end)

        table.insert(tabButtons, btn)
        return btn
    end

    -- Crear pestañas
    local xOff = 5
    for _, name in pairs(tabNames) do
        createTabButton(name, xOff)
        xOff = xOff + 70
    end

    -- ==========================================
    -- FUNCIÓN PARA CARGAR CONTENIDO DE CADA PESTAÑA
    -- ==========================================
    function loadTabContent(tabName)
        local yPos = 5

        -- Función para agregar toggle
        local function addToggle(labelText, defaultState)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 34)
            frame.Position = UDim2.new(0, 0, 0, yPos)
            frame.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
            frame.BackgroundTransparency = 0.25
            frame.BorderSizePixel = 0
            frame.Parent = contentFrame

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.7, 0, 1, 0)
            lbl.Position = UDim2.new(0, 8, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = labelText
            lbl.TextColor3 = Color3.fromRGB(210, 210, 240)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextScaled = true
            lbl.Font = Enum.Font.GothamMedium
            lbl.Parent = frame

            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(0, 55, 0, 24)
            toggle.Position = UDim2.new(0.85, 0, 0.5, -12)
            toggle.BackgroundColor3 = defaultState and Color3.fromRGB(70, 190, 70) or Color3.fromRGB(180, 70, 70)
            toggle.BorderSizePixel = 0
            toggle.Text = defaultState and "ON" or "OFF"
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.TextScaled = true
            toggle.Font = Enum.Font.GothamBold
            toggle.Parent = frame

            local state = defaultState
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.BackgroundColor3 = state and Color3.fromRGB(70, 190, 70) or Color3.fromRGB(180, 70, 70)
                toggle.Text = state and "ON" or "OFF"
                -- Llamar a la función de configuración
                if _G.SetConfig then
                    _G.SetConfig(labelText:gsub("%s+", ""), state)
                end
                print("⚙️ " .. labelText .. " = " .. tostring(state))
            end)
            yPos = yPos + 40
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
            addToggle("Auto Select Cards", false)
            addToggle("Auto Destroy Events", false)

        elseif tabName == "Tasks" then
            addToggle("Start Farm Observation", false)
            addToggle("Farm Observation Hopping", false)
            addToggle("Auto Mystery Swords", false)

        elseif tabName == "Teleports" then
            addToggle("Teleports for Seas", false)
            addToggle("Teleports for Islands", false)

        elseif tabName == "Combat" then
            addToggle("Aimbot", false)
            addToggle("ESP Players", false)
            addToggle("ESP Fruits", false)
            addToggle("ESP Items", false)
            addToggle("ESP Bosses", false)

        elseif tabName == "Shop" then
            addToggle("Shop All Items", false)

        elseif tabName == "Config" then
            addToggle("Anti AFK", false)
            addToggle("Fly", false)
            addToggle("Noclip", false)
            addToggle("Hitbox Extender", false)
        end

        -- Ajustar CanvasSize para Scroll
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 30)
    end

    -- Cargar pestaña inicial
    loadTabContent("Home")

    -- ==========================================
    -- HACER LA VENTANA ARRASTRABLE
    -- ==========================================
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ======================================================
-- FUNCIÓN PARA MINIMIZAR / RESTAURAR
-- ======================================================
function toggleMinimize()
    minimized = not minimized
    if minimized then
        mainFrame.Visible = false
        -- Crear icono flotante
        if not floatingIcon then
            floatingIcon = Instance.new("TextButton")
            floatingIcon.Size = UDim2.new(0, 50, 0, 50)
            floatingIcon.Position = UDim2.new(0, 20, 0, 100)
            floatingIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            floatingIcon.BackgroundTransparency = 0.1
            floatingIcon.BorderSizePixel = 0
            floatingIcon.Text = "🥔"
            floatingIcon.TextScaled = true
            floatingIcon.Font = Enum.Font.GothamBold
            floatingIcon.Parent = gui

            -- Hacer icono arrastrable
            local iconDrag = false
            local iconStart, iconPos
            floatingIcon.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    iconDrag = true
                    iconStart = input.Position
                    iconPos = floatingIcon.Position
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if iconDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Position - iconStart
                    floatingIcon.Position = UDim2.new(
                        iconPos.X.Scale,
                        iconPos.X.Offset + delta.X,
                        iconPos.Y.Scale,
                        iconPos.Y.Offset + delta.Y
                    )
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    iconDrag = false
                end
            end)

            -- Restaurar al hacer clic
            floatingIcon.MouseButton1Click:Connect(function()
                minimized = false
                mainFrame.Visible = true
                floatingIcon:Destroy()
                floatingIcon = nil
            end)
        end
    else
        mainFrame.Visible = true
        if floatingIcon then
            floatingIcon:Destroy()
            floatingIcon = nil
        end
    end
end

-- ======================================================
-- INICIALIZAR
-- ======================================================
createMainWindow()
print("🥔 Bodrio Fruit GUI V2 cargada con éxito.")