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
