-- Module
local JumpRequest = {}

-- Requires
local Movement = require("Features/Movement")

function JumpRequest.CallbackFn(Entity)
	-- Call Movement InfiniteJump function...
	Movement:RunInfiniteJumpFn()
end

-- Return event
return JumpRequest
