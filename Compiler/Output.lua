-- Bundled by luabundle {"luaVersion":"5.1","version":"1.6.0"}
local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(nil)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Check for cloneref...
-- If it doesn't exist, we will halt the script (special and important function...)
if not cloneref then
	return print("Failed to find cloneref method...")
end

-- Global service function (cloneref)
getgenv().GetService = function(ServiceName)
	return cloneref(game:GetService(ServiceName))
end

-- Services
local RunService = GetService("RunService")
local Workspace = GetService("Workspace")
local UserInputService = GetService("UserInputService")

-- Requires
local Draw = require("Modules/Drawing/Draw")
local Event = require("Modules/Helpers/Event")
local Thread = require("Modules/Helpers/Thread")
local Pascal = require("Modules/Helpers/Pascal")
local Remotes = require("Modules/Deepwoken/Remotes")
local Helper = require("Modules/Helpers/Helper")
local Movement = require("Features/Movement")
local Menu = require("UI/Menu")

-- Hooking
local HookHandler = require("Modules/Helpers/HookHandler")

-- Entity folder...
local EntityFolder = Workspace:WaitForChild("Live")

-- Events
local RenderEvent = require("Events/RenderEvent")
local PhysicsEvent = require("Events/PhysicsEvent")
local EntityHandler = require("Events/EntityHandler")
local JumpRequest = require("Events/JumpRequest")

-- Create logger, thread, and event.
local MainThread = Thread:New()
local RenderEventObject = Event:New(RunService.RenderStepped)
local PhysicsEventObject = Event:New(RunService.Stepped)
local EntityHandlerObject = Event:New(EntityFolder.ChildAdded)
local JumpRequestObject = Event:New(UserInputService.JumpRequest)

local function StartDetachFn()
	if not Pascal:IsScriptShuttingDown() then
		return
	end

	-- Unload menu...
	Menu:Unload()

	-- Reset Pascal...
	Pascal:Reset()

	-- Remove events...
	RenderEventObject:Disconnect()
	EntityHandlerObject:Disconnect()
	PhysicsEventObject:Disconnect()
	JumpRequestObject:Disconnect()

	-- Special disconnect (see EventHandler)...
	if EntityHandler.DisconnectAutoParry then
		EntityHandler.DisconnectAutoParry()
	end

	-- Reset movement related stuff...
	Movement:ResetNoclipFn()

	-- Disconnect stuff...
	Pascal:GetEffectReplicator():Disconnect()

	-- Remove drawings...
	Draw:Clear()

	-- Remove hooks...
	if not HookHandler:RemoveHooks() then
		Pascal:GetLogger():Print("Unable to remove hooks while detaching!")
	end

	-- Remove override on remote table...
	Remotes.ResetOverrideGetRemote()

	-- Stop script and return...
	return Pascal:StopScriptWithReason(MainThread, "Detached from script!")
end

local function MainThreadFn()
	-- Check for all methods, if we are missing any, stop the thread and return.
	if not Pascal:CheckForAllMethods() then
		return Pascal:StopScriptWithReason(MainThread, "Failed to find all needed methods!")
	end

	-- Override remote table...
	Remotes.OverrideGetRemoteFromRemoteTable()

	-- Start hooks...
	if not HookHandler:StartHooks() then
		return Pascal:StopScriptWithReason(MainThread, "Failed to start hooks!")
	end

	-- Reset Pascal...
	Pascal:Reset()

	-- Create menu...
	Menu:Setup()

	-- Connect all events...
	RenderEventObject:Connect(RenderEvent.CallbackFn)
	PhysicsEventObject:Connect(PhysicsEvent.CallbackFn)
	EntityHandlerObject:Connect(EntityHandler.CallbackFn)
	JumpRequestObject:Connect(JumpRequest.CallbackFn)

	-- EntityHandler is a special event...
	-- We should call the CallbackFn with our current entities...
	Helper.LoopCurrentEntities(false, EntityFolder, function(Index, Entity)
		EntityHandler.CallbackFn(Entity)
	end)

	-- Wait for detach
	repeat
		task.wait()
	until Pascal:IsScriptShuttingDown()

	-- Run detach code
	StartDetachFn()
end

-- Run thread
MainThread:Create(MainThreadFn)
MainThread:Start()

end)
__bundle_register("Events/JumpRequest", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Module
local JumpRequest = {}

-- Requires
local Movement = require("Features/Movement")

function JumpRequest.CallbackFn(Entity)
	-- Call Movement InfiniteJump function...
	Movement:RunInfiniteJumpFn()
end

-- Return event
return JumpRequest

end)
__bundle_register("Features/Movement", function(require, _LOADED, __bundle_register, __bundle_modules)
local Movement = {}

-- Requires
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function Movement:ResetNoclipFn()
	-- We don't want to run this if we cannot get the LocalPlayer...
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	Helper.LoopInstanceChildren(LocalPlayerData.Character, function(Index, Children)
		-- Check if it's a part we want...
		if not Children:IsA("BasePart") then
			return false
		end

		-- Check if it's already collided...
		if Children.CanCollide then
			return false
		end

		-- Collide this part...
		Children.CanCollide = true

		-- Return false to continue...
		return false
	end)
end

function Movement:RunInfiniteJumpFn()
	-- We don't want to run this if we cannot get the LocalPlayer...
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	-- We don't want to run this if we don't have InfiniteJump on...
	if not Pascal:GetConfig().Movement.InfiniteJump then
		return
	end

	-- Force our state to change to jumping...
	LocalPlayerData.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end

function Movement:RunNoclipFn()
	-- We don't want to run this if we cannot get the LocalPlayer...
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	-- We don't want to run this if we don't have NoClip on...
	if not Pascal:GetConfig().Movement.NoClip then
		return Movement:ResetNoclipFn()
	end

	-- Set the collidable parts our character to not collide...
	Helper.LoopInstanceChildren(LocalPlayerData.Character, function(Index, Children)
		-- Check if it's a part we want...
		if not Children:IsA("BasePart") then
			return false
		end

		-- Check if it's already uncollided...
		if not Children.CanCollide then
			return false
		end

		-- Uncollide this part...
		Children.CanCollide = false

		-- Return false to continue...
		return false
	end)
end

return Movement

end)
__bundle_register("Modules/Helpers/Pascal", function(require, _LOADED, __bundle_register, __bundle_modules)
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

end)
__bundle_register("Modules/Helpers/Helper", function(require, _LOADED, __bundle_register, __bundle_modules)
local Helper = {}

-- Services
local PlayerService = GetService("Players")

-- Main code
function Helper.LoopLuaTable(Table, CallbackFn)
	for Index, Value in next, Table do
		local CallbackReturn = CallbackFn(Index, Value)
		if not CallbackReturn then
			continue
		end

		if typeof(CallbackReturn) == "table" and CallbackReturn.ReturningData == true then
			return CallbackReturn.Data
		end

		break
	end
end

function Helper.GetPlayerFromEntity(Entity)
	return PlayerService:GetPlayerFromCharacter(Entity)
end

function Helper.LoopInstanceDescendants(Instance, CallbackFn)
	for Index, Value in next, Instance:GetDescendants() do
		if not CallbackFn(Index, Value) then
			continue
		end

		break
	end
end

function Helper.LoopCurrentEntities(SkipLocal, EntityFolder, CallbackFn)
	for Index, Entity in next, EntityFolder:GetChildren() do
		local Player = PlayerService:GetPlayerFromCharacter(Entity)
		if Player and Player == PlayerService.LocalPlayer and SkipLocal then
			continue
		end

		local Humanoid = Entity:FindFirstChild("Humanoid")
		if not Humanoid then
			continue
		end

		local HumanoidRootPart = Entity:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart then
			continue
		end

		if not CallbackFn(Index, Entity, Player, Humanoid, HumanoidRootPart) then
			continue
		end

		break
	end
end

function Helper.LoopCurrentPlayers(SkipLocal, CallbackFn)
	for Index, Player in next, PlayerService:GetChildren() do
		local Character = Player.Character
		if not Character then
			continue
		end

		local Humanoid = Character:FindFirstChild("Humanoid")
		if not Humanoid then
			continue
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart then
			continue
		end

		if SkipLocal and Player == PlayerService.LocalPlayer then
			continue
		end

		if not CallbackFn(Index, Player, Character, Humanoid, HumanoidRootPart) then
			continue
		end

		break
	end
end

function Helper.LoopInstanceChildren(Instance, CallbackFn)
	for Index, LoopInstance in next, Instance:GetChildren() do
		local CallbackReturn = CallbackFn(Index, LoopInstance)
		if not CallbackReturn then
			continue
		end

		if typeof(CallbackReturn) == "table" and CallbackReturn.ReturningData == true then
			return CallbackReturn.Data
		end

		break
	end
end

function Helper.LoopOverPlayingAnimationTracks(Animator, CallbackFn)
	local PlayingAnimationTracks = Animator:GetPlayingAnimationTracks()
	if not PlayingAnimationTracks then
		return
	end

	for Index, LoopTrack in next, PlayingAnimationTracks do
		if not LoopTrack.Animation or not LoopTrack.IsPlaying then
			continue
		end

		local CallbackReturn = CallbackFn(Index, LoopTrack, LoopTrack.Animation)
		if not CallbackReturn then
			continue
		end

		break
	end
end

function Helper.GetPlayerWithData(Player)
	if not Player then
		return nil
	end

	local Character = Player.Character
	if not Character then
		return nil
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	if not Humanoid then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return nil
	end

	return { Player = Player, Character = Character, Humanoid = Humanoid, HumanoidRootPart = HumanoidRootPart }
end

function Helper.GetLocalPlayerWithData()
	local LocalPlayer = PlayerService.LocalPlayer
	if not LocalPlayer then
		return nil
	end

	local Character = LocalPlayer.Character
	if not Character then
		return nil
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	if not Humanoid then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return nil
	end

	return { Player = LocalPlayer, Character = Character, Humanoid = Humanoid, HumanoidRootPart = HumanoidRootPart }
end

return Helper

end)
__bundle_register("Modules/Deepwoken/EffectReplication", function(require, _LOADED, __bundle_register, __bundle_modules)
local ReplicatedStorage = GetService("ReplicatedStorage")
local HttpService = GetService("HttpService")

-- Rebuilt EffectReplicator
local EffectReplicator = {}
local ListenerTable = {}
local Connection = nil

function EffectReplicator:FindEffect(Class, AllowDisabled)
	for Index, Effect in next, self.Effects do
		if Effect.Class ~= Class then
			continue
		end

		if AllowDisabled or Effect.Disabled then
			continue
		end

		return Effect
	end
end

function EffectReplicator:OnCommunication(Data)
	local UpdateType = Data.updateType

	if UpdateType == "updatecontainer" and self.Container ~= Data.Container then
		self.Container = Data.Container
		return
	end

	if UpdateType == "remove" and self.Effects[Data.sum] then
		self.Effects[Data.sum] = nil
		return
	end

	if UpdateType == "clear" then
		self.Effects = {}
		return
	end

	if UpdateType == "update" then
		for Index, UpdateData in next, Data.sum do
			local Effect = self.Effects[UpdateData.ID]
				or {
					Domain = UpdateData.Class.Domain or (UpdateData and "Server" or "Client"),
					ID = UpdateData.Class.ID or HttpService:GenerateGUID(false),
					Class = UpdateData.Class,
					Disabled = UpdateData.Disabled and false,
					Value = UpdateData.Value or "???",
					Parent = self,
					Tags = UpdateData.Tags or {},
					DebrisTime = 0,
				}

			if UpdateData.Tags ~= nil then
				Effect.Tags = UpdateData.Tags
			end

			if UpdateData.Value ~= nil then
				Effect.Value = UpdateData.Value
			end

			if UpdateData.Disabled ~= nil then
				Effect.Disabled = UpdateData.Disabled
			end

			if UpdateData.DebrisTime ~= nil then
				Effect.DebrisTime = UpdateData.DebrisTime
			end

			self.Effects[UpdateData.ID] = Effect
		end
	end
end

function EffectReplicator:Disconnect()
	if not Connection then
		return
	end

	Connection:Disconnect()
end

function EffectReplicator:New()
	local EffectReplicatorObject = {
		Container = nil,
		Effects = {},
	}

	-- Set the metatable of the Draw object
	setmetatable(EffectReplicatorObject, self)

	-- Set index back to itself
	self.__index = self

	-- Put into the listener table
	table.insert(ListenerTable, EffectReplicatorObject)

	-- Return itself
	return EffectReplicatorObject
end

function EffectReplicator:CommunicateToListeners(Data)
	for Index, Listener in next, ListenerTable do
		Listener:OnCommunication(Data)
	end
end

local Requests = ReplicatedStorage:WaitForChild("Requests")
local EffectReplication = Requests:WaitForChild("EffectReplication")
local UpdateRemote = EffectReplication:WaitForChild("_update")

Connection = UpdateRemote.OnClientEvent:Connect(function(Data)
	EffectReplicator:CommunicateToListeners(Data)
end)

return EffectReplicator

end)
__bundle_register("Modules/Logging/Logger", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Logger class
local Logger = {}

function Logger:Print(String, ...)
	-- Format string
	local FormatString = string.format(String, ...)

	-- Print using print
	print(FormatString)

	-- Add to current log our current string
	table.insert(self.CurrentLog, FormatString)
end

function Logger:New()
	-- Create Logger object with data
	local LoggerObject = { CurrentLog = {} }

	-- Set the metatable of the Logger object
	setmetatable(LoggerObject, self)

	-- Set index back to itself
	self.__index = self

	-- Return back Logger object
	return LoggerObject
end

return Logger

end)
__bundle_register("Events/EntityHandler", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Module
local EntityHandler = {
	DisconnectAutoParry = nil,
}

-- Requires
local AutoParry = require("Features/AutoParry")

function EntityHandler.CallbackFn(Entity)
	-- Call AutoParry...
	AutoParry:OnEntityAdded(Entity)

	-- (BANDAID-FIX) Cannot require both ways, so I am simply outputting the disconnect function from here...
	EntityHandler.DisconnectAutoParry = AutoParry.Disconnect
end

-- Return event
return EntityHandler

end)
__bundle_register("Features/AutoParry", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Module
local AutoParry = {
	EntityData = {},
	Connections = {},
}

-- Services
local Players = GetService("Players")
local VirtualInputManagerService = GetService("VirtualInputManager")
local WorkspaceService = GetService("Workspace")

-- Requires
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")
local Remotes = require("Modules/Deepwoken/Remotes")

-- Simulate what a keyboard would do when pressing a key using VirtualInputManager:SendKeyEvent
function AutoParry.SimulateKeyFromKeyEvents(KeyCode)
	-- Send key event
	VirtualInputManagerService:SendKeyEvent(true, KeyCode, false, nil)

	-- Data by key press tool which will time key presses
	local KeyPressDelay = math.random(0.045, 0.087)

	-- Delay script before sending another
	task.wait(KeyPressDelay)

	-- Send key event to unpress key
	VirtualInputManagerService:SendKeyEvent(false, KeyCode, false, nil)
end

-- Recreated InputClient code
function AutoParry.SimulateParryThroughRemotes()
	-- Start input
	Remotes:SafeCallRemoteFromName("Block")

	-- Block until we are in a block state
	AutoParry.BlockUntilBlockState()

	-- End input
	Remotes:SafeCallRemoteFromName("Unblock")
end

function AutoParry.CheckDistanceBetweenParts(BuilderData, Part1, Part2)
	-- Nullify out the height in our calculations
	local Part1Position = Vector3.new(Part1.Position.X, 0.0, Part1.Position.Z)
	local Part2Position = Vector3.new(Part2.Position.X, 0.0, Part2.Position.Z)

	-- Get distance
	local Distance = (Part1Position - Part2Position).Magnitude
	return Distance >= BuilderData.MinimumDistance and Distance <= BuilderData.MaximumDistance
end

function AutoParry.HasTalent(Entity, TalentString)
	if not TalentString:match("Talent:") then
		TalentString = "Talent:" .. TalentString
	end

	local PlayerFromCharacter = Players:GetPlayerFromCharacter(Entity)
	if PlayerFromCharacter and PlayerFromCharacter.Backpack:FindFirstChild(TalentString) then
		return true
	end

	if Entity:FindFirstChild(TalentString) then
		return true
	end

	return false
end

function AutoParry.RunDodgeFn(Entity)
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		AutoParry.SimulateKeyFromKeyEvents(Enum.KeyCode.Q)
		return
	end
end

function AutoParry.BlockUntilBlockState()
	local EffectReplicator = Pascal:GetEffectReplicator()

	-- Block until actually blocking
	while task.wait() do
		-- Make sure we can actually get the LocalPlayer's data
		local LocalPlayerData = Helper.GetLocalPlayerWithData()
		if not LocalPlayerData then
			return
		end

		-- Check for the CharacterHandler & InputClient & Requests
		local CharacterHandler = LocalPlayerData.Character:FindFirstChild("CharacterHandler")
		if not CharacterHandler or not CharacterHandler:FindFirstChild("InputClient") then
			return
		end

		if not EffectReplicator:FindEffect("Action") and not EffectReplicator:FindEffect("Knocked") then
			Remotes:SafeCallRemoteFromName("Block")
		end

		if EffectReplicator:FindEffect("Blocking") then
			break
		end
	end
end

function AutoParry.StartBlockFn()
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		-- Send key event
		VirtualInputManagerService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
	end

	if Pascal:GetConfig().AutoParry.InputMethod == "Remotes" then
		-- Block until inside of a blocking state
		AutoParry.BlockUntilBlockState()

		-- Start input
		Remotes:SafeCallRemoteFromName("Block")
	end
end

function AutoParry.EndBlockFn()
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		-- Send key event to unpress key
		VirtualInputManagerService:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
	end

	if Pascal:GetConfig().AutoParry.InputMethod == "Remotes" then
		-- End input
		Remotes:SafeCallRemoteFromName("Unblock")
	end
end

function AutoParry.RunParryFn()
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		AutoParry.SimulateKeyFromKeyEvents(Enum.KeyCode.F)
	end

	if Pascal:GetConfig().AutoParry.InputMethod == "Remotes" then
		AutoParry.SimulateParryThroughRemotes()
	end
end

function AutoParry.EndBlockingStates(PlayerData)
	Helper.LoopLuaTable(PlayerData.AnimationData, function(Index, AnimationData)
		if not AnimationData.StartedBlocking then
			return false
		end

		if AnimationData.AnimationTrack.IsPlaying then
			return false
		end

		-- Get animation builder data
		local BuilderData = AutoParry:GetBuilderData(AnimationData.AnimationTrack.Animation.AnimationId)
		if not BuilderData then
			return false
		end

		-- End blocking
		AutoParry.EndBlockFn()

		-- End blocking state
		AnimationData.StartedBlocking = false

		-- Notify user that blocking has stopped
		Library:Notify(
			string.format("Ended blocking on animation %s(%s)", BuilderData.NickName, BuilderData.AnimationId),
			2.0
		)
	end)
end

function AutoParry.MovementCheck(EffectReplicator)
	if EffectReplicator:FindEffect("Action") then
		return false
	end

	if EffectReplicator:FindEffect("NoParkour") then
		return false
	end

	if EffectReplicator:FindEffect("Knocked") then
		return false
	end

	if EffectReplicator:FindEffect("Unconscious") then
		return false
	end

	if EffectReplicator:FindEffect("Pinned") or EffectReplicator:FindEffect("Carried") then
		return false
	end

	return true
end

function AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, AfterDelay)
	-- Check animation distance
	if
		not AutoParry.CheckDistanceBetweenParts(BuilderData, HumanoidRootPart, LocalPlayerData.HumanoidRootPart)
		and Player ~= LocalPlayerData.Player
	then
		return false
	end

	-- Effect handling...
	local EffectReplicator = Pascal:GetEffectReplicator()

	-- If we're currently attacking we are unable to parry!
	local InsideOfAttack = EffectReplicator:FindEffect("LightAttack")
		and not EffectReplicator:FindEffect("OffhandAttack")

	local CurrentlyInAction = EffectReplicator:FindEffect("Action") or EffectReplicator:FindEffect("MobileAction")

	local CannotCancel = not EffectReplicator:FindEffect("ClickCancel")

	if AfterDelay and CannotCancel and (InsideOfAttack or CurrentlyInAction) and Player ~= LocalPlayerData.Player then
		return false
	end

	-- Cannot parry while we are casting a spell...
	if AfterDelay and EffectReplicator:FindEffect("CastingSpell") and Player ~= LocalPlayerData.Player then
		return false
	end

	-- Can't parry or do anything while we are crouching...
	if AfterDelay and EffectReplicator:FindEffect("Crouching") then
		return false
	end

	-- Can't roll if we are unable to
	if
		AfterDelay
		and BuilderData.ShouldRoll
		and not AutoParry.CanRollWithEffects(EffectReplicator)
		and Player ~= LocalPlayerData.Player
	then
		return false
	end

	-- Cannot block while inside of an action or we are knocked
	if
		AfterDelay
		and (EffectReplicator:FindEffect("Action") or EffectReplicator:FindEffect("Knocked"))
		and Player ~= LocalPlayerData.Player
	then
		return false
	end

	-- Is our animaton still playing?
	if not AnimationTrack.IsPlaying then
		return false
	end

	-- Return true
	return true
end

-- This delay function makes sure that our current state is valid across delays
function AutoParry.DelayAndValidateStateFn(
	DelayInSeconds,
	AnimationTrack,
	BuilderData,
	LocalPlayerData,
	HumanoidRootPart,
	Player
)
	-- Make sure we are valid...
	if not AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, false) then
		return false
	end

	-- Wait the delay out...
	task.wait(DelayInSeconds)

	-- Make sure we are still valid...
	if not AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, true) then
		return false
	end

	return true
end

function AutoParry.CanRollWithEffects(EffectReplicator)
	if not AutoParry.MovementCheck(EffectReplicator) then
		return false
	end

	if EffectReplicator:FindEffect("CarryObject") and not EffectReplicator:FindEffect("ClientSwim") then
		return false
	end

	if EffectReplicator:FindEffect("NoAttack") and not EffectReplicator:FindEffect("CanRoll") then
		return false
	end

	if
		EffectReplicator:FindEffect("UsingSpell")
		or EffectReplicator:FindEffect("Dodged")
		or EffectReplicator:FindEffect("NoRoll")
		or EffectReplicator:FindEffect("Stun")
		or EffectReplicator:FindEffect("Action")
		or EffectReplicator:FindEffect("MobileAction")
		or EffectReplicator:FindEffect("PreventAction")
		or EffectReplicator:FindEffect("Carried")
		or EffectReplicator:FindEffect("ClientSlide")
	then
		return false
	end

	if
		EffectReplicator:FindEffect("LightAttack")
		and (
			EffectReplicator:FindEffect("PressureForward")
			or Helper.GetLocalPlayerWithData().Player.Backpack:FindFirstChild("Talent:Misdirection")
		)
	then
		return false
	end

	if EffectReplicator:FindEffect("Blocking") then
		-- End input
		Remotes:SafeCallRemoteFromName("Unblock")
	end
end

function AutoParry:EmplaceAnimationToData(PlayerData, AnimationTrack, AnimationId)
	if not PlayerData.AnimationData[AnimationId] then
		local AnimationData = {
			AnimationTrack = AnimationTrack,
			StartedBlocking = false,
		}

		PlayerData.AnimationData[AnimationId] = AnimationData
	end

	return PlayerData.AnimationData[AnimationId]
end

function AutoParry:EmplaceEntityToData(Entity)
	if not AutoParry.EntityData[Entity] then
		local EntityData = {
			AnimationData = {},
			MarkedForDeletion = true,
		}

		AutoParry.EntityData[Entity] = EntityData
	end

	return AutoParry.EntityData[Entity]
end

function AutoParry:GetBuilderData(AnimationId)
	-- Builder settings list
	local BuilderSettingsList = Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList
	return BuilderSettingsList[AnimationId]
end

function AutoParry:OnAnimationEnded(EntityData)
	-- Handle block states for player data
	AutoParry.EndBlockingStates(EntityData)
end

function AutoParry:OnAnimationPlayed(EntityData, AnimationTrack, Animation, Player, HumanoidRootPart)
	if not HumanoidRootPart then
		return
	end

	-- Ok, before we do anything... Let's check for these first.
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData or LocalPlayerData.Humanoid.Health <= 0 then
		return
	end

	local LeftHand = LocalPlayerData.Character:FindFirstChild("LeftHand")
	local RightHand = LocalPlayerData.Character:FindFirstChild("RightHand")
	if not LeftHand or not RightHand then
		return
	end

	local HandWeapon = LeftHand:FindFirstChild("HandWeapon") or RightHand:FindFirstChild("HandWeapon")
	if not HandWeapon then
		return
	end

	if not Pascal:GetConfig().AutoParry.Enabled then
		return
	end

	if LocalPlayerData.Player == Player and not Pascal:GetConfig().AutoParry.LocalAttackAutoParry then
		return
	end

	-- Get animation builder data
	local BuilderData = AutoParry:GetBuilderData(Animation.AnimationId)
	if not BuilderData then
		return
	end

	-- Get animation data (this should always work)
	local AnimationData = AutoParry:EmplaceAnimationToData(EntityData, AnimationTrack, Animation.AnimationId)
	if not AnimationData then
		return
	end

	-- Validate current auto-parry state is OK
	if not AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, false) then
		return
	end

	-- Block input if need be...
	if Pascal:GetConfig().AutoParry.DelayM1 then
		Remotes.ShouldBlockInput = true
	end

	-- Randomize seed according to the timestamp (ms)
	math.randomseed(DateTime.now().UnixTimestampMillis)

	-- Check hitchance
	if math.random(0, 100) > Pascal:GetConfig().AutoParry.Hitchance then
		return
	end

	-- Calculate delay
	local AttemptMilisecondsConvertedToSeconds = tonumber(BuilderData.AttemptDelay)
			and tonumber(BuilderData.AttemptDelay) / 1000
		or 0

	local RepeatMilisecondsConvertedToSeconds = tonumber(BuilderData.ParryRepeatDelay)
			and tonumber(BuilderData.ParryRepeatDelay) / 1000
		or 0

	-- Ping converted to two decimal places...
	local PingAdjustmentAmount = LocalPlayerData.Player:GetNetworkPing()
		* math.clamp(((Pascal:GetConfig().AutoParry.PingAdjust or 0) / 100), 0.0, 1.0)

	local RepeatDelayAccountingForPingAdjustment =
		math.clamp(RepeatMilisecondsConvertedToSeconds - PingAdjustmentAmount, 0.0, math.huge)

	local AttemptDelayAccountingForPingAdjustment =
		math.clamp(AttemptMilisecondsConvertedToSeconds - PingAdjustmentAmount, 0.0, math.huge)

	-- Notify user that animation has started
	Library:Notify(
		string.format(
			"Delaying on animation %s(%s) for %.3f seconds (%.3f / %.3f) (%.3f) (%.3f)",
			BuilderData.NickName,
			BuilderData.AnimationId,
			AttemptDelayAccountingForPingAdjustment,
			AnimationTrack.TimePosition,
			AnimationTrack.Length,
			AnimationTrack.Speed,
			os.clock()
		),
		2.0
	)

	-- Wait for delay to occur
	local DelayResult = AutoParry.DelayAndValidateStateFn(
		AttemptDelayAccountingForPingAdjustment,
		AnimationTrack,
		BuilderData,
		LocalPlayerData,
		HumanoidRootPart,
		Player
	)

	if not DelayResult then
		-- Notify user that delay has failed
		Library:Notify(
			string.format(
				"Failed delay on animation %s(%s) due to state validation",
				BuilderData.NickName,
				BuilderData.AnimationId
			),
			2.0
		)

		return
	end

	-- Handle auto-parry repeats
	if BuilderData.ParryRepeat and not BuilderData.ShouldBlock and not BuilderData.ShouldRoll then
		local RepeatDelayResult = nil

		for RepeatIndex = 1, (BuilderData.ParryRepeatTimes or 0) do
			-- Parry
			AutoParry.RunParryFn()

			-- Notify user that animation has repeated
			Library:Notify(
				string.format(
					"(%i) Activated on animation %s(%s) (%s: %.3f seconds)",
					RepeatIndex,
					BuilderData.NickName,
					BuilderData.AnimationId,
					RepeatDelayResult and "repeat-delay" or "delay",
					RepeatDelayResult and RepeatDelayAccountingForPingAdjustment
						or AttemptDelayAccountingForPingAdjustment
				),
				2.0
			)

			-- Wait for delay to occur
			RepeatDelayResult = AutoParry.DelayAndValidateStateFn(
				RepeatDelayAccountingForPingAdjustment,
				AnimationTrack,
				BuilderData,
				LocalPlayerData,
				HumanoidRootPart,
				Player
			)

			if not RepeatDelayResult then
				-- Notify user that delay has failed
				Library:Notify(
					string.format(
						"Failed delay on animation %s(%s) due to state validation",
						BuilderData.NickName,
						BuilderData.AnimationId
					),
					2.0
				)

				return
			end
		end

		return
	end

	-- Handle normal auto-parry
	if not BuilderData.ShouldBlock and not BuilderData.ShouldRoll and not BuilderData.ParryRepeat then
		-- Run auto-parry
		AutoParry.RunParryFn()

		-- Notify user that animation has ended
		Library:Notify(
			string.format(
				"Activated on animation %s(%s) (%.3f)",
				BuilderData.NickName,
				BuilderData.AnimationId,
				os.clock()
			),
			2.0
		)
	end

	-- Handle blocking
	if BuilderData.ShouldBlock then
		-- Start blocking
		AutoParry.StartBlockFn()

		-- Notify user that blocking has started
		Library:Notify(
			string.format("Started blocking on animation %s(%s)", BuilderData.NickName, BuilderData.AnimationId),
			2.0
		)

		-- Set animation data that we started blocking
		AnimationData.StartedBlocking = true
	end

	-- Handle dodging
	if BuilderData.ShouldRoll then
		-- Start dodging
		AutoParry.RunDodgeFn(Entity)

		-- Notify user that we have dodged
		Library:Notify(string.format("Dodged animation %s(%s)", BuilderData.NickName, BuilderData.AnimationId), 2.0)
	end
end

function AutoParry.Disconnect()
	Helper.LoopLuaTable(AutoParry.Connections, function(Index, Connection)
		Connection:Disconnect()
	end)
end

function AutoParry:OnEntityAdded(Entity)
	local Humanoid = Entity:WaitForChild("Humanoid")
	if not Humanoid then
		return
	end

	local HumanoidRootPart = Entity:WaitForChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local Animator = Humanoid:WaitForChild("Animator")
	if not Animator then
		return
	end

	local EntityData = AutoParry:EmplaceEntityToData(Entity)
	if not EntityData then
		return
	end

	-- Connect event to OnAnimationEnded...
	table.insert(
		AutoParry.Connections,
		Animator.AnimationPlayed:Connect(function(AnimationTrack)
			-- Call OnAnimationPlayed...
			AutoParry:OnAnimationPlayed(
				EntityData,
				AnimationTrack,
				AnimationTrack.Animation,
				Helper.GetPlayerFromEntity(Entity),
				HumanoidRootPart
			)

			-- Connect event to OnAnimationEnded...
			table.insert(
				AutoParry.Connections,
				AnimationTrack.Stopped:Connect(function()
					-- Stop blocking input if need be...
					if Pascal:GetConfig().AutoParry.DelayM1 then
						Remotes.ShouldBlockInput = false
					end

					-- Call OnAnimationEnded...
					AutoParry:OnAnimationEnded(EntityData)
				end)
			)
		end)
	)
end

return AutoParry

end)
__bundle_register("Modules/Deepwoken/Remotes", function(require, _LOADED, __bundle_register, __bundle_modules)
local Remotes = {
	OriginalGetRemote = nil,
	OriginalRemoteTable = nil,
	ShouldBlockInput = false,
}

-- Services
local ReplicatedStorageService = GetService("ReplicatedStorage")
local HttpService = GetService("HttpService")

-- Requires
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function Remotes.GetKeyHandlerModule()
	local Modules = ReplicatedStorageService:FindFirstChild("Modules")
	if not Modules then
		return nil
	end

	local ClientManager = Modules:FindFirstChild("ClientManager")
	if not ClientManager then
		return nil
	end

	local KeyHandler = ClientManager:FindFirstChild("KeyHandler")
	if not KeyHandler then
		return nil
	end

	return KeyHandler
end

function Remotes.GetRemoteTable()
	if Remotes.OriginalRemoteTable then
		return Remotes.OriginalRemoteTable
	end

	local KeyHandler = Remotes.GetKeyHandlerModule()
	if not KeyHandler then
		return nil
	end

	local KeyHandlerRequireFunction = require(KeyHandler)
	if not KeyHandlerRequireFunction then
		return nil
	end

	local KeyHandlerFunctionTable = Pascal:GetMethods().GetUpValue(KeyHandlerRequireFunction, 1)
	if not KeyHandlerFunctionTable then
		return nil
	end

	local RemoteTable = Pascal:GetMethods().GetUpValue(KeyHandlerFunctionTable[1], 5)
	if not RemoteTable then
		return nil
	end

	return RemoteTable
end

function Remotes.ModifyRemoteTable(Key, Value)
	local RemoteTable = Remotes.GetRemoteTable()
	if not RemoteTable then
		return
	end

	-- Modify current table...
	if not Remotes.OriginalRemoteTable then
		RemoteTable[Key] = Value

		-- Set table in script...
		Pascal:GetMethods().SetUpValue(KeyHandlerFunctionTable[1], 5, RemoteTable)
	else
		Remotes.OriginalRemoteTable[Key] = Value
	end
end

function Remotes.CreateKeyForRemote(Remote) -- Line: 96
	if not Remote then
		return nil
	end

	-- Modify remote table with our remote (save the original name, with our remote)...
	Remotes.ModifyRemoteTable(Remote.Name, Remote)

	-- Change the name with a random generated GUID
	Remote.Name = HttpService:GenerateGUID(false)

	-- Return the remote...
	return Remote
end

-- Get remote from remote table or emplace inside of it... Basicaly rebuilt KeyHandler!
function Remotes.GetRemoteFromName(Name)
	-- Make sure we can actually get the LocalPlayer's data
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return nil
	end

	-- Check for the CharacterHandler & Requests in Character and ReplicatedStorage
	local CharacterHandler = LocalPlayerData.Character:FindFirstChild("CharacterHandler")
	if not CharacterHandler then
		return nil
	end

	local ReplicatedStorageRequests = ReplicatedStorageService:FindFirstChild("Requests")
	if not ReplicatedStorageRequests then
		return nil
	end

	local CharacterRequests = CharacterHandler:FindFirstChild("Requests")
	if not CharacterRequests then
		return nil
	end

	local RemoteTable = Remotes.GetRemoteTable()
	if not RemoteTable then
		return nil
	end

	local RemoteFromCharacterRequestsFolder = CharacterRequests:FindFirstChild(Name)
	if RemoteFromCharacterRequestsFolder then
		return Remotes.CreateKeyForRemote(RemoteFromCharacterRequestsFolder)
	end

	local RemoteFromReplicatedStorageRequestFolder = ReplicatedStorageRequests:FindFirstChild(Name)
	if RemoteFromReplicatedStorageRequestFolder then
		return Remotes.CreateKeyForRemote(RemoteFromReplicatedStorageRequestFolder)
	end

	return RemoteTable[Name] or nil
end

function Remotes.SafeCallRemoteFromRequests(Name, ...)
	local ReplicatedStorageRequests = ReplicatedStorageService:FindFirstChild("Requests")
	if not ReplicatedStorageRequests then
		return nil
	end

	local RemoteFromReplicatedStorageRequestFolder = ReplicatedStorageRequests:FindFirstChild(Name)
	if not RemoteFromReplicatedStorageRequestFolder then
		return nil
	end

	return RemoteFromReplicatedStorageRequestFolder(...)
end

function Remotes.ResetOverrideGetRemote()
	local KeyHandler = Remotes.GetKeyHandlerModule()
	if not KeyHandler then
		return nil
	end

	local KeyHandlerRequireFunction = require(KeyHandler)
	if not KeyHandlerRequireFunction then
		return nil
	end

	local KeyHandlerFunctionTable = Pascal:GetMethods().GetUpValue(KeyHandlerRequireFunction, 1)
	if not KeyHandlerFunctionTable then
		return nil
	end

	local GetRemoteFunction = KeyHandlerFunctionTable[1]
	if not GetRemoteFunction then
		return nil
	end

	-- Override the upvalue function...
	KeyHandlerFunctionTable[1] = Remotes.OriginalGetRemote

	-- Set our upvalue to our new table...
	Pascal:GetMethods().SetUpValue(KeyHandlerRequireFunction, 1, KeyHandlerFunctionTable)

	-- Remove original...
	Remotes.OriginalGetRemote = nil

	-- Remove remote table...
	Remotes.OriginalRemoteTable = nil
end

function Remotes.OverrideGetRemoteFromRemoteTable()
	local KeyHandler = Remotes.GetKeyHandlerModule()
	if not KeyHandler then
		return nil
	end

	local KeyHandlerRequireFunction = require(KeyHandler)
	if not KeyHandlerRequireFunction then
		return nil
	end

	local KeyHandlerFunctionTable = Pascal:GetMethods().GetUpValue(KeyHandlerRequireFunction, 1)
	if not KeyHandlerFunctionTable then
		return nil
	end

	local GetRemoteFunction = KeyHandlerFunctionTable[1]
	if not GetRemoteFunction then
		return nil
	end

	local RemoteTable = Remotes.GetRemoteTable()
	if not RemoteTable then
		return nil
	end

	-- Save original...
	Remotes.OriginalGetRemote = GetRemoteFunction

	-- Save remote table...
	Remotes.OriginalRemoteTable = RemoteTable

	-- Override the upvalue function...
	KeyHandlerFunctionTable[1] = function(Name, UnknownArgument)
		-- We will never try to get the remote name 30195.341357415226 and "KickRemote"
		if Name == 30195.341357415226 or Name == "KickRemote" then
			return nil
		end

		-- Determines whether or not we should block input...
		if Remotes.ShouldBlockInput == true and Name == "LeftClick" then
			return Instance.new("RemoteEvent")
		end

		return Remotes.GetRemoteFromName(Name)
	end

	-- Set our upvalue to our new table...
	Pascal:GetMethods().SetUpValue(KeyHandlerRequireFunction, 1, KeyHandlerFunctionTable)
end

function Remotes:SafeCallRemoteFromName(Name, ...)
	local Remote = self.GetRemoteFromName(Name)
	if not Remote then
		return
	end

	Remote:FireServer(...)
end

return Remotes

end)
__bundle_register("Events/PhysicsEvent", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Module
local PhysicsEvent = {}

-- Requires
local Movement = require("Features/Movement")

function PhysicsEvent.CallbackFn()
	-- Run Noclip function...
	Movement:RunNoclipFn()
end

-- Return event
return PhysicsEvent

end)
__bundle_register("Events/RenderEvent", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Module
local RenderEvent = {}

-- Requires
local AutoParryLogger = require("Features/AutoParryLogger")
local Movement = require("Features/Movement")

function RenderEvent.CallbackFn(Step)
	-- Run AutoParry logging...
	AutoParryLogger:RunLoggingFn()
end

-- Return event
return RenderEvent

end)
__bundle_register("Features/AutoParryLogger", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Module
local AutoParryLogger = {
	CachedAnimations = {},
	CachedSoundNames = {},

	HasCachedAnimations = false,
	HasCachedSoundNames = false,

	-- Names that we specifically won't show to the user for a better experience...
	BlacklistedNames = {
		["sprint"] = true,
		["idle"] = true,
		["draw"] = true,
		["walk"] = true,
		["jump"] = true,
		["roll"] = true,
		["crouch"] = true,
		["cancelleft"] = true,
		["cancelright"] = true,
		["cancelforwards"] = true,
		["cancelback"] = true,
		["groundslide"] = true,
		["freefall"] = true,
		["parry"] = true,
		["resting"] = true,
		["slide"] = true,
		["landinganim"] = true,
		["vault"] = true,
		["equip"] = true,
		["swim"] = true,
		["treadwater"] = true,
		["block"] = true,
	},
}

-- Services
local WorkspaceService = GetService("Workspace")

-- Requires
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function AutoParryLogger.GetDistanceBetweenParts(Part1, Part2)
	-- Nullify out the height in our calculations
	local Part1Position = Vector3.new(Part1.Position.X, 0.0, Part1.Position.Z)
	local Part2Position = Vector3.new(Part2.Position.X, 0.0, Part2.Position.Z)

	-- Get distance
	local Distance = (Part1Position - Part2Position).Magnitude
	return Distance
end

function AutoParryLogger.IsDistanceOkBetweenParts(Part1, Part2)
	-- Get distance
	local Distance = AutoParryLogger.GetDistanceBetweenParts(Part1, Part2)

	-- Get bounds
	local MinimumDistance = Pascal:GetConfig().AutoParryLogging.MinimumDistance
	local MaximumDistance = Pascal:GetConfig().AutoParryLogging.MaximumDistance

	-- Return if within bounds
	return Distance >= MinimumDistance and Distance <= MaximumDistance
end

function AutoParryLogger:IsAnimationNameBlacklistedByDefault(Name)
	Name = string.lower(Name)

	return Helper.LoopLuaTable(AutoParryLogger.BlacklistedNames, function(Index, Value)
		if not Name:match(Index) then
			return false
		end

		return {
			ReturningData = true,
			Data = Value,
		}
	end)
end

function AutoParryLogger:CacheSoundNames()
	if AutoParryLogger.HasCachedSoundNames then
		return
	end

	Helper.LoopInstanceDescendants(game, function(Index, Descendant)
		if not Descendant:IsA("Sound") then
			return false
		end

		AutoParryLogger.CachedSoundNames[Descendant.SoundId] = Descendant.Name
	end)

	AutoParryLogger.CachedSoundNames = true
end

function AutoParryLogger:CacheAnimations()
	if AutoParryLogger.HasCachedAnimations then
		return
	end

	Helper.LoopInstanceDescendants(game, function(Index, Descendant)
		if not Descendant:IsA("Animation") then
			return false
		end

		AutoParryLogger.CachedAnimations[Descendant.AnimationId] = Descendant
	end)

	AutoParryLogger.HasCachedAnimations = true
end

function AutoParryLogger:RunLoggingFn()
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	-- Cache animations
	AutoParryLogger:CacheAnimations()

	-- Update blacklist for info-logger
	Library:UpdateInfoLoggerBlacklist(Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds)

	-- Loop over Live Folder (contains all living entities)
	Helper.LoopCurrentEntities(
		not Pascal:GetConfig().AutoParryLogging.LogYourself,
		WorkspaceService:WaitForChild("Live"),
		function(Index, Entity, Player, Humanoid, HumanoidRootPart)
			local Animator = Humanoid:FindFirstChild("Animator")
			if not Animator then
				return false
			end

			if
				not AutoParryLogger.IsDistanceOkBetweenParts(HumanoidRootPart, LocalPlayerData.HumanoidRootPart)
				and Player ~= LocalPlayerData.Player
			then
				return false
			end

			-- Loop over playing animation tracks
			Helper.LoopOverPlayingAnimationTracks(Animator, function(TrackIndex, AnimationTrack, Animation)
				local AnimationId = Animation.AnimationId
				local AnimationName = self.CachedAnimations[AnimationId] and self.CachedAnimations[AnimationId].Name
					or AnimationTrack.Name

				if AutoParryLogger:IsAnimationNameBlacklistedByDefault(AnimationName) then
					return false
				end

				Library:AddAnimationDataToInfoLogger(
					Entity.Name,
					AnimationId,
					AnimationName,
					AnimationTrack,
					self.CachedAnimations[AnimationId],
					AutoParryLogger.GetDistanceBetweenParts(HumanoidRootPart, LocalPlayerData.HumanoidRootPart)
				)
			end)

			-- Delete non playing animation data in logger
			Library:DeleteNonPlayingAnimationData(Entity.Name)
		end
	)
end

return AutoParryLogger

end)
__bundle_register("Modules/Helpers/HookHandler", function(require, _LOADED, __bundle_register, __bundle_modules)
local HookHandler = {}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")

-- Hooks
local GameNewIndexHook = require("Hooks/GameNewIndexHook")
local GameNameCallHook = require("Hooks/GameNameCallHook")

function HookHandler:RemoveHooks()
	if not GameNewIndexHook.OriginalFn or not GameNameCallHook.OriginalFn then
		return false
	end

	Pascal:GetMethods().HookMetaMethod(game, "__newindex", GameNewIndexHook.OriginalFn)
	Pascal:GetMethods().HookMetaMethod(game, "__namecall", GameNameCallHook.OriginalFn)
	return true
end

function HookHandler:StartHooks()
	GameNewIndexHook.OriginalFn = Pascal:GetMethods().HookMetaMethod(game, "__newindex", GameNewIndexHook.HookFn)
	if not GameNewIndexHook.OriginalFn then
		return false
	end

	GameNameCallHook.OriginalFn = Pascal:GetMethods().HookMetaMethod(game, "__namecall", GameNameCallHook.HookFn)
	if not GameNameCallHook.OriginalFn then
		return false
	end

	return true
end

return HookHandler

end)
__bundle_register("Hooks/GameNameCallHook", function(require, _LOADED, __bundle_register, __bundle_modules)
local GameNameCallHook = {
	OriginalFn = nil,
}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")
local Helper = require("Modules/Helpers/Helper")

function GameNameCallHook.HookFn(Self, ...)
	-- This is us...
	if Pascal:GetMethods().CheckCaller() then
		return GameNameCallHook.OriginalFn(Self, ...)
	end

	-- Get arguments and namecall-method...
	local Args = { ... }
	local NamecallMethod = Pascal:GetMethods().GetNameCallMethod()

	-- Check if this is the game:FindService function...
	if Self == game and NamecallMethod == "FindService" then
		-- Do not attempt to return services that get detected once created...
		if Args[1] == "VirtualInputManager" or Args[1] == "VirtualUser" then
			return nil
		end
	end

	-- Return original, we don't need to do anything further...
	return GameNameCallHook.OriginalFn(Self, ...)
end

return GameNameCallHook

end)
__bundle_register("Hooks/GameNewIndexHook", function(require, _LOADED, __bundle_register, __bundle_modules)
local GameNewIndexHook = {
    OriginalFn = nil
}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")
local Helper = require("Modules/Helpers/Helper")

function GameNewIndexHook.HookFn(Self, Key, Value)
    -- This is us...
    if Pascal:GetMethods().CheckCaller() then
        return GameNewIndexHook.OriginalFn(Self, Key, Value)
    end

    -- Get LocalPlayer, if existing doing local-player overrides...
    local LocalPlayerData = Helper.GetLocalPlayerWithData()
    if LocalPlayerData then
        -- Do walk-speed overrides when we have walk-speed override enabled...
        if Self == LocalPlayerData.Humanoid and Key == "WalkSpeed" and Pascal:GetConfig().Movement.WalkSpeedOverride then
            return GameNewIndexHook.OriginalFn(Self, Key, Pascal:GetConfig().Movement.WalkSpeedOverrideAmount)
        end

        -- Do jump-power overrides when we have jump-power override enabled...
        if Self == LocalPlayerData.Humanoid and Key == "JumpPower" and Pascal:GetConfig().Movement.JumpPowerOverride then
            return GameNewIndexHook.OriginalFn(Self, Key, Pascal:GetConfig().Movement.JumpPowerOverrideAmount)
        end
    end

    return GameNewIndexHook.OriginalFn(Self, Key, Value)
end

return GameNewIndexHook
end)
__bundle_register("UI/Menu", function(require, _LOADED, __bundle_register, __bundle_modules)
local Menu = {}

-- Requires
local Library = require("UI/Library/Library")

-- Tabs
local SettingsTab = require("UI/Tabs/SettingsTab")
local MovementTab = require("UI/Tabs/MovementTab")
local CombatTab = require("UI/Tabs/CombatTab")
local VisualsTab = require("UI/Tabs/VisualsTab")

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

end)
__bundle_register("UI/Tabs/VisualsTab", function(require, _LOADED, __bundle_register, __bundle_modules)
local VisualsTab = {}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")

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

end)
__bundle_register("UI/Tabs/CombatTab", function(require, _LOADED, __bundle_register, __bundle_modules)
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
		Rounding = 1,
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
		Rounding = 1,
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
		Rounding = 1,
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
		Rounding = 1,
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
		Rounding = 1,
		Compact = false,
		Suffix = "%",

		Callback = function(Value)
			Pascal:GetConfig().AutoParry.PingAdjust = Value
		end,
	})

	SubTab3:AddSlider("HitchanceSlider", {
		Text = "Chance to activate auto-parry",
		Default = 100,
		Min = 0,
		Max = 100,
		Rounding = 1,
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

end)
__bundle_register("UI/Tabs/MovementTab", function(require, _LOADED, __bundle_register, __bundle_modules)
local MovementTab = {}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")

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

end)
__bundle_register("UI/Tabs/SettingsTab", function(require, _LOADED, __bundle_register, __bundle_modules)
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

end)
__bundle_register("UI/Library/SaveManager", function(require, _LOADED, __bundle_register, __bundle_modules)
---@diagnostic disable: undefined-global
local httpService = GetService("HttpService")

local SaveManager = {}
do
	SaveManager.Folder = "LinoriaLibSettings"
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object)
				return { type = "Toggle", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if Toggles[idx] then
					Toggles[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if Options[idx] then
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if Options[idx] then
					Options[idx]:SetValue(data.value)
				end
			end,
		},
		ColorPicker = {
			Save = function(idx, object)
				return {
					type = "ColorPicker",
					idx = idx,
					value = object.Value:ToHex(),
					transparency = object.Transparency,
				}
			end,
			Load = function(idx, data)
				if Options[idx] then
					Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		KeyPicker = {
			Save = function(idx, object)
				return { type = "KeyPicker", idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] then
					Options[idx]:SetValue({ data.key, data.mode })
				end
			end,
		},

		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] and type(data.text) == "string" then
					Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function SaveManager:Save(name)
		if not name then
			return false, "no config file is selected"
		end

		local fullPath = self.Folder .. "/Settings/" .. name .. ".json"

		local data = {
			objects = {},
		}

		for idx, toggle in next, Toggles do
			if self.Ignore[idx] then
				continue
			end

			table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
		end

		for idx, option in next, Options do
			if not self.Parser[option.Type] then
				continue
			end
			if self.Ignore[idx] then
				continue
			end

			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then
			return false, "failed to encode data"
		end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:Load(name)
		if not name then
			return false, "no config file is selected"
		end

		local file = self.Folder .. "/Settings/" .. name .. ".json"
		if not isfile(file) then
			return false, "invalid file"
		end

		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then
			return false, "decode error"
		end

		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				self.Parser[option.type].Load(option.idx, option)
			end
		end

		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({
			"BackgroundColor",
			"MainColor",
			"AccentColor",
			"OutlineColor",
			"FontColor", -- themes
			"ThemeManager_ThemeList",
			"ThemeManager_CustomThemeList",
			"ThemeManager_CustomThemeName", -- themes
		})
	end

	function SaveManager:BuildFolderTree()
		local paths = {
			self.Folder,
			self.Folder .. "/Themes",
			self.Folder .. "/Settings",
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder .. "/settings")

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

	function SaveManager:SetLibrary(library)
		self.Library = library
	end

	function SaveManager:LoadAutoloadConfig()
		if isfile(self.Folder .. "/Settings/Autoload.json") then
			local name = readfile(self.Folder .. "/Settings/Autoload.json")

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify("Failed to load autoload config: " .. err)
			end

			self.Library:Notify(string.format("Auto loaded config %q", name))
		end
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Must set SaveManager.Library")

		local section = tab:AddRightGroupbox("Configuration")

		section:AddDropdown(
			"SaveManager_ConfigList",
			{ Text = "Config list", Values = self:RefreshConfigList(), AllowNull = true }
		)
		section:AddInput("SaveManager_ConfigName", { Text = "Config name" })

		section:AddDivider()

		section
			:AddButton("Create config", function()
				local name = Options.SaveManager_ConfigName.Value

				if name:gsub(" ", "") == "" then
					return self.Library:Notify("Invalid config name (empty)", 2)
				end

				local success, err = self:Save(name)
				if not success then
					return self.Library:Notify("Failed to save config: " .. err)
				end

				self.Library:Notify(string.format("Created config %q", name))

				Options.SaveManager_ConfigList.Values = self:RefreshConfigList()
				Options.SaveManager_ConfigList:SetValues()
				Options.SaveManager_ConfigList:SetValue(nil)
			end)
			:AddButton("Load config", function()
				local name = Options.SaveManager_ConfigList.Value

				local success, err = self:Load(name)
				if not success then
					return self.Library:Notify("Failed to load config: " .. err)
				end

				self.Library:Notify(string.format("Loaded config %q", name))
			end)

		section:AddButton("Overwrite config", function()
			local name = Options.SaveManager_ConfigList.Value

			local success, err = self:Save(name)
			if not success then
				return self.Library:Notify("Failed to overwrite config: " .. err)
			end

			self.Library:Notify(string.format("Overwrote config %q", name))
		end)

		section:AddButton("Autoload config", function()
			local name = Options.SaveManager_ConfigList.Value
			writefile(self.Folder .. "/Settings/Autoload.json", name)
			SaveManager.AutoloadLabel:SetText("Current autoload config: " .. name)
			self.Library:Notify(string.format("Set %q to auto load", name))
		end)

		section:AddButton("Refresh config list", function()
			Options.SaveManager_ConfigList.Values = self:RefreshConfigList()
			Options.SaveManager_ConfigList:SetValues()
			Options.SaveManager_ConfigList:SetValue(nil)
		end)

		SaveManager.AutoloadLabel = section:AddLabel("Current autoload config: none", true)

		if isfile(self.Folder .. "/Settings/Autoload.json") then
			local name = readfile(self.Folder .. "/Settings/Autoload.json")
			SaveManager.AutoloadLabel:SetText("Current autoload config: " .. name)
		end

		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
	end

	SaveManager:BuildFolderTree()
end

return SaveManager

end)
__bundle_register("UI/Library/ThemeManager", function(require, _LOADED, __bundle_register, __bundle_modules)
---@diagnostic disable: undefined-global
local httpService = GetService("HttpService")
local ThemeManager = {}
do
	ThemeManager.Folder = "LinoriaLibSettings"
	-- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

	ThemeManager.Library = nil
	ThemeManager.BuiltInThemes = {
		["Default"] = {
			1,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}'
			),
		},
		["BBot"] = {
			2,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}'
			),
		},
		["Fatality"] = {
			3,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}'
			),
		},
		["Jester"] = {
			4,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}'
			),
		},
		["Mint"] = {
			5,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}'
			),
		},
		["Tokyo Night"] = {
			6,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}'
			),
		},
		["Ubuntu"] = {
			7,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}'
			),
		},
		["Quartz"] = {
			8,
			httpService:JSONDecode(
				'{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}'
			),
		},
	}

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then
			return
		end

		-- custom themes are just regular dictionaries instead of an array with { index, dictionary }

		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			self.Library[idx] = Color3.fromHex(col)

			if Options[idx] then
				Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		-- This allows us to force apply themes without loading the themes tab :)
		local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
		for i, field in next, options do
			if Options and Options[field] then
				self.Library[field] = Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()
		local theme = "Default"
		local content = isfile(self.Folder .. "/Themes/Default.json")
			and readfile(self.Folder .. "/Themes/Default.json")

		local isDefault = true
		if content then
			if self.BuiltInThemes[content] then
				theme = content
			elseif self:GetCustomTheme(content) then
				theme = content
				isDefault = false
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
			theme = self.DefaultTheme
		end

		if isDefault then
			Options.ThemeManager_ThemeList:SetValue(theme)
		else
			self:ApplyTheme(theme)
		end
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. "/Themes/Default.json", theme)
	end

	function ThemeManager:CreateThemeManager(groupbox)
		groupbox
			:AddLabel("Background color")
			:AddColorPicker("BackgroundColor", { Default = self.Library.BackgroundColor })
		groupbox:AddLabel("Main color"):AddColorPicker("MainColor", { Default = self.Library.MainColor })
		groupbox:AddLabel("Accent color"):AddColorPicker("AccentColor", { Default = self.Library.AccentColor })
		groupbox:AddLabel("Outline color"):AddColorPicker("OutlineColor", { Default = self.Library.OutlineColor })
		groupbox:AddLabel("Font color"):AddColorPicker("FontColor", { Default = self.Library.FontColor })

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b)
			return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1]
		end)

		groupbox:AddDivider()
		groupbox:AddDropdown("ThemeManager_ThemeList", { Text = "Theme list", Values = ThemesArray, Default = 1 })

		groupbox:AddButton("Set as default", function()
			self:SaveDefault(Options.ThemeManager_ThemeList.Value)
			self.Library:Notify(string.format("Set default theme to %q", Options.ThemeManager_ThemeList.Value))
		end)

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)

		groupbox:AddDivider()
		groupbox:AddDropdown(
			"ThemeManager_CustomThemeList",
			{ Text = "Custom themes", Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 }
		)
		groupbox:AddInput("ThemeManager_CustomThemeName", { Text = "Custom theme name" })

		groupbox:AddButton("Load custom theme", function()
			self:ApplyTheme(Options.ThemeManager_CustomThemeList.Value)
		end)

		groupbox:AddButton("Save custom theme", function()
			self:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)

			Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
			Options.ThemeManager_CustomThemeList:SetValues()
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton("Refresh list", function()
			Options.ThemeManager_CustomThemeList.Values = self:ReloadCustomThemes()
			Options.ThemeManager_CustomThemeList:SetValues()
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton("Set as default", function()
			if
				Options.ThemeManager_CustomThemeList.Value ~= nil
				and Options.ThemeManager_CustomThemeList.Value ~= ""
			then
				self:SaveDefault(Options.ThemeManager_CustomThemeList.Value)
				self.Library:Notify(
					string.format("Set default theme to %q", Options.ThemeManager_CustomThemeList.Value)
				)
			end
		end)

		ThemeManager:LoadDefault()

		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. "/Themes/" .. file
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(httpService.JSONDecode, httpService, data)

		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(" ", "") == "" then
			return self.Library:Notify("Invalid file name for theme (empty)", 3)
		end

		local theme = {}
		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

		for _, field in next, fields do
			theme[field] = Options[field].Value:ToHex()
		end

		writefile(self.Folder .. "/Themes/" .. file .. ".json", httpService:JSONEncode(theme))
	end

	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. "/themes")

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				-- i hate this but it has to be done ...

				local pos = file:find(".json", 1, true)
				local char = file:sub(pos, pos)

				while char ~= "/" and char ~= "\\" and char ~= "" do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == "/" or char == "\\" then
					table.insert(out, file:sub(pos + 1))
				end
			end
		end

		return out
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}

		-- build the entire tree if a path is like some-hub/phantom-forces
		-- makefolder builds the entire tree on Synapse X but not other exploits

		local parts = self.Folder:split("/")
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, "/", 1, idx)
		end

		table.insert(paths, self.Folder .. "/Themes")
		table.insert(paths, self.Folder .. "/Settings")

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, "Must set ThemeManager.Library first!")
		return tab:AddLeftGroupbox("Themes")
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, "Must set ThemeManager.Library first!")
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, "Must set ThemeManager.Library first!")
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end
return ThemeManager

end)
__bundle_register("UI/Library/Library", function(require, _LOADED, __bundle_register, __bundle_modules)
---@diagnostic disable: undefined-global
local InputService = GetService("UserInputService")
local TextService = GetService("TextService")
local CoreGui = GetService("CoreGui")
local Teams = GetService("Teams")
local Players = GetService("Players")
local RunService = GetService("RunService")
local RenderStepped = RunService.RenderStepped
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local ScreenGui = Instance.new("ScreenGui")
ProtectGui(ScreenGui)

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

local Toggles = {}
local Options = {}

getgenv().Toggles = Toggles
getgenv().Options = Options

local Library = {
	Registry = {},
	RegistryMap = {},

	HudRegistry = {},

	FontColor = Color3.fromRGB(255, 255, 255),
	MainColor = Color3.fromRGB(28, 28, 28),
	BackgroundColor = Color3.fromRGB(20, 20, 20),
	AccentColor = Color3.fromRGB(0, 85, 255),
	OutlineColor = Color3.fromRGB(50, 50, 50),
	RiskColor = Color3.fromRGB(255, 50, 50),

	Black = Color3.new(0, 0, 0),
	Font = Enum.Font.Code,

	OpenedFrames = {},
	DependencyBoxes = {},

	Signals = {},
	ScreenGui = ScreenGui,
}

local RainbowStep = 0
local Hue = 0

table.insert(
	Library.Signals,
	RenderStepped:Connect(function(Delta)
		RainbowStep = RainbowStep + Delta

		if RainbowStep >= (1 / 60) then
			RainbowStep = 0

			Hue = Hue + (1 / 400)

			if Hue > 1 then
				Hue = 0
			end

			Library.CurrentRainbowHue = Hue
			Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1)
		end
	end)
)

local function GetPlayersString()
	local PlayerList = Players:GetPlayers()

	for i = 1, #PlayerList do
		PlayerList[i] = PlayerList[i].Name
	end

	table.sort(PlayerList, function(str1, str2)
		return str1 < str2
	end)

	return PlayerList
end

local function GetTeamsString()
	local TeamList = Teams:GetTeams()

	for i = 1, #TeamList do
		TeamList[i] = TeamList[i].Name
	end

	table.sort(TeamList, function(str1, str2)
		return str1 < str2
	end)

	return TeamList
end

function Library:SafeCallback(f, ...)
	if not f then
		return
	end

	if not Library.NotifyOnError then
		return f(...)
	end

	local success, event = pcall(f, ...)

	if not success then
		local _, i = event:find(":%d+: ")

		if not i then
			return Library:Notify(event)
		end

		return Library:Notify(event:sub(i + 1), 3)
	end
end

function Library:AttemptSave()
	if Library.SaveManager then
		Library.SaveManager:Save()
	end
end

function Library:Create(Class, Properties)
	local _Instance = Class

	if type(Class) == "string" then
		_Instance = Instance.new(Class)
	end

	for Property, Value in next, Properties do
		_Instance[Property] = Value
	end

	return _Instance
end

function Library:CreateLabel(Properties, IsHud)
	local _Instance = Library:Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Library.Font,
		TextColor3 = Library.FontColor,
		TextSize = 16,
		TextStrokeTransparency = 0,
	})

	Library:AddToRegistry(_Instance, {
		TextColor3 = "FontColor",
	}, IsHud)

	return Library:Create(_Instance, Properties)
end

function Library:MakeDraggable(Instance, Cutoff)
	Instance.Active = true

	Instance.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			local ObjPos = Vector2.new(Mouse.X - Instance.AbsolutePosition.X, Mouse.Y - Instance.AbsolutePosition.Y)

			if ObjPos.Y > (Cutoff or 40) then
				return
			end

			while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				Instance.Position = UDim2.new(
					0,
					Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
					0,
					Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
				)

				RenderStepped:Wait()
			end
		end
	end)
end

function Library:AddToolTip(InfoStr, HoverInstance)
	local X, Y = Library:GetTextBounds(InfoStr, Library.Font, 14)
	local Tooltip = Library:Create("Frame", {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.OutlineColor,

		Size = UDim2.fromOffset(X + 5, Y + 4),
		ZIndex = 100,
		Parent = Library.ScreenGui,

		Visible = false,
	})

	local Label = Library:CreateLabel({
		Position = UDim2.fromOffset(3, 1),
		Size = UDim2.fromOffset(X, Y),
		TextSize = 14,
		Text = InfoStr,
		TextColor3 = Library.FontColor,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = Tooltip.ZIndex + 1,

		Parent = Tooltip,
	})

	Library:AddToRegistry(Tooltip, {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
	})

	Library:AddToRegistry(Label, {
		TextColor3 = "FontColor",
	})

	local IsHovering = false
	HoverInstance.MouseEnter:Connect(function()
		IsHovering = true

		Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
		Tooltip.Visible = true

		while IsHovering do
			RunService.Heartbeat:Wait()
			Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
		end
	end)

	HoverInstance.MouseLeave:Connect(function()
		IsHovering = false
		Tooltip.Visible = false
	end)
end

function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault)
	HighlightInstance.MouseEnter:Connect(function()
		local Reg = Library.RegistryMap[Instance]

		for Property, ColorIdx in next, Properties do
			Instance[Property] = Library[ColorIdx] or ColorIdx

			if Reg and Reg.Properties[Property] then
				Reg.Properties[Property] = ColorIdx
			end
		end
	end)

	HighlightInstance.MouseLeave:Connect(function()
		local Reg = Library.RegistryMap[Instance]

		for Property, ColorIdx in next, PropertiesDefault do
			Instance[Property] = Library[ColorIdx] or ColorIdx

			if Reg and Reg.Properties[Property] then
				Reg.Properties[Property] = ColorIdx
			end
		end
	end)
end

function Library:MouseIsOverOpenedFrame()
	for Frame, _ in next, Library.OpenedFrames do
		local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

		if
			Mouse.X >= AbsPos.X
			and Mouse.X <= AbsPos.X + AbsSize.X
			and Mouse.Y >= AbsPos.Y
			and Mouse.Y <= AbsPos.Y + AbsSize.Y
		then
			return true
		end
	end
end

function Library:IsMouseOverFrame(Frame)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize

	if
		Mouse.X >= AbsPos.X
		and Mouse.X <= AbsPos.X + AbsSize.X
		and Mouse.Y >= AbsPos.Y
		and Mouse.Y <= AbsPos.Y + AbsSize.Y
	then
		return true
	end
end

function Library:UpdateDependencyBoxes()
	for _, Depbox in next, Library.DependencyBoxes do
		Depbox:Update()
	end
end

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
	return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB
end

function Library:GetTextBounds(Text, Font, Size, Resolution)
	local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
	return Bounds.X, Bounds.Y
end

function Library:GetDarkerColor(Color)
	local H, S, V = Color3.toHSV(Color)
	return Color3.fromHSV(H, S, V / 1.5)
end
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)

function Library:AddToRegistry(Instance, Properties, IsHud)
	local Idx = #Library.Registry + 1
	local Data = {
		Instance = Instance,
		Properties = Properties,
		Idx = Idx,
	}

	table.insert(Library.Registry, Data)
	Library.RegistryMap[Instance] = Data

	if IsHud then
		table.insert(Library.HudRegistry, Data)
	end
end

function Library:RemoveFromRegistry(Instance)
	local Data = Library.RegistryMap[Instance]

	if Data then
		for Idx = #Library.Registry, 1, -1 do
			if Library.Registry[Idx] == Data then
				table.remove(Library.Registry, Idx)
			end
		end

		for Idx = #Library.HudRegistry, 1, -1 do
			if Library.HudRegistry[Idx] == Data then
				table.remove(Library.HudRegistry, Idx)
			end
		end

		Library.RegistryMap[Instance] = nil
	end
end

function Library:UpdateColorsUsingRegistry()
	-- TODO: Could have an 'active' list of objects
	-- where the active list only contains Visible objects.

	-- IMPL: Could setup .Changed events on the AddToRegistry function
	-- that listens for the 'Visible' propert being changed.
	-- Visible: true => Add to active list, and call UpdateColors function
	-- Visible: false => Remove from active list.

	-- The above would be especially efficient for a rainbow menu color or live color-changing.

	for Idx, Object in next, Library.Registry do
		for Property, ColorIdx in next, Object.Properties do
			if type(ColorIdx) == "string" then
				Object.Instance[Property] = Library[ColorIdx]
			elseif type(ColorIdx) == "function" then
				Object.Instance[Property] = ColorIdx()
			end
		end
	end
end

function Library:GiveSignal(Signal)
	-- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
	table.insert(Library.Signals, Signal)
end

function Library:Unload()
	-- Unload all of the signals
	for Idx = #Library.Signals, 1, -1 do
		local Connection = table.remove(Library.Signals, Idx)
		Connection:Disconnect()
	end

	-- Call our unload callback, maybe to undo some hooks etc
	if Library.OnUnload then
		Library.OnUnload()
	end

	ScreenGui:Destroy()
end

function Library:OnUnload(Callback)
	Library.OnUnload = Callback
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
	if Library.RegistryMap[Instance] then
		Library:RemoveFromRegistry(Instance)
	end
end))

local BaseAddons = {}

do
	local Funcs = {}

	function Funcs:AddColorPicker(Idx, Info)
		local ToggleLabel = self.TextLabel
		-- local Container = self.Container;

		assert(Info.Default, "AddColorPicker: Missing default value.")

		local ColorPicker = {
			Value = Info.Default,
			Transparency = Info.Transparency or 0,
			Type = "ColorPicker",
			Title = type(Info.Title) == "string" and Info.Title or "Color picker",
			Callback = Info.Callback or function(Color) end,
		}

		function ColorPicker:SetHSVFromRGB(Color)
			local H, S, V = Color3.toHSV(Color)

			ColorPicker.Hue = H
			ColorPicker.Sat = S
			ColorPicker.Vib = V
		end

		ColorPicker:SetHSVFromRGB(ColorPicker.Value)

		local DisplayFrame = Library:Create("Frame", {
			BackgroundColor3 = ColorPicker.Value,
			BorderColor3 = Library:GetDarkerColor(ColorPicker.Value),
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(0, 28, 0, 14),
			ZIndex = 6,
			Parent = ToggleLabel,
		})

		-- Transparency image taken from https://github.com/matas3535/SplixPrivateDrawingLibrary/blob/main/Library.lua cus i'm lazy
		local CheckerFrame = Library:Create("ImageLabel", {
			BorderSizePixel = 0,
			Size = UDim2.new(0, 27, 0, 13),
			ZIndex = 5,
			Image = "http://www.roblox.com/asset/?id=12977615774",
			Visible = not not Info.Transparency,
			Parent = DisplayFrame,
		})

		-- 1/16/23
		-- Rewrote this to be placed inside the Library ScreenGui
		-- There was some issue which caused RelativeOffset to be way off
		-- Thus the color picker would never show

		local PickerFrameOuter = Library:Create("Frame", {
			Name = "Color",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
			Size = UDim2.fromOffset(230, Info.Transparency and 271 or 253),
			Visible = false,
			ZIndex = 15,
			Parent = ScreenGui,
		})

		DisplayFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			PickerFrameOuter.Position =
				UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18)
		end)

		local PickerFrameInner = Library:Create("Frame", {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 16,
			Parent = PickerFrameOuter,
		})

		local Highlight = Library:Create("Frame", {
			BackgroundColor3 = Library.AccentColor,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 2),
			ZIndex = 17,
			Parent = PickerFrameInner,
		})

		local SatVibMapOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Position = UDim2.new(0, 4, 0, 25),
			Size = UDim2.new(0, 200, 0, 200),
			ZIndex = 17,
			Parent = PickerFrameInner,
		})

		local SatVibMapInner = Library:Create("Frame", {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 18,
			Parent = SatVibMapOuter,
		})

		local SatVibMap = Library:Create("ImageLabel", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 18,
			Image = "rbxassetid://4155801252",
			Parent = SatVibMapInner,
		})

		local CursorOuter = Library:Create("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(0, 6, 0, 6),
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=9619665977",
			ImageColor3 = Color3.new(0, 0, 0),
			ZIndex = 19,
			Parent = SatVibMap,
		})

		local CursorInner = Library:Create("ImageLabel", {
			Size = UDim2.new(0, CursorOuter.Size.X.Offset - 2, 0, CursorOuter.Size.Y.Offset - 2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=9619665977",
			ZIndex = 20,
			Parent = CursorOuter,
		})

		local HueSelectorOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Position = UDim2.new(0, 208, 0, 25),
			Size = UDim2.new(0, 15, 0, 200),
			ZIndex = 17,
			Parent = PickerFrameInner,
		})

		local HueSelectorInner = Library:Create("Frame", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 18,
			Parent = HueSelectorOuter,
		})

		local HueTextSize = Library:GetTextBounds("Hex color", Library.Font, 16) + 3
		local RgbTextSize = Library:GetTextBounds("255, 255, 255", Library.Font, 16) + 3

		local HueBoxOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Position = UDim2.fromOffset(4, 228),
			Size = UDim2.new(0.5, -6, 0, 20),
			ZIndex = 18,
			Parent = PickerFrameInner,
		})

		local HueBoxInner = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 18,
			Parent = HueBoxOuter,
		})

		Library:Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212)),
			}),
			Rotation = 90,
			Parent = HueBoxInner,
		})

		local HueBox = Library:Create("TextBox", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(1, -5, 1, 0),
			Font = Library.Font,
			PlaceholderColor3 = Color3.fromRGB(190, 190, 190),
			PlaceholderText = "Hex color",
			Text = "#FFFFFF",
			TextColor3 = Library.FontColor,
			TextSize = 14,
			TextStrokeTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 20,
			Parent = HueBoxInner,
		})

		local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
			Position = UDim2.new(0.5, 2, 0, 228),
			Size = UDim2.new(0.5, -6, 0, 20),
			Parent = PickerFrameInner,
		})

		local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild("TextBox"), {
			Text = "255, 255, 255",
			PlaceholderText = "RGB color",
			TextColor3 = Library.FontColor,
		})

		local TransparencyBoxOuter, TransparencyBoxInner

		if Info.Transparency then
			TransparencyBoxOuter = Library:Create("Frame", {
				BorderColor3 = Color3.new(0, 0, 0),
				Position = UDim2.fromOffset(4, 251),
				Size = UDim2.new(1, -8, 0, 15),
				ZIndex = 19,
				Parent = PickerFrameInner,
			})

			TransparencyBoxInner = Library:Create("Frame", {
				BackgroundColor3 = ColorPicker.Value,
				BorderColor3 = Library.OutlineColor,
				BorderMode = Enum.BorderMode.Inset,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 19,
				Parent = TransparencyBoxOuter,
			})

			Library:AddToRegistry(TransparencyBoxInner, { BorderColor3 = "OutlineColor" })

			Library:Create("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Image = "http://www.roblox.com/asset/?id=12978095818",
				ZIndex = 20,
				Parent = TransparencyBoxInner,
			})
		end

		local DisplayLabel = Library:CreateLabel({
			Size = UDim2.new(1, 0, 0, 14),
			Position = UDim2.fromOffset(5, 5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 14,
			Text = ColorPicker.Title, --Info.Default;
			TextWrapped = false,
			ZIndex = 16,
			Parent = PickerFrameInner,
		})

		local ContextMenu = {}
		do
			ContextMenu.Options = {}
			ContextMenu.Container = Library:Create("Frame", {
				BorderColor3 = Color3.new(),
				ZIndex = 14,

				Visible = false,
				Parent = ScreenGui,
			})

			ContextMenu.Inner = Library:Create("Frame", {
				BackgroundColor3 = Library.BackgroundColor,
				BorderColor3 = Library.OutlineColor,
				BorderMode = Enum.BorderMode.Inset,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 15,
				Parent = ContextMenu.Container,
			})

			Library:Create("UIListLayout", {
				Name = "Layout",
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = ContextMenu.Inner,
			})

			Library:Create("UIPadding", {
				Name = "Padding",
				PaddingLeft = UDim.new(0, 4),
				Parent = ContextMenu.Inner,
			})

			local function updateMenuPosition()
				ContextMenu.Container.Position = UDim2.fromOffset(
					(DisplayFrame.AbsolutePosition.X + DisplayFrame.AbsoluteSize.X) + 4,
					DisplayFrame.AbsolutePosition.Y + 1
				)
			end

			local function updateMenuSize()
				local menuWidth = 60
				for i, label in next, ContextMenu.Inner:GetChildren() do
					if label:IsA("TextLabel") then
						menuWidth = math.max(menuWidth, label.TextBounds.X)
					end
				end

				ContextMenu.Container.Size =
					UDim2.fromOffset(menuWidth + 8, ContextMenu.Inner.Layout.AbsoluteContentSize.Y + 4)
			end

			DisplayFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(updateMenuPosition)
			ContextMenu.Inner.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateMenuSize)

			task.spawn(updateMenuPosition)
			task.spawn(updateMenuSize)

			Library:AddToRegistry(ContextMenu.Inner, {
				BackgroundColor3 = "BackgroundColor",
				BorderColor3 = "OutlineColor",
			})

			function ContextMenu:Show()
				self.Container.Visible = true
			end

			function ContextMenu:Hide()
				self.Container.Visible = false
			end

			function ContextMenu:AddOption(Str, Callback)
				if type(Callback) ~= "function" then
					Callback = function() end
				end

				local Button = Library:CreateLabel({
					Active = false,
					Size = UDim2.new(1, 0, 0, 15),
					TextSize = 13,
					Text = Str,
					ZIndex = 16,
					Parent = self.Inner,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				Library:OnHighlight(Button, Button, { TextColor3 = "AccentColor" }, { TextColor3 = "FontColor" })

				Button.InputBegan:Connect(function(Input)
					if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end

					Callback()
				end)
			end

			ContextMenu:AddOption("Copy color", function()
				Library.ColorClipboard = ColorPicker.Value
				Library:Notify("Copied color!", 2)
			end)

			ContextMenu:AddOption("Paste color", function()
				if not Library.ColorClipboard then
					return Library:Notify("You have not copied a color!", 2)
				end
				ColorPicker:SetValueRGB(Library.ColorClipboard)
			end)

			ContextMenu:AddOption("Copy HEX", function()
				pcall(setclipboard, ColorPicker.Value:ToHex())
				Library:Notify("Copied hex code to clipboard!", 2)
			end)

			ContextMenu:AddOption("Copy RGB", function()
				pcall(
					setclipboard,
					table.concat({
						math.floor(ColorPicker.Value.R * 255),
						math.floor(ColorPicker.Value.G * 255),
						math.floor(ColorPicker.Value.B * 255),
					}, ", ")
				)
				Library:Notify("Copied RGB values to clipboard!", 2)
			end)
		end

		Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor" })
		Library:AddToRegistry(Highlight, { BackgroundColor3 = "AccentColor" })
		Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor" })

		Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor" })
		Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor" })
		Library:AddToRegistry(RgbBox, { TextColor3 = "FontColor" })
		Library:AddToRegistry(HueBox, { TextColor3 = "FontColor" })

		local SequenceTable = {}

		for Hue = 0, 1, 0.1 do
			table.insert(SequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
		end

		local HueSelectorGradient = Library:Create("UIGradient", {
			Color = ColorSequence.new(SequenceTable),
			Rotation = 90,
			Parent = HueSelectorInner,
		})

		HueBox.FocusLost:Connect(function(enter)
			if enter then
				local success, result = pcall(Color3.fromHex, HueBox.Text)
				if success and typeof(result) == "Color3" then
					ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
				end
			end

			ColorPicker:Display()
		end)

		RgbBox.FocusLost:Connect(function(enter)
			if enter then
				local r, g, b = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
				if r and g and b then
					ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(Color3.fromRGB(r, g, b))
				end
			end

			ColorPicker:Display()
		end)

		function ColorPicker:Display()
			ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)
			SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)

			Library:Create(DisplayFrame, {
				BackgroundColor3 = ColorPicker.Value,
				BackgroundTransparency = ColorPicker.Transparency,
				BorderColor3 = Library:GetDarkerColor(ColorPicker.Value),
			})

			if TransparencyBoxInner then
				TransparencyBoxInner.BackgroundColor3 = ColorPicker.Value
			end

			CursorOuter.Position = UDim2.new(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0)

			HueBox.Text = "#" .. ColorPicker.Value:ToHex()
			RgbBox.Text = table.concat({
				math.floor(ColorPicker.Value.R * 255),
				math.floor(ColorPicker.Value.G * 255),
				math.floor(ColorPicker.Value.B * 255),
			}, ", ")

			Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
			Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
		end

		function ColorPicker:OnChanged(Func)
			ColorPicker.Changed = Func
			Func(ColorPicker.Value)
		end

		function ColorPicker:Show()
			for Frame, Val in next, Library.OpenedFrames do
				if Frame.Name == "Color" then
					Frame.Visible = false
					Library.OpenedFrames[Frame] = nil
				end
			end

			PickerFrameOuter.Visible = true
			Library.OpenedFrames[PickerFrameOuter] = true
		end

		function ColorPicker:Hide()
			PickerFrameOuter.Visible = false
			Library.OpenedFrames[PickerFrameOuter] = nil
		end

		function ColorPicker:SetValue(HSV, Transparency)
			local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

			ColorPicker.Transparency = Transparency or 0
			ColorPicker:SetHSVFromRGB(Color)
			ColorPicker:Display()
		end

		function ColorPicker:SetValueRGB(Color, Transparency)
			ColorPicker.Transparency = Transparency or 0
			ColorPicker:SetHSVFromRGB(Color)
			ColorPicker:Display()
		end

		SatVibMap.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local MinX = SatVibMap.AbsolutePosition.X
					local MaxX = MinX + SatVibMap.AbsoluteSize.X
					local MouseX = math.clamp(Mouse.X, MinX, MaxX)

					local MinY = SatVibMap.AbsolutePosition.Y
					local MaxY = MinY + SatVibMap.AbsoluteSize.Y
					local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

					ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX)
					ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
					ColorPicker:Display()

					RenderStepped:Wait()
				end

				Library:AttemptSave()
			end
		end)

		HueSelectorInner.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local MinY = HueSelectorInner.AbsolutePosition.Y
					local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y
					local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

					ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY))
					ColorPicker:Display()

					RenderStepped:Wait()
				end

				Library:AttemptSave()
			end
		end)

		DisplayFrame.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				if PickerFrameOuter.Visible then
					ColorPicker:Hide()
				else
					ContextMenu:Hide()
					ColorPicker:Show()
				end
			elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
				ContextMenu:Show()
				ColorPicker:Hide()
			end
		end)

		if TransparencyBoxInner then
			TransparencyBoxInner.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinX = TransparencyBoxInner.AbsolutePosition.X
						local MaxX = MinX + TransparencyBoxInner.AbsoluteSize.X
						local MouseX = math.clamp(Mouse.X, MinX, MaxX)

						ColorPicker.Transparency = 1 - ((MouseX - MinX) / (MaxX - MinX))

						ColorPicker:Display()

						RenderStepped:Wait()
					end

					Library:AttemptSave()
				end
			end)
		end

		Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize

				if
					Mouse.X < AbsPos.X
					or Mouse.X > AbsPos.X + AbsSize.X
					or Mouse.Y < (AbsPos.Y - 20 - 1)
					or Mouse.Y > AbsPos.Y + AbsSize.Y
				then
					ColorPicker:Hide()
				end

				if not Library:IsMouseOverFrame(ContextMenu.Container) then
					ContextMenu:Hide()
				end
			end

			if Input.UserInputType == Enum.UserInputType.MouseButton2 and ContextMenu.Container.Visible then
				if
					not Library:IsMouseOverFrame(ContextMenu.Container) and not Library:IsMouseOverFrame(DisplayFrame)
				then
					ContextMenu:Hide()
				end
			end
		end))

		ColorPicker:Display()
		ColorPicker.DisplayFrame = DisplayFrame

		Options[Idx] = ColorPicker

		return self
	end

	function Funcs:AddKeyPicker(Idx, Info)
		local ParentObj = self
		local ToggleLabel = self.TextLabel
		local Container = self.Container

		assert(Info.Default, "AddKeyPicker: Missing default value.")

		local KeyPicker = {
			Value = Info.Default,
			Toggled = false,
			Mode = Info.Mode or "Toggle", -- Always, Toggle, Hold
			Type = "KeyPicker",
			Callback = Info.Callback or function(Value) end,
			ChangedCallback = Info.ChangedCallback or function(New) end,

			SyncToggleState = Info.SyncToggleState or false,
		}

		if KeyPicker.SyncToggleState then
			Info.Modes = { "Toggle" }
			Info.Mode = "Toggle"
		end

		local PickOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(0, 28, 0, 15),
			ZIndex = 6,
			Parent = ToggleLabel,
		})

		local PickInner = Library:Create("Frame", {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 7,
			Parent = PickOuter,
		})

		Library:AddToRegistry(PickInner, {
			BackgroundColor3 = "BackgroundColor",
			BorderColor3 = "OutlineColor",
		})

		local DisplayLabel = Library:CreateLabel({
			Size = UDim2.new(1, 0, 1, 0),
			TextSize = 13,
			Text = Info.Default,
			TextWrapped = true,
			ZIndex = 8,
			Parent = PickInner,
		})

		local ModeSelectOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Position = UDim2.fromOffset(
				ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4,
				ToggleLabel.AbsolutePosition.Y + 1
			),
			Size = UDim2.new(0, 60, 0, 45 + 2),
			Visible = false,
			ZIndex = 14,
			Parent = ScreenGui,
		})

		ToggleLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			ModeSelectOuter.Position = UDim2.fromOffset(
				ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4,
				ToggleLabel.AbsolutePosition.Y + 1
			)
		end)

		local ModeSelectInner = Library:Create("Frame", {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 15,
			Parent = ModeSelectOuter,
		})

		Library:AddToRegistry(ModeSelectInner, {
			BackgroundColor3 = "BackgroundColor",
			BorderColor3 = "OutlineColor",
		})

		Library:Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ModeSelectInner,
		})

		local ContainerLabel = Library:CreateLabel({
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 18),
			TextSize = 13,
			Visible = false,
			ZIndex = 110,
			Parent = Library.KeybindContainer,
		}, true)

		local Modes = Info.Modes or { "Always", "Toggle", "Hold" }
		local ModeButtons = {}

		for Idx, Mode in next, Modes do
			local ModeButton = {}

			local Label = Library:CreateLabel({
				Active = false,
				Size = UDim2.new(1, 0, 0, 15),
				TextSize = 13,
				Text = Mode,
				ZIndex = 16,
				Parent = ModeSelectInner,
			})

			function ModeButton:Select()
				for _, Button in next, ModeButtons do
					Button:Deselect()
				end

				KeyPicker.Mode = Mode

				Label.TextColor3 = Library.AccentColor
				Library.RegistryMap[Label].Properties.TextColor3 = "AccentColor"

				ModeSelectOuter.Visible = false
			end

			function ModeButton:Deselect()
				KeyPicker.Mode = nil

				Label.TextColor3 = Library.FontColor
				Library.RegistryMap[Label].Properties.TextColor3 = "FontColor"
			end

			Label.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					ModeButton:Select()
					Library:AttemptSave()
				end
			end)

			if Mode == KeyPicker.Mode then
				ModeButton:Select()
			end

			ModeButtons[Mode] = ModeButton
		end

		function KeyPicker:Update()
			if Info.NoUI then
				return
			end

			local State = KeyPicker:GetState()

			ContainerLabel.Text = string.format("[%s] %s (%s)", KeyPicker.Value, Info.Text, KeyPicker.Mode)

			ContainerLabel.Visible = true
			ContainerLabel.TextColor3 = State and Library.AccentColor or Library.FontColor

			Library.RegistryMap[ContainerLabel].Properties.TextColor3 = State and "AccentColor" or "FontColor"

			local YSize = 0
			local XSize = 0

			for _, Label in next, Library.KeybindContainer:GetChildren() do
				if Label:IsA("TextLabel") and Label.Visible then
					YSize = YSize + 18
					if Label.TextBounds.X > XSize then
						XSize = Label.TextBounds.X
					end
				end
			end

			Library.KeybindFrame.Size = UDim2.new(0, math.max(XSize + 10, 210), 0, YSize + 23)
		end

		function KeyPicker:GetState()
			if KeyPicker.Mode == "Always" then
				return true
			elseif KeyPicker.Mode == "Hold" then
				if KeyPicker.Value == "None" then
					return false
				end

				local Key = KeyPicker.Value

				if Key == "MB1" or Key == "MB2" then
					return Key == "MB1" and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						or Key == "MB2" and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
				else
					return InputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value])
				end
			else
				return KeyPicker.Toggled
			end
		end

		function KeyPicker:SetValue(Data)
			local Key, Mode = Data[1], Data[2]
			DisplayLabel.Text = Key
			KeyPicker.Value = Key
			ModeButtons[Mode]:Select()
			KeyPicker:Update()
		end

		function KeyPicker:OnClick(Callback)
			KeyPicker.Clicked = Callback
		end

		function KeyPicker:OnChanged(Callback)
			KeyPicker.Changed = Callback
			Callback(KeyPicker.Value)
		end

		if ParentObj.Addons then
			table.insert(ParentObj.Addons, KeyPicker)
		end

		function KeyPicker:DoClick()
			if ParentObj.Type == "Toggle" and KeyPicker.SyncToggleState then
				ParentObj:SetValue(not ParentObj.Value)
			end

			Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
			Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)
		end

		local Picking = false

		PickOuter.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				Picking = true

				DisplayLabel.Text = ""

				local Break
				local Text = ""

				task.spawn(function()
					while not Break do
						if Text == "..." then
							Text = ""
						end

						Text = Text .. "."
						DisplayLabel.Text = Text

						wait(0.4)
					end
				end)

				wait(0.2)

				local Event
				Event = InputService.InputBegan:Connect(function(Input)
					local Key

					if Input.UserInputType == Enum.UserInputType.Keyboard then
						Key = Input.KeyCode.Name
					elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Key = "MB1"
					elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
						Key = "MB2"
					end

					Break = true
					Picking = false

					DisplayLabel.Text = Key
					KeyPicker.Value = Key

					Library:SafeCallback(KeyPicker.ChangedCallback, Input.KeyCode or Input.UserInputType)
					Library:SafeCallback(KeyPicker.Changed, Input.KeyCode or Input.UserInputType)

					Library:AttemptSave()

					Event:Disconnect()
				end)
			elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
				ModeSelectOuter.Visible = true
			end
		end)

		Library:GiveSignal(InputService.InputBegan:Connect(function(Input, ProcessedByGame)
			if not Picking and not Library.Toggle then
				if KeyPicker.Mode == "Toggle" then
					local Key = KeyPicker.Value

					if Key == "MB1" or Key == "MB2" then
						if
							Key == "MB1" and Input.UserInputType == Enum.UserInputType.MouseButton1
							or Key == "MB2" and Input.UserInputType == Enum.UserInputType.MouseButton2
						then
							KeyPicker.Toggled = not KeyPicker.Toggled
							KeyPicker:DoClick()
						end
					elseif Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode.Name == Key and not ProcessedByGame then
							KeyPicker.Toggled = not KeyPicker.Toggled
							KeyPicker:DoClick()
						end
					end
				end

				KeyPicker:Update()
			end

			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize

				if
					Mouse.X < AbsPos.X
					or Mouse.X > AbsPos.X + AbsSize.X
					or Mouse.Y < (AbsPos.Y - 20 - 1)
					or Mouse.Y > AbsPos.Y + AbsSize.Y
				then
					ModeSelectOuter.Visible = false
				end
			end
		end))

		Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
			if not Picking then
				KeyPicker:Update()
			end
		end))

		KeyPicker:Update()

		Options[Idx] = KeyPicker

		return self
	end

	BaseAddons.__index = Funcs
	BaseAddons.__namecall = function(Table, Key, ...)
		return Funcs[Key](...)
	end
end

local BaseGroupbox = {}

do
	local Funcs = {}

	function Funcs:AddBlank(Size)
		local Groupbox = self
		local Container = Groupbox.Container

		Library:Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Size),
			ZIndex = 1,
			Parent = Container,
		})
	end

	function Funcs:AddLabel(Text, DoesWrap)
		local Label = {}

		local Groupbox = self
		local Container = Groupbox.Container

		local TextLabel = Library:CreateLabel({
			Size = UDim2.new(1, -4, 0, 15),
			TextSize = 14,
			Text = Text,
			TextWrapped = DoesWrap or false,
			RichText = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 5,
			Parent = Container,
		})

		if DoesWrap then
			local Y = select(
				2,
				Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge))
			)
			TextLabel.Size = UDim2.new(1, -4, 0, Y)
		else
			Library:Create("UIListLayout", {
				Padding = UDim.new(0, 4),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = TextLabel,
			})
		end

		Label.TextLabel = TextLabel
		Label.Container = Container

		function Label:SetText(Text)
			TextLabel.Text = Text

			if DoesWrap then
				local Y = select(
					2,
					Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge))
				)
				TextLabel.Size = UDim2.new(1, -4, 0, Y)
			end

			Groupbox:Resize()
		end

		if not DoesWrap then
			setmetatable(Label, BaseAddons)
		end

		Groupbox:AddBlank(5)
		Groupbox:Resize()

		return Label
	end

	function Funcs:AddButton(...)
		-- TODO: Eventually redo this
		local Button = {}
		local function ProcessButtonParams(Class, Obj, ...)
			local Props = select(1, ...)
			if type(Props) == "table" then
				Obj.Text = Props.Text
				Obj.Func = Props.Func
				Obj.DoubleClick = Props.DoubleClick
				Obj.Tooltip = Props.Tooltip
			else
				Obj.Text = select(1, ...)
				Obj.Func = select(2, ...)
			end

			assert(type(Obj.Func) == "function", "AddButton: `Func` callback is missing.")
		end

		ProcessButtonParams("Button", Button, ...)

		local Groupbox = self
		local Container = Groupbox.Container

		local function CreateBaseButton(Button)
			local Outer = Library:Create("Frame", {
				BorderColor3 = Color3.new(0, 0, 0),
				Size = UDim2.new(1, -4, 0, 20),
				ZIndex = 5,
			})

			local Inner = Library:Create("Frame", {
				BackgroundColor3 = Library.MainColor,
				BorderColor3 = Library.OutlineColor,
				BorderMode = Enum.BorderMode.Inset,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 6,
				Parent = Outer,
			})

			local Label = Library:CreateLabel({
				Size = UDim2.new(1, 0, 1, 0),
				TextSize = 14,
				Text = Button.Text,
				ZIndex = 6,
				Parent = Inner,
			})

			Library:Create("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212)),
				}),
				Rotation = 90,
				Parent = Inner,
			})

			Library:AddToRegistry(Outer, {
				BorderColor3 = "Black",
			})

			Library:AddToRegistry(Inner, {
				BackgroundColor3 = "MainColor",
				BorderColor3 = "OutlineColor",
			})

			Library:OnHighlight(Outer, Outer, { BorderColor3 = "AccentColor" }, { BorderColor3 = "Black" })

			return Outer, Inner, Label
		end

		local function InitEvents(Button)
			local function WaitForEvent(event, timeout, validator)
				local bindable = Instance.new("BindableEvent")
				local connection = event:Once(function(...)
					if type(validator) == "function" and validator(...) then
						bindable:Fire(true)
					else
						bindable:Fire(false)
					end
				end)
				task.delay(timeout, function()
					connection:disconnect()
					bindable:Fire(false)
				end)
				return bindable.Event:Wait()
			end

			local function ValidateClick(Input)
				if Library:MouseIsOverOpenedFrame() then
					return false
				end

				if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return false
				end

				return true
			end

			Button.Outer.InputBegan:Connect(function(Input)
				if not ValidateClick(Input) then
					return
				end
				if Button.Locked then
					return
				end

				if Button.DoubleClick then
					Library:RemoveFromRegistry(Button.Label)
					Library:AddToRegistry(Button.Label, { TextColor3 = "AccentColor" })

					Button.Label.TextColor3 = Library.AccentColor
					Button.Label.Text = "Are you sure?"
					Button.Locked = true

					local clicked = WaitForEvent(Button.Outer.InputBegan, 0.5, ValidateClick)

					Library:RemoveFromRegistry(Button.Label)
					Library:AddToRegistry(Button.Label, { TextColor3 = "FontColor" })

					Button.Label.TextColor3 = Library.FontColor
					Button.Label.Text = Button.Text
					task.defer(rawset, Button, "Locked", false)

					if clicked then
						Library:SafeCallback(Button.Func)
					end

					return
				end

				Library:SafeCallback(Button.Func)
			end)
		end

		Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
		Button.Outer.Parent = Container

		InitEvents(Button)

		function Button:AddTooltip(tooltip)
			if type(tooltip) == "string" then
				Library:AddToolTip(tooltip, self.Outer)
			end
			return self
		end

		function Button:AddButton(...)
			local SubButton = {}

			ProcessButtonParams("SubButton", SubButton, ...)

			self.Outer.Size = UDim2.new(0.5, -2, 0, 20)

			SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)

			SubButton.Outer.Position = UDim2.new(1, 3, 0, 0)
			SubButton.Outer.Size = UDim2.fromOffset(self.Outer.AbsoluteSize.X - 2, self.Outer.AbsoluteSize.Y)
			SubButton.Outer.Parent = self.Outer

			function SubButton:AddTooltip(tooltip)
				if type(tooltip) == "string" then
					Library:AddToolTip(tooltip, self.Outer)
				end
				return SubButton
			end

			if type(SubButton.Tooltip) == "string" then
				SubButton:AddTooltip(SubButton.Tooltip)
			end

			InitEvents(SubButton)
			return SubButton
		end

		if type(Button.Tooltip) == "string" then
			Button:AddTooltip(Button.Tooltip)
		end

		Groupbox:AddBlank(5)
		Groupbox:Resize()

		return Button
	end

	function Funcs:AddDivider()
		local Groupbox = self
		local Container = self.Container

		local Divider = {
			Type = "Divider",
		}

		Groupbox:AddBlank(2)
		local DividerOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, -4, 0, 5),
			ZIndex = 5,
			Parent = Container,
		})

		local DividerInner = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 6,
			Parent = DividerOuter,
		})

		Library:AddToRegistry(DividerOuter, {
			BorderColor3 = "Black",
		})

		Library:AddToRegistry(DividerInner, {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
		})

		Groupbox:AddBlank(9)
		Groupbox:Resize()
	end

	function Funcs:AddInput(Idx, Info)
		assert(Info.Text, "AddInput: Missing `Text` string.")

		local Textbox = {
			Value = Info.Default or "",
			Numeric = Info.Numeric or false,
			Finished = Info.Finished or false,
			Type = "Input",
			Callback = Info.Callback or function(Value) end,
		}

		local Groupbox = self
		local Container = Groupbox.Container

		local InputLabel = Library:CreateLabel({
			Size = UDim2.new(1, 0, 0, 15),
			TextSize = 14,
			Text = Info.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 5,
			Parent = Container,
		})

		Groupbox:AddBlank(1)

		local TextBoxOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, -4, 0, 20),
			ZIndex = 5,
			Parent = Container,
		})

		local TextBoxInner = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 6,
			Parent = TextBoxOuter,
		})

		Library:AddToRegistry(TextBoxInner, {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
		})

		Library:OnHighlight(TextBoxOuter, TextBoxOuter, { BorderColor3 = "AccentColor" }, { BorderColor3 = "Black" })

		if type(Info.Tooltip) == "string" then
			Library:AddToolTip(Info.Tooltip, TextBoxOuter)
		end

		Library:Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212)),
			}),
			Rotation = 90,
			Parent = TextBoxInner,
		})

		local Container = Library:Create("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,

			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(1, -5, 1, 0),

			ZIndex = 7,
			Parent = TextBoxInner,
		})

		local Box = Library:Create("TextBox", {
			BackgroundTransparency = 1,

			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(5, 1),

			Font = Library.Font,
			PlaceholderColor3 = Color3.fromRGB(190, 190, 190),
			PlaceholderText = Info.Placeholder or "",

			Text = Info.Default or "",
			TextColor3 = Library.FontColor,
			TextSize = 14,
			TextStrokeTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Left,

			ZIndex = 7,
			Parent = Container,
		})

		function Textbox:SetValue(Text)
			if Info.MaxLength and #Text > Info.MaxLength then
				Text = Text:sub(1, Info.MaxLength)
			end

			if Textbox.Numeric then
				if (not tonumber(Text)) and Text:len() > 0 then
					Text = Textbox.Value
				end
			end

			Textbox.Value = Text
			Box.Text = Text

			Library:SafeCallback(Textbox.Callback, Textbox.Value)
			Library:SafeCallback(Textbox.Changed, Textbox.Value)
		end

		if Textbox.Finished then
			Box.FocusLost:Connect(function(enter)
				if not enter then
					return
				end

				Textbox:SetValue(Box.Text)
				Library:AttemptSave()
			end)
		else
			Box:GetPropertyChangedSignal("Text"):Connect(function()
				Textbox:SetValue(Box.Text)
				Library:AttemptSave()
			end)
		end

		-- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
		-- thank you nicemike40 :)

		local function Update()
			local PADDING = 2
			local reveal = Container.AbsoluteSize.X

			if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
				-- we aren't focused, or we fit so be normal
				Box.Position = UDim2.new(0, PADDING, 0, 0)
			else
				-- we are focused and don't fit, so adjust position
				local cursor = Box.CursorPosition
				if cursor ~= -1 then
					-- calculate pixel width of text from start to cursor
					local subtext = string.sub(Box.Text, 1, cursor - 1)
					local width =
						TextService:GetTextSize(subtext, Box.TextSize, Box.Font, Vector2.new(math.huge, math.huge)).X

					-- check if we're inside the box with the cursor
					local currentCursorPos = Box.Position.X.Offset + width

					-- adjust if necessary
					if currentCursorPos < PADDING then
						Box.Position = UDim2.fromOffset(PADDING - width, 0)
					elseif currentCursorPos > reveal - PADDING - 1 then
						Box.Position = UDim2.fromOffset(reveal - width - PADDING - 1, 0)
					end
				end
			end
		end

		task.spawn(Update)

		Box:GetPropertyChangedSignal("Text"):Connect(Update)
		Box:GetPropertyChangedSignal("CursorPosition"):Connect(Update)
		Box.FocusLost:Connect(Update)
		Box.Focused:Connect(Update)

		Library:AddToRegistry(Box, {
			TextColor3 = "FontColor",
		})

		function Textbox:OnChanged(Func)
			Textbox.Changed = Func
			Func(Textbox.Value)
		end

		Groupbox:AddBlank(5)
		Groupbox:Resize()

		Options[Idx] = Textbox

		return Textbox
	end

	function Funcs:AddToggle(Idx, Info)
		assert(Info.Text, "AddInput: Missing `Text` string.")

		local Toggle = {
			Value = Info.Default or false,
			Type = "Toggle",

			Callback = Info.Callback or function(Value) end,
			Addons = {},
			Risky = Info.Risky,
		}

		local Groupbox = self
		local Container = Groupbox.Container

		local ToggleOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(0, 13, 0, 13),
			ZIndex = 5,
			Parent = Container,
		})

		Library:AddToRegistry(ToggleOuter, {
			BorderColor3 = "Black",
		})

		local ToggleInner = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 6,
			Parent = ToggleOuter,
		})

		Library:AddToRegistry(ToggleInner, {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
		})

		local ToggleLabel = Library:CreateLabel({
			Size = UDim2.new(0, 216, 1, 0),
			Position = UDim2.new(1, 6, 0, 0),
			TextSize = 14,
			Text = Info.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 6,
			Parent = ToggleInner,
		})

		Library:Create("UIListLayout", {
			Padding = UDim.new(0, 4),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ToggleLabel,
		})

		local ToggleRegion = Library:Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 170, 1, 0),
			ZIndex = 8,
			Parent = ToggleOuter,
		})

		Library:OnHighlight(ToggleRegion, ToggleOuter, { BorderColor3 = "AccentColor" }, { BorderColor3 = "Black" })

		function Toggle:UpdateColors()
			Toggle:Display()
		end

		if type(Info.Tooltip) == "string" then
			Library:AddToolTip(Info.Tooltip, ToggleRegion)
		end

		function Toggle:Display()
			ToggleInner.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.MainColor
			ToggleInner.BorderColor3 = Toggle.Value and Library.AccentColorDark or Library.OutlineColor

			Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
			Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and "AccentColorDark"
				or "OutlineColor"
		end

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
			Func(Toggle.Value)
		end

		function Toggle:SetValue(Bool)
			Bool = not not Bool

			Toggle.Value = Bool
			Toggle:Display()

			for _, Addon in next, Toggle.Addons do
				if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
					Addon.Toggled = Bool
					Addon:Update()
				end
			end

			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
			Library:UpdateDependencyBoxes()
		end

		ToggleRegion.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
				Library:AttemptSave()
			end
		end)

		if Toggle.Risky then
			Library:RemoveFromRegistry(ToggleLabel)
			ToggleLabel.TextColor3 = Library.RiskColor
			Library:AddToRegistry(ToggleLabel, { TextColor3 = "RiskColor" })
		end

		Toggle:Display()
		Groupbox:AddBlank(Info.BlankSize or 5 + 2)
		Groupbox:Resize()

		Toggle.TextLabel = ToggleLabel
		Toggle.Container = Container
		setmetatable(Toggle, BaseAddons)

		Toggles[Idx] = Toggle

		Library:UpdateDependencyBoxes()

		return Toggle
	end

	function Funcs:AddSlider(Idx, Info)
		assert(Info.Default, "AddSlider: Missing default value.")
		assert(Info.Text, "AddSlider: Missing slider text.")
		assert(Info.Min, "AddSlider: Missing minimum value.")
		assert(Info.Max, "AddSlider: Missing maximum value.")
		assert(Info.Rounding, "AddSlider: Missing rounding value.")

		local Slider = {
			Value = Info.Default,
			Min = Info.Min,
			Max = Info.Max,
			Rounding = Info.Rounding,
			MaxSize = 232,
			Type = "Slider",
			Callback = Info.Callback or function(Value) end,
		}

		local Groupbox = self
		local Container = Groupbox.Container

		if not Info.Compact then
			Library:CreateLabel({
				Size = UDim2.new(1, 0, 0, 10),
				TextSize = 14,
				Text = Info.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				ZIndex = 5,
				Parent = Container,
			})

			Groupbox:AddBlank(3)
		end

		local SliderOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, -4, 0, 13),
			ZIndex = 5,
			Parent = Container,
		})

		Library:AddToRegistry(SliderOuter, {
			BorderColor3 = "Black",
		})

		local SliderInner = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 6,
			Parent = SliderOuter,
		})

		Library:AddToRegistry(SliderInner, {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
		})

		local Fill = Library:Create("Frame", {
			BackgroundColor3 = Library.AccentColor,
			BorderColor3 = Library.AccentColorDark,
			Size = UDim2.new(0, 0, 1, 0),
			ZIndex = 7,
			Parent = SliderInner,
		})

		Library:AddToRegistry(Fill, {
			BackgroundColor3 = "AccentColor",
			BorderColor3 = "AccentColorDark",
		})

		local HideBorderRight = Library:Create("Frame", {
			BackgroundColor3 = Library.AccentColor,
			BorderSizePixel = 0,
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0, 1, 1, 0),
			ZIndex = 8,
			Parent = Fill,
		})

		Library:AddToRegistry(HideBorderRight, {
			BackgroundColor3 = "AccentColor",
		})

		local DisplayLabel = Library:CreateLabel({
			Size = UDim2.new(1, 0, 1, 0),
			TextSize = 14,
			Text = "Infinite",
			ZIndex = 9,
			Parent = SliderInner,
		})

		Library:OnHighlight(SliderOuter, SliderOuter, { BorderColor3 = "AccentColor" }, { BorderColor3 = "Black" })

		if type(Info.Tooltip) == "string" then
			Library:AddToolTip(Info.Tooltip, SliderOuter)
		end

		function Slider:UpdateColors()
			Fill.BackgroundColor3 = Library.AccentColor
			Fill.BorderColor3 = Library.AccentColorDark
		end

		function Slider:Display()
			local Suffix = Info.Suffix or ""

			if Info.Compact then
				DisplayLabel.Text = Info.Text .. ": " .. Slider.Value .. Suffix
			elseif Info.HideMax then
				DisplayLabel.Text = string.format("%s", Slider.Value .. Suffix)
			else
				DisplayLabel.Text = string.format("%s/%s", Slider.Value .. Suffix, Slider.Max .. Suffix)
			end

			local X = math.ceil(Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, Slider.MaxSize))
			Fill.Size = UDim2.new(0, X, 1, 0)

			HideBorderRight.Visible = not (X == Slider.MaxSize or X == 0)
		end

		function Slider:OnChanged(Func)
			Slider.Changed = Func
			Func(Slider.Value)
		end

		local function Round(Value)
			if Slider.Rounding == 0 then
				return math.floor(Value)
			end

			return tonumber(string.format("%." .. Slider.Rounding .. "f", Value))
		end

		function Slider:GetValueFromXOffset(X)
			return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max))
		end

		function Slider:SetValue(Str)
			local Num = tonumber(Str)

			if not Num then
				return
			end

			Num = math.clamp(Num, Slider.Min, Slider.Max)

			Slider.Value = Num
			Slider:Display()

			Library:SafeCallback(Slider.Callback, Slider.Value)
			Library:SafeCallback(Slider.Changed, Slider.Value)
		end

		SliderInner.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				local mPos = Mouse.X
				local gPos = Fill.Size.X.Offset
				local Diff = mPos - (Fill.AbsolutePosition.X + gPos)

				while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					local nMPos = Mouse.X
					local nX = math.clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize)

					local nValue = Slider:GetValueFromXOffset(nX)
					local OldValue = Slider.Value
					Slider.Value = nValue

					Slider:Display()

					if nValue ~= OldValue then
						Library:SafeCallback(Slider.Callback, Slider.Value)
						Library:SafeCallback(Slider.Changed, Slider.Value)
					end

					RenderStepped:Wait()
				end

				Library:AttemptSave()
			end
		end)

		Slider:Display()
		Groupbox:AddBlank(Info.BlankSize or 6)
		Groupbox:Resize()

		Options[Idx] = Slider

		return Slider
	end

	function Funcs:AddDropdown(Idx, Info)
		if Info.SpecialType == "Player" then
			Info.Values = GetPlayersString()
			Info.AllowNull = true
		elseif Info.SpecialType == "Team" then
			Info.Values = GetTeamsString()
			Info.AllowNull = true
		end

		assert(Info.Values, "AddDropdown: Missing dropdown value list.")
		assert(
			Info.AllowNull or Info.Default,
			"AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional."
		)

		if not Info.Text then
			Info.Compact = true
		end

		local Dropdown = {
			Values = Info.Values,
			Value = Info.Multi and {},
			Multi = Info.Multi,
			Type = "Dropdown",
			SpecialType = Info.SpecialType, -- can be either 'Player' or 'Team'
			Callback = Info.Callback or function(Value) end,
		}

		local Groupbox = self
		local Container = Groupbox.Container

		local RelativeOffset = 0

		if not Info.Compact then
			local DropdownLabel = Library:CreateLabel({
				Size = UDim2.new(1, 0, 0, 10),
				TextSize = 14,
				Text = Info.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
				ZIndex = 5,
				Parent = Container,
			})

			Groupbox:AddBlank(3)
		end

		for _, Element in next, Container:GetChildren() do
			if not Element:IsA("UIListLayout") then
				RelativeOffset = RelativeOffset + Element.Size.Y.Offset
			end
		end

		local DropdownOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Size = UDim2.new(1, -4, 0, 20),
			ZIndex = 5,
			Parent = Container,
		})

		Library:AddToRegistry(DropdownOuter, {
			BorderColor3 = "Black",
		})

		local DropdownInner = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 6,
			Parent = DropdownOuter,
		})

		Library:AddToRegistry(DropdownInner, {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
		})

		Library:Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212)),
			}),
			Rotation = 90,
			Parent = DropdownInner,
		})

		local DropdownArrow = Library:Create("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -16, 0.5, 0),
			Size = UDim2.new(0, 12, 0, 12),
			Image = "http://www.roblox.com/asset/?id=6282522798",
			ZIndex = 8,
			Parent = DropdownInner,
		})

		local ItemList = Library:CreateLabel({
			Position = UDim2.new(0, 5, 0, 0),
			Size = UDim2.new(1, -5, 1, 0),
			TextSize = 14,
			Text = "--",
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			ZIndex = 7,
			Parent = DropdownInner,
		})

		Library:OnHighlight(DropdownOuter, DropdownOuter, { BorderColor3 = "AccentColor" }, { BorderColor3 = "Black" })

		if type(Info.Tooltip) == "string" then
			Library:AddToolTip(Info.Tooltip, DropdownOuter)
		end

		local MAX_DROPDOWN_ITEMS = 8

		local ListOuter = Library:Create("Frame", {
			BorderColor3 = Color3.new(0, 0, 0),
			Position = UDim2.new(0, 4, 0, 20 + RelativeOffset + 1 + 20),
			Size = UDim2.new(1, -8, 0, MAX_DROPDOWN_ITEMS * 20 + 2),
			ZIndex = 20,
			Visible = false,
			Parent = Container.Parent,
		})

		local ListInner = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderColor3 = Library.OutlineColor,
			BorderMode = Enum.BorderMode.Inset,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 21,
			Parent = ListOuter,
		})

		Library:AddToRegistry(ListInner, {
			BackgroundColor3 = "MainColor",
			BorderColor3 = "OutlineColor",
		})

		local Scrolling = Library:Create("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 21,
			Parent = ListInner,

			TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
			BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",

			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Library.AccentColor,
		})

		Library:AddToRegistry(Scrolling, {
			ScrollBarImageColor3 = "AccentColor",
		})

		Library:Create("UIListLayout", {
			Padding = UDim.new(0, 0),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Scrolling,
		})

		function Dropdown:Display()
			local Values = Dropdown.Values
			local Str = ""

			if Info.Multi then
				for Idx, Value in next, Values do
					if Dropdown.Value[Value] then
						Str = Str .. Value .. ", "
					end
				end

				Str = Str:sub(1, #Str - 2)
			else
				Str = Dropdown.Value or ""
			end

			ItemList.Text = (Str == "" and "--" or Str)
		end

		function Dropdown:GetActiveValues()
			if Info.Multi then
				local T = {}

				for Value, Bool in next, Dropdown.Value do
					table.insert(T, Value)
				end

				return T
			else
				return Dropdown.Value and 1 or 0
			end
		end

		function Dropdown:SetValues()
			local Values = Dropdown.Values
			local Buttons = {}

			for _, Element in next, Scrolling:GetChildren() do
				if not Element:IsA("UIListLayout") then
					-- Library:RemoveFromRegistry(Element);
					Element:Destroy()
				end
			end

			local Count = 0

			for Idx, Value in next, Values do
				local Table = {}

				Count = Count + 1

				local Button = Library:Create("Frame", {
					BackgroundColor3 = Library.MainColor,
					BorderColor3 = Library.OutlineColor,
					BorderMode = Enum.BorderMode.Middle,
					Size = UDim2.new(1, -1, 0, 20),
					ZIndex = 23,
					Active = true,
					Parent = Scrolling,
				})

				Library:AddToRegistry(Button, {
					BackgroundColor3 = "MainColor",
					BorderColor3 = "OutlineColor",
				})

				local ButtonLabel = Library:CreateLabel({
					Active = false,
					Size = UDim2.new(1, -6, 1, 0),
					Position = UDim2.new(0, 6, 0, 0),
					TextSize = 14,
					Text = Value,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 25,
					Parent = Button,
				})

				Library:OnHighlight(
					Button,
					Button,
					{ BorderColor3 = "AccentColor", ZIndex = 24 },
					{ BorderColor3 = "OutlineColor", ZIndex = 23 }
				)

				local Selected

				if Info.Multi then
					Selected = Dropdown.Value[Value]
				else
					Selected = Dropdown.Value == Value
				end

				function Table:UpdateButton()
					if Info.Multi then
						Selected = Dropdown.Value[Value]
					else
						Selected = Dropdown.Value == Value
					end

					ButtonLabel.TextColor3 = Selected and Library.AccentColor or Library.FontColor
					Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and "AccentColor" or "FontColor"
				end

				ButtonLabel.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						local Try = not Selected

						if Dropdown:GetActiveValues() == 1 and not Try and not Info.AllowNull then
						else
							if Info.Multi then
								Selected = Try

								if Selected then
									Dropdown.Value[Value] = true
								else
									Dropdown.Value[Value] = nil
								end
							else
								Selected = Try

								if Selected then
									Dropdown.Value = Value
								else
									Dropdown.Value = nil
								end

								for _, OtherButton in next, Buttons do
									OtherButton:UpdateButton()
								end
							end

							Table:UpdateButton()
							Dropdown:Display()

							Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
							Library:SafeCallback(Dropdown.Changed, Dropdown.Value)

							Library:AttemptSave()
						end
					end
				end)

				Table:UpdateButton()
				Dropdown:Display()

				Buttons[Button] = Table
			end

			local Y = math.clamp(Count * 20, 0, MAX_DROPDOWN_ITEMS * 20) + 1
			ListOuter.Size = UDim2.new(1, -8, 0, Y)
			Scrolling.CanvasSize = UDim2.new(0, 0, 0, (Count * 20) + 1)

			-- ListOuter.Size = UDim2.new(1, -8, 0, (#Values * 20) + 2);
		end

		function Dropdown:OpenDropdown()
			ListOuter.Visible = true
			Library.OpenedFrames[ListOuter] = true
			DropdownArrow.Rotation = 180
		end

		function Dropdown:CloseDropdown()
			ListOuter.Visible = false
			Library.OpenedFrames[ListOuter] = nil
			DropdownArrow.Rotation = 0
		end

		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
			Func(Dropdown.Value)
		end

		function Dropdown:SetValue(Val)
			if Dropdown.Multi then
				local nTable = {}

				for Value, Bool in next, Val do
					if table.find(Dropdown.Values, Value) then
						nTable[Value] = true
					end
				end

				Dropdown.Value = nTable
			else
				if not Val then
					Dropdown.Value = nil
				elseif table.find(Dropdown.Values, Val) then
					Dropdown.Value = Val
				end
			end

			Dropdown:SetValues()

			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end

		DropdownOuter.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
				if ListOuter.Visible then
					Dropdown:CloseDropdown()
				else
					Dropdown:OpenDropdown()
				end
			end
		end)

		InputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize

				if
					Mouse.X < AbsPos.X
					or Mouse.X > AbsPos.X + AbsSize.X
					or Mouse.Y < (AbsPos.Y - 20 - 1)
					or Mouse.Y > AbsPos.Y + AbsSize.Y
				then
					Dropdown:CloseDropdown()
				end
			end
		end)

		Dropdown:SetValues()
		Dropdown:Display()

		local Defaults = {}

		if type(Info.Default) == "string" then
			local Idx = table.find(Dropdown.Values, Info.Default)
			if Idx then
				table.insert(Defaults, Idx)
			end
		elseif type(Info.Default) == "table" then
			for _, Value in next, Info.Default do
				local Idx = table.find(Dropdown.Values, Value)
				if Idx then
					table.insert(Defaults, Idx)
				end
			end
		elseif type(Info.Default) == "number" and Dropdown.Values[Info.Default] ~= nil then
			table.insert(Defaults, Info.Default)
		end

		if next(Defaults) then
			for i = 1, #Defaults do
				local Index = Defaults[i]
				if Info.Multi then
					Dropdown.Value[Dropdown.Values[Index]] = true
				else
					Dropdown.Value = Dropdown.Values[Index]
				end

				if not Info.Multi then
					break
				end
			end

			Dropdown:SetValues()
			Dropdown:Display()
		end

		Groupbox:AddBlank(Info.BlankSize or 5)
		Groupbox:Resize()

		Options[Idx] = Dropdown

		return Dropdown
	end

	function Funcs:AddDependencyBox()
		local Depbox = {
			Dependencies = {},
		}

		local Groupbox = self
		local Container = Groupbox.Container

		local Holder = Library:Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			Visible = false,
			Parent = Container,
		})

		local Frame = Library:Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = true,
			Parent = Holder,
		})

		local Layout = Library:Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Frame,
		})

		function Depbox:Resize()
			Holder.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
			Groupbox:Resize()
		end

		Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Depbox:Resize()
		end)

		Holder:GetPropertyChangedSignal("Visible"):Connect(function()
			Depbox:Resize()
		end)

		function Depbox:Update()
			for _, Dependency in next, Depbox.Dependencies do
				local Elem = Dependency[1]
				local Value = Dependency[2]

				if Elem.Type == "Toggle" and Elem.Value ~= Value then
					Holder.Visible = false
					Depbox:Resize()
					return
				end
			end

			Holder.Visible = true
			Depbox:Resize()
		end

		function Depbox:SetupDependencies(Dependencies)
			for _, Dependency in next, Dependencies do
				assert(type(Dependency) == "table", "SetupDependencies: Dependency is not of type `table`.")
				assert(Dependency[1], "SetupDependencies: Dependency is missing element argument.")
				assert(Dependency[2] ~= nil, "SetupDependencies: Dependency is missing value argument.")
			end

			Depbox.Dependencies = Dependencies
			Depbox:Update()
		end

		Depbox.Container = Frame

		setmetatable(Depbox, BaseGroupbox)

		table.insert(Library.DependencyBoxes, Depbox)

		return Depbox
	end

	BaseGroupbox.__index = Funcs
	BaseGroupbox.__namecall = function(Table, Key, ...)
		return Funcs[Key](...)
	end
end

-- < Create other UI elements >
do
	Library.NotificationArea = Library:Create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 0, 0, 40),
		Size = UDim2.new(0, 300, 0, 200),
		ZIndex = 100,
		Parent = ScreenGui,
	})

	Library:Create("UIListLayout", {
		Padding = UDim.new(0, 4),
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Library.NotificationArea,
	})

	local WatermarkOuter = Library:Create("Frame", {
		BorderColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(0, 100, 0, -25),
		Size = UDim2.new(0, 213, 0, 20),
		ZIndex = 200,
		Visible = false,
		Parent = ScreenGui,
	})

	local WatermarkInner = Library:Create("Frame", {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.AccentColor,
		BorderMode = Enum.BorderMode.Inset,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 201,
		Parent = WatermarkOuter,
	})

	Library:AddToRegistry(WatermarkInner, {
		BorderColor3 = "AccentColor",
	})

	local InnerFrame = Library:Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		ZIndex = 202,
		Parent = WatermarkInner,
	})

	local Gradient = Library:Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
			ColorSequenceKeypoint.new(1, Library.MainColor),
		}),
		Rotation = -90,
		Parent = InnerFrame,
	})

	Library:AddToRegistry(Gradient, {
		Color = function()
			return ColorSequence.new({
				ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
				ColorSequenceKeypoint.new(1, Library.MainColor),
			})
		end,
	})

	local WatermarkLabel = Library:CreateLabel({
		Position = UDim2.new(0, 5, 0, 0),
		Size = UDim2.new(1, -4, 1, 0),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 203,
		Parent = InnerFrame,
	})

	Library.Watermark = WatermarkOuter
	Library.WatermarkText = WatermarkLabel
	Library:MakeDraggable(Library.Watermark)

	local InfoLoggerOuter = Library:Create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BorderColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.new(0, 210, 0, 24),
		Visible = false,
		ZIndex = 100,
		Parent = ScreenGui,
	})

	local InfoLoggerInner = Library:Create("Frame", {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.OutlineColor,
		BorderMode = Enum.BorderMode.Inset,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 101,
		Parent = InfoLoggerOuter,
	})

	Library:AddToRegistry(InfoLoggerInner, {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
	}, true)

	local InfoColorFrame = Library:Create("Frame", {
		BackgroundColor3 = Library.AccentColor,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 2),
		ZIndex = 102,
		Parent = InfoLoggerInner,
	})

	Library:AddToRegistry(InfoColorFrame, {
		BackgroundColor3 = "AccentColor",
	}, true)

	local InfoLoggerLabel = Library:CreateLabel({
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.fromOffset(5, 2),
		TextXAlignment = Enum.TextXAlignment.Left,

		Text = "Info-logger",
		ZIndex = 104,
		Parent = InfoLoggerInner,
	})

	local InfoLoggerContainer = Library:Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -20),
		Position = UDim2.new(0, 0, 0, 20),
		ZIndex = 1,
		Parent = InfoLoggerInner,
	})

	Library:Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = InfoLoggerContainer,
	})

	Library:Create("UIPadding", {
		PaddingLeft = UDim.new(0, 5),
		Parent = InfoLoggerContainer,
	})

	Library.InfoLoggerFrame = InfoLoggerOuter
	Library.InfoLoggerContainer = InfoLoggerContainer
	Library.InfoLoggerData = {
		PlayerData = {},
		ContainerLabels = {},
	}

	Library:MakeDraggable(InfoLoggerOuter)

	local KeybindOuter = Library:Create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		BorderColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.new(0, 210, 0, 20),
		Visible = false,
		ZIndex = 100,
		Parent = ScreenGui,
	})

	local KeybindInner = Library:Create("Frame", {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.OutlineColor,
		BorderMode = Enum.BorderMode.Inset,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 101,
		Parent = KeybindOuter,
	})

	Library:AddToRegistry(KeybindInner, {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
	}, true)

	local ColorFrame = Library:Create("Frame", {
		BackgroundColor3 = Library.AccentColor,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 2),
		ZIndex = 102,
		Parent = KeybindInner,
	})

	Library:AddToRegistry(ColorFrame, {
		BackgroundColor3 = "AccentColor",
	}, true)

	local KeybindLabel = Library:CreateLabel({
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.fromOffset(5, 2),
		TextXAlignment = Enum.TextXAlignment.Left,

		Text = "Keybinds",
		ZIndex = 104,
		Parent = KeybindInner,
	})

	local KeybindContainer = Library:Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -20),
		Position = UDim2.new(0, 0, 0, 20),
		ZIndex = 1,
		Parent = KeybindInner,
	})

	Library:Create("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = KeybindContainer,
	})

	Library:Create("UIPadding", {
		PaddingLeft = UDim.new(0, 5),
		Parent = KeybindContainer,
	})

	Library.KeybindFrame = KeybindOuter
	Library.KeybindContainer = KeybindContainer
	Library:MakeDraggable(KeybindOuter)
end

function Library:SetKeybindVisibility(Bool)
	Library.KeybindFrame.Visible = Bool
end

function Library:SetWatermarkVisibility(Bool)
	Library.Watermark.Visible = Bool
end

function Library:SetWatermark(Text)
	local X, Y = Library:GetTextBounds(Text, Library.Font, 14)
	Library.Watermark.Size = UDim2.new(0, X + 15, 0, (Y * 1.5) + 3)
	Library:SetWatermarkVisibility(true)

	Library.WatermarkText.Text = Text
end

function Library:Notify(Text, Time)
	local XSize, YSize = Library:GetTextBounds(Text, Library.Font, 14)

	YSize = YSize + 7

	local NotifyOuter = Library:Create("Frame", {
		BorderColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(0, 100, 0, 10),
		Size = UDim2.new(0, 0, 0, YSize),
		ClipsDescendants = true,
		ZIndex = 100,
		Parent = Library.NotificationArea,
	})

	local NotifyInner = Library:Create("Frame", {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.OutlineColor,
		BorderMode = Enum.BorderMode.Inset,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 101,
		Parent = NotifyOuter,
	})

	Library:AddToRegistry(NotifyInner, {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
	}, true)

	local InnerFrame = Library:Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		ZIndex = 102,
		Parent = NotifyInner,
	})

	local Gradient = Library:Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
			ColorSequenceKeypoint.new(1, Library.MainColor),
		}),
		Rotation = -90,
		Parent = InnerFrame,
	})

	Library:AddToRegistry(Gradient, {
		Color = function()
			return ColorSequence.new({
				ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
				ColorSequenceKeypoint.new(1, Library.MainColor),
			})
		end,
	})

	local NotifyLabel = Library:CreateLabel({
		Position = UDim2.new(0, 4, 0, 0),
		Size = UDim2.new(1, -4, 1, 0),
		Text = Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextSize = 14,
		ZIndex = 103,
		Parent = InnerFrame,
	})

	local LeftColor = Library:Create("Frame", {
		BackgroundColor3 = Library.AccentColor,
		BorderSizePixel = 0,
		Position = UDim2.new(0, -1, 0, -1),
		Size = UDim2.new(0, 3, 1, 2),
		ZIndex = 104,
		Parent = NotifyOuter,
	})

	Library:AddToRegistry(LeftColor, {
		BackgroundColor3 = "AccentColor",
	}, true)

	pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), "Out", "Quad", 0.4, true)

	task.spawn(function()
		wait(Time or 5)

		pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), "Out", "Quad", 0.4, true)

		wait(0.4)

		NotifyOuter:Destroy()
	end)
end

function Library:SetInfoLoggerVisibility(Value)
	Library.InfoLoggerFrame.Visible = Value
end

-- It's ugly but I don't care for anything proper right now
function Library:UpdateInfoLoggerBlacklist(BlacklistList)
	local DidWeEvenRemoveAnything = false

	for Index, InfoContainerLabel in next, Library.InfoLoggerData.ContainerLabels do
		local RegistryValue = Library.RegistryMap[InfoContainerLabel]
		if not RegistryValue then
			continue
		end

		if not BlacklistList[RegistryValue.AnimationId] then
			continue
		end

		InfoContainerLabel:Destroy()
		table.remove(Library.InfoLoggerData.ContainerLabels, Index)
		DidWeEvenRemoveAnything = true
	end

	Library.InfoLoggerData.BlacklistList = BlacklistList

	if DidWeEvenRemoveAnything then
		Library:UpdateInfoLoggerSize()
	end
end

function Library:GetInfoLoggerPlayerData(Name)
	return Library.InfoLoggerData.PlayerData[Name]
end

function Library:GetInfoLoggerAnimationData(Name, AnimationId)
	local InfoLoggerPlayerData = Library:GetInfoLoggerPlayerData(Name)
	if not InfoLoggerPlayerData then
		return nil
	end

	local InfoLoggerAnimationDataTable = InfoLoggerPlayerData.AnimationDataTable
	if not InfoLoggerAnimationDataTable then
		return nil
	end

	return InfoLoggerAnimationDataTable[AnimationId]
end

function Library:DeleteNonPlayingAnimationData(Name)
	local InfoLoggerPlayerData = Library:GetInfoLoggerPlayerData(Name)
	if not InfoLoggerPlayerData then
		return nil
	end

	for Index, AnimationData in next, InfoLoggerPlayerData.AnimationDataTable do
		if AnimationData.AnimationTrack.IsPlaying then
			continue
		end

		AnimationData = nil
		InfoLoggerPlayerData.AnimationDataTable[Index] = nil

		if getgenv().Settings.AutoParryBuilder.BuilderSettingsList[Index] then
			Library:Notify(
				string.format(
					"Animation %s ended (%.3f)",
					getgenv().Settings.AutoParryBuilder.BuilderSettingsList[Index].NickName,
					os.clock()
				),
				3.0
			)
		end
	end
end

function Library:UpdateInfoLoggerSize()
	local YSize = 0
	local XSize = 0

	for _, Label in next, Library.InfoLoggerContainer:GetChildren() do
		if Label:IsA("TextLabel") and Label.Visible then
			YSize = YSize + 18
			if Label.TextBounds.X > XSize then
				XSize = Label.TextBounds.X
			end
		end
	end

	Library.InfoLoggerFrame.Size = UDim2.new(0, math.max(XSize + 10, 210), 0, YSize + 23)
end

function Library:AddAnimationDataToInfoLogger(DataName, AnimationId, AnimationName, AnimationTrack, Animation, Distance)
	local AnimationData = Library:GetInfoLoggerAnimationData(DataName, AnimationId)
	if AnimationData then
		return
	end

	if Library.InfoLoggerData.BlacklistList[AnimationId] then
		return
	end

	if #Library.InfoLoggerData.ContainerLabels >= 8 then
		-- Get first element
		local FirstElement = Library.InfoLoggerData.ContainerLabels[1]

		-- Destroy the last element
		FirstElement:Destroy()

		-- Remove element from table
		table.remove(Library.InfoLoggerData.ContainerLabels, 1)
	end

	local InfoContainerLabel = Library:CreateLabel({
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 18),
		TextSize = 13,
		Visible = false,
		ZIndex = 110,
		Parent = Library.InfoLoggerContainer,
	}, true)

	local TwoHandedString = "X"
	local TypeString = "X"

	if Animation and Animation.Parent and Animation.Parent.Name ~= "TwoHand" and Animation.Parent:IsA("Folder") then
		TwoHandedString = "X"
		TypeString = Animation.Parent.Name
	elseif
		Animation
		and Animation.Parent
		and Animation.Parent.Name == "TwoHand"
		and Animation.Parent.Parent
		and Animation.Parent.Parent:IsA("Folder")
	then
		TwoHandedString = "TH"
		TypeString = Animation.Parent.Parent.Name
	end

	InfoContainerLabel.Text = string.format(
		"[%s] is playing (%s) with ID of %s (%.2fm away) (%s) (%s) (%s)",
		DataName,
		AnimationName,
		AnimationId,
		Distance,
		TypeString,
		TwoHandedString,
		getgenv().Settings.AutoParryBuilder.BuilderSettingsList[AnimationId] and "AP" or "X"
	)

	InfoContainerLabel.Visible = true
	InfoContainerLabel.TextColor3 = Library.FontColor

	Library.InfoLoggerData.PlayerData[DataName] = Library.InfoLoggerData.PlayerData[DataName]
		or { AnimationDataTable = {} }

	Library.InfoLoggerData.ContainerLabels[#Library.InfoLoggerData.ContainerLabels + 1] = InfoContainerLabel

	Library.RegistryMap[InfoContainerLabel].Properties.TextColor3 = "FontColor"
	Library.RegistryMap[InfoContainerLabel].AnimationId = AnimationId

	-- Insert animation data into the player's info-logger-data
	Library.InfoLoggerData.PlayerData[DataName].AnimationDataTable[AnimationId] = {
		AnimationTrack = AnimationTrack,
	}

	InfoContainerLabel.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
			setclipboard(Library.RegistryMap[InfoContainerLabel].AnimationId)
			Library:Notify("Copied Animation ID to Clipboard!", 2.5)
		end
	end)

	Library:UpdateInfoLoggerSize()
end

function Library:CreateWindow(...)
	local Arguments = { ... }
	local Config = { AnchorPoint = Vector2.zero }

	if type(...) == "table" then
		Config = ...
	else
		Config.Title = Arguments[1]
		Config.AutoShow = Arguments[2] or false
	end

	if type(Config.Title) ~= "string" then
		Config.Title = "No title"
	end
	if type(Config.TabPadding) ~= "number" then
		Config.TabPadding = 0
	end

	if typeof(Config.Position) ~= "UDim2" then
		Config.Position = UDim2.fromOffset(175, 50)
	end
	if typeof(Config.Size) ~= "UDim2" then
		Config.Size = UDim2.fromOffset(550, 600)
	end

	if Config.Center then
		Config.AnchorPoint = Vector2.new(0.5, 0.5)
		Config.Position = UDim2.fromScale(0.5, 0.5)
	end

	local Window = {
		Tabs = {},
	}

	local Outer = Library:Create("Frame", {
		AnchorPoint = Config.AnchorPoint,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		Position = Config.Position,
		Size = Config.Size,
		Visible = false,
		ZIndex = 1,
		Parent = ScreenGui,
	})

	Library:MakeDraggable(Outer, 25)

	local Inner = Library:Create("Frame", {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.AccentColor,
		BorderMode = Enum.BorderMode.Inset,
		Position = UDim2.new(0, 1, 0, 1),
		Size = UDim2.new(1, -2, 1, -2),
		ZIndex = 1,
		Parent = Outer,
	})

	Library:AddToRegistry(Inner, {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "AccentColor",
	})

	local WindowLabel = Library:CreateLabel({
		Position = UDim2.new(0, 7, 0, 0),
		Size = UDim2.new(0, 0, 0, 25),
		Text = Config.Title or "",
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 1,
		Parent = Inner,
	})

	local MainSectionOuter = Library:Create("Frame", {
		BackgroundColor3 = Library.BackgroundColor,
		BorderColor3 = Library.OutlineColor,
		Position = UDim2.new(0, 8, 0, 25),
		Size = UDim2.new(1, -16, 1, -33),
		ZIndex = 1,
		Parent = Inner,
	})

	Library:AddToRegistry(MainSectionOuter, {
		BackgroundColor3 = "BackgroundColor",
		BorderColor3 = "OutlineColor",
	})

	local MainSectionInner = Library:Create("Frame", {
		BackgroundColor3 = Library.BackgroundColor,
		BorderColor3 = Color3.new(0, 0, 0),
		BorderMode = Enum.BorderMode.Inset,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 1,
		Parent = MainSectionOuter,
	})

	Library:AddToRegistry(MainSectionInner, {
		BackgroundColor3 = "BackgroundColor",
	})

	local TabArea = Library:Create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 8, 0, 8),
		Size = UDim2.new(1, -16, 0, 21),
		ZIndex = 1,
		Parent = MainSectionInner,
	})

	local TabListLayout = Library:Create("UIListLayout", {
		Padding = UDim.new(0, Config.TabPadding),
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = TabArea,
	})

	local TabContainer = Library:Create("Frame", {
		BackgroundColor3 = Library.MainColor,
		BorderColor3 = Library.OutlineColor,
		Position = UDim2.new(0, 8, 0, 30),
		Size = UDim2.new(1, -16, 1, -38),
		ZIndex = 2,
		Parent = MainSectionInner,
	})

	Library:AddToRegistry(TabContainer, {
		BackgroundColor3 = "MainColor",
		BorderColor3 = "OutlineColor",
	})

	function Window:SetWindowTitle(Title)
		WindowLabel.Text = Title
	end

	function Window:AddTab(Name)
		local Tab = {
			Groupboxes = {},
			Tabboxes = {},
		}

		local TabButtonWidth = Library:GetTextBounds(Name, Library.Font, 16)

		local TabButton = Library:Create("Frame", {
			BackgroundColor3 = Library.BackgroundColor,
			BorderColor3 = Library.OutlineColor,
			Size = UDim2.new(0, TabButtonWidth + 8 + 4, 1, 0),
			ZIndex = 1,
			Parent = TabArea,
		})

		Library:AddToRegistry(TabButton, {
			BackgroundColor3 = "BackgroundColor",
			BorderColor3 = "OutlineColor",
		})

		local TabButtonLabel = Library:CreateLabel({
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, -1),
			Text = Name,
			ZIndex = 1,
			Parent = TabButton,
		})

		local Blocker = Library:Create("Frame", {
			BackgroundColor3 = Library.MainColor,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = TabButton,
		})

		Library:AddToRegistry(Blocker, {
			BackgroundColor3 = "MainColor",
		})

		local TabFrame = Library:Create("Frame", {
			Name = "TabFrame",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false,
			ZIndex = 2,
			Parent = TabContainer,
		})

		local LeftSide = Library:Create("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 8 - 1, 0, 8 - 1),
			Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			BottomImage = "",
			TopImage = "",
			ScrollBarThickness = 0,
			ZIndex = 2,
			Parent = TabFrame,
		})

		local RightSide = Library:Create("ScrollingFrame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1),
			Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			BottomImage = "",
			TopImage = "",
			ScrollBarThickness = 0,
			ZIndex = 2,
			Parent = TabFrame,
		})

		Library:Create("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = LeftSide,
		})

		Library:Create("UIListLayout", {
			Padding = UDim.new(0, 8),
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Parent = RightSide,
		})

		for _, Side in next, { LeftSide, RightSide } do
			Side:WaitForChild("UIListLayout"):GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Side.CanvasSize = UDim2.fromOffset(0, Side.UIListLayout.AbsoluteContentSize.Y)
			end)
		end

		function Tab:ShowTab()
			for _, Tab in next, Window.Tabs do
				Tab:HideTab()
			end

			Blocker.BackgroundTransparency = 0
			TabButton.BackgroundColor3 = Library.MainColor
			Library.RegistryMap[TabButton].Properties.BackgroundColor3 = "MainColor"
			TabFrame.Visible = true
		end

		function Tab:HideTab()
			Blocker.BackgroundTransparency = 1
			TabButton.BackgroundColor3 = Library.BackgroundColor
			Library.RegistryMap[TabButton].Properties.BackgroundColor3 = "BackgroundColor"
			TabFrame.Visible = false
		end

		function Tab:SetLayoutOrder(Position)
			TabButton.LayoutOrder = Position
			TabListLayout:ApplyLayout()
		end

		function Tab:AddGroupbox(Info)
			local Groupbox = {}

			local BoxOuter = Library:Create("Frame", {
				BackgroundColor3 = Library.BackgroundColor,
				BorderColor3 = Library.OutlineColor,
				BorderMode = Enum.BorderMode.Inset,
				Size = UDim2.new(1, 0, 0, 507 + 2),
				ZIndex = 2,
				Parent = Info.Side == 1 and LeftSide or RightSide,
			})

			Library:AddToRegistry(BoxOuter, {
				BackgroundColor3 = "BackgroundColor",
				BorderColor3 = "OutlineColor",
			})

			local BoxInner = Library:Create("Frame", {
				BackgroundColor3 = Library.BackgroundColor,
				BorderColor3 = Color3.new(0, 0, 0),
				-- BorderMode = Enum.BorderMode.Inset;
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				ZIndex = 4,
				Parent = BoxOuter,
			})

			Library:AddToRegistry(BoxInner, {
				BackgroundColor3 = "BackgroundColor",
			})

			local Highlight = Library:Create("Frame", {
				BackgroundColor3 = Library.AccentColor,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 2),
				ZIndex = 5,
				Parent = BoxInner,
			})

			Library:AddToRegistry(Highlight, {
				BackgroundColor3 = "AccentColor",
			})

			local GroupboxLabel = Library:CreateLabel({
				Size = UDim2.new(1, 0, 0, 18),
				Position = UDim2.new(0, 4, 0, 2),
				TextSize = 14,
				Text = Info.Name,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 5,
				Parent = BoxInner,
			})

			local Container = Library:Create("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 4, 0, 20),
				Size = UDim2.new(1, -4, 1, -20),
				ZIndex = 1,
				Parent = BoxInner,
			})

			Library:Create("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = Container,
			})

			function Groupbox:Resize()
				local Size = 0

				for _, Element in next, Groupbox.Container:GetChildren() do
					if (not Element:IsA("UIListLayout")) and Element.Visible then
						Size = Size + Element.Size.Y.Offset
					end
				end

				BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2 + 2)
			end

			Groupbox.Container = Container
			setmetatable(Groupbox, BaseGroupbox)

			Groupbox:AddBlank(3)
			Groupbox:Resize()

			Tab.Groupboxes[Info.Name] = Groupbox

			return Groupbox
		end

		function Tab:AddLeftGroupbox(Name)
			return Tab:AddGroupbox({ Side = 1, Name = Name })
		end

		function Tab:AddRightGroupbox(Name)
			return Tab:AddGroupbox({ Side = 2, Name = Name })
		end

		function Tab:AddTabbox(Info)
			local Tabbox = {
				Tabs = {},
			}

			local BoxOuter = Library:Create("Frame", {
				BackgroundColor3 = Library.BackgroundColor,
				BorderColor3 = Library.OutlineColor,
				BorderMode = Enum.BorderMode.Inset,
				Size = UDim2.new(1, 0, 0, 0),
				ZIndex = 2,
				Parent = Info.Side == 1 and LeftSide or RightSide,
			})

			Library:AddToRegistry(BoxOuter, {
				BackgroundColor3 = "BackgroundColor",
				BorderColor3 = "OutlineColor",
			})

			local BoxInner = Library:Create("Frame", {
				BackgroundColor3 = Library.BackgroundColor,
				BorderColor3 = Color3.new(0, 0, 0),
				-- BorderMode = Enum.BorderMode.Inset;
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				ZIndex = 4,
				Parent = BoxOuter,
			})

			Library:AddToRegistry(BoxInner, {
				BackgroundColor3 = "BackgroundColor",
			})

			local Highlight = Library:Create("Frame", {
				BackgroundColor3 = Library.AccentColor,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 2),
				ZIndex = 10,
				Parent = BoxInner,
			})

			Library:AddToRegistry(Highlight, {
				BackgroundColor3 = "AccentColor",
			})

			local TabboxButtons = Library:Create("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 1),
				Size = UDim2.new(1, 0, 0, 18),
				ZIndex = 5,
				Parent = BoxInner,
			})

			Library:Create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = TabboxButtons,
			})

			function Tabbox:AddTab(Name)
				local Tab = {}

				local Button = Library:Create("Frame", {
					BackgroundColor3 = Library.MainColor,
					BorderColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(0.5, 0, 1, 0),
					ZIndex = 6,
					Parent = TabboxButtons,
				})

				Library:AddToRegistry(Button, {
					BackgroundColor3 = "MainColor",
				})

				local ButtonLabel = Library:CreateLabel({
					Size = UDim2.new(1, 0, 1, 0),
					TextSize = 14,
					Text = Name,
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 7,
					Parent = Button,
				})

				local Block = Library:Create("Frame", {
					BackgroundColor3 = Library.BackgroundColor,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 1, 0),
					Size = UDim2.new(1, 0, 0, 1),
					Visible = false,
					ZIndex = 9,
					Parent = Button,
				})

				Library:AddToRegistry(Block, {
					BackgroundColor3 = "BackgroundColor",
				})

				local Container = Library:Create("Frame", {
					Position = UDim2.new(0, 4, 0, 20),
					Size = UDim2.new(1, -4, 1, -20),
					ZIndex = 1,
					Visible = false,
					Parent = BoxInner,
				})

				Library:Create("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Container,
				})

				function Tab:Show()
					for _, Tab in next, Tabbox.Tabs do
						Tab:Hide()
					end

					Container.Visible = true
					Block.Visible = true

					Button.BackgroundColor3 = Library.BackgroundColor
					Library.RegistryMap[Button].Properties.BackgroundColor3 = "BackgroundColor"

					Tab:Resize()
				end

				function Tab:Hide()
					Container.Visible = false
					Block.Visible = false

					Button.BackgroundColor3 = Library.MainColor
					Library.RegistryMap[Button].Properties.BackgroundColor3 = "MainColor"
				end

				function Tab:Resize()
					local TabCount = 0

					for _, Tab in next, Tabbox.Tabs do
						TabCount = TabCount + 1
					end

					for _, Button in next, TabboxButtons:GetChildren() do
						if not Button:IsA("UIListLayout") then
							Button.Size = UDim2.new(1 / TabCount, 0, 1, 0)
						end
					end

					if not Container.Visible then
						return
					end

					local Size = 0

					for _, Element in next, Tab.Container:GetChildren() do
						if (not Element:IsA("UIListLayout")) and Element.Visible then
							Size = Size + Element.Size.Y.Offset
						end
					end

					BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2 + 2)
				end

				Button.InputBegan:Connect(function(Input)
					if
						Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame()
					then
						Tab:Show()
						Tab:Resize()
					end
				end)

				Tab.Container = Container
				Tabbox.Tabs[Name] = Tab

				setmetatable(Tab, BaseGroupbox)

				Tab:AddBlank(3)
				Tab:Resize()

				-- Show first tab (number is 2 cus of the UIListLayout that also sits in that instance)
				if #TabboxButtons:GetChildren() == 2 then
					Tab:Show()
				end

				return Tab
			end

			Tab.Tabboxes[Info.Name or ""] = Tabbox

			return Tabbox
		end

		function Tab:AddLeftTabbox(Name)
			return Tab:AddTabbox({ Name = Name, Side = 1 })
		end

		function Tab:AddRightTabbox(Name)
			return Tab:AddTabbox({ Name = Name, Side = 2 })
		end

		TabButton.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Tab:ShowTab()
			end
		end)

		-- This was the first tab added, so we show it by default.
		if #TabContainer:GetChildren() == 1 then
			Tab:ShowTab()
		end

		Window.Tabs[Name] = Tab
		return Tab
	end

	local ModalElement = Library:Create("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 0, 0),
		Visible = true,
		Text = "",
		Modal = false,
		Parent = ScreenGui,
	})

	function Library.Toggle()
		Outer.Visible = not Outer.Visible
		ModalElement.Modal = Outer.Visible

		local oIcon = Mouse.Icon
		local State = InputService.MouseIconEnabled

		local Cursor = Drawing.new("Triangle")
		Cursor.Thickness = 1
		Cursor.Filled = true

		while Outer.Visible and ScreenGui.Parent do
			local mPos = InputService:GetMouseLocation()

			Cursor.Color = Library.AccentColor
			Cursor.PointA = Vector2.new(mPos.X, mPos.Y)
			Cursor.PointB = Vector2.new(mPos.X, mPos.Y) + Vector2.new(6, 14)
			Cursor.PointC = Vector2.new(mPos.X, mPos.Y) + Vector2.new(-6, 14)

			Cursor.Visible = not InputService.MouseIconEnabled

			RenderStepped:Wait()
		end

		Cursor:Remove()
	end

	Library:GiveSignal(InputService.InputBegan:Connect(function(Input, Processed)
		if type(Library.ToggleKeybind) == "table" and Library.ToggleKeybind.Type == "KeyPicker" then
			if
				Input.UserInputType == Enum.UserInputType.Keyboard
				and Input.KeyCode.Name == Library.ToggleKeybind.Value
			then
				task.spawn(Library.Toggle)
			end
		elseif
			Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and not Processed)
		then
			task.spawn(Library.Toggle)
		end
	end))

	if Config.AutoShow then
		task.spawn(Library.Toggle)
	end

	Window.Holder = Outer

	return Window
end

local function OnPlayerChange()
	local PlayerList = GetPlayersString()

	for _, Value in next, Options do
		if Value.Type == "Dropdown" and Value.SpecialType == "Player" then
			Value.Values = PlayerList
			Value:SetValues()
		end
	end
end

Players.PlayerAdded:Connect(OnPlayerChange)
Players.PlayerRemoving:Connect(OnPlayerChange)

getgenv().Library = Library
return Library

end)
__bundle_register("Modules/Helpers/Thread", function(require, _LOADED, __bundle_register, __bundle_modules)
-- Thread class
local Thread = {}

function Thread:Create(Function)
	if not self.CurrentThread then
		Thread:Stop()
	end

	self.CurrentThread = coroutine.create(Function)
end

function Thread:Start(...)
	if not self.CurrentThread then
		return
	end

	coroutine.resume(self.CurrentThread, ...)
end

function Thread:Stop()
	if not self.CurrentThread then
		return
	end

	-- Stop execution and close thread
	coroutine.yield(self.CurrentThread)
	coroutine.close(self.CurrentThread)

	-- Set current thread to nil
	self.CurrentThread = nil
end

function Thread:New()
	-- Create Thread object with data
	local ThreadObject = { CurrentThread = nil }

	-- Set the metatable of the Thread object
	setmetatable(ThreadObject, self)

	-- Set index back to itself
	self.__index = self

	-- Return back Thread object
	return ThreadObject
end

return Thread

end)
__bundle_register("Modules/Helpers/Event", function(require, _LOADED, __bundle_register, __bundle_modules)
local Event = {}

function Event:Connect(Function)
	if not self.RobloxEvent then
		return
	end

	if self.Connection then
		self:Disconnect()
	end

	self.Connection = self.RobloxEvent and self.RobloxEvent:Connect(Function) or nil
end

function Event:Disconnect()
	if not self.Connection then
		return
	end

	self.Connection:Disconnect()
end

function Event:New(RobloxEvent)
	-- Create Event object with data
	local EventObject = {
		RobloxEvent = RobloxEvent,
		Connection = nil,
	}

	-- Set the metatable of the Event object
	setmetatable(EventObject, self)

	-- Set index back to itself
	self.__index = self

	-- Return back Event object
	return EventObject
end

return Event

end)
__bundle_register("Modules/Drawing/Draw", function(require, _LOADED, __bundle_register, __bundle_modules)
local Draw = { Objects = {} }

-- Requires
local DrawObject = require("Modules/Drawing/DrawObject")
local Helper = require("Modules/Helpers/Helper")

function Draw:NewObject(Type)
	-- Create a new drawing object with type.
	local DrawingObject = DrawObject:New(Type)

	-- Insert into table, the drawing object.
	table.insert(self.Objects, DrawingObject)

	-- Return drawing object
	return DrawingObject
end

function Draw:Clear()
	Helper.LoopLuaTable(self.Objects, function(Index, Object)
		Object:Remove()
	end)
end

return Draw

end)
__bundle_register("Modules/Drawing/DrawObject", function(require, _LOADED, __bundle_register, __bundle_modules)
local DrawObject = {}

-- Requires
local Helper = require("Modules/Helpers/Helper")

function DrawObject:Update(Data)
	if not self.Drawing then
		return
	end

	-- Copy Data into Keys and Fields of Drawing
	Helper.LoopLuaTable(Data, function(Index, Object)
		self.Drawing[Index] = Object
	end)
end

function DrawObject:Remove()
	if not self.Drawing then
		return
	end

	self.Drawing:Remove()
end

function DrawObject:New(Type)
	-- Create Draw Object with data
	local DrawObjectData = {
		Drawing = Drawing.new(Type),
		Type = Type,
	}

	-- Set the metatable of the Draw object
	setmetatable(DrawObjectData, self)

	-- Set index back to itself
	self.__index = self

	-- Return back Draw object
	return DrawObjectData
end

return DrawObject

end)
return __bundle_require("__root")