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
