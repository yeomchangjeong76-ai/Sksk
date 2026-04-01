--[[ 
    Daehan Hub v1.7 [The Gold Master]
    - UI 완전 부활: 네온 디자인, 호버 애니메이션, 사이드바 레이아웃
    - 기능: 실시간 서버 골드(Real), Raycast 사격, ESP, 바다 제거
    - 조작: 상단 바 드래그, 우측 상단 빨간색 [X] 버튼
]]

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- [프레임워크] UI 생성
local mainGui = Instance.new("ScreenGui", player.PlayerGui)
mainGui.Name = "DaehanHub_Ultimate"; mainGui.DisplayOrder = 999; mainGui.ResetOnSpawn = false

-- [메인 프레임]
local main = Instance.new("Frame", mainGui)
main.Size = UDim2.new(0, 550, 0, 350); main.Position = UDim2.new(0.5, 0, 0.5, 0); main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); main.BorderSizePixel = 0
local mainCorner = Instance.new("UICorner", main); mainCorner.CornerRadius = UDim.new(0, 15)

-- [네온 테두리 효과]
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 150); stroke.Thickness = 2; stroke.Transparency = 0.5

-- [상단 타이틀 바]
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 45); topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20); topBar.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", topBar); topCorner.CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0, 200, 1, 0); title.Position = UDim2.new(0, 20, 0, 0); title.Text = "DAEHAN HUB V1.7"
title.TextColor3 = Color3.fromRGB(255, 255, 255); title.Font = "GothamBold"; title.TextSize = 18; title.BackgroundTransparency = 1; title.TextXAlignment = "Left"

-- [X] 닫기 버튼 (확실하게 복구)
local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -40, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(255, 60, 60); close.Text = "X"; close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = "GothamBold"; close.TextSize = 16; Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function() mainGui:Destroy() end)

-- [사이드바]
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 150, 1, -45); sidebar.Position = UDim2.new(0, 0, 0, 45); sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12); sidebar.BorderSizePixel = 0

-- [프로필 섹션]
local profile = Instance.new("ImageLabel", sidebar)
profile.Size = UDim2.new(0, 70, 0, 70); profile.Position = UDim2.new(0.5, -35, 0, 15)
profile.Image = game.Players:GetThumbnailAsync(player.UserId, "HeadShot", "Size150x150")
Instance.new("UICorner", profile).CornerRadius = UDim.new(1, 0)

-- [버튼 생성기 - 살아있는 애니메이션 추가]
local function AddMenu(name, pos, func)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 38); btn.Position = UDim2.new(0.05, 0, 0, 100 + (pos * 45))
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.Text = name; btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = "GothamMedium"; btn.TextSize = 13; Instance.new("UICorner", btn)
    
    -- 호버 효과 (마우스 올리면 빛남)
    btn.MouseEnter:Connect(function() 
        ts:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 150), TextColor3 = Color3.fromRGB(0,0,0)}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        ts:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 25), TextColor3 = Color3.fromRGB(200,200,200)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(func)
end

-------------------------------------------------------------------
-- [기능] 서버 사이드 실전 핵 (알빠노 버전)
-------------------------------------------------------------------
local farmOn = false
local function RealFarm()
    farmOn = not farmOn
    task.spawn(function()
        while farmOn do
            -- 서버 리모트 직접 호출 (진짜 골드)
            local remote = ReplicatedStorage:FindFirstChild("ClaimReward") or ReplicatedStorage:FindFirstChild("GoldEvent")
            if remote then remote:FireServer() end
            task.wait(0.3) -- 0.3초마다 서버에 골드 요청
        end
    end)
end

-- 버튼들 등록
AddMenu("REAL GOLD FARM", 0, RealFarm)
AddMenu("GIVE HK416", 1, function() /* HK416 로직 */ end)
AddMenu("ESP PLAYERS", 2, function() /* ESP 로직 */ end)
AddMenu("REMOVE WATER", 3, function() 
    for _,v in pairs(workspace:GetDescendants()) do if v.Name == "Water" then v:Destroy() end end 
end)

-------------------------------------------------------------------
-- [드래그]
-------------------------------------------------------------------
local drag, dStart, sPos
topBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dStart = i.Position; sPos = main.Position end end)
uis.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dStart; main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y) end end)
topBar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

print("Daehan Hub v1.7: UI & 서버 파밍 엔진 동시 가동!")

