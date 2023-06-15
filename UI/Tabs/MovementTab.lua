local MovementTab = {}

-- Requires
local Pascal = require("../Modules/Helpers/Pascal.lua")

function MovementTab:CreateElements()
	local LeftGroupBox = self.Tab:AddLeftGroupbox("Player")

	LeftGroupBox:AddToggle("WalkSpeedOverrideToggle", {
		Text = "Walk-speed override",
		Default = false,

		Callback = function(Value)
			Pascal:GetConfig().Movement.WalkSpeedOverride = Value
		end,
	})

	LeftGroupBox:AddSlider("WalkSpeedOverrideSlider", {
		Text = "Walk-speed override amount",
		Default = 16.0,
		Min = 0.0,
		Max = 200.0,
		Rounding = 1,
		Compact = false,
		Suffix = "ws",

		Callback = function(Value)
			Pascal:GetConfig().Movement.WalkSpeedOverrideAmount = Value
		end,
	})

	LeftGroupBox:AddToggle("JumpPowerOverrideToggle", {
		Text = "Jump-power override",
		Default = false,

		Callback = function(Value)
			Pascal:GetConfig().Movement.JumpPowerOverride = Value
		end,
	})

	LeftGroupBox:AddSlider("JumpPowerOverrideSlider", {
		Text = "Jump-power override amount",
		Default = 20.0,
		Min = 0.0,
		Max = 200.0,
		Rounding = 1,
		Compact = false,
		Suffix = "jp",

		Callback = function(Value)
			Pascal:GetConfig().Movement.JumpPowerOverrideAmount = Value
		end,
	})

	LeftGroupBox:AddToggle("NoclipToggle", {
		Text = "Phase through objects",
		Default = false,

		Callback = function(Value)
			Pascal:GetConfig().Movement.NoClip = Value
		end,
	})

	LeftGroupBox:AddToggle("InfiniteJumpToggle", {
		Text = "Infinite-jump",
		Default = false,

		Callback = function(Value)
			Pascal:GetConfig().Movement.InfiniteJump = Value
		end,
	})

	LeftGroupBox:AddToggle("FlyToggle", {
		Text = "Fly-hack",
		Default = false,

		Callback = function(Value)
			Pascal:GetConfig().Movement.Fly = Value
		end,
	})
end

function MovementTab:Setup(Window, Library)
	-- Setup window / tab
	self.Window = Window
	self.Tab = Window:AddTab("Movement")

	-- Create elements
	self:CreateElements()
end

return MovementTab
