local VisualsTab = {}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")

function VisualsTab:CreateElements()
	local TabBox = self.Tab:AddLeftTabbox("ESPTabBox")
	local SubTab1 = TabBox:AddTab("Enemy ESP")
	local SubTab2 = TabBox:AddTab("ESP Settings")

	SubTab1:AddToggle("EnableEnemyESP", {
		Text = "Enable ESP",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.enabled = Value
		end,
	})

	SubTab1:AddToggle("EnableBoxESP", {
		Text = "Enable Box ESP",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.box = Value
		end,
	})

	SubTab1:AddToggle("EnableHealthTextESP", {
		Text = "Enable Health Text",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.healthText = Value
		end,
	})

	SubTab1:AddToggle("EnableHealthBarESP", {
		Text = "Enable Health Bar",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.healthBar = Value
		end,
	})

	SubTab1:AddToggle("EnableNameESP", {
		Text = "Enable Name ESP",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.name = Value
		end,
	})

	SubTab1:AddToggle("EnableWeaponESP", {
		Text = "Enable Weapon ESP",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.weapon = Value
		end,
	})

	SubTab1:AddToggle("EnableDistanceESP", {
		Text = "Enable Distance ESP",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.distance = Value
		end,
	})

	local TabBox2 = self.Tab:AddRightTabbox("MiscVisualsTabBox")
	local VisualsSubTab1 = TabBox2:AddTab("Enemy Visuals")
	VisualsSubTab1:AddToggle("EnableTracerVisuals", {
		Text = "Enable Tracers",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.tracer = Value
		end,
	})

	VisualsSubTab1:AddToggle("EnableChams", {
		Text = "Enable Chams",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.chams = Value
		end,
	})

	VisualsSubTab1:AddToggle("EnableOffScreenArrows", {
		Text = "Enable Off-Screen Arrows",
		Default = false,
		Callback = function(Value)
			Pascal:GetSense().teamSettings.enemy.offScreenArrow = Value
		end,
	})

	local VisualsSubTab2 = TabBox2:AddTab("Visual Settings")
end

function VisualsTab:Setup(Window, Library)
	-- Setup window / tab
	self.Window = Window
	self.Tab = Window:AddTab("Visuals")

	-- Create elements
	self:CreateElements()
end

return VisualsTab
