-- ==============================================================================
-- Project Name: เรื่องโปร Hub | ProScript [667z PvP Edition - Full Mobile & PC]
-- Description: Complete ESP Suite (Players, Item Drops, Zombies, Vehicles, Chams)
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Runtime Configuration State (Full Universal ESP Suite)
local Config = {
    Enabled = true,
    Wallhack = true,
    Boxes = true,
    Names = true,
    Distance = true,
    HealthBar = true,
    Tracers = true,
    ItemESP = true,
    ZombieESP = true,
    VehicleESP = true,
    AntiBan = true
}

-- Modern Cyber-Green & Obsidian Theme Palette
local Theme = {
    Accent = Color3.fromRGB(0, 255, 128),
    AccentDim = Color3.fromRGB(0, 160, 80),
    BgMain = Color3.fromRGB(11, 14, 12),
    BgSecondary = Color3.fromRGB(17, 22, 19),
    CardBg = Color3.fromRGB(23, 30, 26),
    CardStroke = Color3.fromRGB(38, 52, 43),
    TextPrimary = Color3.fromRGB(242, 255, 246),
    TextMuted = Color3.fromRGB(145, 170, 155),
    ToggleOff = Color3.fromRGB(45, 55, 48),
    Danger = Color3.fromRGB(215, 50, 50),
    ItemColor = Color3.fromRGB(255, 220, 50),
    ZombieColor = Color3.fromRGB(255, 80, 80),
    VehicleColor = Color3.fromRGB(50, 180, 255)
}

-- Execute previous cleanup routine if re-executed
if getgenv and getgenv().ProScriptCleanup then
    pcall(getgenv().ProScriptCleanup)
end

-- Remove residual UI instances from target containers
local function DestroyStuckGuis()
    local targets = { CoreGui, LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") }
    if gethui then
        pcall(function() table.insert(targets, gethui()) end)
    end
    for _, parent in ipairs(targets) do
        if parent then
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name == "ProScriptHub" or child.Name == "ProScriptESP" then
                    pcall(function() child:Destroy() end)
                end
            end
        end
    end
    if cleardrawcache then
        pcall(cleardrawcache)
    end
end

DestroyStuckGuis()

-- Resolve optimal GUI container for Mobile and Desktop executors
local function GetSafeGuiParent()
    local ok, res = pcall(function()
        if gethui then return gethui() end
        return CoreGui
    end)
    if ok and res then return res end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- Universal Clipboard Helper
local function CopyToClipboard(text)
    local copyFunc = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if copyFunc then
        return pcall(copyFunc, tostring(text))
    end
    return false
end

-- Root ScreenGui Initialization
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProScriptHub"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GetSafeGuiParent()

-- Containers for Overlays & Highlights
local ESPContainer = Instance.new("Folder")
ESPContainer.Name = "ESPContainer"
ESPContainer.Parent = ScreenGui

local HighlightContainer = Instance.new("Folder")
HighlightContainer.Name = "HighlightContainer"
HighlightContainer.Parent = ScreenGui

local WorldESPContainer = Instance.new("Folder")
WorldESPContainer.Name = "WorldESPContainer"
WorldESPContainer.Parent = ScreenGui

-- ==============================================================================
-- Floating Quick-Access Button (Optimized for Mobile Touch & PC)
-- ==============================================================================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatToggle"
FloatBtn.Parent = ScreenGui
FloatBtn.BackgroundColor3 = Theme.BgMain
FloatBtn.Position = UDim2.new(0, 18, 0.5, -26)
FloatBtn.Size = UDim2.new(0, 52, 0, 52)
FloatBtn.Font = Enum.Font.GothamBlack
FloatBtn.Text = "667z"
FloatBtn.TextColor3 = Theme.Accent
FloatBtn.TextSize = 13
FloatBtn.AutoButtonColor = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 14)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Theme.Accent
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatBtn

-- ==============================================================================
-- Main Control Panel Window
-- ==============================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Theme.BgMain
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 400, 0, 390)
MainFrame.Active = true
MainFrame.ClipsDescendants = true

local UIScale = Instance.new("UIScale")
UIScale.Parent = MainFrame

local function UpdateResponsiveScale()
    Camera = Workspace.CurrentCamera
    if not Camera then return end
    local vp = Camera.ViewportSize
    if vp.Y < 480 then
        UIScale.Scale = math.clamp(vp.Y / 440, 0.72, 1)
    else
        UIScale.Scale = 1
    end
end
UpdateResponsiveScale()

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.6
MainStroke.Parent = MainFrame

-- Top Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Theme.BgSecondary
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Active = true

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderAccentLine = Instance.new("Frame")
HeaderAccentLine.Parent = Header
HeaderAccentLine.BackgroundColor3 = Theme.Accent
HeaderAccentLine.BorderSizePixel = 0
HeaderAccentLine.Position = UDim2.new(0, 0, 1, -2)
HeaderAccentLine.Size = UDim2.new(1, 0, 0, 2)

-- Status Badge Indicator
local BadgeDot = Instance.new("Frame")
BadgeDot.Parent = Header
BadgeDot.BackgroundColor3 = Theme.Accent
BadgeDot.Position = UDim2.new(0, 14, 0, 14)
BadgeDot.Size = UDim2.new(0, 8, 0, 8)

local BadgeDotCorner = Instance.new("UICorner")
BadgeDotCorner.CornerRadius = UDim.new(1, 0)
BadgeDotCorner.Parent = BadgeDot

-- Main Title & Subtitle
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 28, 0, 7)
TitleLabel.Size = UDim2.new(1, -115, 0, 20)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "เรื่องโปร Hub | ProScript"
TitleLabel.TextColor3 = Theme.TextPrimary
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Parent = Header
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Position = UDim2.new(0, 28, 0, 25)
SubTitleLabel.Size = UDim2.new(1, -115, 0, 16)
SubTitleLabel.Font = Enum.Font.GothamMedium
SubTitleLabel.Text = "Server: 667z pvp • Full Mobile & PC ESP"
SubTitleLabel.TextColor3 = Theme.Accent
SubTitleLabel.TextSize = 11
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Header
MinimizeBtn.BackgroundColor3 = Theme.CardBg
MinimizeBtn.Position = UDim2.new(1, -76, 0.5, -15)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Theme.TextPrimary
MinimizeBtn.TextSize = 13

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = Theme.CardStroke
MinStroke.Thickness = 1
MinStroke.Parent = MinimizeBtn

-- Close / Unload Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Theme.Danger
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Scrollable Content Area
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Parent = MainFrame
ContentContainer.Active = true
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 12, 0, 58)
ContentContainer.Size = UDim2.new(1, -24, 1, -68)
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = Theme.Accent
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ScrollingDirection = Enum.ScrollingDirection.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = ContentContainer
UIPadding.PaddingTop = UDim.new(0, 2)
UIPadding.PaddingBottom = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 2)
UIPadding.PaddingRight = UDim.new(0, 4)

-- ==============================================================================
-- Cross-Platform Touch & Mouse Input Handling
-- ==============================================================================
local Connections = {}
table.insert(Connections, Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateResponsiveScale))

local function BindButton(button, callback)
    local lastTrigger = 0
    local pressStartPos = nil

    local function Trigger()
        local now = os.clock()
        if now - lastTrigger < 0.22 then return end
        lastTrigger = now
        task.spawn(callback)
    end

    table.insert(Connections, button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            pressStartPos = input.Position
        end
    end))

    table.insert(Connections, button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if pressStartPos and (input.Position - pressStartPos).Magnitude <= 14 then
                Trigger()
            end
            pressStartPos = nil
        end
    end))

    table.insert(Connections, button.Activated:Connect(Trigger))
end

local function MakeDraggable(dragHandle, targetFrame)
    local dragging = false
    local dragInput, dragStart, startPos

    table.insert(Connections, dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end))

    table.insert(Connections, dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))

    table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end))
end

MakeDraggable(Header, MainFrame)
MakeDraggable(FloatBtn, FloatBtn)

-- Window Collapse & Quick-Toggle Logic
local isMinimized = false
BindButton(MinimizeBtn, function()
    isMinimized = not isMinimized
    ContentContainer.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 400, 0, 50) or UDim2.new(0, 400, 0, 390)
    MinimizeBtn.Text = isMinimized and "+" or "—"
end)

BindButton(FloatBtn, function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ==============================================================================
-- UI Component Builders
-- ==============================================================================
local function CreateSectionHeader(titleText)
    local holder = Instance.new("Frame")
    holder.Parent = ContentContainer
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 22)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = holder
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 4, 0, 4)
    lbl.Size = UDim2.new(1, -8, 1, -4)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = titleText
    lbl.TextColor3 = Theme.Accent
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    return holder
end

local function CreateSwitchToggle(titleText, subtitleText, defaultState, callback)
    local Card = Instance.new("TextButton")
    Card.Parent = ContentContainer
    Card.BackgroundColor3 = Theme.CardBg
    Card.Size = UDim2.new(1, 0, 0, 44)
    Card.AutoButtonColor = false
    Card.Text = ""

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = defaultState and Theme.AccentDim or Theme.CardStroke
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    local Title = Instance.new("TextLabel")
    Title.Parent = Card
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 6)
    Title.Size = UDim2.new(1, -70, 0, 18)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText
    Title.TextColor3 = Theme.TextPrimary
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Sub = Instance.new("TextLabel")
    Sub.Parent = Card
    Sub.BackgroundTransparency = 1
    Sub.Position = UDim2.new(0, 12, 0, 23)
    Sub.Size = UDim2.new(1, -70, 0, 14)
    Sub.Font = Enum.Font.Gotham
    Sub.Text = subtitleText
    Sub.TextColor3 = Theme.TextMuted
    Sub.TextSize = 10
    Sub.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Parent = Card
    SwitchBg.AnchorPoint = Vector2.new(1, 0.5)
    SwitchBg.Position = UDim2.new(1, -12, 0.5, 0)
    SwitchBg.Size = UDim2.new(0, 40, 0, 20)
    SwitchBg.BackgroundColor3 = defaultState and Theme.Accent or Theme.ToggleOff

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBg

    local Knob = Instance.new("Frame")
    Knob.Parent = SwitchBg
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.Position = defaultState and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local state = defaultState
    BindButton(Card, function()
        state = not state
        SwitchBg.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
        Knob.Position = state and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        CardStroke.Color = state and Theme.AccentDim or Theme.CardStroke
        callback(state)
    end)
end

local function CreateActionCard(labelText, accentColor, onClick)
    local Btn = Instance.new("TextButton")
    Btn.Parent = ContentContainer
    Btn.BackgroundColor3 = Theme.CardBg
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.AutoButtonColor = false
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = "   " .. labelText
    Btn.TextColor3 = accentColor
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 9)
    Corner.Parent = Btn

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme.CardStroke
    Stroke.Thickness = 1
    Stroke.Parent = Btn

    BindButton(Btn, onClick)
    return Btn
end

-- ==============================================================================
-- Populate Control Panel Controls (Players, Items, Zombies, Vehicles, Security)
-- ==============================================================================
CreateSectionHeader("⚡ ระบบมองทะลุผู้เล่น (PLAYER ESP)")

CreateSwitchToggle(
    "เปิดใช้งาน ESP ทั้งหมด (Master Switch)",
    "เปิด/ปิดระบบมองทะลุกรอบและผู้เล่นทั้งหมด",
    Config.Enabled,
    function(v) Config.Enabled = v end
)

CreateSwitchToggle(
    "มองทะลุตัวผู้เล่น (Wallhack Highlight)",
    "เรืองแสงตัวละครมองทะลุกำแพงและสิ่งกีดขวาง",
    Config.Wallhack,
    function(v) Config.Wallhack = v end
)

CreateSwitchToggle(
    "กรอบผู้เล่น (2D Box ESP)",
    "ตีกรอบสี่เหลี่ยมรอบตัวผู้เล่นตามระยะจริง",
    Config.Boxes,
    function(v) Config.Boxes = v end
)

CreateSwitchToggle(
    "ชื่อและระยะห่างเป็นเมตร (Name & Distance)",
    "แสดงชื่อผู้เล่นพร้อมบอกระยะทางกี่เมตร",
    Config.Names,
    function(v)
        Config.Names = v
        Config.Distance = v
    end
)

CreateSwitchToggle(
    "หลอดเลือดและตัวเลข HP (Health Bar & HP)",
    "แสดงแถบเลือดด้านข้างกรอบพร้อมตัวเลข HP",
    Config.HealthBar,
    function(v) Config.HealthBar = v end
)

CreateSwitchToggle(
    "เส้นเทเซอชี้เป้า (Tracer Lines)",
    "ลากเส้นบอกตำแหน่งจากหน้าจอไปยังผู้เล่น",
    Config.Tracers,
    function(v) Config.Tracers = v end
)

CreateSectionHeader("📦 ระบบไอเทม ซอมบี้ และยานพาหนะ (WORLD ESP)")

CreateSwitchToggle(
    "ESP ไอเทมดรอปพื้น (World Item Drops)",
    "แสดงชื่อและตำแหน่งไอเทมที่ดรอปบนพื้นแผนที่",
    Config.ItemESP,
    function(v) Config.ItemESP = v end
)

CreateSwitchToggle(
    "ESP ซอมบี้ (Zombies ESP)",
    "แสดงกรอบและระยะห่างของซอมบี้รอบตัว",
    Config.ZombieESP,
    function(v) Config.ZombieESP = v end
)

CreateSwitchToggle(
    "ESP ยานพาหนะ (Vehicles ESP)",
    "แสดงตำแหน่งและชื่อรถ/พาหนะในเกม",
    Config.VehicleESP,
    function(v) Config.VehicleESP = v end
)

CreateSectionHeader("🛡️ ระบบความปลอดภัย (SECURITY SAFEGUARD)")

CreateSwitchToggle(
    "ระบบกันแบน (Anti-Ban Safeguard)",
    "ป้องกันคำสั่งตรวจสอบฝั่งเซิร์ฟเวอร์",
    Config.AntiBan,
    function(v) Config.AntiBan = v end
)

CreateSectionHeader("🌐 เครดิต & ชุมชนเรื่องโปร (CREDITS)")

CreateActionCard("📺 YouTube: เรื่องโปร (แตะเพื่อคัดลอกชื่อช่อง)", Color3.fromRGB(255, 105, 105), function()
    if CopyToClipboard("เรื่องโปร") then
        SubTitleLabel.Text = "คัดลอกชื่อช่อง YouTube: เรื่องโปร สำเร็จ!"
    else
        SubTitleLabel.Text = "YouTube: เรื่องโปร"
    end
    task.wait(1.5)
    SubTitleLabel.Text = "Server: 667z pvp • Full Mobile & PC ESP"
end)

CreateActionCard("💬 Discord: https://discord.gg/gZpkSgmR8", Color3.fromRGB(115, 205, 255), function()
    if CopyToClipboard("https://discord.gg/gZpkSgmR8") then
        SubTitleLabel.Text = "คัดลอกลิงก์ Discord สำเร็จ!"
    else
        SubTitleLabel.Text = "Discord: discord.gg/gZpkSgmR8"
    end
    task.wait(1.5)
    SubTitleLabel.Text = "Server: 667z pvp • Full Mobile & PC ESP"
end)

-- ==============================================================================
-- Client Anti-Ban Hook
-- ==============================================================================
pcall(function()
    local mt = getrawmetatable and getrawmetatable(game)
    if mt and setreadonly then
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        local wrap = newcclosure or function(f) return f end
        mt.__namecall = wrap(function(self, ...)
            if Config.AntiBan then
                local method = getnamecallmethod and getnamecallmethod()
                if method == "Kick" or method == "Ban" then
                    return nil
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
end)

-- ==============================================================================
-- Player ESP Engine
-- ==============================================================================
local ActiveESP = {}

local function CreateESPNode(player)
    local holder = Instance.new("Frame")
    holder.Name = "ESP_" .. player.Name
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 1, 0)
    holder.Visible = false
    holder.Parent = ESPContainer

    local boxOutline = Instance.new("Frame")
    boxOutline.BackgroundTransparency = 1
    boxOutline.BorderSizePixel = 0
    boxOutline.Visible = false
    boxOutline.Parent = holder

    local outlineStroke = Instance.new("UIStroke")
    outlineStroke.Thickness = 3
    outlineStroke.Color = Color3.fromRGB(0, 0, 0)
    outlineStroke.Transparency = 0.25
    outlineStroke.Parent = boxOutline

    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Visible = false
    box.Parent = holder

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Color = Theme.Accent
    boxStroke.Parent = box

    local hpBg = Instance.new("Frame")
    hpBg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    hpBg.BorderColor3 = Color3.fromRGB(0, 0, 0)
    hpBg.BorderSizePixel = 1
    hpBg.Visible = false
    hpBg.Parent = holder

    local hpFill = Instance.new("Frame")
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 110)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.TextColor3 = Theme.TextPrimary
    nameLabel.TextStrokeTransparency = 0.1
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Size = UDim2.new(0, 240, 0, 18)
    nameLabel.AnchorPoint = Vector2.new(0.5, 1)
    nameLabel.Visible = false
    nameLabel.Parent = holder

    local hpText = Instance.new("TextLabel")
    hpText.BackgroundTransparency = 1
    hpText.Font = Enum.Font.GothamBold
    hpText.TextSize = 11
    hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hpText.TextStrokeTransparency = 0.1
    hpText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hpText.Size = UDim2.new(0, 90, 0, 15)
    hpText.TextXAlignment = Enum.TextXAlignment.Left
    hpText.Visible = false
    hpText.Parent = holder

    local tracer = Instance.new("Frame")
    tracer.BackgroundColor3 = Theme.Accent
    tracer.BorderSizePixel = 0
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.Visible = false
    tracer.Parent = holder

    local highlight = Instance.new("Highlight")
    highlight.Name = "Chams_" .. player.Name
    highlight.FillColor = Theme.Accent
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    highlight.Parent = HighlightContainer

    ActiveESP[player] = {
        Holder = holder,
        BoxOutline = boxOutline,
        Box = box,
        BoxStroke = boxStroke,
        HpBg = hpBg,
        HpFill = hpFill,
        Label = nameLabel,
        HpText = hpText,
        Tracer = tracer,
        Highlight = highlight
    }
    return ActiveESP[player]
end

local function RemoveESPNode(player)
    local node = ActiveESP[player]
    if node then
        if node.Holder then pcall(function() node.Holder:Destroy() end) end
        if node.Highlight then pcall(function() node.Highlight:Destroy() end) end
        ActiveESP[player] = nil
    end
end

local function ClearAllESP()
    for player, _ in pairs(ActiveESP) do
        RemoveESPNode(player)
    end
    if ESPContainer then ESPContainer:ClearAllChildren() end
    if HighlightContainer then HighlightContainer:ClearAllChildren() end
    if WorldESPContainer then WorldESPContainer:ClearAllChildren() end
end

table.insert(Connections, Players.PlayerRemoving:Connect(function(player)
    RemoveESPNode(player)
end))

local isUnloaded = false
local function FullUnload()
    if isUnloaded then return end
    isUnloaded = true
    Config.Enabled = false

    for _, conn in ipairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(Connections)

    ClearAllESP()
    DestroyStuckGuis()
    pcall(function() ScreenGui:Destroy() end)
end

if getgenv then
    getgenv().ProScriptCleanup = FullUnload
end

BindButton(CloseBtn, FullUnload)

local function UpdateTracerLine(tracerFrame, fromX, fromY, toX, toY, color)
    local dx = toX - fromX
    local dy = toY - fromY
    local dist = math.sqrt(dx * dx + dy * dy)
    local cx = (fromX + toX) / 2
    local cy = (fromY + toY) / 2
    local angle = math.deg(math.atan2(dy, dx))

    tracerFrame.Position = UDim2.new(0, cx, 0, cy)
    tracerFrame.Size = UDim2.new(0, dist, 0, 1.5)
    tracerFrame.Rotation = angle
    tracerFrame.BackgroundColor3 = color
    tracerFrame.Visible = true
end

-- ==============================================================================
-- World Objects ESP Manager (Items, Zombies, Vehicles)
-- ==============================================================================
local WorldESPNodes = {}

local function CreateWorldESPNode(instance, labelText, color)
    if WorldESPNodes[instance] then return WorldESPNodes[instance] end

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.1
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Size = UDim2.new(0, 200, 0, 16)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Visible = false
    label.Parent = WorldESPContainer

    WorldESPNodes[instance] = { Label = label, Color = color }
    return WorldESPNodes[instance]
end

local function RemoveWorldESPNode(instance)
    local node = WorldESPNodes[instance]
    if node and node.Label then
        pcall(function() node.Label:Destroy() end)
    end
    WorldESPNodes[instance] = nil
end

-- Main Render Loop (Players + World Drops + Zombies + Vehicles)
table.insert(Connections, RunService.RenderStepped:Connect(function()
    if isUnloaded or not Config.Enabled then
        ClearAllESP()
        return
    end

    Camera = Workspace.CurrentCamera
    if not Camera then return end

    local ValidPlayers = {}
    local viewportSize = Camera.ViewportSize

    -- 1. Player ESP Rendering
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Parent == Players and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead then
                ValidPlayers[player] = true
                local node = ActiveESP[player] or CreateESPNode(player)

                if Config.Wallhack then
                    if node.Highlight.Adornee ~= char then
                        node.Highlight.Adornee = char
                    end
                    node.Highlight.Enabled = true
                else
                    node.Highlight.Enabled = false
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    node.Holder.Visible = true

                    local topPos = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3.25, 0))
                    local bottomPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.65, 0))

                    local height = math.max(math.abs(bottomPos.Y - topPos.Y), 22)
                    local width = height * 0.66
                    local boxX = screenPos.X - (width / 2)
                    local boxY = topPos.Y
                    local distMeters = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)

                    if Config.Boxes then
                        node.BoxOutline.Position = UDim2.new(0, boxX, 0, boxY)
                        node.BoxOutline.Size = UDim2.new(0, width, 0, height)
                        node.BoxOutline.Visible = true

                        node.Box.Position = UDim2.new(0, boxX, 0, boxY)
                        node.Box.Size = UDim2.new(0, width, 0, height)
                        node.BoxStroke.Color = Theme.Accent
                        node.Box.Visible = true
                    else
                        node.BoxOutline.Visible = false
                        node.Box.Visible = false
                    end

                    if Config.HealthBar then
                        local maxHp = math.max(hum.MaxHealth, 1)
                        local curHp = math.clamp(hum.Health, 0, maxHp)
                        local ratio = curHp / maxHp
                        local hpColor = Color3.fromHSV(ratio * 0.33, 1, 1)

                        node.HpBg.Position = UDim2.new(0, boxX - 6, 0, boxY)
                        node.HpBg.Size = UDim2.new(0, 3, 0, height)
                        node.HpBg.Visible = true

                        node.HpFill.Position = UDim2.new(0, 0, 1 - ratio, 0)
                        node.HpFill.Size = UDim2.new(1, 0, ratio, 0)
                        node.HpFill.BackgroundColor3 = hpColor

                        node.HpText.Text = string.format("%d HP", math.floor(curHp))
                        node.HpText.Position = UDim2.new(0, boxX + width + 5, 0, boxY)
                        node.HpText.TextColor3 = hpColor
                        node.HpText.Visible = true
                    else
                        node.HpBg.Visible = false
                        node.HpText.Visible = false
                    end

                    if Config.Names or Config.Distance then
                        node.Label.Text = string.format("%s [%dm]", player.DisplayName, distMeters)
                        node.Label.Position = UDim2.new(0, screenPos.X, 0, boxY - 4)
                        node.Label.TextColor3 = Theme.TextPrimary
                        node.Label.Visible = true
                    else
                        node.Label.Visible = false
                    end

                    if Config.Tracers then
                        UpdateTracerLine(node.Tracer, viewportSize.X / 2, viewportSize.Y, screenPos.X, boxY + height, Theme.Accent)
                    else
                        node.Tracer.Visible = false
                    end
                else
                    node.Holder.Visible = false
                end
            end
        end
    end

    for player, _ in pairs(ActiveESP) do
        if not ValidPlayers[player] then
            RemoveESPNode(player)
        end
    end

    -- 2. World Item Drops ESP (`WarZWorldDrops`)
    local activeWorldObjects = {}
    if Config.ItemESP then
        local dropsFolder = Workspace:FindFirstChild("WarZWorldDrops")
        if dropsFolder then
            for _, drop in ipairs(dropsFolder:GetChildren()) do
                local primaryPart = drop:IsA("Model") and (drop.PrimaryPart or drop:FindFirstChildWhichIsA("BasePart")) or (drop:IsA("BasePart") and drop)
                if primaryPart then
                    activeWorldObjects[drop] = true
                    local node = WorldESPNodes[drop] or CreateWorldESPNode(drop, drop.Name, Theme.ItemColor)
                    local screenPos, onScreen = Camera:WorldToViewportPoint(primaryPart.Position)
                    if onScreen then
                        local dist = math.floor((Camera.CFrame.Position - primaryPart.Position).Magnitude)
                        node.Label.Text = string.format("📦 [%s] [%dm]", drop.Name, dist)
                        node.Label.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                        node.Label.TextColor3 = Theme.ItemColor
                        node.Label.Visible = true
                    else
                        node.Label.Visible = false
                    end
                end
            end
        end
    end

    -- 3. Vehicles ESP (`WarZVehicles`)
    if Config.VehicleESP then
        local vehiclesFolder = Workspace:FindFirstChild("WarZVehicles")
        if vehiclesFolder then
            for _, veh in ipairs(vehiclesFolder:GetChildren()) do
                local primaryPart = veh:IsA("Model") and (veh.PrimaryPart or veh:FindFirstChildWhichIsA("BasePart")) or (veh:IsA("BasePart") and veh)
                if primaryPart then
                    activeWorldObjects[veh] = true
                    local node = WorldESPNodes[veh] or CreateWorldESPNode(veh, veh.Name, Theme.VehicleColor)
                    local screenPos, onScreen = Camera:WorldToViewportPoint(primaryPart.Position)
                    if onScreen then
                        local dist = math.floor((Camera.CFrame.Position - primaryPart.Position).Magnitude)
                        node.Label.Text = string.format("🚗 [%s] [%dm]", veh.Name, dist)
                        node.Label.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                        node.Label.TextColor3 = Theme.VehicleColor
                        node.Label.Visible = true
                    else
                        node.Label.Visible = false
                    end
                end
            end
        end
    end

    -- 4. Zombies ESP
    if Config.ZombieESP then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if hum and hrp and hum.Health > 0 then
                    activeWorldObjects[obj] = true
                    local node = WorldESPNodes[obj] or CreateWorldESPNode(obj, "Zombie", Theme.ZombieColor)
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                        node.Label.Text = string.format("🧟 [Zombie] [%dm]", dist)
                        node.Label.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                        node.Label.TextColor3 = Theme.ZombieColor
                        node.Label.Visible = true
                    else
                        node.Label.Visible = false
                    end
                end
            end
        end
    end

    -- Cleanup stale world ESP nodes
    for obj, node in pairs(WorldESPNodes) do
        if not activeWorldObjects[obj] or not obj.Parent then
            RemoveWorldESPNode(obj)
        end
    end
end))