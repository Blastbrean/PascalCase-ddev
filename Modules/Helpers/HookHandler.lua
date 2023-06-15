local HookHandler = {}

-- Requires
local Pascal = require("Modules/Helpers/Pascal")

-- Hooks
local GameNewIndexHook = require("Hooks/GameNewIndexHook")
local GameNameCallHook = require("Hooks/GameNameCallHook")

function HookHandler:RemoveHooks()
	if not GameNewIndexHook.OriginalFn or not GameNameCallHook.OriginalFn then
		return false
	end

	Pascal:GetMethods().HookMetaMethod(game, "__newindex", GameNewIndexHook.OriginalFn)
	Pascal:GetMethods().HookMetaMethod(game, "__namecall", GameNameCallHook.OriginalFn)
	return true
end

function HookHandler:StartHooks()
	GameNewIndexHook.OriginalFn = Pascal:GetMethods().HookMetaMethod(game, "__newindex", GameNewIndexHook.HookFn)
	if not GameNewIndexHook.OriginalFn then
		return false
	end

	GameNameCallHook.OriginalFn = Pascal:GetMethods().HookMetaMethod(game, "__namecall", GameNameCallHook.HookFn)
	if not GameNameCallHook.OriginalFn then
		return false
	end

	return true
end

return HookHandler
