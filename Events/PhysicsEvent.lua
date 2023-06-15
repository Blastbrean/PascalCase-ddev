-- Module
local PhysicsEvent = {}

-- Requires
local Movement = require("../Features/Movement.lua")

function PhysicsEvent.CallbackFn()
	-- Run Noclip function...
	Movement:RunNoclipFn()
end

-- Return event
return PhysicsEvent
