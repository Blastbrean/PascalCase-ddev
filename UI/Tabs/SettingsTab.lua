local SettingsTab = {}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")
local ThemeManager = require("UI/Library/ThemeManager")
local SaveManager = require("UI/Library/SaveManager")

function SettingsTab:SetupSaveManager(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetFolder(Pascal:GetConfigurationPath())
	SaveManager:BuildConfigSection(self.Tab)
	SaveManager:LoadAutoloadConfig()
end

function SettingsTab:SetupThemeManager(Library)
	ThemeManager:SetLibrary(Library)
	ThemeManager:SetFolder(Pascal:GetConfigurationPath())
	ThemeManager:ApplyToTab(self.Tab)
end

function SettingsTab:CreateElements(Library)
	local MenuGroup = self.Tab:AddLeftGroupbox("Script settings")

	MenuGroup:AddToggle("ShowKeyBindsToggle", {
		Text = "Show keybinds",
		Default = false,
		Callback = function(Value)
			Library:SetKeybindVisibility(Value)
		end,
	})

	MenuGroup:AddButton("Unload script", function()
		Library:Unload()
		Pascal:GetEnvironment().ShutdownScript = true
	end)

	MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "End", NoUI = true, Text = "Menu keybind" })
end

function SettingsTab:Setup(Window, Library)
	-- Setup window / tab
	self.Window = Window
	self.Tab = Window:AddTab("Settings")

	-- Setup actual tab in menu
	self:CreateElements(Library)
	self:SetupSaveManager(Library)
	self:SetupThemeManager(Library)

	-- Setup library keybind
	Library.ToggleKeybind = Options.MenuKeybind
end

return SettingsTab
