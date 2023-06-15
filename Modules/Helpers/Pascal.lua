-- Our environment
local Pascal = {}

-- Methods (thank Hydroxide for these)
local Methods = {
	GetGenv = getgenv,
	NewCClosure = newcclosure,
	GetRawMetatable = getrawmetatable,
	GetInfo = getinfo or debug.getinfo,
	CheckCaller = checkcaller,
	HookMetaMethod = hookmetamethod,
	HookFunction = hookfunction,
	GetNameCallMethod = getnamecallmethod or get_namecall_method,
	GetUpValue = getupvalue or debug.getupvalue,
	GetUpValues = getupvalues or debug.getupvalues,
	SetUpValue = setupvalue or debug.setupvalue,
	IsXClosure = is_synapse_function
		or issentinelclosure
		or is_protosmasher_closure
		or is_sirhurt_closure
		or iselectronfunction
		or istempleclosure
		or iskrnlclosure
		or isexecutorclosure
		or checkclosure,
}

-- Hotfix for HookMetaMethod...
if not Methods.HookMetaMethod and Methods.HookFunction and Methods.GetRawMetatable then
	Methods.HookMetaMethod = function(Object, MetaMethod, NewFunction)
		-- Get object's metatable...
		local MetaTable = Methods.GetRawMetatable(Object)

		-- Hook metamethod function inside of metatable, and replace it with our new function...
		-- We will also return the original...
		return Methods.HookFunction(MetaTable[MetaMethod], NewFunction)
	end
end

-- Default settings
local DefaultSettings = {
	Movement = {
		WalkSpeedOverride = false,
		WalkSpeedOverrideAmount = 16.0,
		JumpPowerOverride = false,
		JumpPowerOverrideAmount = 20.0,
		NoClip = false,
		InfiniteJump = false,
		Fly = false,
	},
	AutoParry = {
		Enabled = true,
		InputMethod = "Remotes",
		AutoFeint = false,
		DelayM1 = false,
		IfLookingAtEnemy = false,
		EnemyLookingAtYou = false,
		LocalAttackAutoParry = false,
		RollOnFeints = false,
		BlatantRoll = false,
		PingAdjust = 25.0,
		Hitchance = 100.0,
	},
	AutoParryBuilder = {
		NickName = "",
		AnimationId = "",
		MinimumDistance = 5.0,
		MaximumDistance = 15.0,
		AttemptDelay = 150.0,
		ShouldRoll = false,
		ShouldBlock = false,
		ParryRepeat = false,
		ParryRepeatTimes = 3,
		ParryRepeatDelay = 150.0,
		BuilderSettingsList = {},
		CurrentActiveSettingString = nil,
	},
	AutoParryLogging = {
		Enabled = false,
		Type = "Animations",
		CurrentAnimationIdBlacklist = "",
		BlacklistedAnimationIds = {},
		MinimumDistance = 5.0,
		MaximumDistance = 15.0,
		LockLoggerToPlayer = false,
		LockedPlayers = {},
		ActiveConfigurationString = {},
	},
}

-- Requires
local Logger = require("Modules/Logging/Logger")
local EffectReplication = require("Modules/Deepwoken/EffectReplication")
local Helper = require("Modules/Helpers/Helper")

-- Variables
local LoggerObject = Logger:New()
local EffectReplicator = EffectReplication:New()

function Pascal:GetConfigurationPath()
	return "PascalCase/DeepwokenDev"
end

function Pascal:GetBuilderSettingFromIdentifier(Identifier)
	return Helper.LoopLuaTable(Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList, function(Index, BuilderSetting)
		if BuilderSetting.Identifier ~= Identifier then
			return false
		end

		return {
			ReturningData = true,
			Data = BuilderSetting,
		}
	end)
end

function Pascal:GetLogger()
	return LoggerObject
end

function Pascal:GetEffectReplicator()
	return EffectReplicator
end

function Pascal:GetEnvironment()
	local Environment = getgenv()
	return Environment
end

function Pascal:Reset()
	self:GetEnvironment().Settings = nil

	if self:IsScriptShuttingDown() then
		self:GetEnvironment().ShutdownScript = false
		self:GetEffectReplicator():Disconnect()
	end
end

function Pascal:GetConfig()
	if not self:GetEnvironment().Settings then
		self:GetEnvironment().Settings = DefaultSettings
	end

	return self:GetEnvironment().Settings
end

function Pascal:CheckForAllMethods()
	return Helper.LoopLuaTable(Methods, function(Index, Value)
		if Value ~= nil then
			return false
		end

		return {
			ReturningData = true,
			Data = false,
		}
	end) == false and false or true
end

function Pascal:GetMethods()
	return Methods
end

function Pascal:StopScriptWithReason(Thread, Reason)
	-- Print out reason
	self:GetLogger():Print("Script stopped: %s", Reason)

	-- Stop thread
	Thread:Stop()
end

function Pascal:IsScriptShuttingDown()
	return self:GetEnvironment().ShutdownScript
end

return Pascal
