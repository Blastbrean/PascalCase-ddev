-- Module
local RenderEvent = {}

-- Requires
local AutoParryLogger = require("Features/AutoParryLogger")
local Movement = require("Features/Movement")
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function RenderEvent.CallbackFn(Step)
	Helper.TryAndCatch(
		-- Try...
		function()
			-- Run AutoParry logging...
			AutoParryLogger:RunLoggingFn()
		end,

		-- Catch...
		function(Error)
			Pascal:GetLogger():Print("RenderEvent.CallBackFn - Caught exception: %s", Error)
		end
	)
end

-- Return event
return RenderEvent
