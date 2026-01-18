-- SERVICES
local Players = game:GetService(&#34;Players&#34;)
local player = Players.LocalPlayer

-- STATE
local enabled = false
local running = false

-- CHARACTER
local function getHRP()
    return player.Character
        and player.Character:WaitForChild(&#34;HumanoidRootPart&#34;)
end

-- FIND CLOSEST COIN
local function getClosestCoin()
    local hrp = getHRP()
    if not hrp then return end

    local closest, shortest = nil, math.huge

    for _, model in ipairs(workspace.EventParts:GetChildren()) do
        if model:IsA(&#34;Model&#34;) and model.Name == &#34;Radioactive Coin&#34; then
            local part = model.PrimaryPart
            if part then
                local dist = (part.Position - hrp.Position).Magnitude
                if dist &lt; shortest then
                    shortest = dist
                    closest = model
                end
            end
        end
    end

    return closest
end

-- MAIN LOOP
task.spawn(function()
    while true do
        task.wait()

        if enabled and not running then
            running = true

            while enabled do
                local coin = getClosestCoin()
                if not coin then
                    warn(&#34;No more Radioactive Coins&#34;)
                    enabled = false
                    break
                end

                local hrp = getHRP()
                local part = coin.PrimaryPart

                if hrp and part then
                    -- ABOVE coin
                    hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    task.wait()

                    -- THROUGH coin (touch guaranteed)
                    hrp.CFrame = part.CFrame
                    task.wait()

                    -- BELOW coin (extra safety)
                    hrp.CFrame = part.CFrame - Vector3.new(0, 2, 0)
                end
            end

            running = false
        end
    end
end)

-- ================= GUI =================

local gui = Instance.new(&#34;ScreenGui&#34;)
gui.Name = &#34;RadioCoinGUI&#34;
gui.Parent = player:WaitForChild(&#34;PlayerGui&#34;)
gui.ResetOnSpawn = false

local button = Instance.new(&#34;TextButton&#34;)
button.Size = UDim2.fromScale(0.2, 0.08)
button.Position = UDim2.fromScale(0.02, 0.4)
button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextScaled = true
button.Text = &#34;Radio Coin: OFF&#34;
button.Parent = gui

-- DRAGGABLE
button.Active = true
button.Draggable = true

-- TOGGLE
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and &#34;Radio Coin: ON&#34; or &#34;Radio Coin: OFF&#34;
end)
