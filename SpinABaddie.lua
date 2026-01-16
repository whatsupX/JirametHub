local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Xan = loadstring(game:HttpGet("https://xan.bar/init.lua"))()

local Config = {
    AutoRoll = false,
    AutoPlaceBest = false,
    RollThreads = 5
}

local LastPlaceTime = 0
local ActiveSystems = 0

-[span_5](start_span)- ฟังก์ชันอัปเดต Watermark และสถานะ[span_5](end_span)
local function UpdateWatermark()
    if watermark then
        [span_6](start_span)watermark.Text = "🎲 Jiramet Hub | Active: " .. ActiveSystems[span_6](end_span)
    end
    if statusLabel2 then
        [span_7](start_span)statusLabel2:SetText("Active Systems: " .. ActiveSystems)[span_7](end_span)
    end
end

-[span_8](start_span)- สร้าง Watermark[span_8](end_span)
local function CreateWatermark()
    local screenGui = Instance.new("ScreenGui")
    [span_9](start_span)screenGui.Name = "JirametWatermark"[span_9](end_span)
    screenGui.DisplayOrder = 9999
    [span_10](start_span)screenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")[span_10](end_span)
    
    local watermark = Instance.new("TextLabel")
    watermark.Name = "Watermark"
    watermark.Text = "🎇 Jiramet Hub"
    watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
    watermark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    watermark.BackgroundTransparency = 0.5
    watermark.Size = UDim2.new(0, 120, 0, 25)
    watermark.Position = UDim2.new(1, -130, 0, 10)
    watermark.Parent = screenGui
    return watermark
end

local watermark = CreateWatermark()

local Window = Xan.New({
    Title = "Jiramet Hub",
    Theme = "Midnight",
    Size = UDim2.fromOffset(580, 420)
})

local MainTab = Window:AddTab("🏠 Main", "home")
MainTab:AddSection("🤖 Automation Systems")

-[span_11](start_span)- ระบบ Fast Roll[span_11](end_span)
MainTab:AddToggle("🎲 Fast Roll", {
    Default = false,
    Flag = "AutoRoll"
}, function(state)
    [span_12](start_span)Config.AutoRoll = state[span_12](end_span)
    if state then
        ActiveSystems = ActiveSystems + 1
        for i = 1, Config.RollThreads do
            task.spawn(function()
                while Config.AutoRoll do
                    pcall(function()
                        [span_13](start_span)LocalPlayer.PlayerGui.Main.Dice.RollState:InvokeServer()[span_13](end_span)
                    end)
                    task.wait()
                end
            end)
        end
    else
        ActiveSystems = ActiveSystems - 1
    end
    UpdateWatermark()
end)

-[span_14](start_span)- ระบบ Auto Place Best (ปรับปรุงเป็น 30 วินาที)[span_14](end_span)
MainTab:AddToggle("🧠 Auto Place Best", {
    Default = false,
    Flag = "AutoPlaceBest"
}, function(state)
    Config.AutoPlaceBest = state
    if state then
        ActiveSystems = ActiveSystems + 1
        task.spawn(function()
            while Config.AutoPlaceBest do
                pcall(function()
                    [span_15](start_span)ReplicatedStorage.Events.PlaceBestBaddies:InvokeServer()[span_15](end_span)
                    [span_16](start_span)LastPlaceTime = tick()[span_16](end_span)
                end)
                task.wait(30) -- ปรับเป็น 30 วินาทีตามที่ต้องการ
            end
        end)
    else
        ActiveSystems = ActiveSystems - 1
    end
    UpdateWatermark()
end)

MainTab:AddSection("⚙️ Settings")
MainTab:AddSlider("Roll Threads", {
    Min = 1,
    Max = 10,
    Default = 5,
    Flag = "RollThreads"
}, function(value)
    Config.RollThreads = value
end)

MainTab:AddSection("📊 Status Info")
local statusLabel1 = MainTab:AddLabel("Last Place Time: 0s")
local statusLabel2 = MainTab:AddLabel("Active Systems: 0")

-[span_17](start_span)- อัปเดตสถานะ Last Place Time[span_17](end_span)
task.spawn(function()
    while true do
        if statusLabel1 then
            if LastPlaceTime > 0 then
                [span_18](start_span)local elapsed = math.floor(tick() - LastPlaceTime)[span_18](end_span)
                [span_19](start_span)statusLabel1:SetText("Last Place: " .. elapsed .. "s ago")[span_19](end_span)
            else
                [span_20](start_span)statusLabel1:SetText("Last Place: Never")[span_20](end_span)
            end
        end
        task.wait(1)
    end
end)

[span_21](start_span)UpdateWatermark()[span_21](end_span)
Xan.Success("Jiramet Hub", "Loaded Successfully!")
