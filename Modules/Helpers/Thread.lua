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
