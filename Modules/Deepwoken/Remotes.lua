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
