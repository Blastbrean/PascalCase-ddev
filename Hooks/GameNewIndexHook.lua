local GameNewIndexHook = {
    OriginalFn = nil
}

-- Requires
local Pascal = require("../Modules/Helpers/Pascal.lua")
local Helper = require("../Modules/Helpers/Helper.lua")

function GameNewIndexHook.HookFn(Self, Key, Value)
    -- This is us...
    if Pascal:GetMethods().CheckCaller() then
        return GameNewIndexHook.OriginalFn(Self, Key, Value)
    end

    -- Get LocalPlayer, if existing doing local-player overrides...
    local LocalPlayerData = Helper.GetLocalPlayerWithData()
    if LocalPlayerData then
        -- Do walk-speed overrides when we have walk-speed override enabled...
        if Self == LocalPlayerData.Humanoid and Key == "WalkSpeed" and Pascal:GetConfig().Movement.WalkSpeedOverride then
            return GameNewIndexHook.OriginalFn(Self, Key, Pascal:GetConfig().Movement.WalkSpeedOverrideAmount)
        end

        -- Do jump-power overrides when we have jump-power override enabled...
        if Self == LocalPlayerData.Humanoid and Key == "JumpPower" and Pascal:GetConfig().Movement.JumpPowerOverride then
            return GameNewIndexHook.OriginalFn(Self, Key, Pascal:GetConfig().Movement.JumpPowerOverrideAmount)
        end
    end

    return GameNewIndexHook.OriginalFn(Self, Key, Value)
end

return GameNewIndexHook