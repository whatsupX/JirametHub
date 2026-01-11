local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Xan = loadstring(game:HttpGet("https://xan.bar/init.lua"))()

local Config = {
    AutoRoll = false,
    AutoSell = false,
    AutoPlaceBest = false,
    AutoInfEgg = false,
    AutoDiamondDice = false,

    RollThreads = 5,
    DiamondThreads = 10,

    ItemName = "Basic Dice",
    ItemType = "dice",
    ItemPrice = 300,

    EggName = "MartianEgg",
    EggAmount = 100
}

local LastPlaceTime = 0
_G.MoneyValue = nil

local Window = Xan.New({
    Title = "Jiramet Hub",
    Theme = "Midnight",
    Size = UDim2.fromOffset(580, 420),
    ShowUserInfo = true,
    ShowActiveList = true
})

local HomeTab = Window:AddTab("🏠 Overview", "home")
local AutoTab = Window:AddTab("⚙️ Automation", "settings")

HomeTab:AddSection("💰 Money")

HomeTab:AddInput("Money Amount", {
    Placeholder = "Enter amount..."
}, function(v)
    _G.MoneyValue = tonumber(v)
end)

HomeTab:AddButton("💸 Give Money", function()
    if not _G.MoneyValue then return end
    local calc = -(_G.MoneyValue / Config.ItemPrice)
    ReplicatedStorage.Events.buy:InvokeServer(
        Config.ItemName,
        calc,
        Config.ItemType
    )
end)

HomeTab:AddSection("💎 Diamond Dice")

HomeTab:AddToggle("💠 Auto Diamond Dice", {
    Default = false,
    Flag = "AutoDiamondDice"
}, function(state)
    Config.AutoDiamondDice = state
    if state then
        for i = 1, Config.DiamondThreads do
            task.spawn(function()
                while Config.AutoDiamondDice do
                    pcall(function()
                        ReplicatedStorage.Events.DontLeave:InvokeServer()
                    end)
                    task.wait()
                end
            end)
        end
    end
end)

AutoTab:AddSection("🤖 Automation")

AutoTab:AddToggle("🎲 Fast Roll", {
    Default = false,
    Flag = "AutoRoll"
}, function(state)
    Config.AutoRoll = state
    if state then
        for i = 1, Config.RollThreads do
            task.spawn(function()
                while Config.AutoRoll do
                    pcall(function()
                        LocalPlayer.PlayerGui.Main.Dice.RollState:InvokeServer()
                    end)
                    task.wait()
                end
            end)
        end
    end
end)

AutoTab:AddToggle("🧠 Auto Place Best", {
    Default = false,
    Flag = "AutoPlaceBest"
}, function(state)
    Config.AutoPlaceBest = state
end)

AutoTab:AddToggle("💼 Auto Sell", {
    Default = false,
    Flag = "AutoSell"
}, function(state)
    Config.AutoSell = state
end)

AutoTab:AddToggle("🥚 Auto Best Egg", {
    Default = false,
    Flag = "AutoInfEgg"
}, function(state)
    Config.AutoInfEgg = state
end)

task.spawn(function()
    while true do
        if Config.AutoPlaceBest then
            ReplicatedStorage.Events.PlaceBestBaddies:InvokeServer()
            LastPlaceTime = tick()
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoSell then
            if Config.AutoPlaceBest then
                local diff = tick() - LastPlaceTime
                if diff < 2 then
                    task.wait(2 - diff)
                end
            end
            ReplicatedStorage.Events.sell:InvokeServer("all")
        end
        task.wait(5)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoInfEgg then
            local target = 100000000000000
            local calc = -(target / Config.ItemPrice)

            ReplicatedStorage.Events.buy:InvokeServer(
                Config.ItemName,
                calc,
                Config.ItemType
            )

            pcall(function()
                ReplicatedStorage.Events.RegularPet:InvokeServer(
                    Config.EggName,
                    Config.EggAmount
                )
            end)

            task.wait(0.1)
        else
            task.wait(1)
        end
    end
end)