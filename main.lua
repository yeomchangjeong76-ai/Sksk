--[[
    Daehan Hub v1.3 [Legendary Edition - Final Combined]
    - Real Kill HK416 (Remote Scan + Joint Destruction + Strong Velocity)
    - Infinite Gold (Value Lock + Remote Attempt + Stage Auto Farm)
    - Real-time ESP, Clean Professional UI
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------------------------
-- Loader GUI
-------------------------------------------------------------------
local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "DaehanLoader"
loaderGui.ResetOnSpawn = false
loaderGui.Parent = playerGui

local loadFrame = Instance.new("Frame", loaderGui)
loadFrame.Size = UDim2.new(0, 340, 0, 400)
loadFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", loadFrame).CornerRadius = UDim.new(0, 20)

local loadText = Instance.new("TextLabel", loadFrame)
loadText.Size = UDim2.new(1, 0, 0, 50)
loadText.Position = UDim2.new(0, 0, 0.6, 0)
loadText.Text = "Daehan Hub v1.3 Loading..."
loadText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadText.Font = Enum.Font.GothamBold
loadText.TextSize = 20
loadText.BackgroundTransparency = 1

local barBg = Instance.new("Frame", loadFrame)
barBg.Size = UDim2.new(0.8, 0, 0, 10)
barBg.Position = UDim2.new(0.1, 0, 0.75, 0)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", barBg)

local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
Instance.new("UICorner", barFill)

TweenService:Create(barFill, TweenInfo.new(1.8, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
task.wait(2)
loaderGui:Destroy()

-------------------------------------------------------------------
-- Main GUI
-------------------------------------------------------------------
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "DaehanHub"
mainGui.ResetOnSpawn = false
mainGui.Parent = playerGui

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size = UDim2.new(0, 600, 0, 380)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(0.65, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Text = "Daehan Hub v1.3 - Legendary Edition"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local closeButton = Instance.new("TextButton", topBar)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, 0)
closeButton.AnchorPoint = Vector2.new(0, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 22
Instance.new("UICorner", closeButton)

closeButton.MouseButton1Click:Connect(function() mainGui.Enabled = false end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        mainGui.Enabled = not mainGui.Enabled
    end
end)

-------------------------------------------------------------------
-- Remote Scanner
-------------------------------------------------------------------
local function GetTargetRemotes()
    local targets = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("damage") or n:find("hit") or n:find("kill") or n:find("shoot") or 
               n:find("gold") or n:find("coin") or n:find("money") or n:find("reward") then
                table.insert(targets, v)
            end
        end
    end
    return targets
end

-------------------------------------------------------------------
-- HK416 Real Kill (최대 조합)
-------------------------------------------------------------------
local function GiveHK416()
    local tool = Instance.new("Tool", player.Backpack)
    tool.Name = "🔥 HK416 [v1.3 Real Kill]"

    local handle = Instance.new("Part", tool)
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.5, 1, 3.5)
    Instance.new("SpecialMesh", handle).MeshId = "rbxassetid://4701290654"

    local remotes = GetTargetRemotes()

    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {player.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        local result = workspace:Raycast(handle.Position, (mouse.Hit.Position - handle.Position).Unit * 1500, rayParams)

        -- Visual Beam
        if result then
            local beam = Instance.new("Part", workspace)
            beam.Anchored = true
            beam.CanCollide = false
            beam.Material = Enum.Material.Neon
            beam.Color = Color3.fromRGB(255, 30, 30)
            beam.Size = Vector3.new(0.2, 0.2, (handle.Position - result.Position).Magnitude)
            beam.CFrame = CFrame.lookAt(handle.Position:Lerp(result.Position, 0.5), result.Position)
            Debris:AddItem(beam, 0.1)
        end

        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorWhichIsA("Model")
            if model and model \~= player.Character then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- Remote 시도
                    for _, r in ipairs(remotes) do
                        pcall(function() r:FireServer(hum, 9999, "HK416") end)
                    end

                    -- Joint Destruction (분해)
                    for _, j in pairs(model:GetDescendants()) do
                        if j:IsA("Motor6D") or j:IsA("Weld") or j:IsA("WeldConstraint") then
                            j:Destroy()
                        end
                    end

                    -- 강제 사망 + 물리
                    hum.Health = 0
                    hum:ChangeState(Enum.HumanoidStateType.Dead)

                    local root = hum.RootPart or model:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.AssemblyLinearVelocity = Vector3.new(0, -350, 0)
                        root.AssemblyAngularVelocity = Vector3.new(200, 200, 200)
                    end
                end
            end
        end
    end)
end

-------------------------------------------------------------------
-- Infinite Gold + Auto Farm
-------------------------------------------------------------------
local farming = false
local function EnableInfiniteGold()
    local data = player:FindFirstChild("Data") or player:WaitForChild("Data", 5)
    if not data then warn("[Daehan] Data not found") return end

    local goldNames = {"Gold", "Coins", "Money", "Cash", "Balance", "Currency"}

    local function Lock(v)
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            v.Value = 999999999
            v.Changed:Connect(function() v.Value = 999999999 end)
        end
    end

    for _, child in pairs(data:GetDescendants()) do
        if table.find(goldNames, child.Name) then Lock(child) end
    end

    data.DescendantAdded:Connect(function(c)
        if table.find(goldNames, c.Name) then Lock(c) end
    end)

    -- Remote 시도
    local remotes = GetTargetRemotes()
    for _, r in ipairs(remotes) do
        if r.Name:lower():find("gold") or r.Name:lower():find("coin") then
            pcall(function() r:FireServer(999999) end)
        end
    end

    print("[Daehan] Infinite Gold Locked + Remote Attempted")
end

local function ToggleAutoFarm()
    farming = not farming
    print("Auto Farm:", farming)

    task.spawn(function()
        while farming and task.wait(0.6) do
            local stages = workspace:FindFirstChild("BoatStages") or workspace:FindFirstChild("Stages")
            if stages and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                for i = 1, 12 do
                    if not farming then break end
                    local stage = stages:FindFirstChild("NormalStages") and stages.NormalStages:FindFirstChild("Stage"..i)
                    if stage and stage:FindFirstChild("GoldenChest") then
                        player.Character.HumanoidRootPart.CFrame = stage.GoldenChest.Part.CFrame + Vector3.new(0, 5, 0)
                        task.wait(0.8)
                    end
                end
            end
        end
    end)
end

-------------------------------------------------------------------
-- Real-time ESP
-------------------------------------------------------------------
local function ToggleESP()
    local enabled = not (getgenv and getgenv().DaehanESP or false)
    getgenv().DaehanESP = enabled

    for _, plr in pairs(Players:GetPlayers()) do
        if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            if plr.Character.Head:FindFirstChild("DaehanESP") then plr.Character.Head.DaehanESP:Destroy() end
            if enabled then
                local bg = Instance.new("BillboardGui", plr.Character.Head)
                bg.Name = "DaehanESP"
                bg.Size = UDim2.new(0, 220, 0, 60)
                bg.AlwaysOnTop = true

                local label = Instance.new("TextLabel", bg)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(0, 255, 120)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 15

                RunService.RenderStepped:Connect(function()
                    if not getgenv().DaehanESP or not bg.Parent then return end
                    if player.Character and player.Character:FindFirstChild("Head") and plr.Character and plr.Character:FindFirstChild("Head") then
                        local dist = math.floor((player.Character.Head.Position - plr.Character.Head.Position).Magnitude)
                        label.Text = plr.DisplayName .. " [" .. dist .. "m]"
                    end
                end)
            end
        end
    end
end

-------------------------------------------------------------------
-- Sidebar Buttons
-------------------------------------------------------------------
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 160, 1, -35)
sidebar.Position = UDim2.new(0, 0, 0, 35)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local function CreateButton(text, yOffset, callback)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, 25 + yOffset * 48)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

CreateButton("Give HK416 [Real Kill]", 0, GiveHK416)
CreateButton("Enable Infinite Gold", 1, EnableInfiniteGold)
CreateButton("Toggle Auto Farm", 2, ToggleAutoFarm)
CreateButton("Toggle Real-time ESP", 3, ToggleESP)
CreateButton("Remove Water", 4, function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Water" or v:IsA("Terrain") then v:Destroy() end
    end
    print("Water/Terrain Removed")
end)

print("Daehan Hub v1.3 Final Combined Loaded Successfully")
