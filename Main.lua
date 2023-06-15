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
local Draw = require("../Modules/Drawing/Draw.lua")
local Event = require("../Modules/Helpers/Event.lua")
local Thread = require("../Modules/Helpers/Thread.lua")
local Pascal = require("../Modules/Helpers/Pascal.lua")
local Remotes = require("../Modules/Deepwoken/Remotes.lua")
local Helper = require("../Modules/Helpers/Helper.lua")
local Movement = require("../Features/Movement.lua")
local Menu = require("../UI/Menu.lua")

-- Hooking
local HookHandler = require("../Modules/Helpers/HookHandler.lua")

-- Entity folder...
local EntityFolder = Workspace:WaitForChild("Live")

-- Events
local RenderEvent = require("../Events/RenderEvent.lua")
local PhysicsEvent = require("../Events/PhysicsEvent.lua")
local EntityHandler = require("../Events/EntityHandler.lua")
local JumpRequest = require("../Events/JumpRequest.lua")

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
