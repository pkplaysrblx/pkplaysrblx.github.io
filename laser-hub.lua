-- Helper Functions
function isNumber(str)
    if tonumber(str) ~= nil or str == 'inf' then
        return true
    end
end

-- Services
local v = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Notification Setup
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local Notify = AkaliNotif.Notify

Notify({
    Description = "Thank you for using Laser Hub!";
    Title = "Laser Hub";
    Duration = 10;
})

-- UI Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/pkplaysrblx/Orion-Library-Roblox-PE/refs/heads/main/i')))()
local Window = OrionLib:MakeWindow({Name = "Laser Hub | Super League Soccer", HidePremium = false, SaveConfig = true, ConfigFolder = "LaserHubSLS"})

-- Default Variables
local transparencyValue = 0.5
local increment = 0.1
local sizeMultiplier = 1.0
local tpwalking = false

-- Function Definitions
local function Bypass()
    if not hookmetamethod then
        return Notify({
            Description = "Your executor does not support 'hookmetamethod'.";
            Title = "Laser Hub";
            Duration = 5;
        })
    end

    local checkcaller = checkcaller or function() return false end

    local KickFunctions = {"Kick", "kick"}
    for _, v in ipairs(KickFunctions) do
        local oldKick = hookfunction(game.Players.LocalPlayer[v], function(self, ...)
            if self == LocalPlayer and not checkcaller() then
                return
            end
            return oldKick(self, ...)
        end)
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if self == LocalPlayer and table.find(KickFunctions, method) and not checkcaller() then
            return
        end
        return oldNamecall(self, ...)
    end)

    Notify({
        Description = "Bypass activated.";
        Title = "Laser Hub";
        Duration = 5;
    })
end

local function TPWalk(amount)
    tpwalking = true
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

    while tpwalking and character and humanoid and humanoid.Parent do
        local delta = RunService.Heartbeat:Wait()
        if humanoid.MoveDirection.Magnitude > 0 then
            character:TranslateBy(humanoid.MoveDirection * (amount or 1) * delta * 10)
        end
    end
end

local function expandHitbox(part, sizeMultiplier, transparencyValue)
    local existingClone = part.Parent:FindFirstChild(part.Name .. "_Hitbox")
    if existingClone then
        existingClone:Destroy()
    end

    local hitbox = Instance.new("Part")
    hitbox.Size = part.Size * sizeMultiplier
    hitbox.CanCollide = false
    hitbox.Transparency = transparencyValue
    hitbox.Name = part.Name .. "_Hitbox"
    hitbox.Position = part.Position
    hitbox.Anchored = false
    hitbox.Parent = part.Parent

    local originalAttachment = Instance.new("Attachment", part)
    local hitboxAttachment = Instance.new("Attachment", hitbox)

    local alignPosition = Instance.new("AlignPosition")
    alignPosition.Attachment0 = hitboxAttachment
    alignPosition.Attachment1 = originalAttachment
    alignPosition.RigidityEnabled = true
    alignPosition.Parent = hitbox

    local alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Attachment0 = hitboxAttachment
    alignOrientation.Attachment1 = originalAttachment
    alignOrientation.RigidityEnabled = true
    alignOrientation.Parent = hitbox

    return hitbox
end

local function expandParts()
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                expandHitbox(part, sizeMultiplier, transparencyValue)
            end
        end
    end
end

-- UI Tabs and Buttons
local configTab = Window:MakeTab({
    Name = "Config",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

configTab:AddParagraph("Config", "You can load configs in this tab. To do it, open your workspace folder and select the 'LaserHubSLS' folder. After, create the file with a '.lua' extension and put the config in there.")
configTab:AddTextbox({
    Name = "File Name",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        Notify({
            Description = "Loading file 'LaserHubSLS/" .. Value .. "'.";
            Title = "Laser Client";
            Duration = 5;
        })
        loadfile('LaserHubSLS/' .. Value)
    end
})

local bypassTab = Window:MakeTab({
    Name = "Bypass",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

bypassTab:AddButton({
    Name = "Bypass [NEED THIS ACTIVATED TO BYPASS AC]",
    Callback = function()
        Bypass()
    end
})

local speedTab = Window:MakeTab({
    Name = "Speed",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

for i = 1, 10 do
    speedTab:AddButton({
        Name = "TP Speed " .. i,
        Callback = function()
            TPWalk(i)
        end
    })
end

local hitboxTab = Window:MakeTab({
    Name = "Hitbox",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

hitboxTab:AddSlider({
    Name = "Transparency",
    Min = 0,
    Max = 1,
    Default = transparencyValue,
    Increment = 0.1,
    ValueName = "",
    Callback = function(Value)
        transparencyValue = Value
    end
})

hitboxTab:AddSlider({
    Name = "Size Multiplier",
    Min = 0.5,
    Max = 10,
    Default = sizeMultiplier,
    Increment = 0.1,
    ValueName = "x",
    Callback = function(Value)
        sizeMultiplier = Value
    end
})

hitboxTab:AddButton({
    Name = "Expand Hitbox [T]",
    Callback = function()
        expandParts()
    end
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        expandParts()
    end
end)

print("Script initialized! Press 'T' to expand parts.")
