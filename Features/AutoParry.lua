-- Module
local AutoParry = {
	EntityData = {},
	Connections = {},
}

-- Services
local Players = GetService("Players")
local VirtualInputManagerService = GetService("VirtualInputManager")
local WorkspaceService = GetService("Workspace")

-- Requires
local Helper = require("Modules/Helpers/Helper")
local Pascal = require("Modules/Helpers/Pascal")
local Remotes = require("Modules/Deepwoken/Remotes")

-- Simulate what a keyboard would do when pressing a key using VirtualInputManager:SendKeyEvent
function AutoParry.SimulateKeyFromKeyEvents(KeyCode)
	-- Send key event
	VirtualInputManagerService:SendKeyEvent(true, KeyCode, false, nil)

	-- Data by key press tool which will time key presses
	local KeyPressDelay = math.random(0.045, 0.087)

	-- Delay script before sending another
	task.wait(KeyPressDelay)

	-- Send key event to unpress key
	VirtualInputManagerService:SendKeyEvent(false, KeyCode, false, nil)
end

-- Recreated InputClient code
function AutoParry.SimulateParryThroughRemotes()
	-- Start input
	Remotes:SafeCallRemoteFromName("Block")

	-- Block until we are in a block state
	AutoParry.BlockUntilBlockState()

	-- End input
	Remotes:SafeCallRemoteFromName("Unblock")
end

function AutoParry.CheckDistanceBetweenParts(BuilderData, Part1, Part2)
	-- Nullify out the height in our calculations
	local Part1Position = Vector3.new(Part1.Position.X, 0.0, Part1.Position.Z)
	local Part2Position = Vector3.new(Part2.Position.X, 0.0, Part2.Position.Z)

	-- Get distance
	local Distance = (Part1Position - Part2Position).Magnitude
	return Distance >= BuilderData.MinimumDistance and Distance <= BuilderData.MaximumDistance
end

function AutoParry.HasTalent(Entity, TalentString)
	if not TalentString:match("Talent:") then
		TalentString = "Talent:" .. TalentString
	end

	local PlayerFromCharacter = Players:GetPlayerFromCharacter(Entity)
	if PlayerFromCharacter and PlayerFromCharacter.Backpack:FindFirstChild(TalentString) then
		return true
	end

	if Entity:FindFirstChild(TalentString) then
		return true
	end

	return false
end

function AutoParry.RunDodgeFn(Entity)
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		AutoParry.SimulateKeyFromKeyEvents(Enum.KeyCode.Q)
		return
	end
end

function AutoParry.BlockUntilBlockState()
	local EffectReplicator = Pascal:GetEffectReplicator()

	-- Block until actually blocking
	while task.wait() do
		-- Make sure we can actually get the LocalPlayer's data
		local LocalPlayerData = Helper.GetLocalPlayerWithData()
		if not LocalPlayerData then
			return
		end

		-- Check for the CharacterHandler & InputClient & Requests
		local CharacterHandler = LocalPlayerData.Character:FindFirstChild("CharacterHandler")
		if not CharacterHandler or not CharacterHandler:FindFirstChild("InputClient") then
			return
		end

		if not EffectReplicator:FindEffect("Action") and not EffectReplicator:FindEffect("Knocked") then
			Remotes:SafeCallRemoteFromName("Block")
		end

		if EffectReplicator:FindEffect("Blocking") then
			break
		end
	end
end

function AutoParry.StartBlockFn()
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		-- Send key event
		VirtualInputManagerService:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
	end

	if Pascal:GetConfig().AutoParry.InputMethod == "Remotes" then
		-- Block until inside of a blocking state
		AutoParry.BlockUntilBlockState()

		-- Start input
		Remotes:SafeCallRemoteFromName("Block")
	end
end

function AutoParry.EndBlockFn()
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		-- Send key event to unpress key
		VirtualInputManagerService:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
	end

	if Pascal:GetConfig().AutoParry.InputMethod == "Remotes" then
		-- End input
		Remotes:SafeCallRemoteFromName("Unblock")
	end
end

function AutoParry.RunParryFn()
	if Pascal:GetConfig().AutoParry.InputMethod == "KeyEvents" then
		AutoParry.SimulateKeyFromKeyEvents(Enum.KeyCode.F)
	end

	if Pascal:GetConfig().AutoParry.InputMethod == "Remotes" then
		AutoParry.SimulateParryThroughRemotes()
	end
end

function AutoParry.EndBlockingStates(PlayerData)
	Helper.LoopLuaTable(PlayerData.AnimationData, function(Index, AnimationData)
		if not AnimationData.StartedBlocking then
			return false
		end

		if AnimationData.AnimationTrack.IsPlaying then
			return false
		end

		-- Get animation builder data
		local BuilderData = AutoParry:GetBuilderData(AnimationData.AnimationTrack.Animation.AnimationId)
		if not BuilderData then
			return false
		end

		-- End blocking
		AutoParry.EndBlockFn()

		-- End blocking state
		AnimationData.StartedBlocking = false

		-- Notify user that blocking has stopped
		Library:Notify(
			string.format("Ended blocking on animation %s(%s)", BuilderData.NickName, BuilderData.AnimationId),
			2.0
		)
	end)
end

function AutoParry.MovementCheck(EffectReplicator)
	if EffectReplicator:FindEffect("Action") then
		return false
	end

	if EffectReplicator:FindEffect("NoParkour") then
		return false
	end

	if EffectReplicator:FindEffect("Knocked") then
		return false
	end

	if EffectReplicator:FindEffect("Unconscious") then
		return false
	end

	if EffectReplicator:FindEffect("Pinned") or EffectReplicator:FindEffect("Carried") then
		return false
	end

	return true
end

function AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, AfterDelay)
	-- Check animation distance
	if
		not AutoParry.CheckDistanceBetweenParts(BuilderData, HumanoidRootPart, LocalPlayerData.HumanoidRootPart)
		and Player ~= LocalPlayerData.Player
	then
		return false
	end

	-- Effect handling...
	local EffectReplicator = Pascal:GetEffectReplicator()

	-- If we're currently attacking we are unable to parry!
	local InsideOfAttack = EffectReplicator:FindEffect("LightAttack")
		and not EffectReplicator:FindEffect("OffhandAttack")

	local CurrentlyInAction = EffectReplicator:FindEffect("Action") or EffectReplicator:FindEffect("MobileAction")

	local CannotCancel = not EffectReplicator:FindEffect("ClickCancel")

	if AfterDelay and CannotCancel and (InsideOfAttack or CurrentlyInAction) and Player ~= LocalPlayerData.Player then
		return false
	end

	-- Cannot parry while we are casting a spell...
	if AfterDelay and EffectReplicator:FindEffect("CastingSpell") and Player ~= LocalPlayerData.Player then
		return false
	end

	-- Can't parry or do anything while we are crouching...
	if AfterDelay and EffectReplicator:FindEffect("Crouching") then
		return false
	end

	-- Can't roll if we are unable to
	if
		AfterDelay
		and BuilderData.ShouldRoll
		and not AutoParry.CanRollWithEffects(EffectReplicator)
		and Player ~= LocalPlayerData.Player
	then
		return false
	end

	-- Cannot block while inside of an action or we are knocked
	if
		AfterDelay
		and (EffectReplicator:FindEffect("Action") or EffectReplicator:FindEffect("Knocked"))
		and Player ~= LocalPlayerData.Player
	then
		return false
	end

	-- Is our animaton still playing?
	if not AnimationTrack.IsPlaying then
		return false
	end

	-- Return true
	return true
end

-- This delay function makes sure that our current state is valid across delays
function AutoParry.DelayAndValidateStateFn(
	DelayInSeconds,
	AnimationTrack,
	BuilderData,
	LocalPlayerData,
	HumanoidRootPart,
	Player
)
	-- Make sure we are valid...
	if not AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, false) then
		return false
	end

	-- Wait the delay out...
	task.wait(DelayInSeconds)

	-- Make sure we are still valid...
	if not AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, true) then
		return false
	end

	return true
end

function AutoParry.CanRollWithEffects(EffectReplicator)
	if not AutoParry.MovementCheck(EffectReplicator) then
		return false
	end

	if EffectReplicator:FindEffect("CarryObject") and not EffectReplicator:FindEffect("ClientSwim") then
		return false
	end

	if EffectReplicator:FindEffect("NoAttack") and not EffectReplicator:FindEffect("CanRoll") then
		return false
	end

	if
		EffectReplicator:FindEffect("UsingSpell")
		or EffectReplicator:FindEffect("Dodged")
		or EffectReplicator:FindEffect("NoRoll")
		or EffectReplicator:FindEffect("Stun")
		or EffectReplicator:FindEffect("Action")
		or EffectReplicator:FindEffect("MobileAction")
		or EffectReplicator:FindEffect("PreventAction")
		or EffectReplicator:FindEffect("Carried")
		or EffectReplicator:FindEffect("ClientSlide")
	then
		return false
	end

	if
		EffectReplicator:FindEffect("LightAttack")
		and (
			EffectReplicator:FindEffect("PressureForward")
			or Helper.GetLocalPlayerWithData().Player.Backpack:FindFirstChild("Talent:Misdirection")
		)
	then
		return false
	end

	if EffectReplicator:FindEffect("Blocking") then
		-- End input
		Remotes:SafeCallRemoteFromName("Unblock")
	end
end

function AutoParry:EmplaceAnimationToData(PlayerData, AnimationTrack, AnimationId)
	if not PlayerData.AnimationData[AnimationId] then
		local AnimationData = {
			AnimationTrack = AnimationTrack,
			StartedBlocking = false,
		}

		PlayerData.AnimationData[AnimationId] = AnimationData
	end

	return PlayerData.AnimationData[AnimationId]
end

function AutoParry:EmplaceEntityToData(Entity)
	if not AutoParry.EntityData[Entity] then
		local EntityData = {
			AnimationData = {},
			MarkedForDeletion = true,
		}

		AutoParry.EntityData[Entity] = EntityData
	end

	return AutoParry.EntityData[Entity]
end

function AutoParry:GetBuilderData(AnimationId)
	-- Builder settings list
	local BuilderSettingsList = Pascal:GetConfig().AutoParryBuilder.BuilderSettingsList
	return BuilderSettingsList[AnimationId]
end

function AutoParry:OnAnimationEnded(EntityData)
	-- Handle block states for player data
	AutoParry.EndBlockingStates(EntityData)
end

function AutoParry:OnAnimationPlayed(EntityData, AnimationTrack, Animation, Player, HumanoidRootPart)
	if not HumanoidRootPart then
		return
	end

	-- Ok, before we do anything... Let's check for these first.
	local LocalPlayerData = Helper.GetLocalPlayerWithData()
	if not LocalPlayerData or LocalPlayerData.Humanoid.Health <= 0 then
		return
	end

	local LeftHand = LocalPlayerData.Character:FindFirstChild("LeftHand")
	local RightHand = LocalPlayerData.Character:FindFirstChild("RightHand")
	if not LeftHand or not RightHand then
		return
	end

	local HandWeapon = LeftHand:FindFirstChild("HandWeapon") or RightHand:FindFirstChild("HandWeapon")
	if not HandWeapon then
		return
	end

	if not Pascal:GetConfig().AutoParry.Enabled then
		return
	end

	if LocalPlayerData.Player == Player and not Pascal:GetConfig().AutoParry.LocalAttackAutoParry then
		return
	end

	-- Get animation builder data
	local BuilderData = AutoParry:GetBuilderData(Animation.AnimationId)
	if not BuilderData then
		return
	end

	-- Get animation data (this should always work)
	local AnimationData = AutoParry:EmplaceAnimationToData(EntityData, AnimationTrack, Animation.AnimationId)
	if not AnimationData then
		return
	end

	-- Validate current auto-parry state is OK
	if not AutoParry.ValidateState(AnimationTrack, BuilderData, LocalPlayerData, HumanoidRootPart, Player, false) then
		return
	end

	-- Block input if need be...
	if Pascal:GetConfig().AutoParry.DelayM1 then
		Remotes.ShouldBlockInput = true
	end

	-- Randomize seed according to the timestamp (ms)
	math.randomseed(DateTime.now().UnixTimestampMillis)

	-- Check hitchance
	if math.random(0, 100) > Pascal:GetConfig().AutoParry.Hitchance then
		return
	end

	-- Calculate delay
	local AttemptMilisecondsConvertedToSeconds = tonumber(BuilderData.AttemptDelay)
			and tonumber(BuilderData.AttemptDelay) / 1000
		or 0

	local RepeatMilisecondsConvertedToSeconds = tonumber(BuilderData.ParryRepeatDelay)
			and tonumber(BuilderData.ParryRepeatDelay) / 1000
		or 0

	-- Ping converted to two decimal places...
	local PingAdjustmentAmount = LocalPlayerData.Player:GetNetworkPing()
		* math.clamp(((Pascal:GetConfig().AutoParry.PingAdjust or 0) / 100), 0.0, 1.0)

	local RepeatDelayAccountingForPingAdjustment =
		math.clamp(RepeatMilisecondsConvertedToSeconds - PingAdjustmentAmount, 0.0, math.huge)

	local AttemptDelayAccountingForPingAdjustment =
		math.clamp(AttemptMilisecondsConvertedToSeconds - PingAdjustmentAmount, 0.0, math.huge)

	-- Notify user that animation has started
	Library:Notify(
		string.format(
			"Delaying on animation %s(%s) for %.3f seconds (%.3f / %.3f) (%.3f) (%.3f)",
			BuilderData.NickName,
			BuilderData.AnimationId,
			AttemptDelayAccountingForPingAdjustment,
			AnimationTrack.TimePosition,
			AnimationTrack.Length,
			AnimationTrack.Speed,
			os.clock()
		),
		2.0
	)

	-- Wait for delay to occur
	local DelayResult = AutoParry.DelayAndValidateStateFn(
		AttemptDelayAccountingForPingAdjustment,
		AnimationTrack,
		BuilderData,
		LocalPlayerData,
		HumanoidRootPart,
		Player
	)

	if not DelayResult then
		-- Notify user that delay has failed
		Library:Notify(
			string.format(
				"Failed delay on animation %s(%s) due to state validation",
				BuilderData.NickName,
				BuilderData.AnimationId
			),
			2.0
		)

		return
	end

	-- Handle auto-parry repeats
	if BuilderData.ParryRepeat and not BuilderData.ShouldBlock and not BuilderData.ShouldRoll then
		local RepeatDelayResult = nil

		for RepeatIndex = 1, (BuilderData.ParryRepeatTimes or 0) do
			-- Parry
			AutoParry.RunParryFn()

			-- Notify user that animation has repeated
			Library:Notify(
				string.format(
					"(%i) Activated on animation %s(%s) (%s: %.3f seconds)",
					RepeatIndex,
					BuilderData.NickName,
					BuilderData.AnimationId,
					RepeatDelayResult and "repeat-delay" or "delay",
					RepeatDelayResult and RepeatDelayAccountingForPingAdjustment
						or AttemptDelayAccountingForPingAdjustment
				),
				2.0
			)

			-- Wait for delay to occur
			RepeatDelayResult = AutoParry.DelayAndValidateStateFn(
				RepeatDelayAccountingForPingAdjustment,
				AnimationTrack,
				BuilderData,
				LocalPlayerData,
				HumanoidRootPart,
				Player
			)

			if not RepeatDelayResult then
				-- Notify user that delay has failed
				Library:Notify(
					string.format(
						"Failed delay on animation %s(%s) due to state validation",
						BuilderData.NickName,
						BuilderData.AnimationId
					),
					2.0
				)

				return
			end
		end

		return
	end

	-- Handle normal auto-parry
	if not BuilderData.ShouldBlock and not BuilderData.ShouldRoll and not BuilderData.ParryRepeat then
		-- Run auto-parry
		AutoParry.RunParryFn()

		-- Notify user that animation has ended
		Library:Notify(
			string.format(
				"Activated on animation %s(%s) (%.3f)",
				BuilderData.NickName,
				BuilderData.AnimationId,
				os.clock()
			),
			2.0
		)
	end

	-- Handle blocking
	if BuilderData.ShouldBlock then
		-- Start blocking
		AutoParry.StartBlockFn()

		-- Notify user that blocking has started
		Library:Notify(
			string.format("Started blocking on animation %s(%s)", BuilderData.NickName, BuilderData.AnimationId),
			2.0
		)

		-- Set animation data that we started blocking
		AnimationData.StartedBlocking = true
	end

	-- Handle dodging
	if BuilderData.ShouldRoll then
		-- Start dodging
		AutoParry.RunDodgeFn(Entity)

		-- Notify user that we have dodged
		Library:Notify(string.format("Dodged animation %s(%s)", BuilderData.NickName, BuilderData.AnimationId), 2.0)
	end
end

function AutoParry.Disconnect()
	Helper.LoopLuaTable(AutoParry.Connections, function(Index, Connection)
		Connection:Disconnect()
	end)
end

function AutoParry:OnEntityAdded(Entity)
	local Humanoid = Entity:WaitForChild("Humanoid")
	if not Humanoid then
		return
	end

	local HumanoidRootPart = Entity:WaitForChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local Animator = Humanoid:WaitForChild("Animator")
	if not Animator then
		return
	end

	local EntityData = AutoParry:EmplaceEntityToData(Entity)
	if not EntityData then
		return
	end

	-- Connect event to OnAnimationEnded...
	table.insert(
		AutoParry.Connections,
		Animator.AnimationPlayed:Connect(function(AnimationTrack)
			-- Call OnAnimationPlayed...
			AutoParry:OnAnimationPlayed(
				EntityData,
				AnimationTrack,
				AnimationTrack.Animation,
				Helper.GetPlayerFromEntity(Entity),
				HumanoidRootPart
			)

			-- Connect event to OnAnimationEnded...
			table.insert(
				AutoParry.Connections,
				AnimationTrack.Stopped:Connect(function()
					-- Stop blocking input if need be...
					if Pascal:GetConfig().AutoParry.DelayM1 then
						Remotes.ShouldBlockInput = false
					end

					-- Call OnAnimationEnded...
					AutoParry:OnAnimationEnded(EntityData)
				end)
			)
		end)
	)
end

return AutoParry
