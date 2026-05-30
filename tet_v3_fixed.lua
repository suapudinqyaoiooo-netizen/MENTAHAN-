--// Rilzz Hub - Inside Brainrot Heads

local Players          = game:GetService("Players")
local RS               = game:GetService("ReplicatedStorage")
local StarterGui       = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LP               = Players.LocalPlayer

local Character = LP.Character or LP.CharacterAdded:Wait()
local HRP       = Character:WaitForChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(char)
    Character = char
    HRP       = char:WaitForChild("HumanoidRootPart")
end)

local remContainer = RS
    :WaitForChild("packages")
    :WaitForChild("_Index")
    :WaitForChild("littensy_remo@1.5.3")
    :WaitForChild("remo")
    :WaitForChild("container")

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title    = title,
            Text     = text,
            Duration = duration or 3,
        })
    end)
end

local Library = loadstring(game:HttpGet("https://pastefy.app/TaC9quOO/raw"))()
-- =============================================
--  SCANNER GUI — Brainrot Radar (v3 · no-select)
-- =============================================
local scanGui = Instance.new("ScreenGui")
scanGui.Name = "RilzzScannerGui"
scanGui.ResetOnSpawn = false
scanGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
scanGui.Parent = LP.PlayerGui

local VARIANT_COLOR = {
    astral  = Color3.fromRGB(0,   220, 255),
    honey   = Color3.fromRGB(255, 200, 0  ),
    blazing = Color3.fromRGB(255, 110, 0  ),
    poison  = Color3.fromRGB(100, 220, 50 ),
    diamond = Color3.fromRGB(150, 220, 255),
    gold    = Color3.fromRGB(255, 215, 0  ),
    normal  = Color3.fromRGB(180, 180, 180),
}
local VARIANT_ICON = {
    astral  = "✦",
    honey   = "🍯",
    blazing = "🔥",
    poison  = "☠",
    diamond = "💎",
    gold    = "⭐",
    normal  = "●",
}
local VARIANT_LABEL = {
    astral  = "ASTRAL",
    honey   = "HONEY",
    blazing = "BLAZE",
    poison  = "POISON",
    diamond = "DIAM",
    gold    = "GOLD",
    normal  = "NORM",
}
-- Priority rank (untuk badge)
local VARIANT_RANK = {
    astral=6, honey=5, blazing=4, poison=3, diamond=2, gold=1, normal=0
}

-- State: hanya currentTweenPrompt (no pinned, no select)
local currentTweenPrompt = nil

-- ── MAIN FRAME ────────────────────────────────────────────────────
local RADAR_W, RADAR_H = 280, 360
local mainFrame = Instance.new("Frame")
mainFrame.Name = "RadarFrame"
mainFrame.Size = UDim2.fromOffset(RADAR_W, RADAR_H)
mainFrame.Position = UDim2.new(1, -(RADAR_W + 14), 0, 70)
mainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
mainFrame.BackgroundTransparency = 0.04
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = scanGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

-- Outer glow stroke
local outerStroke = Instance.new("UIStroke", mainFrame)
outerStroke.Color = Color3.fromRGB(50, 55, 120)
outerStroke.Thickness = 1.5

-- ── GRADIENT BG ───────────────────────────────────────────────────
local bgGrad = Instance.new("UIGradient", mainFrame)
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(10, 10, 22)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(6, 6, 12)),
})
bgGrad.Rotation = 135

-- ── TOP BAR ───────────────────────────────────────────────────────
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(12, 12, 26)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

-- Gradient topbar
local topGrad = Instance.new("UIGradient", topBar)
topGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 18, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 26)),
})
topGrad.Rotation = 90

-- Accent line bawah topbar
local accent = Instance.new("Frame", topBar)
accent.Size = UDim2.new(1, 0, 0, 2)
accent.Position = UDim2.new(0, 0, 1, -2)
accent.BackgroundColor3 = Color3.fromRGB(60, 80, 220)
accent.BorderSizePixel = 0
local accentGrad = Instance.new("UIGradient", accent)
accentGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(0, 180, 255)),
    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(80, 80, 220)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(160, 0, 255)),
})
accentGrad.Rotation = 0

-- Icon radar
local radarIcon = Instance.new("TextLabel", topBar)
radarIcon.Size = UDim2.fromOffset(30, 30)
radarIcon.Position = UDim2.new(0, 8, 0, 5)
radarIcon.BackgroundTransparency = 1
radarIcon.Text = "📡"
radarIcon.TextSize = 18
radarIcon.Font = Enum.Font.Gotham
radarIcon.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Title
local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(1, -110, 1, 0)
titleLbl.Position = UDim2.new(0, 44, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "BRAINROT RADAR"
titleLbl.TextColor3 = Color3.fromRGB(180, 190, 255)
titleLbl.TextSize = 13
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle kecil
local subLbl = Instance.new("TextLabel", topBar)
subLbl.Size = UDim2.new(1, -110, 0, 12)
subLbl.Position = UDim2.new(0, 44, 1, -14)
subLbl.BackgroundTransparency = 1
subLbl.Text = "AUTO PRIORITY"
subLbl.TextColor3 = Color3.fromRGB(80, 90, 160)
subLbl.TextSize = 9
subLbl.Font = Enum.Font.Gotham
subLbl.TextXAlignment = Enum.TextXAlignment.Left

-- Counter badge (top right — geser kiri sedikit buat kasih ruang minimize btn)
local counterBadge = Instance.new("Frame", topBar)
counterBadge.Size = UDim2.fromOffset(58, 22)
counterBadge.Position = UDim2.new(1, -128, 0.5, -11)
counterBadge.BackgroundColor3 = Color3.fromRGB(20, 22, 50)
counterBadge.BorderSizePixel = 0
Instance.new("UICorner", counterBadge).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", counterBadge).Color = Color3.fromRGB(40, 45, 100)

local counterLbl = Instance.new("TextLabel", counterBadge)
counterLbl.Size = UDim2.new(1, 0, 1, 0)
counterLbl.BackgroundTransparency = 1
counterLbl.Text = "0 found"
counterLbl.TextColor3 = Color3.fromRGB(100, 120, 200)
counterLbl.TextSize = 10
counterLbl.Font = Enum.Font.GothamBold

-- Minimize button (pojok kanan topbar)
local minimizeBtn = Instance.new("TextButton", topBar)
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.fromOffset(56, 22)
minimizeBtn.Position = UDim2.new(1, -62, 0.5, -11)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 40)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "▼ MIN"
minimizeBtn.TextColor3 = Color3.fromRGB(120, 130, 200)
minimizeBtn.TextSize = 10
minimizeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)
local minStroke = Instance.new("UIStroke", minimizeBtn)
minStroke.Color = Color3.fromRGB(50, 55, 120)
minStroke.Thickness = 1

-- ── STATUS BAR ────────────────────────────────────────────────────
local statusBar = Instance.new("Frame", mainFrame)
statusBar.Size = UDim2.new(1, -16, 0, 24)
statusBar.Position = UDim2.new(0, 8, 0, 44)
statusBar.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
statusBar.BorderSizePixel = 0
Instance.new("UICorner", statusBar).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", statusBar).Color = Color3.fromRGB(30, 35, 75)

local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size = UDim2.new(1, -10, 1, 0)
statusLbl.Position = UDim2.new(0, 8, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "● Scanning..."
statusLbl.TextColor3 = Color3.fromRGB(80, 220, 120)
statusLbl.TextSize = 11
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.RichText = true

-- ── SCROLL AREA ───────────────────────────────────────────────────
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1, -10, 1, -76)
scrollFrame.Position = UDim2.new(0, 5, 0, 73)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 70, 160)
scrollFrame.CanvasSize = UDim2.fromOffset(0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 5)
local listPad = Instance.new("UIPadding", scrollFrame)
listPad.PaddingTop = UDim.new(0, 2)
listPad.PaddingBottom = UDim.new(0, 4)

-- ── HELPER: buat card ─────────────────────────────────────────────
local function makeCard(parent)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -4, 0, 58)
    card.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local cs = Instance.new("UIStroke", card)
    cs.Color = Color3.fromRGB(35, 38, 65)
    cs.Thickness = 1

    -- Left glow bar
    local bar = Instance.new("Frame", card)
    bar.Name = "ColorBar"
    bar.Size = UDim2.new(0, 4, 1, -10)
    bar.Position = UDim2.new(0, 5, 0, 5)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

    -- Icon circle
    local iconCircle = Instance.new("Frame", card)
    iconCircle.Name = "IconCircle"
    iconCircle.Size = UDim2.fromOffset(32, 32)
    iconCircle.Position = UDim2.new(0, 16, 0, 13)
    iconCircle.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
    iconCircle.BorderSizePixel = 0
    Instance.new("UICorner", iconCircle).CornerRadius = UDim.new(0, 8)
    local icStroke = Instance.new("UIStroke", iconCircle)
    icStroke.Color = Color3.fromRGB(40, 45, 80)
    icStroke.Thickness = 1

    local icon = Instance.new("TextLabel", iconCircle)
    icon.Name = "Icon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "●"
    icon.TextSize = 16
    icon.Font = Enum.Font.GothamBold
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Nama brainrot
    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.Name = "NameLbl"
    nameLbl.Size = UDim2.new(1, -130, 0, 18)
    nameLbl.Position = UDim2.new(0, 55, 0, 7)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = "BrainrotName"
    nameLbl.TextColor3 = Color3.fromRGB(220, 225, 255)
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    -- Row bawah: variant badge + dist + priority
    local rowFrame = Instance.new("Frame", card)
    rowFrame.Name = "RowFrame"
    rowFrame.Size = UDim2.new(1, -58, 0, 18)
    rowFrame.Position = UDim2.new(0, 55, 0, 30)
    rowFrame.BackgroundTransparency = 1
    local rowList = Instance.new("UIListLayout", rowFrame)
    rowList.FillDirection = Enum.FillDirection.Horizontal
    rowList.Padding = UDim.new(0, 5)
    rowList.VerticalAlignment = Enum.VerticalAlignment.Center

    -- Variant badge
    local varLbl = Instance.new("TextLabel", rowFrame)
    varLbl.Name = "Variant"
    varLbl.Size = UDim2.fromOffset(50, 16)
    varLbl.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
    varLbl.BorderSizePixel = 0
    varLbl.Text = "NORM"
    varLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    varLbl.TextSize = 9
    varLbl.Font = Enum.Font.GothamBold
    Instance.new("UICorner", varLbl).CornerRadius = UDim.new(0, 5)

    -- Jarak badge
    local distLbl = Instance.new("TextLabel", rowFrame)
    distLbl.Name = "Dist"
    distLbl.Size = UDim2.fromOffset(40, 16)
    distLbl.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    distLbl.BorderSizePixel = 0
    distLbl.Text = "0m"
    distLbl.TextColor3 = Color3.fromRGB(120, 130, 180)
    distLbl.TextSize = 9
    distLbl.Font = Enum.Font.GothamBold
    Instance.new("UICorner", distLbl).CornerRadius = UDim.new(0, 5)

    -- Status indicator (kanan card) — "TARGET" kalau di-tween, "AUTO" kalau top priority biasa
    local statusBadge = Instance.new("TextLabel", card)
    statusBadge.Name = "StatusBadge"
    statusBadge.Size = UDim2.fromOffset(54, 38)
    statusBadge.Position = UDim2.new(1, -60, 0.5, -19)
    statusBadge.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
    statusBadge.BorderSizePixel = 0
    statusBadge.Text = ""
    statusBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusBadge.TextSize = 9
    statusBadge.Font = Enum.Font.GothamBold
    statusBadge.TextWrapped = true
    Instance.new("UICorner", statusBadge).CornerRadius = UDim.new(0, 8)
    local sbStroke = Instance.new("UIStroke", statusBadge)
    sbStroke.Color = Color3.fromRGB(40, 40, 80)
    sbStroke.Thickness = 1

    return card
end

-- Pool card
local cardPool = {}
local function getCard()
    local c = table.remove(cardPool)
    if not c then c = makeCard(scrollFrame) end
    c.Parent = scrollFrame
    c.Visible = true
    return c
end
local function recycleCard(c)
    c.Visible = false
    c.Parent = nil
    table.insert(cardPool, c)
end

local activeCards = {}

-- ── UPDATE RADAR ──────────────────────────────────────────────────
local function updateRadar()
    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local MUT_PRI = {astral=6,honey=5,blazing=4,poison=3,diamond=2,gold=1}

    local BASE_POS_LOCAL = Vector3.new(-34.5, 33.5, -297.1)
    local atBase = not hrp or (hrp.Position - BASE_POS_LOCAL).Magnitude < 150
    if atBase then
        statusLbl.Text = '<font color="#FF8855">⚠ Go Nest — Fast</font>'
        counterLbl.Text = "—"
        for _, c in ipairs(activeCards) do recycleCard(c) end
        activeCards = {}
        return
    end

    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        local isPrompt = false
        pcall(function() isPrompt = obj:IsA("ProximityPrompt") end)
        if isPrompt then
            local action = ""
            pcall(function() action = obj.ActionText:lower() end)
            if action == "grab" then
                local att = obj.Parent
                local model = att and att.Parent
                if model then
                    local variant, brainrotName, pos = "", "", nil
                    pcall(function()
                        variant = tostring(model:GetAttribute("variant") or "")
                        local n = model:GetAttribute("name")
                        brainrotName = n and tostring(n) or model.Name
                    end)
                    pcall(function()
                        local p = model:IsA("Model")
                            and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"))
                            or (model:IsA("BasePart") and model or nil)
                        if p then pos = p.Position end
                    end)
                    if variant ~= "" and pos then
                        local dist = hrp and math.floor((pos - hrp.Position).Magnitude) or 0
                        if dist <= 75 then
                            local v = variant:lower()
                            table.insert(found, {
                                name     = brainrotName,
                                variant  = v,
                                dist     = dist,
                                priority = MUT_PRI[v] or 0,
                                prompt   = obj,
                            })
                        end
                    end
                end
            end
        end
    end

    table.sort(found, function(a, b)
        if a.priority ~= b.priority then return a.priority > b.priority end
        return a.dist < b.dist
    end)

    counterLbl.Text = #found .. " found"

    for _, c in ipairs(activeCards) do recycleCard(c) end
    activeCards = {}

    if #found == 0 then
        statusLbl.Text = '<font color="#556688">● Tidak ada brainrot di 75m</font>'
        return
    end

    -- Status bar text
    if currentTweenPrompt then
        statusLbl.Text = '<font color="#FF6060">🎯 Menuju target...</font>'
    else
        statusLbl.Text = '<font color="#44EE88">▲ Auto-priority aktif</font>'
    end

    for i = 1, math.min(#found, 10) do
        local item   = found[i]
        local col    = VARIANT_COLOR[item.variant] or VARIANT_COLOR.normal
        local icon   = VARIANT_ICON[item.variant] or "●"
        local vLabel = VARIANT_LABEL[item.variant] or "NORM"
        local isTweening = (currentTweenPrompt ~= nil and item.prompt == currentTweenPrompt)
        local isTop  = (i == 1 and not isTweening and currentTweenPrompt == nil)

        local card = getCard()
        table.insert(activeCards, card)

        -- Color bar
        card.ColorBar.BackgroundColor3 = col

        -- Card styling
        local cs = card:FindFirstChildOfClass("UIStroke")
        if isTweening then
            -- Merah berkedip — target aktif sedang di-tween
            card.BackgroundColor3 = Color3.fromRGB(28, 8, 8)
            if cs then
                cs.Color = Color3.fromRGB(220, 50, 50)
                cs.Thickness = 1.5
            end
        elseif isTop then
            -- Hijau soft — next auto target
            card.BackgroundColor3 = Color3.fromRGB(8, 22, 14)
            if cs then
                cs.Color = Color3.fromRGB(40, 160, 80)
                cs.Thickness = 1.2
            end
        else
            card.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
            if cs then
                cs.Color = Color3.fromRGB(35, 38, 65)
                cs.Thickness = 1
            end
        end

        -- Icon circle
        local iconCircle = card:FindFirstChild("IconCircle")
        if iconCircle then
            iconCircle.BackgroundColor3 = Color3.fromRGB(
                math.clamp(math.floor(col.R * 255 * 0.12), 0, 255),
                math.clamp(math.floor(col.G * 255 * 0.12), 0, 255),
                math.clamp(math.floor(col.B * 255 * 0.12), 0, 255)
            )
            local icStroke = iconCircle:FindFirstChildOfClass("UIStroke")
            if icStroke then icStroke.Color = col end
            local iconLbl = iconCircle:FindFirstChild("Icon")
            if iconLbl then
                iconLbl.Text = icon
                iconLbl.TextColor3 = col
            end
        end

        -- Nama
        card.NameLbl.Text = item.name
        card.NameLbl.TextColor3 = isTweening
            and Color3.fromRGB(255, 180, 180)
            or  (isTop and Color3.fromRGB(200, 255, 220) or Color3.fromRGB(220, 225, 255))

        -- Variant badge
        local rowFrame = card:FindFirstChild("RowFrame")
        if rowFrame then
            local varLbl = rowFrame:FindFirstChild("Variant")
            if varLbl then
                varLbl.Text = " " .. vLabel .. " "
                varLbl.TextColor3 = col
                varLbl.BackgroundColor3 = Color3.fromRGB(
                    math.clamp(math.floor(col.R * 255 * 0.12), 0, 255),
                    math.clamp(math.floor(col.G * 255 * 0.12), 0, 255),
                    math.clamp(math.floor(col.B * 255 * 0.12), 0, 255)
                )
            end
            local distLbl = rowFrame:FindFirstChild("Dist")
            if distLbl then
                distLbl.Text = " " .. item.dist .. "m "
                distLbl.TextColor3 = item.dist < 20
                    and Color3.fromRGB(80, 255, 140)
                    or  Color3.fromRGB(100, 110, 170)
                distLbl.BackgroundColor3 = item.dist < 20
                    and Color3.fromRGB(10, 35, 18)
                    or  Color3.fromRGB(15, 15, 30)
            end
        end

        -- Status badge kanan
        local sb = card:FindFirstChild("StatusBadge")
        if sb then
            local sbStroke = sb:FindFirstChildOfClass("UIStroke")
            if isTweening then
                sb.Text = "🎯\nTARGET"
                sb.TextColor3 = Color3.fromRGB(255, 100, 100)
                sb.BackgroundColor3 = Color3.fromRGB(35, 8, 8)
                if sbStroke then sbStroke.Color = Color3.fromRGB(180, 40, 40) end
            elseif isTop then
                sb.Text = "▲\nNEXT"
                sb.TextColor3 = Color3.fromRGB(80, 255, 140)
                sb.BackgroundColor3 = Color3.fromRGB(8, 28, 16)
                if sbStroke then sbStroke.Color = Color3.fromRGB(40, 160, 80) end
            else
                -- Tampilkan rank priority
                local rank = item.priority
                local rankStr = rank > 0 and ("P" .. rank) or "—"
                sb.Text = rankStr
                sb.TextColor3 = col
                sb.BackgroundColor3 = Color3.fromRGB(14, 14, 28)
                if sbStroke then sbStroke.Color = Color3.fromRGB(35, 38, 65) end
            end
        end
    end
end

-- ── MINIMIZE / MAXIMIZE LOGIC ─────────────────────────────────────
local isMinimized = false

local function setMinimized(v)
    isMinimized = v
    if v then
        -- Minimize: kecilkan frame jadi cuma topbar
        TweenService:Create(mainFrame,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.fromOffset(RADAR_W, 40) }
        ):Play()
        statusBar.Visible  = false
        scrollFrame.Visible = false
        minimizeBtn.Text = "▲ MAX"
        minimizeBtn.TextColor3 = Color3.fromRGB(80, 200, 130)
        minStroke.Color = Color3.fromRGB(40, 130, 80)
    else
        -- Maximize: balik ke ukuran penuh
        TweenService:Create(mainFrame,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.fromOffset(RADAR_W, RADAR_H) }
        ):Play()
        statusBar.Visible  = true
        scrollFrame.Visible = true
        minimizeBtn.Text = "▼ MIN"
        minimizeBtn.TextColor3 = Color3.fromRGB(120, 130, 200)
        minStroke.Color = Color3.fromRGB(50, 55, 120)
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(not isMinimized)
end)

-- Loop update tiap 0.2 detik (lebih responsif)
task.spawn(function()
    while true do
        pcall(updateRadar)
        task.wait(0.2)
    end
end)








local isMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
local windowSize = isMobile and UDim2.fromOffset(528, 334) or UDim2.fromOffset(580, 350)

local Window = Library:CreateWindow({
    ["Title"]              = "Rilzz Hub",
    ["Icon"]               = "crown",
    ["Author"]             = "Inside Brainrot Head",
    ["Folder"]             = "RilzzHub",
    ["Size"]               = windowSize,
    ["LiveSearchDropdown"] = true,
    ["FileSaveName"]       = "RilzzHub/Config.json",
})

local TabMain   = Window:Tab({ ["Title"] = "Main",     ["Icon"] = "house" })
local TabMainV2 = Window:Tab({ ["Title"] = "Main V2",  ["Icon"] = "zap" })
local TabTP     = Window:Tab({ ["Title"] = "Teleport", ["Icon"] = "map-pin" })

local nests = {
    {"Meowl",              "meowl"},
    {"Eleccobee",          "eleccoBee"},
    {"Lava Golem",         "lavaGolem"},
    {"Frogio Blingo",      "frogioBlingo"},
    {"Dragon Cannelloni",  "dragonCannelloni"},
    {"Job Sahur",          "jobJobJobSahur"},
    {"Strawberry",         "strewberry"},
    {"Yellow Lucky Block", "yellowLuckyBlock"},
    {"Karkar Kurkur",      "karkarKurkurkur"},
    {"Esok Sekolah",       "esokSekolah"},
    {"Brainrot 67",        "brainrot67"},
    {"Noob",               "noob"},
}

local resetPos   = Vector3.new(-34.5, 33.5, -297.1)
local BASE_POS   = Vector3.new(-34.5, 33.5, -297.1)
local SCAN_RADIUS = 75

-- Bounding box tiap nest (X dan Z) untuk validasi posisi
local NEST_BOUNDS = {
    meowl            = { xMin=773.6, xMax=896.6, zMin=-354.5,  zMax=-248.4  },
    eleccoBee        = { xMin=530.7, xMax=636.5, zMin=-1029.1, zMax=-906.0  },
    lavaGolem        = { xMin=373.9, xMax=480.0, zMin=338.5,   zMax=461.7   },
    frogioBlingo     = { xMin=371.5, xMax=477.7, zMin=-1185.4, zMax=-1062.6 },
    dragonCannelloni = { xMin=339.6, xMax=445.5, zMin=203.5,   zMax=325.8   },
    jobJobJobSahur   = { xMin=264.7, xMax=369.9, zMin=-1028.7, zMax=-906.3  },
    strewberry       = { xMin=164.1, xMax=269.7, zMin=192.3,   zMax=314.8   },
    yellowLuckyBlock = { xMin=169.0, xMax=274.8, zMin=-1028.9, zMax=-906.4  },
    karkarKurkurkur  = { xMin=70.5,  xMax=176.2, zMin=172.8,   zMax=295.7   },
    esokSekolah      = { xMin=68.6,  xMax=174.6, zMin=-1026.3, zMax=-903.1  },
    brainrot67       = { xMin=-55.0, xMax=51.1,  zMin=191.6,   zMax=314.7   },
    noob             = { xMin=-27.4, xMax=78.9,  zMin=-1028.9, zMax=-905.7  },
}

-- Cek apakah HRP ada di dalam bounding box nest tertentu
local function isInNest(nestId)
    if not HRP then return false end
    local b = NEST_BOUNDS[nestId]
    if not b then return not isAtBase() end
    local p = HRP.Position
    return p.X >= b.xMin and p.X <= b.xMax
       and p.Z >= b.zMin and p.Z <= b.zMax
end

-- V2: nest yang dipilih manual oleh user (default = nest pertama)
local selectedNestId   = nests[1][2]
local selectedNestName = nests[1][1]

-- Lookup reward langsung by "name|variant" → reward (518 entries)
local BRAINROT_SCORE = {}
do
    local list = {
        {"rengRongo","poison",500000000000},{"rengRongo","diamond",425000000000},{"rengRongo","astral",200000000000},{"rengRongo","honey",175000000000},{"rengRongo","blazing",160000000000},{"rengRongo","gold",150000000000},{"rengRongo","normal",100000000000},
        {"kingFalken","astral",375000000000},{"kingFalken","gold",375000000000},{"kingFalken","honey",325000000000},{"kingFalken","diamond",318750000000},{"kingFalken","blazing",300000000000},{"kingFalken","poison",250000000000},{"kingFalken","normal",250000000000},
        {"vulture","blazing",360000000000},{"vulture","astral",300000000000},{"vulture","poison",300000000000},{"vulture","honey",270000000000},{"vulture","diamond",255000000000},{"vulture","gold",90000000000},{"vulture","normal",60000000000},
        {"pineaplino","astral",320000000000},{"pineaplino","honey",280000000000},{"pineaplino","blazing",240000000000},{"pineaplino","poison",200000000000},{"pineaplino","diamond",170000000000},{"pineaplino","gold",60000000000},{"pineaplino","normal",40000000000},
        {"neonMeowl","astral",280000000000},{"neonMeowl","honey",245000000000},{"neonMeowl","blazing",210000000000},{"neonMeowl","poison",175000000000},{"neonMeowl","diamond",148750000000},{"neonMeowl","gold",52500000000},{"neonMeowl","normal",35000000000},
        {"lordoRobo","astral",260000000000},{"lordoRobo","honey",227500000000},{"lordoRobo","blazing",195000000000},{"lordoRobo","poison",195000000000},{"lordoRobo","gold",195000000000},{"lordoRobo","diamond",175750000000},{"lordoRobo","normal",130000000000},
        {"jobJobDiablo","astral",240000000000},{"jobJobDiablo","honey",210000000000},{"jobJobDiablo","blazing",180000000000},{"jobJobDiablo","poison",150000000000},{"jobJobDiablo","diamond",127500000000},{"jobJobDiablo","gold",45000000000},{"jobJobDiablo","normal",30000000000},
        {"crocoBling","astral",176000000000},{"crocoBling","honey",154000000000},{"crocoBling","blazing",132000000000},{"crocoBling","poison",110000000000},{"crocoBling","diamond",93500000000},{"crocoBling","gold",33000000000},{"crocoBling","normal",22000000000},
        {"eleccoBee","astral",160000000000},{"eleccoBee","honey",140000000000},{"eleccoBee","blazing",120000000000},{"eleccoBee","poison",100000000000},{"eleccoBee","diamond",85000000000},{"eleccoBee","gold",30000000000},{"eleccoBee","normal",20000000000},
        {"tralalaTralalita","astral",60000000000},{"tralalaTralalita","honey",52500000000},{"tralalaTralalita","blazing",45000000000},{"tralalaTralalita","poison",37500000000},{"tralalaTralalita","diamond",31875000000},{"tralalaTralalita","gold",11250000000},{"tralalaTralalita","normal",7500000000},
        {"tractoDino","astral",56000000000},{"tractoDino","honey",49000000000},{"tractoDino","blazing",42000000000},{"tractoDino","poison",35000000000},{"tractoDino","diamond",29750000000},{"tractoDino","gold",10500000000},{"tractoDino","normal",7000000000},
        {"fireDragon","astral",40000000000},{"fireDragon","honey",35000000000},{"fireDragon","blazing",30000000000},{"fireDragon","poison",25000000000},{"fireDragon","diamond",21250000000},{"fireDragon","gold",7500000000},{"fireDragon","normal",5000000000},
        {"fireMedusa","astral",24000000000},{"fireMedusa","honey",21000000000},{"fireMedusa","blazing",18000000000},{"fireMedusa","poison",15000000000},{"fireMedusa","diamond",12750000000},{"fireMedusa","gold",4500000000},{"fireMedusa","normal",3000000000},
        {"fireCappuccino","astral",16000000000},{"fireCappuccino","honey",14000000000},{"fireCappuccino","blazing",12000000000},{"fireCappuccino","poison",10000000000},{"fireCappuccino","diamond",8500000000},{"fireCappuccino","gold",3000000000},{"fireCappuccino","normal",2000000000},
        {"sadoBananito","astral",8000000000},{"sadoBananito","honey",7000000000},{"sadoBananito","blazing",6000000000},{"sadoBananito","poison",5000000000},{"sadoBananito","diamond",4250000000},{"sadoBananito","gold",1500000000},{"sadoBananito","normal",1000000000},
        {"grappeminoDojo","astral",6000000000},{"grappeminoDojo","honey",5250000000},{"grappeminoDojo","blazing",4500000000},{"grappeminoDojo","poison",3750000000},{"grappeminoDojo","diamond",3187500000},{"grappeminoDojo","gold",1125000000},{"grappeminoDojo","normal",750000000},
        {"techDimon","astral",3700000000},{"techDimon","honey",3237500000},{"techDimon","blazing",2775000000},{"techDimon","poison",2312500000},{"techDimon","diamond",1965625000},{"techDimon","gold",693750000},{"techDimon","normal",462500000},
        {"techScorpio","astral",1400000000},{"techScorpio","honey",1225000000},{"techScorpio","blazing",1050000000},{"techScorpio","poison",875000000},{"techScorpio","diamond",743750000},{"techScorpio","gold",262500000},{"techScorpio","normal",175000000},
        {"sadoSkeletono","astral",800000000},{"sadoSkeletono","honey",700000000},{"sadoSkeletono","blazing",600000000},{"sadoSkeletono","poison",500000000},{"sadoSkeletono","diamond",425000000},{"sadoSkeletono","gold",150000000},{"sadoSkeletono","normal",100000000},
        {"grappellinoDoro","astral",720000000},{"grappellinoDoro","honey",630000000},{"grappellinoDoro","blazing",540000000},{"grappellinoDoro","poison",450000000},{"grappellinoDoro","diamond",382500000},{"grappellinoDoro","gold",135000000},{"grappellinoDoro","normal",90000000},
        {"strawberryElephant","astral",616000000},{"strawberryElephant","honey",539000000},{"strawberryElephant","blazing",462000000},{"strawberryElephant","poison",385000000},{"strawberryElephant","diamond",327250000},{"strawberryElephant","gold",115500000},{"strawberryElephant","normal",77000000},
        {"dinDinValluero","astral",512000000},{"dinDinValluero","honey",448000000},{"dinDinValluero","blazing",384000000},{"dinDinValluero","poison",320000000},{"dinDinValluero","diamond",272000000},{"dinDinValluero","gold",96000000},{"dinDinValluero","normal",64000000},
        {"martinoGravitino","astral",408000000},{"martinoGravitino","honey",357000000},{"martinoGravitino","blazing",306000000},{"martinoGravitino","poison",255000000},{"martinoGravitino","diamond",216750000},{"martinoGravitino","gold",76500000},{"martinoGravitino","normal",51000000},
        {"stoupoTraffico","astral",360000000},{"stoupoTraffico","honey",315000000},{"stoupoTraffico","blazing",270000000},{"stoupoTraffico","poison",225000000},{"stoupoTraffico","diamond",191250000},{"stoupoTraffico","gold",67500000},{"stoupoTraffico","normal",45000000},
        {"cupitronUFO","astral",304000000},{"cupitronUFO","honey",266000000},{"cupitronUFO","blazing",228000000},{"cupitronUFO","poison",190000000},{"cupitronUFO","diamond",161500000},{"cupitronUFO","gold",57000000},{"cupitronUFO","normal",38000000},
        {"galactioFantasma","astral",200000000},{"galactioFantasma","honey",175000000},{"galactioFantasma","blazing",150000000},{"galactioFantasma","poison",125000000},{"galactioFantasma","diamond",106250000},{"galactioFantasma","gold",37500000},{"galactioFantasma","normal",25000000},
        {"udinDinDun","astral",104000000},{"udinDinDun","honey",91000000},{"udinDinDun","blazing",78000000},{"udinDinDun","poison",65000000},{"udinDinDun","diamond",55250000},{"udinDinDun","gold",19500000},{"udinDinDun","normal",13000000},
        {"rubickPlanet","astral",88000000},{"rubickPlanet","honey",77000000},{"rubickPlanet","blazing",66000000},{"rubickPlanet","poison",55000000},{"rubickPlanet","diamond",46750000},{"rubickPlanet","gold",16500000},{"rubickPlanet","normal",11000000},
        {"potatoRider","astral",76000000},{"potatoRider","honey",66500000},{"potatoRider","blazing",57000000},{"potatoRider","poison",47500000},{"potatoRider","diamond",40375000},{"potatoRider","gold",14250000},{"potatoRider","normal",9500000},
        {"dugdug","astral",64000000},{"dugdug","honey",56000000},{"dugdug","blazing",48000000},{"dugdug","poison",40000000},{"dugdug","diamond",34000000},{"dugdug","gold",12000000},{"dugdug","normal",8000000},
        {"frogzoSoda","astral",56000000},{"frogzoSoda","honey",49000000},{"frogzoSoda","blazing",42000000},{"frogzoSoda","poison",35000000},{"frogzoSoda","diamond",29750000},{"frogzoSoda","gold",10500000},{"frogzoSoda","normal",7000000},
        {"wOrL","astral",52000000},{"wOrL","honey",45500000},{"wOrL","blazing",39000000},{"wOrL","poison",32500000},{"wOrL","diamond",27625000},{"wOrL","gold",9750000},{"wOrL","normal",6500000},
        {"glacierelloInfernitti","astral",40000000},{"glacierelloInfernitti","honey",35000000},{"glacierelloInfernitti","blazing",30000000},{"glacierelloInfernitti","poison",25000000},{"glacierelloInfernitti","diamond",21250000},{"glacierelloInfernitti","gold",7500000},{"glacierelloInfernitti","normal",5000000},
        {"crostinaGelifio","astral",37600000},{"crostinaGelifio","honey",32900000},{"crostinaGelifio","blazing",28200000},{"crostinaGelifio","poison",23500000},{"crostinaGelifio","diamond",19975000},{"crostinaGelifio","gold",7050000},{"crostinaGelifio","normal",4700000},
        {"rubichettoCubini","astral",35200000},{"rubichettoCubini","honey",30800000},{"rubichettoCubini","blazing",26400000},{"rubichettoCubini","poison",22000000},{"rubichettoCubini","diamond",18700000},{"rubichettoCubini","gold",6600000},{"rubichettoCubini","normal",4400000},
        {"meowl","astral",32000000},{"meowl","honey",28000000},{"meowl","blazing",24000000},{"meowl","poison",20000000},{"meowl","diamond",17000000},{"meowl","gold",6000000},{"meowl","normal",4000000},
        {"los67","astral",25920000},{"los67","honey",22680000},{"los67","blazing",19440000},{"los67","poison",16200000},{"los67","diamond",13770000},{"los67","gold",4860000},{"los67","normal",3240000},
        {"trubobuzzoFrazzolopoulos","astral",19840000},{"trubobuzzoFrazzolopoulos","honey",17360000},{"trubobuzzoFrazzolopoulos","blazing",14880000},{"trubobuzzoFrazzolopoulos","poison",12400000},{"trubobuzzoFrazzolopoulos","diamond",10540000},{"trubobuzzoFrazzolopoulos","gold",3720000},{"trubobuzzoFrazzolopoulos","normal",2480000},
        {"tralaleroTralala","astral",13760000},{"tralaleroTralala","honey",12040000},{"tralaleroTralala","blazing",10320000},{"tralaleroTralala","poison",8600000},{"tralaleroTralala","diamond",7310000},{"tralaleroTralala","gold",2580000},{"tralaleroTralala","normal",1720000},
        {"strawberelliFlamingelli","astral",7680000},{"strawberelliFlamingelli","honey",6720000},{"strawberelliFlamingelli","blazing",5760000},{"strawberelliFlamingelli","poison",4800000},{"strawberelliFlamingelli","diamond",4080000},{"strawberelliFlamingelli","gold",1440000},{"strawberelliFlamingelli","normal",960000},
        {"pinkMedussi","astral",4800000},{"pinkMedussi","honey",4200000},{"pinkMedussi","blazing",3600000},{"pinkMedussi","poison",3000000},{"pinkMedussi","diamond",2550000},{"pinkMedussi","gold",900000},{"pinkMedussi","normal",600000},
        {"bombardinoCrocodilo","astral",1600000},{"bombardinoCrocodilo","honey",1400000},{"bombardinoCrocodilo","blazing",1200000},{"bombardinoCrocodilo","poison",1000000},{"bombardinoCrocodilo","diamond",850000},{"bombardinoCrocodilo","gold",300000},{"bombardinoCrocodilo","normal",200000},
        {"dragonCannelloni","astral",1200000},{"dragonCannelloni","honey",1050000},{"dragonCannelloni","blazing",900000},{"dragonCannelloni","poison",750000},{"dragonCannelloni","diamond",637500},{"dragonCannelloni","gold",225000},{"dragonCannelloni","normal",150000},
        {"blueElephant","astral",940000},{"blueElephant","honey",822500},{"blueElephant","blazing",705000},{"blueElephant","poison",587500},{"blueElephant","diamond",499375},{"blueElephant","gold",176250},{"blueElephant","normal",117500},
        {"headlessHorse","astral",680000},{"headlessHorse","honey",595000},{"headlessHorse","blazing",510000},{"headlessHorse","diamond",499375},{"headlessHorse","poison",425000},{"headlessHorse","gold",127500},{"headlessHorse","normal",85000},
        {"spookyCombinasion","astral",420000},{"spookyCombinasion","honey",367500},{"spookyCombinasion","blazing",315000},{"spookyCombinasion","poison",262500},{"spookyCombinasion","diamond",223125},{"spookyCombinasion","gold",78750},{"spookyCombinasion","normal",52500},
        {"laCasaBoo","astral",296000},{"laCasaBoo","honey",259000},{"laCasaBoo","blazing",222000},{"laCasaBoo","poison",185000},{"laCasaBoo","diamond",157250},{"laCasaBoo","gold",55500},{"laCasaBoo","normal",37000},
        {"brainrot76","astral",176000},{"brainrot76","honey",154000},{"brainrot76","blazing",132000},{"brainrot76","poison",110000},{"brainrot76","diamond",93500},{"brainrot76","gold",33000},{"brainrot76","normal",22000},
        {"cappuccinoAssassino","astral",144000},{"cappuccinoAssassino","honey",126000},{"cappuccinoAssassino","blazing",108000},{"cappuccinoAssassino","poison",90000},{"cappuccinoAssassino","diamond",76500},{"cappuccinoAssassino","gold",27000},{"cappuccinoAssassino","normal",18000},
        {"ballerinaCappuccina","astral",112000},{"ballerinaCappuccina","honey",98000},{"ballerinaCappuccina","blazing",84000},{"ballerinaCappuccina","poison",70000},{"ballerinaCappuccina","diamond",59500},{"ballerinaCappuccina","gold",21000},{"ballerinaCappuccina","normal",14000},
        {"brainrot69","astral",80000},{"brainrot69","honey",70000},{"brainrot69","blazing",60000},{"brainrot69","poison",50000},{"brainrot69","diamond",42500},{"brainrot69","gold",15000},{"brainrot69","normal",10000},
        {"liriliLarila","astral",48000},{"liriliLarila","honey",42000},{"liriliLarila","blazing",36000},{"liriliLarila","poison",30000},{"liriliLarila","diamond",25500},{"liriliLarila","gold",9000},{"liriliLarila","normal",6000},
        {"brainrot67","astral",36000},{"brainrot67","honey",31500},{"brainrot67","blazing",27000},{"brainrot67","poison",22500},{"brainrot67","diamond",19125},{"brainrot67","gold",6750},{"brainrot67","normal",4500},
        {"trippiTroppi","astral",29400},{"trippiTroppi","honey",25725},{"trippiTroppi","blazing",22050},{"trippiTroppi","poison",18375},{"trippiTroppi","diamond",15619},{"trippiTroppi","gold",5513},{"trippiTroppi","normal",3675},
        {"avocadiniGuffo","astral",22800},{"avocadiniGuffo","honey",19950},{"avocadiniGuffo","blazing",17100},{"avocadiniGuffo","poison",14250},{"avocadiniGuffo","diamond",12113},{"avocadiniGuffo","gold",4275},{"avocadiniGuffo","normal",2850},
        {"cactoHipopotamo","astral",16200},{"cactoHipopotamo","honey",14175},{"cactoHipopotamo","blazing",12150},{"cactoHipopotamo","poison",10125},{"cactoHipopotamo","diamond",8607},{"cactoHipopotamo","gold",3038},{"cactoHipopotamo","normal",2025},
        {"banditoBobritto","astral",9600},{"banditoBobritto","honey",8400},{"banditoBobritto","blazing",7200},{"banditoBobritto","poison",6000},{"banditoBobritto","diamond",5100},{"banditoBobritto","gold",1800},{"banditoBobritto","normal",1200},
        {"tungTungTungSahur","astral",8000},{"tungTungTungSahur","honey",7000},{"tungTungTungSahur","blazing",6000},{"tungTungTungSahur","poison",5000},{"tungTungTungSahur","diamond",4250},{"tungTungTungSahur","gold",1500},{"tungTungTungSahur","normal",1000},
        {"brrBrrPatapim","astral",6400},{"brrBrrPatapim","honey",5600},{"brrBrrPatapim","blazing",4800},{"brrBrrPatapim","poison",4000},{"brrBrrPatapim","diamond",3400},{"brrBrrPatapim","gold",1200},{"brrBrrPatapim","normal",800},
        {"foxitaAnanasita","astral",4800},{"foxitaAnanasita","honey",4200},{"foxitaAnanasita","blazing",3600},{"foxitaAnanasita","poison",3000},{"foxitaAnanasita","diamond",2550},{"foxitaAnanasita","gold",900},{"foxitaAnanasita","normal",600},
        {"blueberriniOctopusini","astral",3200},{"blueberriniOctopusini","honey",2800},{"blueberriniOctopusini","blazing",2400},{"blueberriniOctopusini","poison",2000},{"blueberriniOctopusini","diamond",1700},{"blueberriniOctopusini","gold",600},{"blueberriniOctopusini","normal",400},
        {"penguinoPhone","astral",1600},{"penguinoPhone","honey",1400},{"penguinoPhone","blazing",1200},{"penguinoPhone","poison",1000},{"penguinoPhone","diamond",850},{"penguinoPhone","gold",300},{"penguinoPhone","normal",200},
        {"chimpanziniBananini","astral",1400},{"chimpanziniBananini","honey",1225},{"chimpanziniBananini","blazing",1050},{"chimpanziniBananini","poison",875},{"chimpanziniBananini","diamond",744},{"chimpanziniBananini","gold",263},{"chimpanziniBananini","normal",175},
        {"brainrot21","astral",1160},{"brainrot21","honey",1015},{"brainrot21","blazing",870},{"brainrot21","poison",725},{"brainrot21","diamond",617},{"brainrot21","gold",218},{"brainrot21","normal",145},
        {"pepperoniPenguino","astral",920},{"pepperoniPenguino","honey",805},{"pepperoniPenguino","blazing",690},{"pepperoniPenguino","poison",575},{"pepperoniPenguino","diamond",489},{"pepperoniPenguino","gold",173},{"pepperoniPenguino","normal",115},
        {"penguinoCocosino","astral",640},{"penguinoCocosino","honey",560},{"penguinoCocosino","blazing",480},{"penguinoCocosino","poison",400},{"penguinoCocosino","diamond",340},{"penguinoCocosino","gold",120},{"penguinoCocosino","normal",80},
        {"bananitaDolphinita","astral",400},{"bananitaDolphinita","honey",350},{"bananitaDolphinita","blazing",300},{"bananitaDolphinita","poison",250},{"bananitaDolphinita","diamond",213},{"bananitaDolphinita","gold",75},{"bananitaDolphinita","normal",50},
        {"bambiniCrostini","astral",200},{"bambiniCrostini","honey",175},{"bambiniCrostini","blazing",150},{"bambiniCrostini","poison",125},{"bambiniCrostini","diamond",107},{"bambiniCrostini","gold",38},{"bambiniCrostini","normal",25},
        {"pipiCorni","astral",152},{"pipiCorni","honey",133},{"pipiCorni","blazing",114},{"pipiCorni","poison",95},{"pipiCorni","diamond",81},{"pipiCorni","gold",29},{"pipiCorni","normal",19},
        {"pipiAvocado","astral",104},{"pipiAvocado","honey",91},{"pipiAvocado","blazing",78},{"pipiAvocado","poison",65},{"pipiAvocado","diamond",56},{"pipiAvocado","gold",20},{"pipiAvocado","normal",13},
        {"bonecaAmbalabu","astral",96},{"bonecaAmbalabu","honey",84},{"bonecaAmbalabu","blazing",72},{"bonecaAmbalabu","poison",60},{"bonecaAmbalabu","diamond",51},{"bonecaAmbalabu","gold",18},{"bonecaAmbalabu","normal",12},
        {"porkupine","astral",80},{"porkupine","honey",70},{"porkupine","blazing",60},{"porkupine","poison",50},{"porkupine","diamond",43},{"porkupine","gold",15},{"porkupine","normal",10},
        {"pipiKiwi","astral",48},{"pipiKiwi","honey",42},{"pipiKiwi","blazing",36},{"pipiKiwi","poison",30},{"pipiKiwi","diamond",26},{"pipiKiwi","gold",9},{"pipiKiwi","normal",6},
        {"talpaDiFerro","astral",16},{"talpaDiFerro","honey",14},{"talpaDiFerro","blazing",12},{"talpaDiFerro","poison",10},{"talpaDiFerro","diamond",9},{"talpaDiFerro","gold",3},{"talpaDiFerro","normal",2},
    }
    for _, v in ipairs(list) do
        BRAINROT_SCORE[v[1] .. "|" .. v[2]] = v[3]
    end
end





-- =============================================
--  HELPER: ambil model & posisi dari prompt
-- =============================================
local function getModelFromPrompt(prompt)
    if not prompt then return nil, nil end
    -- Struktur: Model > ProximityAttachment (Attachment) > ProximityPrompt
    -- prompt.Parent = ProximityAttachment, prompt.Parent.Parent = Model
    local model = nil
    local ok, err = pcall(function()
        local attachment = prompt.Parent
        if attachment and attachment:IsA("Attachment") then
            local parent = attachment.Parent
            if parent then
                if parent:IsA("Model") then
                    model = parent
                elseif parent:IsA("BasePart") then
                    -- BasePart langsung, ambil parent-nya jika Model
                    if parent.Parent and parent.Parent:IsA("Model") then
                        model = parent.Parent
                    else
                        model = parent
                    end
                end
            end
        end
    end)
    if not model then return nil, nil end

    local pos = nil
    pcall(function()
        if model:IsA("Model") then
            local p = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if p then pos = p.Position end
        elseif model:IsA("BasePart") then
            pos = model.Position
        end
    end)
    return model, pos
end

-- =============================================
--  HELPER: cek apakah sedang di base
-- =============================================
local function isAtBase()
    if not HRP then return true end
    return (HRP.Position - BASE_POS).Magnitude < 150
end

-- =============================================
--  HELPER: tunggu posisi berubah signifikan
-- =============================================
local function waitForPositionChange(timeout)
    local startPos = HRP.Position
    local elapsed  = 0
    while elapsed < timeout do
        task.wait(0.05)
        elapsed += 0.05
        if (HRP.Position - startPos).Magnitude > 200 then return true end
    end
    return false
end

-- =============================================
--  HELPER: cari nest yang aktif
-- =============================================
local function findActiveNest()
    for _, nest in ipairs(nests) do
        if not isAtBase() then
            HRP.CFrame = CFrame.new(BASE_POS)
            task.wait(0.5)
        end
        pcall(function()
            remContainer["game.nest.enterNest"]:FireServer(nest[2])
        end)
        if waitForPositionChange(0.6) then
            task.wait(0.4)
            if not isAtBase() then
                return nest
            end
        end
    end
    return nil
end

-- =============================================
--  HELPER: TP ke base lalu kill character
-- =============================================
local function tpAndReset()
    if HRP then
        HRP.CFrame = CFrame.new(resetPos)
    end
    task.spawn(function()
        task.wait(0.1)
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)
end

-- =============================================
--  HELPER: tunggu DropButton visible
-- =============================================
local function waitDropButton(timeout)
    local inGameGui = LP.PlayerGui:FindFirstChild("InGameGui")
    if not inGameGui then return false end
    local dropBtn = inGameGui:FindFirstChild("DropButton")
    if not dropBtn then return false end
    local t = 0
    while t < timeout do
        if dropBtn.Visible then return true end
        task.wait(0.05)
        t += 0.05
    end
    return false
end

-- =============================================
--  HELPER: ambil score langsung dari lookup table
--  key = "brainrotName|variant"
-- =============================================
local function getBrainrotScore(model)
    if not model then return 0, "Normal" end
    local brainrotName, variant = "", "normal"
    pcall(function()
        brainrotName = tostring(model:GetAttribute("name") or model.Name or "")
        variant      = (model:GetAttribute("variant") or "normal"):lower()
    end)
    local score = BRAINROT_SCORE[brainrotName .. "|" .. variant] or 0
    local label = variant:sub(1,1):upper() .. variant:sub(2)
    return score, label
end

-- =============================================
--  HELPER: tween ke prompt lalu fire
-- =============================================
local activeTween = nil  -- tween yang sedang berjalan (bisa di-cancel)

-- grabProximityPrompt: tween ke brainrot, cancel jika prompt despawn atau keluar bounds
-- nestBounds (opsional): kalau diisi, cancel jika brainrot keluar bounds nest
local function grabProximityPrompt(prompt, nestBounds)
    if not prompt or not HRP then return false end

    local _, pos = getModelFromPrompt(prompt)
    if not pos then
        pcall(function()
            local att = prompt.Parent
            local model = att and att.Parent
            if model then
                local p = model:IsA("Model")
                    and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart"))
                    or (model:IsA("BasePart") and model or nil)
                if p then pos = p.Position end
            end
        end)
    end
    if not pos then return false end

    -- Cek bounds sebelum mulai tween
    if nestBounds then
        if pos.X < nestBounds.xMin or pos.X > nestBounds.xMax
        or pos.Z < nestBounds.zMin or pos.Z > nestBounds.zMax then
            return false
        end
    end

    currentTweenPrompt = prompt

    local targetCFrame = CFrame.new(pos + Vector3.new(0, 0, 3))
    local tweenInfo    = TweenInfo.new(4.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    activeTween        = TweenService:Create(HRP, tweenInfo, { CFrame = targetCFrame })

    -- Flag untuk monitor thread
    local cancelled = false
    local tweenDone = false

    -- Monitor di thread terpisah: cek despawn & bounds tiap 0.3 detik
    local monitorThread = task.spawn(function()
        while not tweenDone do
            task.wait(0.3)
            if tweenDone then break end

            -- Cek prompt masih ada (model masih di workspace)
            local model = nil
            pcall(function()
                local att = prompt.Parent
                model = att and att.Parent
            end)
            local stillValid = model and model.Parent ~= nil
            if not stillValid then
                cancelled = true
                if activeTween then activeTween:Cancel(); activeTween = nil end
                break
            end

            -- Cek brainrot masih di dalam bounds
            if nestBounds and not cancelled then
                local curPos = nil
                pcall(function()
                    local _, p = getModelFromPrompt(prompt)
                    curPos = p
                end)
                if curPos then
                    if curPos.X < nestBounds.xMin or curPos.X > nestBounds.xMax
                    or curPos.Z < nestBounds.zMin or curPos.Z > nestBounds.zMax then
                        cancelled = true
                        if activeTween then activeTween:Cancel(); activeTween = nil end
                        break
                    end
                end
            end
        end
    end)

    activeTween:Play()
    activeTween.Completed:Wait()
    tweenDone = true
    activeTween = nil

    task.cancel(monitorThread)

    currentTweenPrompt = nil

    if cancelled then return false end

    task.wait(0.1)
    fireproximityprompt(prompt)
    task.wait(0.2)

    return true
end

-- =============================================
--  HELPER: scan radius 75, pilih score tertinggi
--  score = reward × variant multiplier
-- =============================================
-- blacklistedPositions = posisi brainrot Robux, TIDAK pernah direset (persist sesi)
-- nestId (opsional): kalau diisi, hanya ambil brainrot di dalam NEST_BOUNDS[nestId]
local VARIANT_PRIORITY_FALLBACK = {astral=6,honey=5,blazing=4,poison=3,diamond=2,gold=1,normal=0}

local function findBest(blacklistedPositions, nestId)
    if not HRP then return nil, 0, "Normal" end
    blacklistedPositions = blacklistedPositions or {}

    -- Ambil bounding box nest yang aktif (nil = tidak filter bounds)
    local bounds = nestId and NEST_BOUNDS[nestId] or nil

    local best, bestScore, bestVariantPri, bestLabel = nil, -1, -1, "Normal"

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local action = ""
            pcall(function() action = obj.ActionText:lower() end)
            if action == "grab" then
                local model, pos = getModelFromPrompt(obj)
                if model and pos then
                    -- Filter: brainrot harus di dalam bounding box nest yang dituju
                    if bounds then
                        if pos.X < bounds.xMin or pos.X > bounds.xMax
                        or pos.Z < bounds.zMin or pos.Z > bounds.zMax then
                            continue
                        end
                    end

                    local isBlacklisted = false
                    for _, bpos in ipairs(blacklistedPositions) do
                        if (pos - bpos).Magnitude < 5 then
                            isBlacklisted = true
                            break
                        end
                    end
                    if not isBlacklisted then
                        local dist = (pos - HRP.Position).Magnitude
                        if dist <= SCAN_RADIUS then
                            local score, label = getBrainrotScore(model)
                            -- Ambil variant priority untuk tiebreak kalau score = 0
                            local variant = "normal"
                            pcall(function()
                                variant = (model:GetAttribute("variant") or "normal"):lower()
                            end)
                            local varPri = VARIANT_PRIORITY_FALLBACK[variant] or 0

                            -- Bandingkan: utamakan score lookup table,
                            -- kalau sama (misal sama-sama 0), fallback ke variant priority
                            local better = false
                            if score > bestScore then
                                better = true
                            elseif score == bestScore and varPri > bestVariantPri then
                                better = true
                            end

                            if better then
                                bestScore      = score
                                bestVariantPri = varPri
                                bestLabel      = label
                                best           = obj
                            end
                        end
                    end
                end
            end
        end
    end

    return best, bestScore, bestLabel
end

-- Blacklist posisi Robux — persist sepanjang sesi, shared semua fitur
local blacklistedPositions = {}

-- =============================================
--  AUTO BRAINROT V3 — DATA & HELPERS
-- =============================================

-- Urutan rarity (index = tingkat, makin besar makin tinggi)
local RARITY_ORDER = {
    Common=1, Uncommon=2, Rare=3, Epic=4, Legendary=5,
    Mythical=6, Cosmic=7, Secret=8, Celestial=9,
    Divine=10, Infinity=11, Singularity=12, Eternal=13,
}

-- List brainrot lengkap dari brainrotList_lua.txt
local BRAINROT_LIST = {
    {rarity="Eternal",     name="kingFalken"},
    {rarity="Eternal",     name="lordoRobo"},
    {rarity="Eternal",     name="rengRongo"},
    {rarity="Eternal",     name="vulture"},
    {rarity="Eternal",     name="pineaplino"},
    {rarity="Eternal",     name="neonMeowl"},
    {rarity="Eternal",     name="jobJobDiablo"},
    {rarity="Eternal",     name="crocoBling"},
    {rarity="Singularity", name="eleccoBee"},
    {rarity="Singularity", name="tralalaTralalita"},
    {rarity="Singularity", name="tractoDino"},
    {rarity="Singularity", name="fireDragon"},
    {rarity="Singularity", name="fireMedusa"},
    {rarity="Singularity", name="fireCappuccino"},
    {rarity="Infinity",    name="sadoBananito"},
    {rarity="Infinity",    name="grappeminoDojo"},
    {rarity="Infinity",    name="techDimon"},
    {rarity="Infinity",    name="techScorpio"},
    {rarity="Divine",      name="sadoSkeletono"},
    {rarity="Divine",      name="grappellinoDoro"},
    {rarity="Divine",      name="strawberryElephant"},
    {rarity="Divine",      name="dinDinValluero"},
    {rarity="Divine",      name="martinoGravitino"},
    {rarity="Divine",      name="stoupoTraffico"},
    {rarity="Divine",      name="cupitronUFO"},
    {rarity="Divine",      name="galactioFantasma"},
    {rarity="Celestial",   name="udinDinDun"},
    {rarity="Celestial",   name="rubickPlanet"},
    {rarity="Celestial",   name="potatoRider"},
    {rarity="Celestial",   name="dugdug"},
    {rarity="Celestial",   name="frogzoSoda"},
    {rarity="Celestial",   name="wOrL"},
    {rarity="Celestial",   name="glacierelloInfernitti"},
    {rarity="Celestial",   name="crostinaGelifio"},
    {rarity="Celestial",   name="rubichettoCubini"},
    {rarity="Secret",      name="meowl"},
    {rarity="Secret",      name="los67"},
    {rarity="Secret",      name="trubobuzzoFrazzolopoulos"},
    {rarity="Secret",      name="tralaleroTralala"},
    {rarity="Secret",      name="strawberelliFlamingelli"},
    {rarity="Secret",      name="pinkMedussi"},
    {rarity="Secret",      name="bombardinoCrocodilo"},
    {rarity="Cosmic",      name="dragonCannelloni"},
    {rarity="Cosmic",      name="blueElephant"},
    {rarity="Cosmic",      name="headlessHorse"},
    {rarity="Cosmic",      name="spookyCombinasion"},
    {rarity="Cosmic",      name="laCasaBoo"},
    {rarity="Mythical",    name="brainrot76"},
    {rarity="Mythical",    name="cappuccinoAssassino"},
    {rarity="Mythical",    name="ballerinaCappuccina"},
    {rarity="Mythical",    name="brainrot69"},
    {rarity="Mythical",    name="liriliLarila"},
    {rarity="Legendary",   name="brainrot67"},
    {rarity="Legendary",   name="trippiTroppi"},
    {rarity="Legendary",   name="avocadiniGuffo"},
    {rarity="Legendary",   name="cactoHipopotamo"},
    {rarity="Legendary",   name="banditoBobritto"},
    {rarity="Epic",        name="tungTungTungSahur"},
    {rarity="Epic",        name="brrBrrPatapim"},
    {rarity="Epic",        name="foxitaAnanasita"},
    {rarity="Epic",        name="blueberriniOctopusini"},
    {rarity="Epic",        name="penguinoPhone"},
    {rarity="Rare",        name="chimpanziniBananini"},
    {rarity="Rare",        name="brainrot21"},
    {rarity="Rare",        name="pepperoniPenguino"},
    {rarity="Rare",        name="penguinoCocosino"},
    {rarity="Rare",        name="bananitaDolphinita"},
    {rarity="Uncommon",    name="bambiniCrostini"},
    {rarity="Uncommon",    name="pipiCorni"},
    {rarity="Uncommon",    name="pipiAvocado"},
    {rarity="Uncommon",    name="bonecaAmbalabu"},
    {rarity="Common",      name="porkupine"},
    {rarity="Common",      name="pipiKiwi"},
    {rarity="Common",      name="talpaDiFerro"},
}

-- Lookup cepat name → rarity
local BRAINROT_RARITY_MAP = {}
for _, b in ipairs(BRAINROT_LIST) do
    BRAINROT_RARITY_MAP[b.name:lower()] = b.rarity
end

-- Map nest → rarity yang tersedia di nest itu
local NEST_RARITY = {
    noob             = {"Common","Uncommon"},
    brainrot67       = {"Uncommon","Rare","Epic"},
    esokSekolah      = {"Uncommon","Rare","Epic","Legendary","Mythical"},
    karkarKurkurkur  = {"Epic","Legendary","Mythical","Cosmic"},
    yellowLuckyBlock = {"Legendary","Mythical","Cosmic"},
    strewberry       = {"Cosmic","Secret","Celestial"},
    jobJobJobSahur   = {"Cosmic","Secret","Celestial"},
    dragonCannelloni = {"Celestial","Divine","Infinity"},
    frogioBlingo     = {"Divine","Infinity","Singularity"},
    lavaGolem        = {"Infinity","Singularity"},
    eleccoBee        = {"Singularity","Eternal"},
    meowl            = {"Eternal"},
}

-- Nest berurutan dari terendah ke tertinggi (untuk routing)
local NEST_ORDER = {
    "noob","brainrot67","esokSekolah","karkarKurkurkur",
    "yellowLuckyBlock","strewberry","jobJobJobSahur",
    "dragonCannelloni","frogioBlingo","lavaGolem","eleccoBee","meowl",
}

-- Cari nest TERENDAH yang menyediakan rarity tertentu
local function findMinNestForRarity(rarityName)
    for _, nestId in ipairs(NEST_ORDER) do
        local rarities = NEST_RARITY[nestId]
        if rarities then
            for _, r in ipairs(rarities) do
                if r == rarityName then
                    return nestId
                end
            end
        end
    end
    return nil
end

-- Cek apakah nest menyediakan rarity tertentu
local function nestHasRarity(nestId, rarityName)
    local rarities = NEST_RARITY[nestId]
    if not rarities then return false end
    for _, r in ipairs(rarities) do
        if r == rarityName then return true end
    end
    return false
end

-- State V3 (multi-select)
local v3TargetBrainrots = {}   -- SET nama brainrot yang dipilih (internal name lowercase) → true
local v3TargetVariants  = {}   -- SET variant/mutasi target → true (kosong = any semua)
local v3TargetRarities  = {}   -- SET rarity dari semua brainrot yang dipilih
local v3TargetBrainrot  = ""   -- (compat) nama pertama, untuk notify
local v3TargetVariant   = ""   -- (compat) variant pertama, untuk notify
local v3TargetRarity    = ""   -- (compat) rarity pertama
local v3BlacklistPos    = {}   -- blacklist posisi khusus V3 (reset per-run)
local v3FailCount       = {}   -- hitungan fail per posisi

-- Helper: apakah brainrotName cocok dengan target yang dipilih?
local function v3MatchBrainrot(bName)
    -- Jika tidak ada yang dipilih, match semua (fallback)
    if next(v3TargetBrainrots) == nil then return true end
    return v3TargetBrainrots[bName:gsub("%s+","")] == true
end

-- Helper: apakah variant cocok dengan target yang dipilih?
local function v3MatchVariant(bVariant)
    -- Jika kosong (any all) atau "any" ada di set → match semua
    if next(v3TargetVariants) == nil or v3TargetVariants["any"] then return true end
    return v3TargetVariants[bVariant] == true
end

-- Helper: dapatkan rarity tertinggi dari semua brainrot yang dipilih (untuk cari validNests)
local function v3GetLowestRarity()
    -- Cari rarity dengan RARITY_ORDER terendah supaya nestnya bisa cover semua target
    local minRank = 99
    local minRarity = ""
    for _, b in ipairs(BRAINROT_LIST) do
        local norm = b.name:lower():gsub("%s+","")
        if v3TargetBrainrots[norm] then
            local rank = RARITY_ORDER[b.rarity] or 0
            if rank < minRank then
                minRank   = rank
                minRarity = b.rarity
            end
        end
    end
    if minRarity == "" then
        -- Fallback ke rarity pertama di list
        for _, b in ipairs(BRAINROT_LIST) do
            minRarity = b.rarity; break
        end
    end
    return minRarity
end

-- findBest khusus V3: hanya ambil brainrot yang namanya cocok (+ variant kalau diset)
local function findBestV3(nestId)
    if not HRP then return nil, nil end
    local bounds = nestId and NEST_BOUNDS[nestId] or nil

    local best, bestPos = nil, nil
    local bestVarPri = -1

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local action = ""
            pcall(function() action = obj.ActionText:lower() end)
            if action == "grab" then
                local model, pos = getModelFromPrompt(obj)
                if model and pos then
                    -- Filter bounds
                    if bounds then
                        if pos.X < bounds.xMin or pos.X > bounds.xMax
                        or pos.Z < bounds.zMin or pos.Z > bounds.zMax then
                            continue
                        end
                    end

                    -- Filter radius: max 500 unit dari player (seluruh area nest)
                    local dist = (pos - HRP.Position).Magnitude
                    if dist > 500 then continue end

                    -- Cek blacklist V3
                    local isBlacklisted = false
                    for _, bpos in ipairs(v3BlacklistPos) do
                        if (pos - bpos).Magnitude < 5 then
                            isBlacklisted = true
                            break
                        end
                    end
                    if isBlacklisted then continue end

                    -- Ambil nama & variant dari model
                    local bName, bVariant = "", "normal"
                    pcall(function()
                        local n = model:GetAttribute("name")
                        local rawName = n and tostring(n) or model.Name
                        -- Normalisasi: lowercase + hapus spasi agar "w or l" == "worl"
                        bName    = rawName:lower():gsub("%s+", "")
                        bVariant = (model:GetAttribute("variant") or "normal"):lower()
                    end)

                    -- Cocokkan nama brainrot (multi-select)
                    if not v3MatchBrainrot(bName) then continue end

                    -- Cocokkan variant (multi-select, "any" = semua)
                    if not v3MatchVariant(bVariant) then continue end

                    local varPri = VARIANT_PRIORITY_FALLBACK[bVariant] or 0
                    if varPri > bestVarPri then
                        bestVarPri = varPri
                        best    = obj
                        bestPos = pos
                    end
                end
            end
        end
    end

    return best, bestPos
end

-- Buat dropdown list brainrot (nama display) dan map ke internal name
local v3BrainrotDisplayList = {}
local v3BrainrotDisplayMap  = {}  -- displayName → {name, rarity}
for _, b in ipairs(BRAINROT_LIST) do
    -- Format: "pipiKiwi (Common)"
    local display = b.name .. " (" .. b.rarity .. ")"
    table.insert(v3BrainrotDisplayList, display)
    v3BrainrotDisplayMap[display] = {name=b.name, rarity=b.rarity}
end

local VARIANT_LIST = {"any","normal","gold","diamond","blazing","poison","honey","astral"}

-- V3 multi-select state (display)
local v3SelectedDisplays = {}   -- set displayName → true
local v3SelectedVariantSet = {["any"]=true}  -- default: any

-- =============================================
--  STATE & THREADS
-- =============================================
local State = {
    AutoBrainrot   = false,
    AutoCollect    = false,
    AutoUpgrade    = false,
    AutoCoils      = false,
    AutoRebirth    = false,
    AutoFuse       = false,
    AutoNearest    = false,
    AutoNearestV2  = false,
    AutoBrainrotV2 = false,
    AutoBrainrotV3 = false,
}
local threads = {}

local function stopThread(name)
    if threads[name] then
        task.cancel(threads[name])
        threads[name] = nil
    end
end

-- =============================================
--  AUTO BRAINROT V3 — MAIN LOOP
-- =============================================
local function startAutoBrainrotV3()
    threads.AutoBrainrotV3 = task.spawn(function()

        -- Reset blacklist V3 tiap kali distart
        v3BlacklistPos = {}
        v3FailCount    = {}

        local function waitRespawnAtBase()
            local elapsed = 0
            while elapsed < 6 do
                task.wait(0.2)
                elapsed += 0.2
                local char = LP.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                local hum  = char and char:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    Character = char
                    HRP       = hrp
                    if isAtBase() then return true end
                end
            end
            Character = LP.Character or Character
            HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
            return true
        end

        -- ── FASE 1: Bangun validNests SEKALI di awal ──────────────────
        -- Pakai rarity terendah dari semua brainrot yang dipilih
        local targetRarity = v3GetLowestRarity()
        local minNestId    = findMinNestForRarity(targetRarity)

        if not minNestId then
            notify("Auto Brainrot V3", "Rarity " .. targetRarity .. " tidak dikenali!", 4)
            State.AutoBrainrotV3 = false
            stopThread("AutoBrainrotV3")
            return
        end

        if not isAtBase() then
            tpAndReset()
            waitRespawnAtBase()
        else
            Character = LP.Character or Character
            HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
        end

        if not State.AutoBrainrotV3 then return end

        local startIdx = 1
        for i, nId in ipairs(NEST_ORDER) do
            if nId == minNestId then startIdx = i; break end
        end

        local validNests = {}
        for idx = startIdx, #NEST_ORDER do
            local nId = NEST_ORDER[idx]
            -- Nest valid kalau bisa spawn minimal 1 rarity dari brainrot yang dipilih
            local nestNeeded = false
            if next(v3TargetRarities) == nil then
                -- Tidak ada filter → semua nest valid
                nestNeeded = nestHasRarity(nId, targetRarity)
            else
                for rar in pairs(v3TargetRarities) do
                    if nestHasRarity(nId, rar) then nestNeeded = true; break end
                end
            end
            if not nestNeeded then continue end

            local nDisplayName = nId
            for _, n in ipairs(nests) do
                if n[2] == nId then nDisplayName = n[1]; break end
            end

            -- Pastikan di base dulu sebelum cek tiap nest
            if not isAtBase() then
                HRP.CFrame = CFrame.new(BASE_POS)
                task.wait(0.4)
            end

            -- Masuk nest, polling isInNest
            local inCorrectNest = false
            pcall(function()
                remContainer["game.nest.enterNest"]:FireServer(nId)
            end)
            local enterEl = 0
            repeat
                task.wait(0.2)
                enterEl += 0.2
                Character = LP.Character or Character
                HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                inCorrectNest = isInNest(nId)
            until inCorrectNest or enterEl >= 3

            -- Reset (kill) lalu tunggu respawn di base sebelum ke nest berikutnya
            tpAndReset()
            waitRespawnAtBase()
            task.wait(1)

            if inCorrectNest then
                table.insert(validNests, {id = nId, name = nDisplayName})
                notify("Auto Brainrot V3", "✓ " .. nDisplayName .. " valid", 1)
            else
                notify("Auto Brainrot V3", nDisplayName .. " belum di-unlock, skip...", 2)
            end
        end

        if #validNests == 0 then
            notify("Auto Brainrot V3",
                "Belum bisa! Unlock nest dengan rarity " .. targetRarity .. " dulu!", 4)
            State.AutoBrainrotV3 = false
            stopThread("AutoBrainrotV3")
            return
        end

        notify("Auto Brainrot V3", #validNests .. " nest valid, mulai rotasi...", 3)
        task.wait(0.5)

        if not State.AutoBrainrotV3 then return end

        -- ── FASE 2: Rotasi nest SATU PER SATU ─────────────────────────
        local nestIdx = 1
        while State.AutoBrainrotV3 do
            local nestEntry        = validNests[nestIdx]
            nestIdx                = (nestIdx % #validNests) + 1
            local nestToSearch     = nestEntry.id
            local nestToSearchName = nestEntry.name

            -- Paksa balik ke base dulu, tunggu 0.5 detik sebelum masuk nest
            HRP.CFrame = CFrame.new(BASE_POS)
            task.wait(0.5)

            Character = LP.Character or Character
            HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP

            -- Masuk nest, polling isInNest sampai berhasil atau timeout 3 detik
            notify("Auto Brainrot V3", "▶ Masuk " .. nestToSearchName .. "...", 1)
            pcall(function()
                remContainer["game.nest.enterNest"]:FireServer(nestToSearch)
            end)

            local enterElapsed = 0
            local entered = false
            repeat
                task.wait(0.2)
                enterElapsed += 0.2
                Character = LP.Character or Character
                HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                entered = isInNest(nestToSearch)
            until entered or enterElapsed >= 3

            if not entered then
                notify("Auto Brainrot V3", nestToSearchName .. " gagal masuk, skip...", 1)
                HRP.CFrame = CFrame.new(BASE_POS)
                task.wait(1)
                continue
            end

            notify("Auto Brainrot V3", "Scan 1 detik di " .. nestToSearchName .. "...", 2)

            -- Scan tiap 0.1 detik, max 1 detik
            local spawnWait   = 0
            local firstPrompt = nil
            repeat
                task.wait(0.1)
                spawnWait += 0.1
                Character  = LP.Character or Character
                HRP        = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                firstPrompt = findBestV3(nestToSearch)
            until firstPrompt or spawnWait >= 1 or not State.AutoBrainrotV3

            if not State.AutoBrainrotV3 then break end

            if not firstPrompt then
                -- Tidak ada → balik base, tunggu 1 detik, lanjut nest berikutnya
                notify("Auto Brainrot V3", "Tidak ada di " .. nestToSearchName .. ", pindah...", 1)
                tpAndReset()
                waitRespawnAtBase()
                continue
            end

            -- Ada target! Grab
            local bestPrompt, promptPos = findBestV3(nestToSearch)
            if not bestPrompt then
                tpAndReset()
                waitRespawnAtBase()
                continue
            end

            local variantLabel = (next(v3TargetVariants) == nil or v3TargetVariants["any"]) and "any" or table.concat((function()
                local t={}; for k in pairs(v3TargetVariants) do table.insert(t,k) end; return t
            end)(), "/")
            local brainrotLabel = (next(v3TargetBrainrots) == nil) and "all" or table.concat((function()
                local t={}; for k in pairs(v3TargetBrainrots) do table.insert(t,k) end; return t
            end)(), "/")
            notify("Auto Brainrot V3",
                "Tween ke " .. brainrotLabel .. " [" .. variantLabel .. "] di " .. nestToSearchName .. "...", 2)

            local grabbed = grabProximityPrompt(bestPrompt)

            if not grabbed then
                notify("Auto Brainrot V3", "Gagal grab, blacklist posisi...", 1)
                if promptPos then table.insert(v3BlacklistPos, promptPos) end
                tpAndReset()
                waitRespawnAtBase()
            else
                local success = waitDropButton(3)
                if success then
                    local gotName = ""
                    pcall(function()
                        local att = bestPrompt.Parent
                        local m = att and att.Parent
                        if m then
                            local n = m:GetAttribute("name")
                            gotName = n and tostring(n) or m.Name
                        end
                    end)
                    notify("Auto Brainrot V3", "✅ Dapat " .. gotName .. "! Reset...", 3)
                    tpAndReset()
                    waitRespawnAtBase()
                    notify("Auto Brainrot V3", "Loop ulang mencari target...", 2)
                else
                    if promptPos then
                        local key = math.floor(promptPos.X) .. "," .. math.floor(promptPos.Z)
                        v3FailCount[key] = (v3FailCount[key] or 0) + 1
                        if v3FailCount[key] >= 3 then
                            notify("Auto Brainrot V3", "Posisi di-blacklist (3x gagal)!", 2)
                            table.insert(v3BlacklistPos, promptPos)
                            v3FailCount[key] = 0
                        else
                            notify("Auto Brainrot V3",
                                "Skip (fail " .. v3FailCount[key] .. "/3), pindah...", 1)
                        end
                    end
                    tpAndReset()
                    waitRespawnAtBase()
                end
            end
        end

    end)
end

-- =============================================
--  AUTO BRAINROT (manual — enter nest, tunggu drop)
-- =============================================
local function startAutoBrainrot()
    threads.AutoBrainrot = task.spawn(function()
        while State.AutoBrainrot do
            local waitSpam = task.spawn(function()
                while State.AutoBrainrot do
                    notify("Wait", "Mencari nest aktif...", 1)
                    task.wait(0.8)
                end
            end)
            local activeNest = findActiveNest()
            task.cancel(waitSpam)
            if not State.AutoBrainrot then break end

            if activeNest then
                local takeSpam = task.spawn(function()
                    while State.AutoBrainrot do
                        notify("Take Brainrot", "Go Take!", 1)
                        task.wait(0.8)
                    end
                end)
                local dropBtn = LP.PlayerGui
                    :WaitForChild("InGameGui")
                    :WaitForChild("DropButton")
                while not dropBtn.Visible and State.AutoBrainrot do
                    task.wait(0.05)
                end
                task.cancel(takeSpam)
                if not State.AutoBrainrot then break end
                tpAndReset()
                notify("Loop Ulang", "Memulai ulang...", 2)
                task.wait(0.1)
            end
            task.wait(0.5)
        end
    end)
end

-- =============================================
--  AUTO NEAREST BRAINROT (otomatis — grab prioritas)
-- =============================================
local function startAutoNearestBrainrot()
    threads.AutoNearest = task.spawn(function()
        while State.AutoNearest do
            local waitSpam = task.spawn(function()
                while State.AutoNearest do
                    notify("Auto Nearest", "Mencari nest aktif...", 1)
                    task.wait(0.8)
                end
            end)
            local activeNest = findActiveNest()
            task.cancel(waitSpam)
            if not State.AutoNearest then break end

            if activeNest then
                notify("Auto Nearest", "Masuk: " .. activeNest[1], 2)

                -- Tunggu brainrot spawn (max 5 detik polling tiap 0.5s)
                local spawnWait = 0
                local firstPrompt = nil
                repeat
                    task.wait(0.5)
                    spawnWait += 0.5
                    Character = LP.Character or Character
                    HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                    firstPrompt = findBest(blacklistedPositions, activeNest[2])
                until firstPrompt or spawnWait >= 5 or not State.AutoNearest

                if not State.AutoNearest then break end

                if not firstPrompt then
                    -- Nest benar-benar kosong, balik cari nest lain
                    notify("Auto Nearest", "Nest kosong, cari nest lain...", 2)
                    tpAndReset()
                    task.wait(0.3)
                else
                    while State.AutoNearest do
                        -- Re-scan fresh setiap iterasi (termasuk setelah skip Robux)
                        Character = LP.Character or Character
                        HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP

                        local bestPrompt, bestScore, mutasiName = findBest(blacklistedPositions, activeNest[2])
                        if not bestPrompt then
                            -- Tunggu respawn brainrot max 3 detik sebelum beneran balik
                            local retryWait = 0
                            while retryWait < 3 and State.AutoNearest do
                                task.wait(0.5)
                                retryWait += 0.5
                                Character = LP.Character or Character
                                HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                                bestPrompt, bestScore, mutasiName = findBest(blacklistedPositions, activeNest[2])
                                if bestPrompt then break end
                            end
                            if not bestPrompt then
                                notify("Auto Nearest", "Nest kosong, loop ulang...", 1)
                                break
                            end
                        end

                        local _, promptPos = getModelFromPrompt(bestPrompt)

                        -- Re-scan tepat sebelum tween: pastikan masih best & masih di bounds
                        local confirmPrompt, confirmScore, confirmName = findBest(blacklistedPositions, activeNest[2])
                        if confirmPrompt ~= bestPrompt then
                            -- Ada yang lebih baik atau prompt sudah ganti, scan ulang dari atas
                            notify("Auto Nearest", "Target berubah, scan ulang...", 1)
                            task.wait(0.05)
                        else
                            notify("Auto Nearest", "Grab: " .. mutasiName, 2)
                            local nestBounds = NEST_BOUNDS[activeNest[2]]
                            local grabbed = grabProximityPrompt(bestPrompt, nestBounds)

                            if not grabbed then
                                notify("Auto Nearest", "Gagal/despawn/keluar bounds, scan ulang...", 1)
                                if promptPos then
                                    table.insert(blacklistedPositions, promptPos)
                                end
                                task.wait(0.1)
                            else
                                local success = waitDropButton(3)
                                if success then
                                    notify("Auto Nearest", "Berhasil! TP reset...", 2)
                                    break
                                else
                                    notify("Auto Nearest", "Skip (Robux/gagal), cari lain...", 2)
                                    if promptPos then
                                        table.insert(blacklistedPositions, promptPos)
                                    end
                                    task.wait(0.15)
                                end
                            end
                        end
                    end

                    tpAndReset()
                    notify("Auto Nearest", "Loop ulang...", 1)
                end
            end
            task.wait(0.3)
        end
    end)
end

-- =============================================
--  AUTO NEAREST BRAINROT V2 (manual nest selector)
--  → langsung TP ke nest yang dipilih, tanpa scan semua nest
-- =============================================
local function startAutoNearestBrainrotV2()
    threads.AutoNearestV2 = task.spawn(function()

        -- Helper: tunggu karakter respawn (hidup kembali), lalu update HRP
        local function waitRespawnAtBase()
            local elapsed = 0
            while elapsed < 6 do
                task.wait(0.2)
                elapsed += 0.2
                local char = LP.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                local hum  = char and char:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    Character = char
                    HRP       = hrp
                    return true
                end
            end
            Character = LP.Character or Character
            HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
            return true
        end

        while State.AutoNearestV2 do
            -- TP reset + tunggu respawn sebelum masuk nest
            tpAndReset()
            waitRespawnAtBase()

            if not State.AutoNearestV2 then break end

            local nestId   = selectedNestId
            local nestName = selectedNestName

            notify("Auto Nearest V2", "Masuk: " .. nestName, 2)

            -- Masuk nest, polling isInNest max 3 detik
            pcall(function()
                remContainer["game.nest.enterNest"]:FireServer(nestId)
            end)
            local enterEl = 0
            local inCorrectNest = false
            repeat
                task.wait(0.2)
                enterEl += 0.2
                Character = LP.Character or Character
                HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                inCorrectNest = isInNest(nestId)
            until inCorrectNest or enterEl >= 3

            if not inCorrectNest then
                notify("Unlock This Area", nestName .. " belum di-unlock!", 3)
                State.AutoNearestV2 = false
                mainFrame.Visible = false
                stopThread("AutoNearestV2")
                break
            end

            if not State.AutoNearestV2 then break end

            Character = LP.Character or Character
            HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP

            -- Tunggu brainrot spawn setelah masuk nest (max 5 detik polling tiap 0.5s)
            local spawnWait = 0
            local firstPrompt = nil
            notify("Auto Nearest V2", "Tunggu brainrot spawn...", 1)
            repeat
                task.wait(0.5)
                spawnWait += 0.5
                Character = LP.Character or Character
                HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                firstPrompt = findBest(blacklistedPositions, nestId)
            until firstPrompt or spawnWait >= 5 or not State.AutoNearestV2

            if not State.AutoNearestV2 then break end

            if not firstPrompt then
                notify("Auto Nearest V2", "Nest kosong, loop ulang...", 2)
                tpAndReset()
                task.wait(0.3)
            else
                -- Loop grab brainrot di dalam nest
                while State.AutoNearestV2 do
                    if selectedNestId ~= nestId then
                        notify("Auto Nearest V2", "Nest diganti, pindah...", 1)
                        break
                    end

                    -- Re-scan fresh setiap iterasi (termasuk setelah skip Robux)
                    Character = LP.Character or Character
                    HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP

                    local bestPrompt, bestScore, mutasiName = findBest(blacklistedPositions, nestId)
                    if not bestPrompt then
                        -- Retry tunggu respawn brainrot max 3 detik sebelum beneran balik
                        local retryWait = 0
                        while retryWait < 3 and State.AutoNearestV2 do
                            task.wait(0.5)
                            retryWait += 0.5
                            Character = LP.Character or Character
                            HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                            bestPrompt, bestScore, mutasiName = findBest(blacklistedPositions, nestId)
                            if bestPrompt then break end
                        end
                        if not bestPrompt then
                            notify("Auto Nearest V2", "Nest kosong, loop ulang...", 1)
                            break
                        end
                    end

                    local _, promptPos = getModelFromPrompt(bestPrompt)

                    -- Re-scan tepat sebelum tween: pastikan masih best & masih di bounds
                    local confirmPrompt2, _, confirmName2 = findBest(blacklistedPositions, nestId)
                    if confirmPrompt2 ~= bestPrompt then
                        notify("Auto Nearest V2", "Target berubah, scan ulang...", 1)
                        task.wait(0.05)
                    else
                        notify("Auto Nearest V2", "Grab: " .. mutasiName, 2)
                        local nestBounds2 = NEST_BOUNDS[nestId]
                        local grabbed = grabProximityPrompt(bestPrompt, nestBounds2)

                        if not grabbed then
                            notify("Auto Nearest V2", "Gagal/despawn/keluar bounds, scan ulang...", 1)
                            if promptPos then
                                table.insert(blacklistedPositions, promptPos)
                            end
                            task.wait(0.1)
                        else
                            local success = waitDropButton(3)
                            if success then
                                notify("Auto Nearest V2", "Berhasil! TP reset...", 2)
                                break
                            else
                                notify("Auto Nearest V2", "Skip (Robux/gagal), cari lain...", 2)
                                if promptPos then
                                    table.insert(blacklistedPositions, promptPos)
                                end
                                task.wait(0.15)
                            end
                        end
                    end
                end
            end

            tpAndReset()
            notify("Auto Nearest V2", "Loop ulang...", 1)
        end
    end)
end

-- =============================================
--  AUTO BRAINROT V2 (pilih nest + otomatis)
-- =============================================
local function startAutoBrainrotV2()
    threads.AutoBrainrotV2 = task.spawn(function()

        -- Helper: tunggu karakter respawn & balik ke base, update HRP
        local function waitRespawnAtBase()
            -- Tunggu humanoid mati + respawn (max 6 detik)
            local elapsed = 0
            while elapsed < 6 do
                task.wait(0.2)
                elapsed += 0.2
                local char = LP.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                local hum  = char and char:FindFirstChild("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    Character = char
                    HRP       = hrp
                    -- Pastikan udah di base
                    if isAtBase() then return true end
                end
            end
            -- Fallback: refresh manual
            Character = LP.Character or Character
            HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
            return isAtBase()
        end

        while State.AutoBrainrotV2 do
            -- Pastikan di base + HRP valid sebelum enter nest
            if not isAtBase() then
                tpAndReset()
                waitRespawnAtBase()
            else
                -- Refresh HRP tiap loop biar ga stale
                Character = LP.Character or Character
                HRP       = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
            end

            if not State.AutoBrainrotV2 then break end

            local nestId   = selectedNestId
            local nestName = selectedNestName

            notify("Auto Brainrot V2", "Masuk: " .. nestName, 2)

            -- Masuk nest, polling isInNest max 3 detik
            pcall(function()
                remContainer["game.nest.enterNest"]:FireServer(nestId)
            end)
            local enterEl2 = 0
            local inCorrectNest = false
            repeat
                task.wait(0.2)
                enterEl2 += 0.2
                Character = LP.Character or Character
                HRP = Character and Character:FindFirstChild("HumanoidRootPart") or HRP
                inCorrectNest = isInNest(nestId)
            until inCorrectNest or enterEl2 >= 3

            if not inCorrectNest then
                notify("Unlock This Area", nestName .. " belum di-unlock!", 3)
                State.AutoBrainrotV2 = false
                stopThread("AutoBrainrotV2")
                break
            end

            task.wait(0.4)
            if not State.AutoBrainrotV2 then break end

            local takeSpam = task.spawn(function()
                while State.AutoBrainrotV2 do
                    notify("Auto Brainrot V2", "Menunggu brainrot...", 1)
                    task.wait(0.8)
                end
            end)
            local success = waitDropButton(30)
            task.cancel(takeSpam)
            if not State.AutoBrainrotV2 then break end

            notify("Auto Brainrot V2", success and "Berhasil! TP reset..." or "Timeout, coba lagi...", 2)
            tpAndReset()
            -- Tunggu respawn beneran sebelum loop ulang
            waitRespawnAtBase()
        end
    end)
end

-- =============================================
--  UI — TAB MAIN (V1)
-- =============================================
TabMain:Toggle({
    ["Title"]   = "Auto Brainrot ( manual )",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoBrainrot = v
        if v then startAutoBrainrot()
        else stopThread("AutoBrainrot") end
    end,
})

TabMain:Toggle({
    ["Title"]   = "Auto Nearest Brainrot ( otomatis )",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoNearest = v
        if v then
            -- Reset ke maximize saat radar dibuka
            setMinimized(false)
            mainFrame.Size = UDim2.fromOffset(RADAR_W, RADAR_H)
            mainFrame.Visible = true
            startAutoNearestBrainrot()
        else
            mainFrame.Visible = false
            stopThread("AutoNearest")
        end
    end,
})

-- ── Buat list nama nest untuk dropdown V2 ─────────────────────────
local nestNames = {}
for _, n in ipairs(nests) do
    table.insert(nestNames, n[1])
end

-- =============================================
--  UI — TAB MAIN V2
-- =============================================
TabMainV2:Dropdown({
    ["Title"]   = "Pilih Nest",
    ["Values"]  = nestNames,
    ["Default"] = nestNames[1],
    ["Callback"] = function(val)
        for _, n in ipairs(nests) do
            if n[1] == val then
                selectedNestId   = n[2]
                selectedNestName = n[1]
                notify("V2", "Target: " .. n[1], 2)
                break
            end
        end
    end,
})

TabMainV2:Toggle({
    ["Title"]   = "Auto Brainrot V2 ( pilih nest + manual )",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoBrainrotV2 = v
        if v then startAutoBrainrotV2()
        else stopThread("AutoBrainrotV2") end
    end,
})

TabMainV2:Toggle({
    ["Title"]   = "Auto Nearest Brainrot V2 ( pilih nest )",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoNearestV2 = v
        if v then
            setMinimized(false)
            mainFrame.Size = UDim2.fromOffset(RADAR_W, RADAR_H)
            mainFrame.Visible = true
            startAutoNearestBrainrotV2()
        else
            mainFrame.Visible = false
            stopThread("AutoNearestV2")
        end
    end,
})

-- ── AUTO BRAINROT V3 UI ──────────────────────────────────────────
TabMainV2:Dropdown({
    ["Title"]   = "V3 · Pilih Brainrot (multi)",
    ["Values"]  = v3BrainrotDisplayList,
    ["Default"] = v3BrainrotDisplayList[1],
    ["Multi"]   = true,
    ["Callback"] = function(val)
        -- val bisa string (single) atau table (multi) tergantung library
        v3TargetBrainrots = {}
        v3TargetRarities  = {}
        local function addEntry(v)
            local data = v3BrainrotDisplayMap[v]
            if data then
                local norm = data.name:lower():gsub("%s+","")
                v3TargetBrainrots[norm] = true
                v3TargetRarities[data.rarity] = true
                -- compat single
                v3TargetBrainrot = data.name:lower()
                v3TargetRarity   = data.rarity
            end
        end
        if type(val) == "table" then
            for _, v in pairs(val) do addEntry(v) end
        else
            addEntry(val)
        end
        -- Hitung jumlah yang dipilih
        local count = 0
        for _ in pairs(v3TargetBrainrots) do count += 1 end
        notify("V3", count .. " brainrot dipilih", 2)
    end,
})

TabMainV2:Dropdown({
    ["Title"]   = "V3 · Pilih Mutasi (multi, any = semua)",
    ["Values"]  = VARIANT_LIST,
    ["Default"] = "any",
    ["Multi"]   = true,
    ["Callback"] = function(val)
        v3TargetVariants = {}
        local function addVariant(v)
            v3TargetVariants[v] = true
            v3TargetVariant = v  -- compat
            v3SelectedVariantSet[v] = true
        end
        if type(val) == "table" then
            for _, v in pairs(val) do addVariant(v) end
        else
            addVariant(val)
        end
        -- Kalau "any" dipilih, clear yang lain
        if v3TargetVariants["any"] then
            v3TargetVariants = {["any"]=true}
        end
        local count = 0
        for _ in pairs(v3TargetVariants) do count += 1 end
        notify("V3", count .. " mutasi dipilih" .. (v3TargetVariants["any"] and " (semua)" or ""), 2)
    end,
})

TabMainV2:Toggle({
    ["Title"]   = "Auto Brainrot V3 ( pilih brainrot + mutasi )",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoBrainrotV3 = v
        if v then
            -- Gunakan rarity terendah dari semua target
            local targetRarity = v3GetLowestRarity()
            local minNestId = findMinNestForRarity(targetRarity)
            if not minNestId then
                notify("Auto Brainrot V3", "Rarity tidak valid!", 3)
                State.AutoBrainrotV3 = false
                return
            end
            local minNestName = minNestId
            for _, n in ipairs(nests) do
                if n[2] == minNestId then minNestName = n[1]; break end
            end
            -- Hitung berapa brainrot & variant yang dipilih
            local bCount = 0; for _ in pairs(v3TargetBrainrots) do bCount += 1 end
            local vCount = 0; for _ in pairs(v3TargetVariants) do vCount += 1 end
            local anyVariant = v3TargetVariants["any"] or vCount == 0
            notify("Auto Brainrot V3",
                "Start! " .. bCount .. " brainrot | " ..
                (anyVariant and "any mutasi" or vCount .. " mutasi") ..
                " | Min: " .. minNestName, 4)
            v3BlacklistPos = {}
            v3FailCount    = {}
            startAutoBrainrotV3()
        else
            stopThread("AutoBrainrotV3")
        end
    end,
})

TabMain:Toggle({
    ["Title"]   = "Auto Collect Cash",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoCollect = v
        if v then
            threads.AutoCollect = task.spawn(function()
                while State.AutoCollect do
                    for i = 1, 48 do
                        task.spawn(function()
                            remContainer["data.base.collectPadMoney"]:InvokeServer(i)
                        end)
                    end
                    task.wait(0.5)
                end
            end)
        else stopThread("AutoCollect") end
    end,
})

TabMain:Toggle({
    ["Title"]   = "Auto Upgrade Base",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoUpgrade = v
        if v then
            threads.AutoUpgrade = task.spawn(function()
                while State.AutoUpgrade do
                    remContainer["data.base.upgradeBase"]:FireServer()
                    task.wait(0.5)
                end
            end)
        else stopThread("AutoUpgrade") end
    end,
})

TabMain:Toggle({
    ["Title"]   = "Auto Buy All Coils",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoCoils = v
        if v then
            threads.AutoCoils = task.spawn(function()
                local cList = {"red","blue","yellow","water","lava","poison","abyss","inferno","dream","rainbow","magma"}
                while State.AutoCoils do
                    for _, name in pairs(cList) do
                        remContainer["data.toolShop.buySpeedCoil"]:FireServer(name)
                    end
                    task.wait(1)
                end
            end)
        else stopThread("AutoCoils") end
    end,
})

TabMain:Toggle({
    ["Title"]   = "Auto Rebirth",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoRebirth = v
        if v then
            threads.AutoRebirth = task.spawn(function()
                while State.AutoRebirth do
                    remContainer["data.base.rebirth"]:FireServer()
                    task.wait(1)
                end
            end)
        else stopThread("AutoRebirth") end
    end,
})

-- =============================================
--  AUTO FUSE
-- =============================================
local FUSE_LIST = {
    "tralala",
    "bee",
    "pineaplino",
    "vulture",
    "rengRongo",
    "lordoRobo",
    "kingFalken",
}

local selectedFuse = FUSE_LIST[1]

TabMain:Dropdown({
    ["Title"]   = "Pilih Fuse Target",
    ["Values"]  = FUSE_LIST,
    ["Default"] = FUSE_LIST[1],
    ["Callback"] = function(val)
        selectedFuse = val
        notify("Auto Fuse", "Fuse target: " .. val, 2)
    end,
})

TabMain:Toggle({
    ["Title"]   = "Auto Fuse",
    ["Default"] = false,
    ["Callback"] = function(v)
        State.AutoFuse = v
        if v then
            threads.AutoFuse = task.spawn(function()
                while State.AutoFuse do
                    local ok, err = pcall(function()
                        remContainer["data.fuse.createFuse"]:FireServer(selectedFuse)
                    end)
                    if ok then
                        notify("Auto Fuse", "🔁 Fuse dikirim: " .. selectedFuse, 2)
                    else
                        notify("Auto Fuse ❌", "Gagal: " .. tostring(err):sub(1, 60), 3)
                    end
                    task.wait(3)
                end
            end)
        else stopThread("AutoFuse") end
    end,
})

-- =============================================
--  UI — TAB TELEPORT
-- =============================================
TabTP:Button({
    ["Title"]    = "Claim Brainrot To Base",
    ["Callback"] = function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(resetPos)
            task.spawn(function()
                task.wait(0.1)
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    LP.Character.Humanoid.Health = 0
                end
            end)
        end
    end,
})

for _, nest in ipairs(nests) do
    local nestName = nest[1]
    local nestId   = nest[2]
    TabTP:Button({
        ["Title"]    = "TP " .. nestName,
        ["Callback"] = function()
            local startPos = HRP and HRP.Position
            pcall(function()
                remContainer["game.nest.enterNest"]:FireServer(nestId)
            end)
            task.spawn(function()
                task.wait(0.5)
                if HRP and startPos then
                    local moved = (HRP.Position - startPos).Magnitude > 100
                    if not moved then
                        notify("Unlock This Area", nestName .. " belum di-unlock!", 3)
                    end
                end
            end)
        end,
    })
end

notify("Rilzz Hub", "Script loaded!", 3)
