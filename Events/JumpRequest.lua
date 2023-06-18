-- Module
local JumpRequest = {}

-- Requires
local Movement = require("Features/Movement")
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function JumpRequest.CallbackFn(Entity)
	Helper.TryAndCatch(
		-- Try...
		function()
			-- Call Movement InfiniteJump function...
			Movement:RunInfiniteJumpFn()
		end,

		-- Catch...
		function(Error)
			Pascal:GetLogger():Print("JumpRequest.CallBackFn - Caught exception: %s", Error)
		end
	)
end

-- Return event
return JumpRequest
