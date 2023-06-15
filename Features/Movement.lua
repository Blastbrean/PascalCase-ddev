local Movement = {}

-- Requires
local Helper = require("../Modules/Helpers/Helper.lua")
local Pascal = require("../Modules/Helpers/Pascal.lua")

function Movement:ResetNoclipFn()
	-- We don't want to run this if we cannot get the LocalPlayer...
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	Helper.LoopInstanceChildren(LocalPlayerData.Character, function(Index, Children)
		-- Check if it's a part we want...
		if not Children:IsA("BasePart") then
			return false
		end

		-- Check if it's already collided...
		if Children.CanCollide then
			return false
		end

		-- Collide this part...
		Children.CanCollide = true

		-- Return false to continue...
		return false
	end)
end

function Movement:RunInfiniteJumpFn()
	-- We don't want to run this if we cannot get the LocalPlayer...
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	-- We don't want to run this if we don't have InfiniteJump on...
	if not Pascal:GetConfig().Movement.InfiniteJump then
		return
	end

	-- Force our state to change to jumping...
	LocalPlayerData.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end

function Movement:RunNoclipFn()
	-- We don't want to run this if we cannot get the LocalPlayer...
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	-- We don't want to run this if we don't have NoClip on...
	if not Pascal:GetConfig().Movement.NoClip then
		return Movement:ResetNoclipFn()
	end

	-- Set the collidable parts our character to not collide...
	Helper.LoopInstanceChildren(LocalPlayerData.Character, function(Index, Children)
		-- Check if it's a part we want...
		if not Children:IsA("BasePart") then
			return false
		end

		-- Check if it's already uncollided...
		if not Children.CanCollide then
			return false
		end

		-- Uncollide this part...
		Children.CanCollide = false

		-- Return false to continue...
		return false
	end)
end

return Movement
