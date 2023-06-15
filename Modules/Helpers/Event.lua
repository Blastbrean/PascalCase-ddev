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
