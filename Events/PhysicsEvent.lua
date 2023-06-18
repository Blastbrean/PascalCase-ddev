-- Module
local PhysicsEvent = {}

-- Requires
local Movement = require("Features/Movement")
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function PhysicsEvent.CallbackFn()
	Helper.TryAndCatch(
		-- Try...
		function()
			-- Run Noclip function...
			Movement:RunNoclipFn()
		end,

		-- Catch...
		function(Error)
			Pascal:GetLogger():Print("PhysicsEvent.CallBackFn - Caught exception: %s", Error)
		end
	)
end

-- Return event
return PhysicsEvent
