function isNumber(str)
	if tonumber(str) ~= nil or str == 'inf' then
		return true
	end
end

local v = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local Notify = AkaliNotif.Notify

Notify({
    Description = "Thank you for using Laser Hub!";
    Title = "Laser Hub";
    Duration = 10;
})

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/pkplaysrblx/Orion-Library-Roblox-PE/refs/heads/main/i')))()
local Window = OrionLib:MakeWindow({Name = "Laser Hub | Super League Soccer", HidePremium = false, SaveConfig = true, ConfigFolder = "LaserHubSLS"})

local Tab = Window:MakeTab({
    Name = "Hitbox",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Default values
local transparencyValue = 0.5
local increment = 0.1
local sizeMultiplier = 1.0

-- Add sliders for customization
Tab:AddSlider({
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

Tab:AddSlider({
    Name = "Increment",
    Min = 0.1,
    Max = 5,
    Default = increment,
    Increment = 0.1,
    ValueName = "",
    Callback = function(Value)
        increment = Value
    end
})

Tab:AddSlider({
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

-- Function to create and stabilize a helper part (hitbox)
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

-- Function to expand parts
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

-- Key bindings for testing
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        expandParts()
    end
end)

Tab:AddButton({
    Name = "Expand Hitbox [T]",
    Callback = function()
        expandParts()
    end
})

print("Script initialized! Press 'T' to expand parts.")
