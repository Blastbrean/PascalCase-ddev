local CombatTab = {}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")

-- Services
local HttpService = GetService("HttpService")

-- Configuration system for combat (this code is horrible, but i don't care enough right now. it works then it works.)
function CombatTab:LoadConfigurationFromName(Name)
	if not isfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. Name .. ".json") then
		Library:Notify(string.format("Unable to load config %s, file does not exist!", Name), 2.0)
		return
	end

	local JSONData = readfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. Name .. ".json")
	if not JSONData then
		Library:Notify(string.format("Unable to load config %s, failed to read file!", Name), 2.0)
		return
	end

	local ConfigData = HttpService:JSONDecode(JSONData)
	if not ConfigData or not ConfigData.BuilderSettingsList or not ConfigData.BlacklistedIdList then
		Library:Notify(string.format("Unable to load config %s, data may be corrupted!", Name), 2.0)
		return
	end

	Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList = ConfigData.BuilderSettingsList
	Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds = ConfigData.BlacklistedIdList
	Library:Notify(string.format("Successfully loaded config %s", Name), 2.0)
end

function CombatTab:CreateConfigurationWithName(Name)
	if typeof(Name) ~= "string" then
		Library:Notify(string.format("Unable to create config, name is invalid!"), 2.0)
		return
	end

	if isfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. Name .. ".json") then
		Library:Notify(string.format("Unable to create config, config already exists!"), 2.0)
		return
	end

	local ConfigData = {
		BuilderSettingsList = Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList,
		BlacklistedIdList = Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds,
	}

	local JSONData = HttpService:JSONEncode(ConfigData)
	writefile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. Name .. ".json", JSONData)
	Library:Notify(string.format("Successfully created config %s", Name), 2.0)
end

function CombatTab:SaveConfigurationWithName(Name)
	if typeof(Name) ~= "string" then
		Library:Notify(string.format("Unable to save config, name is invalid!"), 2.0)
		return
	end

	local ConfigData = {
		BuilderSettingsList = Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList,
		BlacklistedIdList = Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds,
	}

	local JSONData = HttpService:JSONEncode(ConfigData)
	writefile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. Name .. ".json", JSONData)
	Library:Notify(string.format("Successfully saved config %s", Name), 2.0)
end

function CombatTab:SetDefaultConfig(Name)
	if not isfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. Name .. ".json") then
		Library:Notify(string.format("Unable to set default config %s, file does not exist!", Name), 2.0)
		return
	end

	writefile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/Autoload.json", Name)
	Library:Notify(string.format("Config %s will auto-load on start-up!", Name), 2.0)
end

function CombatTab:LoadDefaultConfig()
	if not isfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/Autoload.json") then
		return
	end

	local ConfigToAutoload = readfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/Autoload.json")
	if not ConfigToAutoload then
		return
	end

	if not isfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. ConfigToAutoload .. ".json") then
		return
	end

	local JSONData = readfile(Pascal:GetConfigurationPath() .. "/CombatConfigurations/" .. ConfigToAutoload .. ".json")
	if not JSONData then
		return
	end

	local ConfigData = HttpService:JSONDecode(JSONData)
	if not ConfigData or not ConfigData.BuilderSettingsList or not ConfigData.BlacklistedIdList then
		Library:Notify(string.format("Unable to auto-load config, data may be corrupted!"), 2.0)
		return
	end

	Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList = ConfigData.BuilderSettingsList
	Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds = ConfigData.BlacklistedIdList
	Library:Notify(string.format('Auto loaded combat config "%s"', ConfigToAutoload), 2.0)
end

function CombatTab:GetConfigurationList()
	if not isfolder(Pascal:GetConfigurationPath() .. "/CombatConfigurations") then
		makefolder(Pascal:GetConfigurationPath() .. "/CombatConfigurations")
	end

	local list = listfiles(Pascal:GetConfigurationPath() .. "/CombatConfigurations")

	-- this part is pasted from SaveManager.lua
	local out = {}
	for i = 1, #list do
		local file = list[i]
		if file:sub(-5) == ".json" then
			-- i hate this but it has to be done ...

			local pos = file:find(".json", 1, true)
			local start = pos

			local char = file:sub(pos, pos)
			while char ~= "/" and char ~= "\\" and char ~= "" do
				pos = pos - 1
				char = file:sub(pos, pos)
			end

			if char == "/" or char == "\\" then
				local filename = file:sub(pos + 1, start - 1)
				if filename ~= "Autoload" then
					table.insert(out, filename)
				end
			end
		end
	end

	return out
end

function CombatTab:AutoParryGroup()
	local TabBox = self.Tab:AddLeftTabbox("AutoParry")
	local SubTab1 = TabBox:AddTab("Builder")

	SubTab1:AddInput("AnimationNickNameInput", {
		Numeric = false,
		Finished = false,
		Text = "Animation Nickname",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.NickName = Value
		end,
	})

	SubTab1:AddInput("AnimationIdInput", {
		Numeric = false,
		Finished = false,
		Text = "Animation ID",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.AnimationId = Value
		end,
	})

	SubTab1:AddSlider("MinimumDistanceSlider", {
		Text = "Minimum distance to activate",
		Default = 5,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Suffix = "m",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.MinimumDistance = Value
		end,
	})

	SubTab1:AddSlider("MaximumDistanceSlider", {
		Text = "Maximum distance to activate",
		Default = 15,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Suffix = "m",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.MaximumDistance = Value
		end,
	})

	SubTab1:AddInput("AttemptDelayInput", {
		Numeric = true,
		Finished = false,
		Text = "Delay until attempt (ms)",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.AttemptDelay = Value
		end,
	})

	SubTab1:AddToggle("RollInsteadOfParryToggle", {
		Text = "Roll instead of parry",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ShouldRoll = Value
		end,
	})

	local Depbox3 = SubTab1:AddDependencyBox()
	Depbox3:AddToggle("RollCancelToggle", {
		Text = "Roll-cancel instead of roll",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ShouldRollCancel = Value
		end,
	})

	local Depbox4 = SubTab1:AddDependencyBox()
	Depbox4:AddInput("RollCancelDelayInput", {
		Numeric = true,
		Finished = false,
		Text = "Roll-cancel delay (ms)",
		Tooltip = "This will cancel your roll after the specified time input.",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ParryRepeatDelay = Value
		end,
	})

	Depbox3:SetupDependencies({
		{ Toggles.RollInsteadOfParryToggle, true }, -- We can also pass `false` if we only want our features to show when the toggle is off!
	})

	Depbox4:SetupDependencies({
		{ Toggles.RollCancelToggle, true }, -- We can also pass `false` if we only want our features to show when the toggle is off!
		{ Toggles.RollInsteadOfParryToggle, true },
	})

	SubTab1:AddToggle("BlockInsteadOfParryToggle", {
		Text = "Block until animation ends",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ShouldBlock = Value
		end,
	})

	SubTab1:AddToggle("EnableParryRepeat", {
		Text = "Enable parry repeating",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ParryRepeat = Value
		end,
	})

	local Depbox = SubTab1:AddDependencyBox()
	Depbox:AddSlider("ParryRepeatSlider", {
		Text = "Parry repeat times",
		Default = 3,
		Min = 1,
		Max = 10,
		Rounding = 0,
		Compact = false,
		Suffix = "x",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ParryRepeatTimes = Value
		end,
	})

	Depbox:AddInput("ParryRepeatDelayInput", {
		Numeric = true,
		Finished = false,
		Text = "Delay between repeat parries (ms)",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ParryRepeatDelay = Value
		end,
	})

	Depbox:SetupDependencies({
		{ Toggles.EnableParryRepeat, true }, -- We can also pass `false` if we only want our features to show when the toggle is off!
	})

	local SubTab2 = TabBox:AddTab("Logger")

	SubTab2:AddToggle("EnableAutoParryLogging", {
		Text = "Enable info-logger",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.Enabled = Value
			Library:SetInfoLoggerVisibility(Value)
		end,
	})

	SubTab2:AddToggle("LogLocalPlayerToggle", {
		Text = "Allow logging yourself",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.LogYourself = Value
		end,
	})

	SubTab2:AddDropdown("LoggerTypeDropDown", {
		Values = { "Animations" },
		Default = 1,
		Multi = false,
		Text = "Logger Type",
		Tooltip = "The type decides what will be logged",
		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.Type = Value
		end,
	})

	local Depbox2 = SubTab2:AddDependencyBox()
	Depbox2:AddSlider("MinimumDistanceLogSlider", {
		Text = "Minimum distance to log",
		Default = 5,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Suffix = "m",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.MinimumDistance = Value
		end,
	})

	Depbox2:AddSlider("MaximumDistanceLogSlider", {
		Text = "Maximum distance to log",
		Default = 15,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Suffix = "m",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.MaximumDistance = Value
		end,
	})

	Depbox2:SetupDependencies({
		{ Toggles.EnableAutoParryLogging, true }, -- We can also pass `false` if we only want our features to show when the toggle is off!
	})

	local SubTab3 = TabBox:AddTab("Options")

	SubTab3:AddToggle("EnableAutoParryToggle", {
		Text = "Enable auto-parry",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			if Value == false then
				Library:Notify("You have enabled the SmartParry technology!", 3.0)
			end

			Pascal:GetConfig().AutoParry.Enabled = Value
		end,
	})

	SubTab3:AddDropdown("InputMethodDropdown", {
		Values = { "Remotes", "KeyEvents" },
		Default = 1,
		Multi = false,
		Text = "Input Method",
		Tooltip = "Using Remotes is usually more risky, as KeyEvents will simulate a key press instead.",
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.InputMethod = Value
		end,
	})

	SubTab3:AddToggle("EnableRunOnLocal", {
		Text = "Run auto-parry on local attacks",
		Default = false, -- Default value (true / false)
		Tooltip = "This feature can help you while testing your own attacks and timings.",
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.LocalAttackAutoParry = Value
		end,
	})

	SubTab3:AddToggle("EnableAutoFeintToggle", {
		Text = "Auto-feint attacks",
		Default = false, -- Default value (true / false)
		Tooltip = "This will automatically feint attacks when the user is swinging while auto-parry is active.",
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.AutoFeint = Value
		end,
	})

	SubTab3:AddToggle("EnableM1Hold", {
		Text = "M1 Hold",
		Default = false, -- Default value (true / false)
		Tooltip = "Allow yourself to simply hold down your attack button and swing automatically!",
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.HoldM1 = Value
		end,
	})

	SubTab3:AddToggle("EnableAutoTimeM1Toggle", {
		Text = "Delay M1s until animation ends",
		Default = false, -- Default value (true / false)
		Tooltip = "This feature is essentially block-input on Aztup, and it will block your M1s to re-time them.",
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.DelayM1 = Value
		end,
	})

	SubTab3:AddToggle("EnableLocalLookToggle", {
		Text = "Check if looking at enemy",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.IfLookingAtEnemy = Value
		end,
	})

	SubTab3:AddToggle("EnableEnemyLookToggle", {
		Text = "Check if enemy looks at you",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.EnemyLookingAtYou = Value
		end,
	})

	SubTab3:AddToggle("EnableRollOnFeints", {
		Text = "Roll on feints",
		Default = false, -- Default value (true / false)
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.RollOnFeints = Value
		end,
	})

	SubTab3:AddToggle("EnableBlatantRoll", {
		Text = "Blatant roll",
		Default = false, -- Default value (true / false)
		Tooltip = "Blatant roll calls the remote directly without doing roll checks, this makes you roll in place. This will call remotes if you are using KeyEvents.",
		Callback = function(Value)
			Pascal:GetConfig().AutoParry.BlatantRoll = Value
		end,
	})

	SubTab3:AddSlider("PingAdjustSlider", {
		Text = "Adjust timings by ping",
		Default = 25,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Suffix = "%",

		Callback = function(Value)
			Pascal:GetConfig().AutoParry.PingAdjust = Value
		end,
	})

	SubTab3:AddSlider("GlobalTimingAdjustSlider", {
		Text = "Adjust timings by slider",
		Default = 0,
		Min = -1000,
		Max = 1000,
		Rounding = 0,
		Compact = false,
		Suffix = "ms",

		Callback = function(Value)
			Pascal:GetConfig().AutoParry.AdjustTimingsBySlider = Value
		end,
	})

	SubTab3:AddSlider("GlobalDistanceAdjustSlider", {
		Text = "Adjust distances by slider",
		Default = 0,
		Min = -100,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Suffix = "m",

		Callback = function(Value)
			Pascal:GetConfig().AutoParry.AdjustDistancesBySlider = Value
		end,
	})

	SubTab3:AddSlider("HitchanceSlider", {
		Text = "Chance to activate auto-parry",
		Default = 100,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Suffix = "%",

		Callback = function(Value)
			Pascal:GetConfig().AutoParry.Hitchance = Value
		end,
	})
end

function CombatTab:BuilderSettingsGroup()
	local TabBox = self.Tab:AddRightTabbox("BuilderSettings")

	local SubTab1 = TabBox:AddTab("Settings")
	SubTab1:AddDropdown("BuilderSettingsList", {
		Values = CombatTab:UpdateBuilderSettingsList(),

		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		AllowNull = true,

		Text = "Builder settings list",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.CurrentActiveSettingString = Value

			local BuilderSetting = Pascal:GetBuilderSettingFromIdentifier(Value)
			if not BuilderSetting then
				return
			end

			Options.AnimationNickNameInput:SetValue(BuilderSetting.NickName)
			Options.AnimationIdInput:SetValue(BuilderSetting.AnimationId)
			Options.MinimumDistanceSlider:SetValue(BuilderSetting.MinimumDistance)
			Options.MaximumDistanceSlider:SetValue(BuilderSetting.MaximumDistance)
			Options.AttemptDelayInput:SetValue(BuilderSetting.AttemptDelay)
			Options.ParryRepeatSlider:SetValue(BuilderSetting.ParryRepeatTimes)
			Options.ParryRepeatDelayInput:SetValue(BuilderSetting.ParryRepeatDelay)
			Toggles.EnableParryRepeat:SetValue(BuilderSetting.ParryRepeat)
			Toggles.RollInsteadOfParryToggle:SetValue(BuilderSetting.ShouldRoll)
			Toggles.BlockInsteadOfParryToggle:SetValue(BuilderSetting.ShouldBlock)
		end,
	})

	SubTab1:AddButton("Register setting into list", function()
		local BuilderSettingsList = Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList

		if BuilderSettingsList[Pascal:GetConfig().AutoParryBuilder.AnimationId] then
			Library:Notify(
				string.format(
					"%s(%s) is already in list, cannot re-register it",
					Pascal:GetConfig().AutoParryBuilder.NickName,
					Pascal:GetConfig().AutoParryBuilder.AnimationId
				),
				2.5
			)

			return
		end

		-- Handle the builder settings list
		BuilderSettingsList[Pascal:GetConfig().AutoParryBuilder.AnimationId] = {
			Identifier = string.format(
				"%s | %s",
				Pascal:GetConfig().AutoParryBuilder.NickName,
				Pascal:GetConfig().AutoParryBuilder.AnimationId
			),

			NickName = Pascal:GetConfig().AutoParryBuilder.NickName,
			AnimationId = Pascal:GetConfig().AutoParryBuilder.AnimationId,
			MinimumDistance = Pascal:GetConfig().AutoParryBuilder.MinimumDistance,
			MaximumDistance = Pascal:GetConfig().AutoParryBuilder.MaximumDistance,
			AttemptDelay = Pascal:GetConfig().AutoParryBuilder.AttemptDelay,
			ShouldRoll = Pascal:GetConfig().AutoParryBuilder.ShouldRoll,
			ShouldBlock = Pascal:GetConfig().AutoParryBuilder.ShouldBlock,
			ParryRepeat = Pascal:GetConfig().AutoParryBuilder.ParryRepeat,
			ParryRepeatTimes = Pascal:GetConfig().AutoParryBuilder.ParryRepeatTimes,
			ParryRepeatDelay = Pascal:GetConfig().AutoParryBuilder.ParryRepeatDelay,
		}

		Library:Notify(
			string.format(
				"Registered %s(%s) into list",
				Pascal:GetConfig().AutoParryBuilder.NickName,
				Pascal:GetConfig().AutoParryBuilder.AnimationId
			),
			2.5
		)

		CombatTab:UpdateBuilderSettingsList()
	end)

	SubTab1:AddButton("Update setting from list", function()
		local BuilderSetting =
			Pascal:GetBuilderSettingFromIdentifier(Pascal:GetConfig().AutoParryBuilder.CurrentActiveSettingString)

		if not BuilderSetting then
			return
		end

		Library:Notify(
			string.format("Updated %s(%s) from list", BuilderSetting.NickName, BuilderSetting.AnimationId),
			2.5
		)

		-- Handle the builder settings list
		BuilderSetting.Identifier = string.format(
			"%s | %s",
			Pascal:GetConfig().AutoParryBuilder.NickName,
			Pascal:GetConfig().AutoParryBuilder.AnimationId
		)

		BuilderSetting.NickName = Pascal:GetConfig().AutoParryBuilder.NickName
		BuilderSetting.MinimumDistance = Pascal:GetConfig().AutoParryBuilder.MinimumDistance
		BuilderSetting.MaximumDistance = Pascal:GetConfig().AutoParryBuilder.MaximumDistance
		BuilderSetting.AttemptDelay = Pascal:GetConfig().AutoParryBuilder.AttemptDelay
		BuilderSetting.ShouldRoll = Pascal:GetConfig().AutoParryBuilder.ShouldRoll
		BuilderSetting.ShouldBlock = Pascal:GetConfig().AutoParryBuilder.ShouldBlock
		BuilderSetting.ParryRepeat = Pascal:GetConfig().AutoParryBuilder.ParryRepeat
		BuilderSetting.ParryRepeatTimes = Pascal:GetConfig().AutoParryBuilder.ParryRepeatTimes
		BuilderSetting.ParryRepeatDelay = Pascal:GetConfig().AutoParryBuilder.ParryRepeatDelay

		CombatTab:UpdateBuilderSettingsList()
		Options.BuilderSettingsList:SetValue(nil)
	end)

	SubTab1:AddButton("Delete setting from list", function()
		local BuilderSetting =
			Pascal:GetBuilderSettingFromIdentifier(Pascal:GetConfig().AutoParryBuilder.CurrentActiveSettingString)

		if not BuilderSetting then
			return
		end

		Library:Notify(
			string.format("Deleted %s(%s) from list", BuilderSetting.NickName, BuilderSetting.AnimationId),
			2.5
		)

		local BuilderSettingsList = Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList
		BuilderSettingsList[BuilderSetting.AnimationId] = nil

		CombatTab:UpdateBuilderSettingsList()
		Options.BuilderSettingsList:SetValue(nil)
	end)

	SubTab1:AddDropdown("BlacklistedAnimationIdsList", {
		Values = CombatTab:UpdateBlacklistedAnimationIdsList(),

		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		AllowNull = true,

		Text = "Blacklisted Animation IDs",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.CurrentActiveAnimationIdSetting = Value
		end,
	})

	SubTab1:AddInput("AnimationIdInputBlacklist", {
		Numeric = false,
		Finished = false,
		Text = "Hide Animation ID",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.CurrentAnimationIdBlacklist = Value
		end,
	})

	SubTab1:AddButton("Blacklist ID from logger", function()
		local ActiveAnimationIdValue =
			Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds[Pascal:GetConfig().AutoParryLogging.CurrentAnimationIdBlacklist]

		if ActiveAnimationIdValue == true then
			Library:Notify(
				string.format(
					"%s is already blacklisted from logging",
					Pascal:GetConfig().AutoParryLogging.CurrentAnimationIdBlacklist
				),
				2.5
			)

			return
		end

		Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds[Pascal:GetConfig().AutoParryLogging.CurrentAnimationIdBlacklist] =
			true

		Library:Notify(
			string.format(
				"Blacklisted %s from logging",
				Pascal:GetConfig().AutoParryLogging.CurrentAnimationIdBlacklist
			),
			2.5
		)

		CombatTab:UpdateBlacklistedAnimationIdsList()
	end)

	SubTab1:AddButton("Re-whitelist selected ID", function()
		local ActiveAnimationIdValue =
			Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds[Pascal:GetConfig().AutoParryLogging.CurrentActiveAnimationIdSetting]

		if ActiveAnimationIdValue == nil then
			Library:Notify(string.format("Active ID does not exist in the list (error)"), 2.5)
			return
		end

		if ActiveAnimationIdValue == false then
			Library:Notify(
				string.format(
					"%s is already whitelisted from logging",
					Pascal:GetConfig().AutoParryLogging.CurrentActiveAnimationIdSetting
				),
				2.5
			)

			return
		end

		Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds[Pascal:GetConfig().AutoParryLogging.CurrentActiveAnimationIdSetting] =
			false

		Library:Notify(
			string.format(
				"Re-whitelisted %s from logging",
				Pascal:GetConfig().AutoParryLogging.CurrentActiveAnimationIdSetting
			),
			2.5
		)

		CombatTab:UpdateBlacklistedAnimationIdsList()
		Options.BlacklistedAnimationIdsList:SetValue(nil)
	end)

	local SubTab2 = TabBox:AddTab("Transfering")

	SubTab2:AddDropdown("ConfigurationList", {
		Values = CombatTab:GetConfigurationList(),

		Default = 1, -- number index of the value / string
		Multi = false, -- true / false, allows multiple choices to be selected
		AllowNull = true,

		Text = "Configuration list",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryBuilder.ActiveConfigurationString = Value
		end,
	})

	SubTab2:AddInput("ConfigNameInput", {
		Numeric = false,
		Finished = false,
		Text = "Configuration name",

		Callback = function(Value)
			Pascal:GetConfig().AutoParryLogging.ActiveConfigurationNameString = Value
		end,
	})

	SubTab2
		:AddButton("Create config", function()
			CombatTab:CreateConfigurationWithName(Pascal:GetConfig().AutoParryLogging.ActiveConfigurationNameString)
			Options.ConfigurationList.Values = CombatTab:GetConfigurationList()
			Options.ConfigurationList:SetValues()
			Options.ConfigurationList:SetValue(nil)
		end)
		:AddButton("Load config", function()
			CombatTab:LoadConfigurationFromName(Pascal:GetConfig().AutoParryBuilder.ActiveConfigurationString)
			CombatTab:UpdateBuilderSettingsList()
			CombatTab:UpdateBlacklistedAnimationIdsList()
		end)

	SubTab2:AddButton("Save config", function()
		CombatTab:SaveConfigurationWithName(Pascal:GetConfig().AutoParryBuilder.ActiveConfigurationString)
	end)

	SubTab2:AddButton("Set as default config", function()
		CombatTab:SetDefaultConfig(Pascal:GetConfig().AutoParryBuilder.ActiveConfigurationString)
	end)

	SubTab2:AddButton("Refresh configuration list", function()
		Options.ConfigurationList.Values = CombatTab:GetConfigurationList()
		Options.ConfigurationList:SetValues()
		Options.ConfigurationList:SetValue(nil)
	end)
end

function CombatTab:CreateElements()
	self:AutoParryGroup()
	self:BuilderSettingsGroup()
end

function CombatTab:UpdateBlacklistedAnimationIdsList()
	local VisibleBlacklistedAnimationIds = {}

	for AnimationId, CurrentValue in next, Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds do
		-- Don't add this to the current list if it is whitelisted...
		if CurrentValue == false then
			continue
		end

		table.insert(VisibleBlacklistedAnimationIds, AnimationId)
	end

	if Options.BlacklistedAnimationIdsList then
		Options.BlacklistedAnimationIdsList.Values = VisibleBlacklistedAnimationIds
		Options.BlacklistedAnimationIdsList:SetValues()
	end

	return VisibleBlacklistedAnimationIds
end

function CombatTab:UpdateBuilderSettingsList()
	local VisibleBuilderSettingsList = {}

	for _, BuilderSettings in next, Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList do
		table.insert(VisibleBuilderSettingsList, BuilderSettings.Identifier)
	end

	if Options.BuilderSettingsList then
		Options.BuilderSettingsList.Values = VisibleBuilderSettingsList
		Options.BuilderSettingsList:SetValues()
	end

	return VisibleBuilderSettingsList
end

function CombatTab:Setup(Window)
	-- Setup window / tab
	self.Window = Window
	self.Tab = Window:AddTab("Combat")

	-- Load default config
	CombatTab:LoadDefaultConfig()

	-- Setup elements
	self:CreateElements()
end

return CombatTab
