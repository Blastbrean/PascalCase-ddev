local Helper = {}

-- Services
local PlayerService = GetService("Players")

-- Main code
function Helper.LoopLuaTable(Table, CallbackFn)
	for Index, Value in next, Table do
		local CallbackReturn = CallbackFn(Index, Value)
		if not CallbackReturn then
			continue
		end

		if typeof(CallbackReturn) == "table" and CallbackReturn.ReturningData == true then
			return CallbackReturn.Data
		end

		break
	end
end

function Helper.GetPlayerFromEntity(Entity)
	return PlayerService:GetPlayerFromCharacter(Entity)
end

function Helper.LoopInstanceDescendants(Instance, CallbackFn)
	for Index, Value in next, Instance:GetDescendants() do
		if not CallbackFn(Index, Value) then
			continue
		end

		break
	end
end

function Helper.LoopCurrentEntities(SkipLocal, EntityFolder, CallbackFn)
	for Index, Entity in next, EntityFolder:GetChildren() do
		local Player = PlayerService:GetPlayerFromCharacter(Entity)
		if Player and Player == PlayerService.LocalPlayer and SkipLocal then
			continue
		end

		local Humanoid = Entity:FindFirstChild("Humanoid")
		if not Humanoid then
			continue
		end

		local HumanoidRootPart = Entity:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart then
			continue
		end

		if not CallbackFn(Index, Entity, Player, Humanoid, HumanoidRootPart) then
			continue
		end

		break
	end
end

function Helper.LoopCurrentPlayers(SkipLocal, CallbackFn)
	for Index, Player in next, PlayerService:GetChildren() do
		local Character = Player.Character
		if not Character then
			continue
		end

		local Humanoid = Character:FindFirstChild("Humanoid")
		if not Humanoid then
			continue
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		if not HumanoidRootPart then
			continue
		end

		if SkipLocal and Player == PlayerService.LocalPlayer then
			continue
		end

		if not CallbackFn(Index, Player, Character, Humanoid, HumanoidRootPart) then
			continue
		end

		break
	end
end

function Helper.LoopInstanceChildren(Instance, CallbackFn)
	for Index, LoopInstance in next, Instance:GetChildren() do
		local CallbackReturn = CallbackFn(Index, LoopInstance)
		if not CallbackReturn then
			continue
		end

		if typeof(CallbackReturn) == "table" and CallbackReturn.ReturningData == true then
			return CallbackReturn.Data
		end

		break
	end
end

function Helper.LoopOverPlayingAnimationTracks(Animator, CallbackFn)
	local PlayingAnimationTracks = Animator:GetPlayingAnimationTracks()
	if not PlayingAnimationTracks then
		return
	end

	for Index, LoopTrack in next, PlayingAnimationTracks do
		if not LoopTrack.Animation or not LoopTrack.IsPlaying then
			continue
		end

		local CallbackReturn = CallbackFn(Index, LoopTrack, LoopTrack.Animation)
		if not CallbackReturn then
			continue
		end

		break
	end
end

function Helper.GetPlayerWithData(Player)
	if not Player then
		return nil
	end

	local Character = Player.Character
	if not Character then
		return nil
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	if not Humanoid then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return nil
	end

	return { Player = Player, Character = Character, Humanoid = Humanoid, HumanoidRootPart = HumanoidRootPart }
end

function Helper.GetLocalPlayerWithData()
	local LocalPlayer = PlayerService.LocalPlayer
	if not LocalPlayer then
		return nil
	end

	local Character = LocalPlayer.Character
	if not Character then
		return nil
	end

	local Humanoid = Character:FindFirstChild("Humanoid")
	if not Humanoid then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return nil
	end

	return { Player = LocalPlayer, Character = Character, Humanoid = Humanoid, HumanoidRootPart = HumanoidRootPart }
end

return Helper
