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
