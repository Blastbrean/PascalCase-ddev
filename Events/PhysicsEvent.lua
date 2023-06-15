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
