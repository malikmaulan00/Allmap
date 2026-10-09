--[[
╔═══════════════════════════════════════════════════════════════════════════╗
║              ✦ ETERNITY PREMIUM - NEXUS EDITION ✦                      ║
║              🔥 Copy Map 100% • Asset Ripper • Server Spy              ║
║                   💎 Premium GUI • 250+ Features                       ║
╚═══════════════════════════════════════════════════════════════════════════╝
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")
local VirtualUser = game:GetService("VirtualUser")
local LP = Players.LocalPlayer
local Cam = Workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 PREMIUM THEME
-- ═══════════════════════════════════════════════════════════════════════════

local T = {
    Bg = Color3.fromRGB(18, 14, 30),
    Bg2 = Color3.fromRGB(28, 22, 45),
    Panel = Color3.fromRGB(35, 28, 55),
    Elem = Color3.fromRGB(45, 38, 70),
    ElemHover = Color3.fromRGB(60, 50, 90),
    Gold = Color3.fromRGB(255, 215, 0),
    GoldD = Color3.fromRGB(200, 170, 0),
    GoldL = Color3.fromRGB(255, 235, 150),
    Purple = Color3.fromRGB(160, 100, 255),
    PurpleL = Color3.fromRGB(200, 160, 255),
    PurpleD = Color3.fromRGB(100, 60, 200),
    Pink = Color3.fromRGB(255, 105, 180),
    White = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(220, 210, 240),
    TextDim = Color3.fromRGB(160, 150, 180),
    On = Color3.fromRGB(80, 220, 100),
    Off = Color3.fromRGB(80, 70, 100),
    Close = Color3.fromRGB(255, 80, 80),
    Border = Color3.fromRGB(255, 215, 0),
    Shadow = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(160, 100, 255),
    Progress = Color3.fromRGB(255, 215, 0),
    ProgressBg = Color3.fromRGB(40, 35, 60),
    Emerald = Color3.fromRGB(80, 220, 100),
    Cyan = Color3.fromRGB(80, 200, 255),
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔧 SETTINGS
-- ═══════════════════════════════════════════════════════════════════════════

local Settings = {
    W = 780, H = 600,
    Opacity = 0.05,
    Corner = 20,
    FontSize = 12,
    TitleSize = 18,
    AnimSpeed = 0.4,
    NotifDur = 3,
    BorderThick = 2.5,
    ShowCredits = true,
    TabSize = 12,
    ScrollW = 4,
}

-- ═══ CONFIG ═══
local Config = {
    Speed = 16, JumpPower = 50, InfiniteJump = false, AutoJump = false,
    Bhop = false, MoonJump = false, Sprint = false, SprintSpeed = 40,
    Fly = false, FlySpeed = 50, Noclip = false,
    GodMode = false, AntiVoid = false, AntiKnockback = false,
    NoFallDamage = false, ClickTP = false, Invisible = false,
    Aimbot = false, SuperAimbot = false, AimbotFOV = 200,
    Crosshair = false, AutoClick = false, AutoClickTarget = nil,
    KillAura = false, KillAuraRange = 15,
    ESP = false, ESPDistFilter = 500, TracerLines = false,
    ShowFPS = false, LoopTP = false, LoopTPDelay = 500,
    AutoWalk = false, AutoFarm = false, AutoFarmRange = 30,
    AntiAFK = true, AutoRejoin = false,
    Fullbright = false, NoFog = false,
    FishItAutoClick = false, FishItAutoSkip = false,
    FishItAutoReel = false, FishItAutoCollect = false,
    RejoinCount = 0,
    
    -- NexusCopy Features
    ServerSpy = false,
    ServerSpyDuration = 60,
    ScanAssets = false,
    ExtractTerrain = false,
}

-- ═══ SHARED VARIABLES ═══
local PVPTarget = nil
local SelP = nil
local fps, frc, lt = 0, 0, tick()
local flying, flyBV, flyBG = false, nil, nil
local isCopyingMap = false
local copyProgress = 0
local copyTotal = 0
local mapCopyFolder = nil
local monitoredObjects = {}
local AutoClickActive = false
local AutoClickTarget = nil
local RejoinActive = false
local AntiAFKActive = false
local SoundData = {}
local isScanning = false
local serverSpyActive = false
local serverSpyLogs = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 UI FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateGlow(parent, color, size, transparency)
    local glow = Instance.new("ImageLabel")
    glow.Size = UDim2.new(1, size, 1, size)
    glow.Position = UDim2.new(0, -size/2, 0, -size/2)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5554236805"
    glow.ImageColor3 = color or T.Glow
    glow.ImageTransparency = transparency or 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.ZIndex = 0
    glow.Parent = parent
    return glow
end

local function CreateGradient(parent, colors, rotation)
    local grad = Instance.new("UIGradient", parent)
    local colorPoints = {}
    for i, color in pairs(colors) do
        table.insert(colorPoints, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
    end
    grad.Color = ColorSequence.new(colorPoints)
    grad.Rotation = rotation or 0
    return grad
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📱 MAIN GUI
-- ═══════════════════════════════════════════════════════════════════════════

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "ETERNITY_NEXUS" then v:Destroy() end
end

local SG = Instance.new("ScreenGui")
SG.Name = "ETERNITY_NEXUS"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = CoreGui

-- FPS LABEL
local FPSL = Instance.new("TextLabel")
FPSL.Size = UDim2.new(0, 180, 0, 32)
FPSL.Position = UDim2.new(0, 15, 0, 75)
FPSL.BackgroundColor3 = T.Bg2
FPSL.BackgroundTransparency = 0.2
FPSL.Text = "FPS: 0 | Ping: 0"
FPSL.TextColor3 = T.Gold
FPSL.TextSize = 11
FPSL.Font = Enum.Font.GothamBold
FPSL.Visible = false
FPSL.Parent = SG
Instance.new("UICorner", FPSL).CornerRadius = UDim.new(0, 10)

-- CROSSHAIR
local crosshairParts = {}
local function CreateCrosshair()
    local configs = {
        {2, 24, 0.5, -1, 0.5, -12},
        {24, 2, 0.5, -12, 0.5, -1},
        {2, 8, 0.5, -1, 0.5, -18},
        {2, 8, 0.5, -1, 0.5, 10},
        {8, 2, 0.5, -18, 0.5, -1},
        {8, 2, 0.5, 10, 0.5, -1},
    }
    for _, cfg in pairs(configs) do
        local f = Instance.new("Frame", SG)
        f.Size = UDim2.new(0, cfg[1], 0, cfg[2])
        f.Position = UDim2.new(cfg[3], cfg[4], cfg[5], cfg[6])
        f.BackgroundColor3 = T.Gold
        f.BorderSizePixel = 0
        f.Visible = false
        table.insert(crosshairParts, f)
    end
end
CreateCrosshair()

-- MAIN FRAME
local MF = Instance.new("Frame")
MF.Name = "Main"
MF.Size = UDim2.new(0, Settings.W, 0, Settings.H)
MF.Position = UDim2.new(0.5, 0, 0.5, 0)
MF.AnchorPoint = Vector2.new(0.5, 0.5)
MF.BackgroundColor3 = T.Bg
MF.BackgroundTransparency = Settings.Opacity
MF.ClipsDescendants = true
MF.BorderSizePixel = 0
MF.Active = true
MF.Draggable = true
MF.Parent = SG

local MFC = Instance.new("UICorner", MF)
MFC.CornerRadius = UDim.new(0, Settings.Corner)

local MainGlow = CreateGlow(MF, T.Glow, 60, 0.5)

local MFS = Instance.new("UIStroke", MF)
MFS.Thickness = Settings.BorderThick
MFS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
local BorderGrad = CreateGradient(MFS, {T.Gold, T.Purple, T.Gold, T.Pink, T.Gold}, 0)

spawn(function()
    local r = 0
    while SG.Parent do
        r = (r + 0.5) % 360
        BorderGrad.Rotation = r
        wait(0.03)
    end
end)

-- TITLE BAR
local TB = Instance.new("Frame")
TB.Size = UDim2.new(1, 0, 0, 48)
TB.BackgroundColor3 = T.Bg2
TB.BackgroundTransparency = 0.3
TB.BorderSizePixel = 0
TB.ZIndex = 2
TB.Parent = MF
Instance.new("UICorner", TB).CornerRadius = UDim.new(0, Settings.Corner)

CreateGradient(TB, {T.PurpleD, T.Bg2, T.PurpleD}, 0)

local TBLine = Instance.new("Frame")
TBLine.Size = UDim2.new(1, -30, 0, 2.5)
TBLine.Position = UDim2.new(0, 15, 1, -2.5)
TBLine.BackgroundColor3 = T.Gold
TBLine.BorderSizePixel = 0
TBLine.ZIndex = 3
TBLine.Parent = TB
CreateGradient(TBLine, {T.Gold, T.Purple, T.Gold, T.Pink, T.Gold}, 0)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 350, 1, 0)
Logo.Position = UDim2.new(0, 18, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "✦ ETERNITY NEXUS"
Logo.TextColor3 = T.Gold
Logo.TextSize = Settings.TitleSize
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.ZIndex = 3
Logo.Parent = TB

spawn(function()
    local h = 0
    while SG.Parent do
        h = (h + 0.002) % 1
        local c = Color3.fromHSV((h * 0.1 + 0.12) % 1, 1, 0.9)
        Logo.TextColor3 = c
        wait(0.03)
    end
end)

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 0, 16)
SubTitle.Position = UDim2.new(0, 155, 0, 28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "✦ Nexus Edition"
SubTitle.TextColor3 = T.PurpleL
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.ZIndex = 3
SubTitle.Parent = TB

local Cred = Instance.new("TextLabel")
Cred.Size = UDim2.new(0, 250, 0, 18)
Cred.Position = UDim2.new(0, 18, 1, -24)
Cred.BackgroundTransparency = 1
Cred.Text = "✦ 250+ Features ✦ Asset Ripper ✦"
Cred.TextColor3 = T.GoldL
Cred.TextSize = 10
Cred.Font = Enum.Font.GothamBold
Cred.TextXAlignment = Enum.TextXAlignment.Left
Cred.Parent = MF

-- CLOSE BUTTON
local CB = Instance.new("TextButton")
CB.Size = UDim2.new(0, 34, 0, 34)
CB.Position = UDim2.new(1, -42, 0, 7)
CB.BackgroundColor3 = T.Close
CB.Text = "✕"
CB.TextColor3 = T.White
CB.TextSize = 16
CB.Font = Enum.Font.GothamBold
CB.ZIndex = 3
CB.Parent = TB
Instance.new("UICorner", CB).CornerRadius = UDim.new(0, 10)
CB.MouseButton1Click:Connect(function()
    TweenService:Create(MF, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.25)
    SG:Destroy()
end)

-- MINIMIZE BUTTON
local MB = Instance.new("TextButton")
MB.Size = UDim2.new(0, 34, 0, 34)
MB.Position = UDim2.new(1, -80, 0, 7)
MB.BackgroundColor3 = T.PurpleD
MB.Text = "−"
MB.TextColor3 = T.Gold
MB.TextSize = 22
MB.Font = Enum.Font.GothamBold
MB.ZIndex = 3
MB.Parent = TB
MB.BorderSizePixel = 0
Instance.new("UICorner", MB).CornerRadius = UDim.new(0, 10)

-- TOGGLE BUTTON
local TOB = Instance.new("TextButton")
TOB.Size = UDim2.new(0, 160, 0, 44)
TOB.Position = UDim2.new(0, 15, 0.5, -22)
TOB.BackgroundColor3 = T.Bg
TOB.BackgroundTransparency = 0.1
TOB.Text = "✦ ETERNITY NEXUS"
TOB.TextColor3 = T.Gold
TOB.Font = Enum.Font.GothamBold
TOB.TextSize = 13
TOB.Visible = false
TOB.Active = true
TOB.ZIndex = 999
TOB.Parent = SG
Instance.new("UICorner", TOB).CornerRadius = UDim.new(0, 14)
local TOBS = Instance.new("UIStroke", TOB)
TOBS.Color = T.Gold
TOBS.Thickness = 2
local TOGlow = CreateGlow(TOB, T.Glow, 30, 0.6)

MB.MouseButton1Click:Connect(function()
    TweenService:Create(MF, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    MF.Visible = false
    TOB.Visible = true
    TOB.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(TOB, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 160, 0, 44)
    }):Play()
end)

TOB.MouseButton1Click:Connect(function()
    TOB.Visible = false
    MF.Visible = true
    MF.Size = UDim2.new(0, 0, 0, 0)
    MF.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MF, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, Settings.W, 0, Settings.H)
    }):Play()
end)

local tobDrag = false
TOB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        tobDrag = true
        local start = i.Position
        local pos = TOB.Position
        local mc = UserInputService.InputChanged:Connect(function(j)
            if tobDrag and (j.UserInputType == Enum.UserInputType.MouseMovement or j.UserInputType == Enum.UserInputType.Touch) then
                local d = j.Position - start
                TOB.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
            end
        end)
        local uc = UserInputService.InputEnded:Connect(function(j)
            if j.UserInputType == Enum.UserInputType.MouseButton1 or j.UserInputType == Enum.UserInputType.Touch then
                tobDrag = false
                mc:Disconnect()
                uc:Disconnect()
            end
        end)
    end
end)

spawn(function()
    while SG.Parent do
        if TOB.Visible then
            TweenService:Create(TOBS, TweenInfo.new(0.7), {Color = T.Purple, Thickness = 3}):Play()
            TweenService:Create(TOGlow, TweenInfo.new(0.7), {ImageTransparency = 0.4}):Play()
            wait(0.7)
            TweenService:Create(TOBS, TweenInfo.new(0.7), {Color = T.Gold, Thickness = 2}):Play()
            TweenService:Create(TOGlow, TweenInfo.new(0.7), {ImageTransparency = 0.7}):Play()
            wait(0.7)
        else
            wait(0.3)
        end
    end
end)

-- TAB BAR
local TabBar = Instance.new("ScrollingFrame")
TabBar.Size = UDim2.new(1, -25, 0, 38)
TabBar.Position = UDim2.new(0, 12, 0, 50)
TabBar.BackgroundColor3 = T.Bg2
TabBar.BackgroundTransparency = 0.5
TabBar.BorderSizePixel = 0
TabBar.ScrollBarThickness = 0
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.ClipsDescendants = true
TabBar.ZIndex = 2
TabBar.Parent = MF
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 12)

local TBL = Instance.new("UIListLayout", TabBar)
TBL.FillDirection = Enum.FillDirection.Horizontal
TBL.SortOrder = Enum.SortOrder.LayoutOrder
TBL.Padding = UDim.new(0, 8)
TBL.VerticalAlignment = Enum.VerticalAlignment.Center

TBL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabBar.CanvasSize = UDim2.new(0, TBL.AbsoluteContentSize.X + 20, 0, 0)
end)

-- CONTENT AREA
local CA = Instance.new("Frame")
CA.Size = UDim2.new(1, -25, 1, -125)
CA.Position = UDim2.new(0, 12, 0, 92)
CA.BackgroundColor3 = T.Bg2
CA.BackgroundTransparency = 0.3
CA.BorderSizePixel = 0
CA.ClipsDescendants = true
CA.Parent = MF
Instance.new("UICorner", CA).CornerRadius = UDim.new(0, 16)

-- TAB SYSTEM
local Tabs = {}
local function CreateTab(name, icon)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 0, 1, 0)
    B.AutomaticSize = Enum.AutomaticSize.X
    B.BackgroundColor3 = T.Bg2
    B.BackgroundTransparency = 0.5
    B.Text = " " .. icon .. " " .. name .. " "
    B.TextColor3 = T.TextDim
    B.TextSize = Settings.TabSize
    B.Font = Enum.Font.GothamBold
    B.Parent = TabBar
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)

    local C = Instance.new("ScrollingFrame")
    C.Size = UDim2.new(1, -12, 1, -12)
    C.Position = UDim2.new(0, 6, 0, 6)
    C.BackgroundTransparency = 1
    C.ScrollBarThickness = Settings.ScrollW
    C.ScrollBarImageColor3 = T.Gold
    C.Visible = false
    C.CanvasSize = UDim2.new(0, 0, 0, 0)
    C.Parent = CA

    local CL = Instance.new("UIListLayout", C)
    CL.SortOrder = Enum.SortOrder.LayoutOrder
    CL.Padding = UDim.new(0, 6)
    CL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        C.CanvasSize = UDim2.new(0, 0, 0, CL.AbsoluteContentSize.Y + 16)
    end)

    Tabs[name] = {Button = B, Content = C}
    B.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {
                BackgroundColor3 = T.Bg2,
                BackgroundTransparency = 0.5,
                TextColor3 = T.TextDim
            }):Play()
        end
        C.Visible = true
        TweenService:Create(B, TweenInfo.new(0.15), {
            BackgroundColor3 = T.Gold,
            BackgroundTransparency = 0.15,
            TextColor3 = T.White
        }):Play()
    end)
    return C
end

-- ═══ UI HELPERS ═══

local function Sec(p, t)
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1, -8, 0, 26)
    S.BackgroundTransparency = 1
    S.Text = "✦ " .. t
    S.TextColor3 = T.Gold
    S.TextSize = 13
    S.Font = Enum.Font.GothamBold
    S.TextXAlignment = Enum.TextXAlignment.Left
    S.Parent = p
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -8, 0, 2)
    line.Position = UDim2.new(0, 4, 1, -2)
    line.BackgroundColor3 = T.Gold
    line.BorderSizePixel = 0
    line.Parent = S
end

local function Tog(p, t, d, cb)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 36)
    F.BackgroundColor3 = T.Bg2
    F.BackgroundTransparency = 0.4
    F.BorderSizePixel = 0
    F.Parent = p
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 14, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = t
    L.TextColor3 = T.Text
    L.TextSize = Settings.FontSize
    L.Font = Enum.Font.Gotham
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.TextTruncate = Enum.TextTruncate.AtEnd
    L.Parent = F

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 50, 0, 24)
    B.Position = UDim2.new(1, -54, 0.5, -12)
    B.BackgroundColor3 = d and T.On or T.Off
    B.Text = d and "ON" or "OFF"
    B.TextSize = 9
    B.Font = Enum.Font.GothamBold
    B.TextColor3 = d and T.White or T.TextDim
    B.Parent = F
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 12)

    local on = d
    B.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(B, TweenInfo.new(0.15), {BackgroundColor3 = on and T.On or T.Off}):Play()
        B.Text = on and "ON" or "OFF"
        B.TextColor3 = on and T.White or T.TextDim
        if cb then cb(on) end
    end)
    return function(v)
        on = v
        B.BackgroundColor3 = on and T.On or T.Off
        B.Text = on and "ON" or "OFF"
        B.TextColor3 = on and T.White or T.TextDim
    end
end

local function Sld(p, t, mn, mx, df, cb)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 50)
    F.BackgroundColor3 = T.Bg2
    F.BackgroundTransparency = 0.4
    F.BorderSizePixel = 0
    F.Parent = p
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 10)

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -56, 0, 18)
    L.Position = UDim2.new(0, 14, 0, 4)
    L.BackgroundTransparency = 1
    L.Text = t
    L.TextColor3 = T.Text
    L.TextSize = 11
    L.Font = Enum.Font.Gotham
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local V = Instance.new("TextLabel")
    V.Size = UDim2.new(0, 44, 0, 18)
    V.Position = UDim2.new(1, -48, 0, 4)
    V.BackgroundTransparency = 1
    V.Text = tostring(df)
    V.TextColor3 = T.Gold
    V.TextSize = 11
    V.Font = Enum.Font.GothamBold
    V.Parent = F

    local SB = Instance.new("Frame")
    SB.Size = UDim2.new(1, -28, 0, 6)
    SB.Position = UDim2.new(0, 14, 0, 30)
    SB.BackgroundColor3 = T.Off
    SB.BorderSizePixel = 0
    SB.Parent = F
    Instance.new("UICorner", SB).CornerRadius = UDim.new(1, 0)

    local SF = Instance.new("Frame")
    SF.Size = UDim2.new((df - mn) / (mx - mn), 0, 1, 0)
    SF.BackgroundColor3 = T.Gold
    SF.BorderSizePixel = 0
    SF.Parent = SB
    Instance.new("UICorner", SF).CornerRadius = UDim.new(1, 0)

    local dr = false
    SB.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dr = true
            local mc, uc
            mc = UserInputService.InputChanged:Connect(function(j)
                if j.UserInputType == Enum.UserInputType.MouseMove