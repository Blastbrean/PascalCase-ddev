local Menu = {}

-- Requires
local Library = require("../UI/Library/Library.lua")

-- Tabs
local SettingsTab = require("../UI/Tabs/SettingsTab.lua")
local MovementTab = require("../UI/Tabs/MovementTab.lua")
local CombatTab = require("../UI/Tabs/CombatTab.lua")
local VisualsTab = require("../UI/Tabs/VisualsTab.lua")

function Menu:Setup()
	-- Create Window
	self.Library = Library
	self.Window = Library:CreateWindow({
		Title = "PascalCase | Deepwoken Dev",
		Center = true,
		AutoShow = true,
	})

	-- Setup Tabs
	CombatTab:Setup(self.Window)
	MovementTab:Setup(self.Window)
	VisualsTab:Setup(self.Window)
	SettingsTab:Setup(self.Window, Library)
end

function Menu:Unload()
	Library:Unload()
end

return Menu
