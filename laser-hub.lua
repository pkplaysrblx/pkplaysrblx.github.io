function isNumber(str)
	if tonumber(str) ~= nil or str == 'inf' then
		return true
	end
end

local v = game:GetService("VirtualInputManager")

local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
local Notify = AkaliNotif.Notify;
local LocalPlayer = game.Players.LocalPlayer

local Bypass = function()
	if not hookmetamethod then 
		return Notify({ 
Description = "Your executor does not support 'hookmetamethod'.";
Title = "Laser Hub";
Duration = 5;
});
	end

	local checkcaller = checkcaller

	if not checkcaller then
		Notify({
        Description = "Your executor doesn't support checkcaller. We will return checkcaller as return false.";
        Title = "Laser Hub";
        Duration = 5;
        });
		checkcaller = function() return false end
		task.wait(2) -- thanks for overlapping, notifs :<
	end

	local AllowExecutorKicks = not (args[1] and args[1]:lower() == "false") -- some silly noobs might use "False" for the argument and then scream because their executor kicked them. also this logic statement sucks.

	local LocalPlayer = Players.LocalPlayer
	local KickFunctions = {"Kick", "kick"}

	for i,v in ipairs(KickFunctions) do -- prevents localscripts from sanity checking LocalPlayer.KiCk or some other combination of capitals that aren't an actual function
		local oldkick
		oldkick = hookfunction(game.Players.LocalPlayer[v], newcclosure(function(self, ...)
			if self == game.Players.LocalPlayer then
				if AllowExecutorKicks and checkcaller() then
					return oldkick(self, ...)
				else
					return
				end
			end
			return oldkick(self, ...)
		end))
	end

	local oldhmmnc
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
		if self == game.Players.LocalPlayer and table.find(KickFunctions, getnamecallmethod()) then
			if AllowExecutorKicks and checkcaller() then
				return oldhmmnc(self, ...)
			else
				return
			end
		end
		return oldhmmnc(self, ...)
	end)
end

Notify({
Description = "Thank you for using Laser Hub!";
Title = "Laser Hub";
Duration = 10;
});

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/pkplaysrblx/Orion-Library-Roblox-PE/refs/heads/main/i')))()
local Window = OrionLib:MakeWindow({Name = "Laser Hub | Super League Soccer", HidePremium = false, SaveConfig = true, ConfigFolder = "LaserHubSLS"})

local Tab = Window:MakeTab({
	Name = "Config",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddParagraph("Config","You can load configs in this tab. To do it, open your workspace folder and select the 'LaserHubSLS' folder. After, create the file with a '.lua' extension and put the config in there.")
Tab:AddParagraph("Loading Configs","If you have created the file with the '.lua' extension, enter the config name in the textbox below.")
Tab:AddParagraph("Warning","You have to put the config name properly like if your config name is 'Config.lua' then type 'Config.lua' in the box.")
Tab:AddTextbox({
	Name = "File Name",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
        Notify({
        Description = "Loading file 'LaserHubSLS/" .. Value .. "'.";
        Title = "Laser Client";
        Duration = 5;
        });
		loadfile('LaserHubSLS/' .. Value)
	end	  
})

function TPWalk(amount)
    local hb = game:GetService("RunService").Heartbeat
	tpwalking = true
	local chr = game.Players.LocalPlayer.Character
	local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
	while tpwalking and chr and hum and hum.Parent do
		local delta = hb:Wait()
		if hum.MoveDirection.Magnitude > 0 then
			if amount and isNumber(amount) then
				chr:TranslateBy(hum.MoveDirection * tonumber(amount) * delta * 10)
			else
				chr:TranslateBy(hum.MoveDirection * delta * 10)
			end
		end
	end
end

local Tab = Window:MakeTab({
	Name = "Bypass",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Bypass [NEED THIS ACTIVATED TO BYPASS AC]",
	Callback = function()
      		Bypass()
  	end    
})

local Tab = Window:MakeTab({
	Name = "Speed",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "TP Speed 1",
	Callback = function()
      		TPWalk(1)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 2",
	Callback = function()
      		TPWalk(2)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 3",
	Callback = function()
      		TPWalk(3)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 4",
	Callback = function()
      		TPWalk(4)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 5",
	Callback = function()
      		TPWalk(5)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 1",
	Callback = function()
      		TPWalk(1)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 6",
	Callback = function()
      		TPWalk(6)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 7",
	Callback = function()
      		TPWalk(7)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 8",
	Callback = function()
      		TPWalk(8)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 9",
	Callback = function()
      		TPWalk(9)
  	end    
})
Tab:AddButton({
	Name = "TP Speed 10",
	Callback = function()
      		TPWalk(10)
  	end    
})


local Tab = Window:MakeTab({
	Name = "Hitbox",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddLabel("Press T or the button below after you chose the settings.")

Tab:AddButton({
	Name = "Key Press [T]",
	Callback = function()
      		v:SendKeyEvent(true, Enum.KeyCode.T, false, game)
  	end    
})

local UserInputService = game:GetService("UserInputService")
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
        updateTransparency()
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

-- Function to update the transparency of clones
local function updateTransparency()
    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
        if part:IsA("Part") and part.Name:match("_Expanded") then
            part.Transparency = transparencyValue
        end
    end
end

-- Function to create and stabilize a helper part
local function createAndStabilizePart(part, size, name, transparency)
    local existingClone = part.Parent:FindFirstChild(name)
    if existingClone then
        existingClone:Destroy()
    end

    local clone = Instance.new("Part")
    clone.Size = size * sizeMultiplier -- Adjust size based on slider
    clone.CanCollide = false
    clone.Transparency = transparency
    clone.Name = name
    clone.Position = part.Position
    clone.Anchored = false
    clone.Parent = part.Parent

    local originalAttachment = Instance.new("Attachment")
    originalAttachment.Name = "OriginalAttachment"
    originalAttachment.Parent = part

    local cloneAttachment = Instance.new("Attachment")
    cloneAttachment.Name = "CloneAttachment"
    cloneAttachment.Parent = clone

    local alignPosition = Instance.new("AlignPosition")
    alignPosition.Attachment0 = cloneAttachment
    alignPosition.Attachment1 = originalAttachment
    alignPosition.RigidityEnabled = true
    alignPosition.Parent = clone

    local alignOrientation = Instance.new("AlignOrientation")
    alignOrientation.Attachment0 = cloneAttachment
    alignOrientation.Attachment1 = originalAttachment
    alignOrientation.RigidityEnabled = true
    alignOrientation.Parent = clone

    return clone
end

-- Function to expand parts
local function expandParts()
    local character = LocalPlayer.Character
    if character then
        local lowerTorso = character:FindFirstChild("LowerTorso")
        if lowerTorso then
            local lowerClone1 = createAndStabilizePart(lowerTorso, Vector3.new(20, 20, 20), "LowerTorso_Expanded", transparencyValue)
            local lowerClone2 = createAndStabilizePart(lowerClone1, Vector3.new(15, 15, 15), "LowerTorso_MidExpanded1", transparencyValue + 0.1)
            local lowerClone3 = createAndStabilizePart(lowerClone2, Vector3.new(6, 6, 6), "LowerTorso_HalfExpanded", transparencyValue + 0.2)
            createAndStabilizePart(lowerClone3, Vector3.new(3, 3, 3), "LowerTorso_MidExpanded2", transparencyValue + 0.3)
        end

        -- Additional parts expansion logic for other body parts remains unchanged
    end
end

-- Key bindings for testing
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.T then
        expandParts()
    end
end)

-- Initial test call
print("Script initialized! Press 'T' to expand parts.")
