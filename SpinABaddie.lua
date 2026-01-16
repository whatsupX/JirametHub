[span_4](start_span)local Players = game:GetService("Players")[span_4](end_span)
[span_5](start_span)local ReplicatedStorage = game:GetService("ReplicatedStorage")[span_5](end_span)
[span_6](start_span)local LocalPlayer = Players.LocalPlayer[span_6](end_span)

[span_7](start_span)local Xan = loadstring(game:HttpGet("https://xan.bar/init.lua"))()[span_7](end_span)

local Config = {
    AutoRoll = false,
    AutoPlaceBest = false,
    RollThreads = 5
[span_8](start_span)}

local LastPlaceTime = 0[span_8](end_span)
[span_9](start_span)local ActiveSystems = 0[span_9](end_span)

-- 1. ย้ายฟังก์ชันอัปเดตมาไว้ด้านบนเพื่อแก้ Error (attempt to call a nil value)
local watermark -- ประกาศตัวแปรไว้ก่อน
local statusLabel2

[span_10](start_span)local function UpdateWatermark()[span_10](end_span)
    if watermark then
        [span_11](start_span)watermark.Text = "🎲 Jiramet Hub | Active: " .. ActiveSystems[span_11](end_span)
    end
    if statusLabel2 then
        [span_12](start_span)statusLabel2:SetText("Active Systems: " .. ActiveSystems)[span_12](end_span)
    end
[span_13](start_span)end[span_13](end_span)

-- 2. สร้าง Watermark
[span_14](start_span)local function CreateWatermark()[span_14](end_span)
    [span_15](start_span)local screenGui = Instance.new("ScreenGui")[span_15](end_span)
    [span_16](start_span)screenGui.Name = "JirametWatermark"[span_16](end_span)
    [span_17](start_span)screenGui.DisplayOrder = 9999[span_17](end_span)
    [span_18](start_span)screenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")[span_18](end_span)
    
    [span_19](start_span)local label = Instance.new("TextLabel")[span_19](end_span)
    [span_20](start_span)label.Name = "Watermark"[span_20](end_span)
    [span_21](start_span)label.Text = "🎇 Jiramet Hub"[span_21](end_span)
    [span_22](start_span)label.TextColor3 = Color3.fromRGB(255, 255, 255)[span_22](end_span)
    [span_23](start_span)label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)[span_23](end_span)
    [span_24](start_span)label.BackgroundTransparency = 0.5[span_24](end_span)
    [span_25](start_span)label.Size = UDim2.new(0, 120, 0, 25)[span_25](end_span)
    [span_26](start_span)label.Position = UDim2.new(1, -130, 0, 10)[span_26](end_span)
    [span_27](start_span)label.Parent = screenGui[span_27](end_span)
    
    return label
end

[span_28](start_span)watermark = CreateWatermark()[span_28](end_span)

local Window = Xan.New({
    Title = "Jiramet Hub",
    Theme = "Midnight",
    Size = UDim2.fromOffset(580, 420)
[span_29](start_span)})[span_29](end_span)

[span_30](start_span)local MainTab = Window:AddTab("🏠 Main", "home")[span_30](end_span)
[span_31](start_span)MainTab:AddSection("🤖 Automation Systems")[span_31](end_span)

-- 3. ระบบ Fast Roll
MainTab:AddToggle("🎲 Fast Roll", {
    Default = false,
    Flag = "AutoRoll"
[span_32](start_span)}, function(state)[span_32](end_span)
    [span_33](start_span)Config.AutoRoll = state[span_33](end_span)
    if state then
        [span_34](start_span)ActiveSystems = ActiveSystems + 1[span_34](end_span)
        [span_35](start_span)for i = 1, Config.RollThreads do[span_35](end_span)
            [span_36](start_span)task.spawn(function()[span_36](end_span)
                [span_37](start_span)while Config.AutoRoll do[span_37](end_span)
                    [span_38](start_span)pcall(function()[span_38](end_span)
                        [span_39](start_span)LocalPlayer.PlayerGui.Main.Dice.RollState:InvokeServer()[span_39](end_span)
                    end)
                    [span_40](start_span)task.wait()[span_40](end_span)
                end
            end)
        end
    else
        [span_41](start_span)ActiveSystems = ActiveSystems - 1[span_41](end_span)
    end
    [span_42](start_span)UpdateWatermark()[span_42](end_span)
end)

-- 4. ระบบ Auto Place Best (ปรับเป็น 30 วินาที)
MainTab:AddToggle("🧠 Auto Place Best", {
    Default = false,
    Flag = "AutoPlaceBest"
[span_43](start_span)}, function(state)[span_43](end_span)
    [span_44](start_span)Config.AutoPlaceBest = state[span_44](end_span)
    if state then
        [span_45](start_span)ActiveSystems = ActiveSystems + 1[span_45](end_span)
        [span_46](start_span)task.spawn(function()[span_46](end_span)
            [span_47](start_span)while Config.AutoPlaceBest do[span_47](end_span)
                [span_48](start_span)pcall(function()[span_48](end_span)
                    [span_49](start_span)ReplicatedStorage.Events.PlaceBestBaddies:InvokeServer()[span_49](end_span)
                    [span_50](start_span)LastPlaceTime = tick()[span_50](end_span)
                end)
                [span_51](start_span)task.wait(30) -- ปรับเป็น 30 วินาทีตามต้องการ[span_51](end_span)
            end
        end)
    else
        [span_52](start_span)ActiveSystems = ActiveSystems - 1[span_52](end_span)
    end
    [span_53](start_span)UpdateWatermark()[span_53](end_span)
end)

[span_54](start_span)MainTab:AddSection("⚙️ Settings")[span_54](end_span)
MainTab:AddSlider("Roll Threads", {
    Min = 1, Max = 10, Default = 5, Flag = "RollThreads"
[span_55](start_span)}, function(value)[span_55](end_span)
    [span_56](start_span)Config.RollThreads = value[span_56](end_span)
end)

[span_57](start_span)MainTab:AddSection("📊 Status Info")[span_57](end_span)
[span_58](start_span)local statusLabel1 = MainTab:AddLabel("Last Place: Never")[span_58](end_span)
[span_59](start_span)statusLabel2 = MainTab:AddLabel("Active Systems: 0")[span_59](end_span)

-- 5. ลูปอัปเดตเวลาที่ผ่านไป
[span_60](start_span)task.spawn(function()[span_60](end_span)
    while true do
        [span_61](start_span)if LastPlaceTime > 0 then[span_61](end_span)
            [span_62](start_span)local elapsed = math.floor(tick() - LastPlaceTime)[span_62](end_span)
            [span_63](start_span)statusLabel1:SetText("Last Place: " .. elapsed .. "s ago")[span_63](end_span)
        end
        [span_64](start_span)task.wait(1)[span_64](end_span)
    end
end)

[span_65](start_span)UpdateWatermark()[span_65](end_span)
[span_66](start_span)Xan.Success("Jiramet Hub", "Loaded Successfully!")[span_66](end_span)
