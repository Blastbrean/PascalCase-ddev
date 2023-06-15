local VisualsTab = {}

-- Requires
local Pascal = require("../Modules/Helpers/Pascal.lua")

function VisualsTab:CreateElements()
	local TabBox = self.Tab:AddLeftTabbox("ESPTabBox")
	local SubTab1 = TabBox:AddTab("Enemy ESP")
	local SubTab2 = TabBox:AddTab("ESP Settings")
	local TabBox2 = self.Tab:AddRightTabbox("MiscVisualsTabBox")
	local SubTab1 = TabBox2:AddTab("Enemy Visuals")
	local SubTab2 = TabBox2:AddTab("Visual Settings")
end

function VisualsTab:Setup(Window, Library)
	-- Setup window / tab
	self.Window = Window
	self.Tab = Window:AddTab("Visuals")

	-- Create elements
	self:CreateElements()
end

return VisualsTab
