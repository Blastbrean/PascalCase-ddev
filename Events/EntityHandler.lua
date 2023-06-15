-- Module
local EntityHandler = {
	DisconnectAutoParry = nil,
}

-- Requires
local AutoParry = require("Features/AutoParry")

function EntityHandler.CallbackFn(Entity)
	-- Call AutoParry...
	AutoParry:OnEntityAdded(Entity)

	-- (BANDAID-FIX) Cannot require both ways, so I am simply outputting the disconnect function from here...
	EntityHandler.DisconnectAutoParry = AutoParry.Disconnect
end

-- Return event
return EntityHandler
