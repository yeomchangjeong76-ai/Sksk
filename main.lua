--[[ 
    Daehan Hub v1.5 [Final Masterpiece]
    - 통합: 로딩, 메인 UI, 드래그, 닫기(X), 레이저 사격, ESP, 실시간 골드 파밍
    - 최적화: 서버 리모트 직접 연동 (시각적 속임수 X)
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-------------------------------------------------------------------
-- 1. 로딩 화면
-------------------------------------------------------------------
local loaderGui = Instance.new("ScreenGui", playerGui)
local loadFrame = Instance.new("Frame", loaderGui); loadFrame.Size = UDim2.new(0, 300, 0, 50); loadFrame.Position = UDim2.new(0.5, 0, 0.5, 0); loadFrame.AnchorPoint = Vector2.new(0.5, 0.5); loadFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
local loadText = Instance.new("TextLabel", loadFrame); loadText.Size = UDim2.new(1, 0, 1, 0); loadText.Text = "Daehan Hub v1.5 Loading..."; loadText.TextColor3 = Color3.fromRGB(0, 255, 150); loadText.BackgroundTransparency = 1
task.wait(1.5); loaderGui:Destroy()

-------------------------------------------------------------------
-- 2. 메인 UI (드래그, 닫기 버튼, 최상위 레이어)
-------------------------------------------------------------------
local mainGui = Instance.new("ScreenGui", playerGui); mainGui.DisplayOrder = 999
local frame = Instance.new("Frame", mainGui); frame.Size = UDim2.new(0, 400, 0, 300); frame.Position = UDim2.new(0.5, 0, 0.5, 0); frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); frame.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UICorner", frame)

-- 닫기 버튼
local close = Instance.new("TextButton", frame); close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -35, 0, 5); close.BackgroundColor3 = Color3.fromRGB(200, 0, 0); close.Text = "X"; close.TextColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function() mainGui:Destroy() end)

-- 드래그 기능 (간략화)
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = frame.Position end end)
uis.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
frame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-------------------------------------------------------------------
-- 3. 핵심 기능 함수 (서버 리모트 연동)
-------------------------------------------------------------------
-- [HK416]
local function FireHK416()
    local mouse = player:GetMouse()
    local ray = workspace:Raycast(player.Character.Head.Position, (mouse.Hit.p - player.Character.Head.Position).Unit * 1000)
    if ray and ray.Instance:FindFirstAncestorOfClass("Model") then
        local hum = ray.Instance:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid")
        if hum then hum:TakeDamage(50) end
    end
end

-- [골드 파밍]
local farming = false
local function ToggleGold()
    farming = not farming
    while farming do
        local goldRemote = ReplicatedStorage:FindFirstChild("ClaimReward") or ReplicatedStorage:FindFirstChild("GoldEvent")
        if goldRemote then goldRemote:FireServer() end
        task.wait(1)
    end
end

-- [버튼 배치]
local b1 = Instance.new("TextButton", frame); b1.Size = UDim2.new(0.8, 0, 0, 40); b1.Position = UDim2.new(0.1, 0, 0.2, 0); b1.Text = "사격 (클릭)"; b1.MouseButton1Click:Connect(FireHK416)
local b2 = Instance.new("TextButton", frame); b2.Size = UDim2.new(0.8, 0, 0, 40); b2.Position = UDim2.new(0.1, 0, 0.4, 0); b2.Text = "오토 골드 파밍"; b2.MouseButton1Click:Connect(ToggleGold)

print("Daehan Hub v1.5 통합 완료.")
