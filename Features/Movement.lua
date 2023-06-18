local Movement = {
	UncollidedInstancesTable = {},
}

-- Requires
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")

function Movement:ResetNoclipFn()
	-- We don't want to run this if we cannot get the LocalPlayer...
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	Helper.LoopLuaTable(Movement.UncollidedInstancesTable, function(Index, Instance)
		-- Check if it's a part we want...
		if not Instance:IsA("BasePart") then
			return false
		end

		-- Check if it's already collided...
		if Instance.CanCollide then
			return false
		end

		-- Collide this part...
		Instance.CanCollide = true

		-- Remove part from uncolided table...
		Movement.UncollidedInstancesTable[Index] = nil

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

		-- Insert to parts we have uncolided...
		table.insert(Movement.UncollidedInstancesTable, Children)

		-- Return false to continue...
		return false
	end)
end

return Movement
