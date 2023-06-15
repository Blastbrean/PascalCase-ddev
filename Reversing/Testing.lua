-- Services
local ReplicatedStorageService = GetService("ReplicatedStorage")
local HttpService = GetService("HttpService")

function GetKeyHandlerModule()
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

local KeyHandler = Remotes.GetKeyHandlerModule()
if not KeyHandler then
	return nil
end

local KeyHandlerRequireFunction = require(KeyHandler)
if not KeyHandlerRequireFunction then
	return nil
end

local KeyHandlerFunctionTable = getupvalue(KeyHandlerRequireFunction, 1)
if not KeyHandlerFunctionTable then
	return nil
end
