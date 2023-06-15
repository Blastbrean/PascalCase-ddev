-- Module
local RenderEvent = {}

-- Requires
local AutoParryLogger = require("../Features/AutoParryLogger.lua")
local Movement = require("../Features/Movement.lua")

function RenderEvent.CallbackFn(Step)
	-- Run AutoParry logging...
	AutoParryLogger:RunLoggingFn()
end

-- Return event
return RenderEvent
