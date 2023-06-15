local GameNameCallHook = {
	OriginalFn = nil,
}

-- Requires
local Pascal = require("../Modules/Helpers/Pascal.lua")
local Helper = require("../Modules/Helpers/Helper.lua")

function GameNameCallHook.HookFn(Self, ...)
	-- This is us...
	if Pascal:GetMethods().CheckCaller() then
		return GameNameCallHook.OriginalFn(Self, ...)
	end

	-- Get arguments and namecall-method...
	local Args = { ... }
	local NamecallMethod = Pascal:GetMethods().GetNameCallMethod()

	-- Check if this is the game:FindService function...
	if Self == game and NamecallMethod == "FindService" then
		-- Do not attempt to return services that get detected once created...
		if Args[1] == "VirtualInputManager" or Args[1] == "VirtualUser" then
			return nil
		end
	end

	-- Return original, we don't need to do anything further...
	return GameNameCallHook.OriginalFn(Self, ...)
end

return GameNameCallHook
