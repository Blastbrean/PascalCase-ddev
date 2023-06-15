-- Module
local AutoParryLogger = {
	CachedAnimations = {},
	CachedSoundNames = {},

	HasCachedAnimations = false,
	HasCachedSoundNames = false,

	-- Names that we specifically won't show to the user for a better experience...
	BlacklistedNames = {
		["sprint"] = true,
		["idle"] = true,
		["draw"] = true,
		["walk"] = true,
		["jump"] = true,
		["roll"] = true,
		["crouch"] = true,
		["cancelleft"] = true,
		["cancelright"] = true,
		["cancelforwards"] = true,
		["cancelback"] = true,
		["groundslide"] = true,
		["freefall"] = true,
		["parry"] = true,
		["resting"] = true,
		["slide"] = true,
		["landinganim"] = true,
		["vault"] = true,
		["equip"] = true,
		["swim"] = true,
		["treadwater"] = true,
		["block"] = true,
	},
}

-- Services
local WorkspaceService = GetService("Workspace")

-- Requires
local Helper = require("../Modules/Helpers/Helper.lua")
local Pascal = require("../Modules/Helpers/Pascal.lua")

function AutoParryLogger.GetDistanceBetweenParts(Part1, Part2)
	-- Nullify out the height in our calculations
	local Part1Position = Vector3.new(Part1.Position.X, 0.0, Part1.Position.Z)
	local Part2Position = Vector3.new(Part2.Position.X, 0.0, Part2.Position.Z)

	-- Get distance
	local Distance = (Part1Position - Part2Position).Magnitude
	return Distance
end

function AutoParryLogger.IsDistanceOkBetweenParts(Part1, Part2)
	-- Get distance
	local Distance = AutoParryLogger.GetDistanceBetweenParts(Part1, Part2)

	-- Get bounds
	local MinimumDistance = Pascal:GetConfig().AutoParryLogging.MinimumDistance
	local MaximumDistance = Pascal:GetConfig().AutoParryLogging.MaximumDistance

	-- Return if within bounds
	return Distance >= MinimumDistance and Distance <= MaximumDistance
end

function AutoParryLogger:IsAnimationNameBlacklistedByDefault(Name)
	Name = string.lower(Name)

	return Helper.LoopLuaTable(AutoParryLogger.BlacklistedNames, function(Index, Value)
		if not Name:match(Index) then
			return false
		end

		return {
			ReturningData = true,
			Data = Value,
		}
	end)
end

function AutoParryLogger:CacheSoundNames()
	if AutoParryLogger.HasCachedSoundNames then
		return
	end

	Helper.LoopInstanceDescendants(game, function(Index, Descendant)
		if not Descendant:IsA("Sound") then
			return false
		end

		AutoParryLogger.CachedSoundNames[Descendant.SoundId] = Descendant.Name
	end)

	AutoParryLogger.CachedSoundNames = true
end

function AutoParryLogger:CacheAnimations()
	if AutoParryLogger.HasCachedAnimations then
		return
	end

	Helper.LoopInstanceDescendants(game, function(Index, Descendant)
		if not Descendant:IsA("Animation") then
			return false
		end

		AutoParryLogger.CachedAnimations[Descendant.AnimationId] = Descendant
	end)

	AutoParryLogger.HasCachedAnimations = true
end

function AutoParryLogger:RunLoggingFn()
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData then
		return
	end

	-- Cache animations
	AutoParryLogger:CacheAnimations()

	-- Update blacklist for info-logger
	Library:UpdateInfoLoggerBlacklist(Pascal:GetConfig().AutoParryLogging.BlacklistedAnimationIds)

	-- Loop over Live Folder (contains all living entities)
	Helper.LoopCurrentEntities(
		not Pascal:GetConfig().AutoParryLogging.LogYourself,
		WorkspaceService:WaitForChild("Live"),
		function(Index, Entity, Player, Humanoid, HumanoidRootPart)
			local Animator = Humanoid:FindFirstChild("Animator")
			if not Animator then
				return false
			end

			if
				not AutoParryLogger.IsDistanceOkBetweenParts(HumanoidRootPart, LocalPlayerData.HumanoidRootPart)
				and Player ~= LocalPlayerData.Player
			then
				return false
			end

			-- Loop over playing animation tracks
			Helper.LoopOverPlayingAnimationTracks(Animator, function(TrackIndex, AnimationTrack, Animation)
				local AnimationId = Animation.AnimationId
				local AnimationName = self.CachedAnimations[AnimationId] and self.CachedAnimations[AnimationId].Name
					or AnimationTrack.Name

				if AutoParryLogger:IsAnimationNameBlacklistedByDefault(AnimationName) then
					return false
				end

				Library:AddAnimationDataToInfoLogger(
					Entity.Name,
					AnimationId,
					AnimationName,
					AnimationTrack,
					self.CachedAnimations[AnimationId],
					AutoParryLogger.GetDistanceBetweenParts(HumanoidRootPart, LocalPlayerData.HumanoidRootPart)
				)
			end)

			-- Delete non playing animation data in logger
			Library:DeleteNonPlayingAnimationData(Entity.Name)
		end
	)
end

return AutoParryLogger
