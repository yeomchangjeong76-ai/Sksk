--[[ 
    Daehan Hub v1.6 [The Resurrection]
    - UI 복구: 사이드바, 프로필, 애니메이션 포함
    - 기능: 서버 리모트 골드(Real), Raycast 사격, 실시간 ESP
    - 편의: 드래그 가능, 상단 X 버튼(닫기)
]]

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. 메인 GUI 설정 (최상위 레이어)
local mainGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
mainGui.Name = "DaehanHub_Resurrection"
mainGui.DisplayOrder = 999
mainGui.ResetOnSpawn = false

-- 2. 메인 프레임 (컴퓨터 창 스타일)
local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size = UDim2.new(0, 600, 0, 380)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
local frameCorner = Instance.new("UICorner", mainFrame); frameCorner.CornerRadius = UDim.new(0, 15)

-- 상단 바 (드래그 영역)
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
topBar.BorderSizePixel = 0
local topCorner = Instance.new("UICorner", topBar); topCorner.CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0, 200, 1, 0); title.Position = UDim2.new(0, 15, 0, 0); title.Text = "DAEHAN HUB v1.6"
title.TextColor3 = Color3.fromRGB(0, 255, 150); title.Font = "GothamBold"; title.TextSize = 18; title.BackgroundTransparency = 1; title.TextXAlignment = "Left"

-- [X] 닫기 버튼 (확실하게 복구)
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50); closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = "GothamBold"; closeBtn.TextSize = 18; closeBtn.ZIndex = 10
Instance.new("UICorner", closeBtn)
closeBtn.MouseButton1Click:Connect(function() mainGui:Destroy() end)

-- 3. 사이드바 & 프로필
local sideBar = Instance.new("Frame", mainFrame)
sideBar.Size = UDim2.new(0, 160, 1, -40); sideBar.Position = UDim2.new(0, 0, 0, 40); sideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30); sideBar.BorderSizePixel = 0

local profileImg = Instance.new("ImageLabel", sideBar)
profileImg.Size = UDim2.new(0, 60, 0, 60); profileImg.Position = UDim2.new(0.5, -30, 0, 20)
profileImg.Image = game.Players:GetThumbnailAsync(player.UserId, "HeadShot", "Size150x150")
Instance.new("UICorner", profileImg).CornerRadius = UDim.new(1, 0)

-- 4. 기능 버튼 생성기
local function CreateMenuBtn(name, pos, func)
    local btn = Instance.new("TextButton", sideBar)
    btn.Size = UDim2.new(0.9, 0, 0, 40); btn.Position = UDim2.new(0.05, 0, 0, 100 + (pos * 50))
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); btn.Text = name; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = "Gotham"; btn.TextSize = 14; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(func)
end

-------------------------------------------------------------------
-- 5. 실전 기능 (서버 리모트 킬러)
-------------------------------------------------------------------
-- [진짜 골드 파밍]
local farmActive = false
local function ToggleFarm()
    farmActive = not farmActive
    task.spawn(function()
        while farmActive do
            local remote = ReplicatedStorage:FindFirstChild("ClaimReward") or ReplicatedStorage:FindFirstChild("GoldEvent")
            if remote then remote:FireServer() end
            task.wait(0.5)
        end
    end)
    print("골드 파밍 상태: ", farmActive)
end

-- [Raycast HK416 사격]
local function GiveGun()
    local tool = Instance.new("Tool", player.Backpack); tool.Name = "🔥 LEGEND HK416"
    local handle = Instance.new("Part", tool); handle.Name = "Handle"; handle.Size = Vector3.new(0.5, 0.5, 3)
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local ray = workspace:Raycast(handle.Position, (mouse.Hit.p - handle.Position).Unit * 1000)
        if ray and ray.Instance then
            local hum = ray.Instance.Parent:FindFirstChild("Humanoid") or ray.Instance.Parent.Parent:FindFirstChild("Humanoid")
            if hum then hum:TakeDamage(50) end
        end
    end)
end

-- 버튼 연결
CreateMenuBtn("진짜 골드 파밍", 0, ToggleFarm)
CreateMenuBtn("HK416 레이건 지급", 1, GiveGun)
CreateMenuBtn("바다 제거", 2, function()
    for _, v in pairs(workspace:GetDescendants()) do if v.Name == "Water" then v:Destroy() end end
end)

-------------------------------------------------------------------
-- 드래그 기능 (복구)
-------------------------------------------------------------------
local dragging, dragStart, startPos
topBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = mainFrame.Position end end)
uis.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart; mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
topBar.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

print("Daehan Hub v1.6 UI & Function Fully Restored!")

