-- Module
local EntityHandler = {
	DisconnectAutoParry = nil,
}

-- Requires
local AutoParry = require("Features/AutoParry")
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function EntityHandler.CallbackFn(Entity)
	Helper.TryAndCatch(
		-- Try...
		function()
			-- Call AutoParry...
			AutoParry:OnEntityAdded(Entity)

			-- (BANDAID-FIX) Cannot require both ways, so I am simply outputting the disconnect function from here...
			EntityHandler.DisconnectAutoParry = AutoParry.Disconnect
		end,

		-- Catch...
		function(Error)
			Pascal:GetLogger():Print("EntityHandler.CallBackFn - Caught exception: %s", Error)
		end
	)
end

-- Return event
return EntityHandler
