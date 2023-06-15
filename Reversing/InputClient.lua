-- Decompiled with the Synapse X Luau decompiler.

local l__ReplicatedStorage__1 = GetService("ReplicatedStorage")
local v2 = require(l__ReplicatedStorage__1.EffectReplicator)
v2:WaitForContainer()
local v3 = tostring(v2.FindEffect)
local v4 = require(l__ReplicatedStorage__1.Modules.Lib)
local v5 = require(l__ReplicatedStorage__1.Modules.VectorMaths)
local v6 = require(game.ReplicatedStorage.Modules.Waves)
local l__TweenService__7 = GetService("TweenService")
local l__RunService__8 = GetService("RunService")
local v9 = setmetatable({}, {
	__index = 1,
	__tostring = 1,
	__newindex = 1,
})
for v10 = 1, 10 do
	v9 = setmetatable(v9, {
		__index = 1,
		__tostring = 1,
		__newindex = 1,
	})
end
scr = script
script = setmetatable({}, {
	__index = 1,
	__tostring = 1,
	__newindex = 1,
	__call = 1,
	__namecall = 1,
	__metatable = false,
})
local l__Parent__11 = scr.Parent
local l__Requests__12 = l__Parent__11:WaitForChild("Requests")
local l__StopSprint__13 = l__Requests__12:WaitForChild("StopSprint")
local l__LocalPlayer__14 = game.Players.LocalPlayer
local v15 = l__LocalPlayer__14.Character or l__LocalPlayer__14.CharacterAdded:wait()
local l__Humanoid__16 = v15:WaitForChild("Humanoid")
local l__HumanoidRootPart__17 = v15:WaitForChild("HumanoidRootPart")
local l__Torso__18 = v15:WaitForChild("Torso")
local l__UserInputService__19 = GetService("UserInputService")
local l__Movement__20 = l__ReplicatedStorage__1.Assets.Anims.Movement
local l__Workspace__21 = GetService("Workspace")
local l__RunService__22 = GetService("RunService")
local l__Players__23 = GetService("Players")
local l__ReplicatedStorage__24 = GetService("ReplicatedStorage")
local l__Lighting__25 = GetService("Lighting")
local l__TweenService__26 = GetService("TweenService")
local l__Debris__27 = GetService("Debris")
local l__GetDescendants__28 = game.GetDescendants
local l__FindFirstChild__1 = game.FindFirstChild
function hasTalent(p1, p2)
	if not p2:match("Talent:") then
		p2 = "Talent:" .. p2
	end
	local v29 = game.Players:GetPlayerFromCharacter(p1)
	if v29 then
		if l__FindFirstChild__1(v29.Backpack, p2) then
			return true
		end
	elseif l__FindFirstChild__1(p1, p2) then
		return true
	end
	return false
end
local l__LoadAnimation__30 = Instance.new("Humanoid").LoadAnimation
local l__GetState__31 = Instance.new("Humanoid").GetState
local l__SoundService__32 = GetService("SoundService")
local l__CollectionService__33 = GetService("CollectionService")
local l__AddTag__34 = l__CollectionService__33.AddTag
local l__InvokeServer__35 = Instance.new("RemoteFunction").InvokeServer
local l__FireServer__36 = Instance.new("RemoteEvent").FireServer
local v37 = tostring(l__InvokeServer__35)
local v38 = tostring(l__FireServer__36)
local l__Disconnect__39 = game.Changed:Connect(function() end).Disconnect
local l__Live__40 = l__Workspace__21:WaitForChild("Live")
local l__NPCs__41 = l__Workspace__21:WaitForChild("NPCs")
local l__Thrown__42 = l__Workspace__21:WaitForChild("Thrown")
local l__Terrain__43 = l__Workspace__21:WaitForChild("Terrain")
local u2 = require(l__ReplicatedStorage__24.Modules.ClientManager.KeyHandler)()
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("Dodge", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("StopDodge", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("Block", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("Unblock", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("LeftClick", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("RightClick", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("CriticalClick", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("CriticalUnclick", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("ServerSwim", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("GrabShip", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("ServerSlide", math.huge))
end)
task.spawn(function()
	u2[2](l__Requests__12:WaitForChild("ServerSlideStop", math.huge))
end)
local v44 = l__Humanoid__16:LoadAnimation(scr.Jump)
local v45 = l__Humanoid__16:LoadAnimation(l__Movement__20.Roll.CancelLeft)
local v46 = l__Humanoid__16:LoadAnimation(l__Movement__20.Roll.CancelRight)
local l__ForwardRoll__47 = l__Movement__20.Roll.ForwardRoll
local l__BackRoll__48 = l__Movement__20.Roll.BackRoll
local l__RightRoll__49 = l__Movement__20.Roll.RightRoll
local l__LeftRoll__50 = l__Movement__20.Roll.LeftRoll
local v51 = l__Humanoid__16:LoadAnimation(l__Movement__20.Sprint)
local v52 = l__Humanoid__16:LoadAnimation(l__Movement__20.SaberSprint)
local v53 = l__Humanoid__16:LoadAnimation(l__Movement__20.AxeSprint)
local v54 = l__Humanoid__16:LoadAnimation(l__Movement__20.RifleSprint)
local v55 = l__Humanoid__16:LoadAnimation(l__Movement__20.GreatswordSprint)
local v56 = l__Humanoid__16:LoadAnimation(l__Movement__20.FistSprint)
local v57 = l__Humanoid__16:LoadAnimation(l__Movement__20.Groundslide)
local v58 = l__Humanoid__16:LoadAnimation(l__Movement__20.Freestyle)
local v59 = l__Humanoid__16:LoadAnimation(l__Movement__20.Swim)
local v60 = l__Humanoid__16:LoadAnimation(l__Movement__20.TreadWater)
function InAir()
	if v2:FindEffect("Swimming") then
		return false
	end
	local v61 = v15.Humanoid:GetState()
	if v61 ~= Enum.HumanoidStateType.Freefall then
	else
		return true
	end
	if v61 == Enum.HumanoidStateType.Jumping then
		return true
	end
	if v2:FindEffect("AirBorne") then
		return true
	end
	return false
end
l__ReplicatedStorage__24.Requests.GetShiftLock.OnClientInvoke = function()
	return not (not v2:FindEffect("ShiftLock"))
end
l__ReplicatedStorage__24.Requests.WaitTillState.OnClientInvoke = function()
	while true do
		task.wait()
		print("Waiting")
		if v15.Humanoid.FloorMaterial ~= Enum.Material.Air then
			break
		end
	end
	print("Finished")
	return true
end
local l__CurrentCamera__3 = l__Workspace__21.CurrentCamera
local l__mouse__4 = l__LocalPlayer__14:GetMouse()
local l__IsA__5 = game.IsA
l__ReplicatedStorage__24.Requests.GetResTP.OnClientInvoke = function()
	local v62 = nil
	local v63 = 0.4
	local v64 = CFrame.new(l__CurrentCamera__3.CFrame.p, l__mouse__4.Hit.p)
	local l__ExistingResTPMarkers__65 = l__Workspace__21:FindFirstChild("ExistingResTPMarkers")
	if not l__ExistingResTPMarkers__65 then
		return
	end
	for v66, v67 in pairs(l__ExistingResTPMarkers__65:GetChildren()) do
		if v67.Value and v67.Value.Parent then
			local v68 = v67.Value
			if l__IsA__5(v68, "BasePart") then
				v68 = v68.X
			end
			local l__Adornee__69 = v68.Adornee
			if
				(CFrame.new(l__CurrentCamera__3.CFrame.p, l__Adornee__69.Position).lookVector - v64.LookVector).magnitude
				< v63
			then
				v63 = (CFrame.new(l__CurrentCamera__3.CFrame.p, l__Adornee__69.Position).lookVector - v64.lookVector).magnitude
				v62 = v68.ListID.Value
			end
		end
	end
	return v62
end
l__ReplicatedStorage__24.Requests.GetCameraToMouse.OnClientInvoke = function()
	return CFrame.new(l__CurrentCamera__3.CFrame.p, l__mouse__4.Hit.p)
end
local u6 = {}
game.ReplicatedStorage.Requests.GetMouse.OnClientInvoke = function()
	local v70 = {
		Hit = l__mouse__4.Hit,
	}
	local v71 = l__mouse__4.Target
	if v71 and v71.Name == "MouseTracker" and v71:IsDescendantOf(l__Terrain__43) then
		v71 = v71.Parent
	end
	v70.Target = v71
	v70.UnitRay = l__mouse__4.UnitRay
	v70.X = l__mouse__4.X
	v70.Y = l__mouse__4.Y
	return v70, u6
end
function MovementCheck()
	if v2:FindEffect("Action") then
		return false
	end
	if v2:FindEffect("NoParkour") then
		return false
	end
	if not v2:FindEffect("Knocked") then
	else
		return false
	end
	if v2:FindEffect("Unconscious") then
		return false
	end
	if not v2:FindEffect("Pinned") then
		if v2:FindEffect("Carried") then
		else
			return true
		end
	end
	return false
end
function CrouchCheck()
	if not MovementCheck() then
		return
	end
	if v2:FindEffect("Stun") then
		return
	end
	if v2:FindEffect("Action") then
		return
	end
	if v2:FindEffect("MobileAction") then
		return
	end
	if v2:FindEffect("Blocking") then
		return
	end
	if v2:FindEffect("ClientSlide") then
		return
	end
	if v2:FindEffect("ClientSwim") then
		return
	end
	return true
end
local u7 = false
local u8 = false
local u9 = false
local u10 = l__Humanoid__16:LoadAnimation(l__Movement__20.Crouch)
function Crouch()
	local v72 = v2:FindEffect("ClientCrouch")
	if v72 then
		if u7 then
			return
		else
			v72:Remove()
			return
		end
	end
	local v73 = v2:FindEffect("ClientSlide")
	if v73 then
		v73:Remove()
		return
	end
	if v2:FindEffect("Crouching") then
		return
	end
	if v2:FindEffect("ClientSwim") then
		return
	end
	if v2:FindEffect("ClientDodge") then
		return
	end
	if not CrouchCheck() then
		return
	end
	local l__MoveDirection__74 = l__Humanoid__16.MoveDirection
	if 0.1 < l__MoveDirection__74.magnitude then
		local v75 = false
		local v76, v77, v78 = l__Workspace__21:FindPartOnRayWithIgnoreList(
			Ray.new(l__HumanoidRootPart__17.Position, (Vector3.new(0, -12, 0))),
			{ l__Live__40, l__NPCs__41, l__Thrown__42 }
		)
		if v76 then
			if v78.y <= 0.99 then
				local l__unit__79 = (v78 * Vector3.new(1, 0, 1)).unit
				local l__magnitude__80 = l__unit__79.magnitude
				if 0 < l__magnitude__80 then
					if l__magnitude__80 == l__magnitude__80 then
						if -0.1 < l__unit__79:Dot(l__MoveDirection__74) then
							v75 = true
						end
					end
				end
			end
		end
		local v81 = v15.Humanoid:GetState()
		if v81 ~= Enum.HumanoidStateType.Freefall then
			if v81 ~= Enum.HumanoidStateType.Jumping then
				if v81 ~= Enum.HumanoidStateType.Landed then
				end
			else
				v83 = true
			end
		else
			v83 = true
		end
		if u8 ~= true then
			if u9 == true then
				if not v75 then
					SlideForward(v83)
					return
				end
			end
		elseif not v75 then
			SlideForward(v83)
			return
		end
		if v75 then
			SlideDown(v83)
			return
		end
	end
	if v2:FindEffect("CastingSpell") then
		return
	end
	Sprint(false)
	u10:Play()
	l__Requests__12.ServerCrouch:FireServer(true)
	if CrouchCheck() then
		if not v2:FindEffect("Sprinting") then
			local l__Jump__82 = l__Humanoid__16.Jump
		end
	end
	local v83 = v2:CreateEffect("ClientCrouch")
	while true do
		local v84 = not CrouchCheck()
		if not v84 then
			v84 = v2:FindEffect("Sprinting")
			if not v84 then
				v84 = l__Humanoid__16.Jump
				if not v84 then
					v84 = true
					if u8 ~= true then
						v84 = v2:FindEffect("DurationCast")
					end
				end
			end
		end
		if l__Humanoid__16.MoveDirection.magnitude < 0.1 then
			u10:AdjustSpeed(0)
		else
			u10:AdjustSpeed(l__Humanoid__16.WalkSpeed / 15.5)
		end
		wait()
		if v83 then
		else
			break
		end
		if v83.Parent then
		else
			break
		end
		if not v84 then
		else
			break
		end
		if not v2:FindEffect("LightAttack") then
		else
			break
		end
	end
	l__Requests__12.ServerCrouch:FireServer(false)
	u10:Stop()
	if v83 then
		if v83.Parent then
			v83:Remove()
		end
	end
end
local l__pcall__11 = pcall
function JetJump()
	if v2:FindEffect("ClientSwim") then
		return
	end
	if not hasTalent(v15, "Arc Module: Leap") then
		return
	end
	if not (v15:FindFirstChild("Ether").Value < 15) then
	else
		return
	end
	if v2:FindEffect("JetJumpCD") then
		return
	end
	v2:CreateEffect("JetJumpCD"):Debris(5)
	v2:CreateEffect("ArcJump"):Debris(0.25)
	local l__Position__12 = l__HumanoidRootPart__17.Position
	local u13 = l__HumanoidRootPart__17.CFrame.UpVector * 3
	l__pcall__11(function()
		l__Requests__12.ServerJetJump:FireServer(l__Position__12, u13)
	end)
	local v85 = 40
	if l__Humanoid__16.Health < l__Humanoid__16.MaxHealth * 0.5 then
		v85 = v85 / 2
	end
	local v86 = Instance.new("BodyVelocity", l__HumanoidRootPart__17)
	v86.Velocity = u13.unit * v85
	v86.MaxForce = Vector3.new(0, 1, 0) * 80000
	if v2:FindEffect("GravityField") then
		v86.MaxForce = Vector3.new(60000, 50, 60000)
	end
	v86.Parent = v15.Torso
	l__CollectionService__33:AddTag(v86, "AllowedBM")
	local v87 = tick()
	l__Humanoid__16:LoadAnimation(scr.JetJump):Play(0.1)
	while true do
		task.wait()
		if tick() - v87 < 0.05 then
			v86.Velocity = u13.unit * v85 * 1.5
		else
			v86.Velocity = u13.unit * v85
		end
		if not (0.5 <= tick() - v87) then
		else
			break
		end
		if u6.Space then
		else
			break
		end
		if not v2:FindEffect("Stun") then
		else
			break
		end
		if not v2:FindEffect("Action") then
		else
			break
		end
	end
	local v88 = Instance.new("Folder", v15)
	v88.Name = "ExhaustCancel"
	game.Debris:AddItem(v88, 0.1)
	if v86 then
		v86:Destroy()
	end
end
local u14 = 0
function LongJump(p3)
	local v89 = tick()
	local v90 = 1
	if v2:FindEffect("Danger") then
		v90 = 2
	end
	if v89 - u14 < v90 then
		return
	end
	if v2:FindEffect("GravityField") then
		return
	end
	local l__Position__91 = l__HumanoidRootPart__17.Position
	local v92 = Instance.new("BodyVelocity")
	v92.Name = "SlideJump"
	local v93 = 50
	if p3 ~= false then
		v93 = v93 + 10
		v2:CreateEffect("SlideJumping"):Debris(1.5)
	end
	if v15.Humanoid.Health <= v15.Humanoid.MaxHealth * 0.4 then
		v93 = v93 * 0.8
	end
	v92.Velocity = (l__HumanoidRootPart__17.CFrame.lookVector * 3 + l__HumanoidRootPart__17.CFrame.upVector).unit * v93
	v92.MaxForce = Vector3.new(1, 1, 1) * 80000
	l__CollectionService__33:AddTag(v92, "AllowedBM")
	v92.Parent = v15.Torso
	l__Debris__27:AddItem(v92, 0.25)
	v2:CreateEffect("AirBorne"):Debris(0.5)
	game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("WindTrails", {
		char = v15,
		Duration = 0.5,
	})
	u14 = v89
end
function GaleLeap(p4)
	if v2:FindEffect("Danger") then
		if v15:FindFirstChild("Ether").Value < 20 then
			return
		end
	end
	v2:CreateEffect("GaleLeapin"):Debris(0.25)
	local l__Position__15 = l__HumanoidRootPart__17.Position
	local u16 = l__HumanoidRootPart__17.CFrame.lookVector * 3 + l__HumanoidRootPart__17.CFrame.upVector
	l__pcall__11(function()
		l__Requests__12.ServerGaleLeap:FireServer(l__Position__15, u16, p4)
	end)
	local v94 = 110
	if l__Humanoid__16.Health < l__Humanoid__16.MaxHealth * 0.5 then
		v94 = v94 / 2
	end
	local v95 = Instance.new("BodyVelocity")
	v95.Velocity = u16.unit * v94
	v95.MaxForce = Vector3.new(1, 1, 1) * 80000
	v95.Parent = v15.Torso
	l__CollectionService__33:AddTag(v95, "AllowedBM")
	l__Debris__27:AddItem(v95, 0.25)
	l__Humanoid__16:LoadAnimation(scr.GaleLeap):Play(0.1)
end
local u17 = false
local u18 = l__Humanoid__16:LoadAnimation(l__Movement__20.Slide)
local u19 = false
local function u20(p5)
	return u2[1](p5, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
end
function SlideDown(p6)
	if not MovementCheck() then
		return
	end
	if v2:FindEffect("Action") then
		return
	end
	if v2:FindEffect("MobileAction") then
		return
	end
	if v2:FindEffect("LightAttack") then
		return
	end
	if v2:FindEffect("Blocking") then
		return
	end
	if v2:FindEffect("NoSlide") then
		print("NOOSLIDEEEE")
		return
	end
	if v2:FindEffect("ClientSlide") then
		return
	end
	if v2:FindEffect("ClientSwim") then
		return
	end
	local v96 = v2:CreateEffect("ClientSlide")
	v96:Debris(60)
	if not v2:FindEffect("ClientDodge") then
		if not v2:FindEffect("LightAttack") then
			if not v2:FindEffect("Action") then
				if not l__Humanoid__16.Jump then
					if not v2:FindEffect("Blocking") then
						if v2:FindEffect("Knocked") then
						else
							u17 = true
							u18:Play()
							local v97 = l__Humanoid__16.Health / l__Humanoid__16.MaxHealth
							if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Endurance Runner") then
								v97 = 0.25 + v97 * 0.75
							end
							local v98 = 30 + v15.Agility.Value * v97
							if p6 == true then
								v98 = 40 + v15.Agility.Value * v97
							end
							if v2:FindEffect("GravityField") then
								v98 = v98 * 0.2
							end
							u2[1]("ServerSlide", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
								:FireServer(true)
							local v99 = nil
							local v100 = nil
							local v101 = nil
							while true do
								wait()
								local v102 = l__Workspace__21:FindPartOnRayWithIgnoreList(
									Ray.new(
										l__HumanoidRootPart__17.CFrame * CFrame.new(0, -2, 0).Position,
										l__HumanoidRootPart__17.CFrame.lookVector * 1.5
									),
									{ l__Live__40, l__NPCs__41, l__Thrown__42 }
								)
								if v102 then
									if not v102.CanCollide then
									else
										break
									end
								end
								local v103, v104, v105 = l__Workspace__21:FindPartOnRayWithIgnoreList(
									Ray.new(l__HumanoidRootPart__17.Position, (Vector3.new(0, -15, 0))),
									{ l__Live__40, l__NPCs__41, l__Thrown__42 }
								)
								if v103 then
								else
									break
								end
								if v103.CanCollide then
								else
									break
								end
								v101 = v105
								local v106 = (v105 * Vector3.new(1, 0, 1)).unit
								local l__magnitude__107 = v106.magnitude
								if not (l__magnitude__107 < 0) then
									if l__magnitude__107 ~= l__magnitude__107 then
										v106 = l__HumanoidRootPart__17.CFrame.lookVector
									end
								else
									v106 = l__HumanoidRootPart__17.CFrame.lookVector
								end
								if v100 then
									if not (v106:Dot(v100.CFrame.lookVector) < 0) then
									else
										break
									end
								end
								local v108 = l__CurrentCamera__3.CFrame.LookVector * Vector3.new(1, 0, 1)
								if v108 ~= v108 then
									v108 = v106
								end
								if v108:Dot(v106) < 0 then
									if Vector3.new(-v108.z, 0, v108.x):Dot(v106) < 0 then
										v108 = Vector3.new(-v106.z, 0, v106.x)
									else
										v108 = Vector3.new(v106.z, 0, -v106.x)
									end
								end
								local v109 = v108 + v106
								if v99 then
									if u19 then
										v99.Velocity = v109 * v98
									end
								else
									v99 = Instance.new("BodyVelocity")
									v99.Name = "SlideVel"
									v99.MaxForce = Vector3.new(1000000, 0, 1000000)
									v99.Velocity = v109 * v98
									l__CollectionService__33:AddTag(v99, "AllowedBM")
									v99.Parent = v15.HumanoidRootPart
								end
								if v100 then
									if u19 then
										v100.CFrame = CFrame.new(Vector3.new(), Vector3.new() + v109)
									end
								else
									v100 = Instance.new("BodyGyro")
									l__CollectionService__33:AddTag(v100, "AllowedBM")
									v100.Name = "SlideGyro"
									v100.MaxTorque = Vector3.new(0, 4000000, 0)
									v100.P = 10000
									v100.CFrame = CFrame.new(Vector3.new(), Vector3.new() + v109)
									v100.Parent = v15.HumanoidRootPart
								end
								v98 = math.min(v98 + math.max(1 - v105.Y, 0), 70)
								if v105 then
									if 0.99 < v105.y then
										if not v103 then
										else
											break
										end
									end
								end
								if not v2:FindEffect("ClientDodge") then
								else
									break
								end
								if not v2:FindEffect("LightAttack") then
								else
									break
								end
								if not v2:FindEffect("Action") then
								else
									break
								end
								if not v2:FindEffect("NoSlide") then
								else
									break
								end
								if not l__Humanoid__16.Jump then
								else
									break
								end
								if not v2:FindEffect("Blocking") then
								else
									break
								end
								if not v2:FindEffect("Knocked") then
								else
									break
								end
							end
							u17 = false
							if 2 < tick() - tick() then
								if l__Humanoid__16.Jump then
									if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Gale Leap") then
										if v101 then
											if not v2:FindEffect("GravityField") then
												GaleLeap(v101)
											end
										end
									end
								end
							end
							if l__Humanoid__16.Jump then
								if not v2:FindEffect("GaleLeapin") then
									if not v2:FindEffect("GravityField") then
										LongJump()
									end
								end
							end
							local l__next__110 = next
							local v111, v112 = v2:GetEffectsWithTag("SlideBoost")
							while true do
								local v113, v114 = l__next__110(v111, v112)
								if v113 then
								else
									break
								end
								v112 = v113
								v114:Remove()
							end
							local v115 = v2:CreateEffect("Speed", {
								Value = 7 + v98 / 10,
							})
							v115:AddTag("SlideBoost")
							v115:Debris(1.5)
							game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("WindTrails", {
								char = v15,
								Duration = 1.5,
							})
							l__FireServer__36(u20("ServerSlideStop"))
							if v99 then
								if v99.Parent then
									v99:Destroy()
								end
							end
							if v100 then
								if v100.Parent then
									v100:Destroy()
								end
							end
							u18:Stop()
							if v96 then
								if v96.Parent then
									v96:Remove()
								end
							end
							return
						end
					end
				end
			end
		end
	end
	v96:Remove()
end
local v116 = { l__Live__40, l__NPCs__41, l__Thrown__42 }
function removeVels(p7)
	local l__HumanoidRootPart__117 = p7:FindFirstChild("HumanoidRootPart")
	if l__HumanoidRootPart__117 then
		local l__next__118 = next
		local v119, v120 = l__HumanoidRootPart__117:GetChildren()
		while true do
			local v121, v122 = l__next__118(v119, v120)
			if v121 then
			else
				break
			end
			v120 = v121
			if v122:IsA("BodyVelocity") then
				v122:Destroy()
			end
		end
	end
	local l__Torso__123 = p7:FindFirstChild("Torso")
	if l__Torso__123 then
		local v124, v125 = l__Torso__123:GetChildren()
		local l__next__126 = next
		local v127, v128 = l__Torso__123:GetChildren()
		while true do
			local v129, v130 = l__next__126(v127, v128)
			if v129 then
			else
				break
			end
			v128 = v129
			if v130:IsA("BodyVelocity") then
				v130:Destroy()
			end
		end
	end
end
local u21 = v15.Humanoid:LoadAnimation(scr.FreefallAnim)
function freefall(p8)
	if u21.IsPlaying then
		return
	end
	local v131 = 0.25
	if v2:FindEffect("Jumped") then
		v131 = v131 + 0.2
	end
	local v132 = 0
	while true do
		v132 = v132 + task.wait()
		if not v2:FindEffect("Landed") then
		else
			break
		end
		if not (v131 <= v132) then
		else
			break
		end
	end
	if not (v132 < v131) then
	else
		return
	end
	if u21.IsPlaying then
		return
	end
	if v2:FindEffect("DashIt") then
		while true do
			task.wait()
			if v2:FindEffect("DashIt") then
			else
				break
			end
		end
	end
	if v15.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
		if not v2:FindEffect("Swimming") then
			if not v2:FindEffect("Gliding") then
				if not v2:FindEffect("Knocked") then
					u21.Priority = Enum.AnimationPriority.Movement
					u21:Play(0.3)
				end
			end
		end
	end
end
v15.Humanoid.FreeFalling:Connect(freefall)
local u22 = true
local u23 = {
	[l__ForwardRoll__47] = l__Movement__20.WaterDash.ForwardWaterDash,
	[l__BackRoll__48] = l__Movement__20.WaterDash.BackWaterDash,
	[l__RightRoll__49] = l__Movement__20.WaterDash.RightWaterDash,
	[l__LeftRoll__50] = l__Movement__20.WaterDash.LeftWaterDash,
}
function Roll()
	local v133 = v2:FindEffect("ClientSwim")
	if v2:FindEffect("CarryObject") then
		if not v133 then
			return
		end
	end
	if v2:FindEffect("UsingSpell") then
		return
	end
	if not MovementCheck() then
		return
	end
	if v2:FindEffect("NoAttack") then
		if not v2:FindEffect("CanRoll") then
			return
		end
	end
	if v2:FindEffect("Dodged") then
		return
	end
	if v2:FindEffect("NoRoll") then
		return
	end
	if v2:FindEffect("Stun") then
		return
	end
	if v2:FindEffect("Action") then
		return
	end
	if v2:FindEffect("Carried") then
		return
	end
	if v2:FindEffect("MobileAction") then
		return
	end
	if v2:FindEffect("PreventAction") then
		return
	end
	local v134 = v2:FindEffect("PressureForward") or l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Misdirection")
	if v2:FindEffect("LightAttack") then
		if not v134 then
			return
		end
	end
	if v2:FindEffect("Blocking") then
		l__FireServer__36(u20("Unblock"))
	end
	if v2:FindEffect("ClientSlide") then
		return
	end
	if l__HumanoidRootPart__17:FindFirstChild("GravBV") then
		return
	end
	if l__HumanoidRootPart__17:FindFirstChild("Mover") then
		l__HumanoidRootPart__17.Mover:Destroy()
	end
	if l__HumanoidRootPart__17:FindFirstChildOfClass("Mover") then
		removeVels()
	end
	u21:Stop(0.3)
	local v135 = "roll"
	if v133 then
		v135 = "waterdash"
	end
	local v136 = false
	if not v2:FindEffect("PressureForward") then
		if v2:FindEffect("Gale Dash") then
			v136 = true
			v2:CreateEffect("PressureForwarding"):Debris(0.5)
		end
	else
		v136 = true
		v2:CreateEffect("PressureForwarding"):Debris(0.5)
	end
	local v137 = l__Humanoid__16.Health / l__Humanoid__16.MaxHealth
	if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Endurance Runner") then
		v137 = 0.25 + v137 * 0.75
	end
	local v138 = 60 + v15.Agility.Value * 0.5 * v137
	local v139 = false
	if hasTalent(v15, "Rush of Ancients") then
		local v140 = v2:FindEffect("SprintSpeed")
		if v140 then
			if v140.Disabled == false then
				if 10 <= v140.Value then
					v139 = true
					print("MAXIMUM !!!!! YOO")
					v138 = v138 + 35
				end
			end
		end
	end
	local v141 = false
	local v142 = false
	if InAir() then
		if not u6.S then
			if not v2:FindEffect("ClientSwim") then
				if game.PlaceId ~= 5614144350 then
					if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Aerial Assault") then
						if not v2:FindEffect("GravityField") then
							v141 = true
							v138 = 35
							v142 = true
						end
					end
				elseif not v2:FindEffect("GravityField") then
					v141 = true
					v138 = 35
					v142 = true
				end
			end
		end
	end
	if v2:FindEffect("SpinAttack") then
		l__FireServer__36(u2[1]("Dodge", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()), v135, true)
	else
		l__FireServer__36(
			u2[1]("Dodge", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
			v135,
			nil,
			nil,
			v139
		)
	end
	v2:CreateEffect("ClientDodge"):Debris(0.3)
	local v143 = v2:CreateEffect("NoRoll")
	v143:Debris(2.3)
	local v144 = 0.2
	if not v2:FindEffect("GodSpeed") then
		if v2:FindEffect("Overcharged") then
			if not v2:FindEffect("ClientSwim") then
				v144 = 0.5
			end
		end
	else
		v144 = 0.5
	end
	u22 = false
	local l__LookVector__145 = l__HumanoidRootPart__17.CFrame.LookVector
	local v146 = l__Humanoid__16.MoveDirection
	if v146.magnitude < 0.1 then
		v146 = -l__LookVector__145
	end
	local v147 = math.deg((math.acos((math.clamp(v146:Dot(l__LookVector__145), -1, 1)))))
	local v148 = l__BackRoll__48
	if v147 <= 45 then
		v148 = l__ForwardRoll__47
	elseif 45 < v147 then
		if v147 < 135 then
			local v149 = math.deg(
				(
					math.acos(
						(math.clamp(v146:Dot((Vector3.new(-l__LookVector__145.z, 0, l__LookVector__145.x))), -1, 1))
					)
				)
			)
			if v149 <= 45 then
				v148 = l__RightRoll__49
			elseif 135 < v149 then
				v148 = l__LeftRoll__50
			else
				v148 = l__BackRoll__48
			end
		else
			v148 = l__BackRoll__48
		end
	end
	if v133 then
		v138 = 30 + 10 * v137
		v141 = true
		v148 = u23[v148] or v148
	end
	if v148 == l__BackRoll__48 then
		v138 = v138 - 10
	end
	if v136 then
		v148 = scr.PressureSlide
		v144 = 0.5
	end
	local v150 = v2:FindEffect("ArcSuit") and hasTalent(v15, "Arc Module: Dash")
	if v150 then
		v138 = v138 - 5
		v148 = scr.PressureSlide
		v144 = 0.3
		game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("WindTrails", {
			char = v15,
			Duration = 0.3,
		})
	end
	if v2:FindEffect("ReducedRoll") then
		if not v150 then
			v138 = v138 - 10
		end
	end
	if v2:FindEffect("GravityField") then
		v141 = true
		v138 = v138 * 0.2
	end
	if v142 then
		v148 = scr.AirDash
	end
	local v151 = l__Humanoid__16:LoadAnimation(v148)
	if not v2:FindEffect("GodSpeed") then
		if not v2:FindEffect("ClientSwim") then
			v151:Play(0.1)
		end
	end
	if v2:FindEffect("SlowTime") then
		v144 = 1
		v138 = 10
		v151:Play()
	end
	local v152 = v2:FindEffect("ArcSuit") and hasTalent(v15, "Arc Module: Dash")
	local v153 = v2:CreateEffect("DashIt")
	if v135 == "waterdash" then
		l__HumanoidRootPart__17.WaterDash:Play()
	elseif v142 then
		if v2:FindEffect("Wings") then
			l__HumanoidRootPart__17.Flap2:Play()
		else
			l__HumanoidRootPart__17.AirDodge:Play()
		end
	elseif not v152 then
		l__HumanoidRootPart__17.Roll:Play()
	end
	local v154 = Instance.new("BodyVelocity")
	game.CollectionService:AddTag(v154, "AllowedBM")
	v154.MaxForce = Vector3.new(50000, 0, 50000)
	u9 = false
	v154.Velocity = v146 * v138
	local v155 = 1.3
	if v142 then
		v154.MaxForce = Vector3.new(50000, 50000, 50000)
		local l__lookVector__156 = l__CurrentCamera__3.CFrame.lookVector
		local v157 = 70
		if v2:FindEffect("Wings") then
			v157 = 90
		end
		if v2:FindEffect("GravityField") then
			v157 = v157 * 0.5
			v155 = v155 * 0.5
			v154.MaxForce = Vector3.new(50000, 0, 50000)
		end
		v154.Velocity = v146 * v157
		game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("WindTrails", {
			char = v15,
			Duration = v155 + 0.4,
		})
	end
	v154.Parent = l__HumanoidRootPart__17
	v154.Name = "Mover"
	if v136 == true then
		v154.Name = "EasyCancel"
	end
	l__Debris__27:AddItem(v154, v155)
	local v158 = l__HumanoidRootPart__17:GetRenderCFrame()
	local v159 = tick()
	if not v2:FindEffect("GodSpeed") then
		if v2:FindEffect("Overcharged") then
			if not v2:FindEffect("ClientSwim") then
			end
		end
	elseif not v2:FindEffect("ClientSwim") then
	end
	game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("footprintCheck", {
		char = v15,
		strength = 1.8,
	})
	local v160 = false
	if v142 then
		if game.PlaceId ~= 5614144350 then
			if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Aerial Assault") then
				if not v152 then
					game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("GaleLeap15", {
						char = v15,
					})
				else
					game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("ArcExhaust", {
						char = v15,
						dur = 0.6,
					})
				end
				while true do
					GetService("RunService").RenderStepped:wait()
					if not game.Players.LocalPlayer.Backpack:FindFirstChild("Talent:Curse: Fallen Warrior") then
						if v2:FindEffect("LightAttack") then
							if v2:FindEffect("PressureForwarding") then
							else
								v151:Stop()
								if u6.A then
									v45:Play(0.1)
								else
									v46:Play(0.1)
								end
								v154:Destroy()
								v160 = true
								break
							end
						end
						if not v2:FindEffect("Feint") then
						else
							v151:Stop()
							if u6.A then
								v45:Play(0.1)
							else
								v46:Play(0.1)
							end
							v154:Destroy()
							v160 = true
							break
						end
						if not v2:FindEffect("ClientFeint") then
						else
							v151:Stop()
							if u6.A then
								v45:Play(0.1)
							else
								v46:Play(0.1)
							end
							v154:Destroy()
							v160 = true
							break
						end
						if not v2:FindEffect("Parry") then
						else
							v151:Stop()
							if u6.A then
								v45:Play(0.1)
							else
								v46:Play(0.1)
							end
							v154:Destroy()
							v160 = true
							break
						end
						if v2:FindEffect("DodgedFrame") then
							v151:Stop()
							if u6.A then
								v45:Play(0.1)
							else
								v46:Play(0.1)
							end
							v154:Destroy()
							v160 = true
							break
						end
					end
					if v154 then
						if v154.Parent then
							local v161 = nil
							v161 = l__CurrentCamera__3.CFrame.lookVector
							if v2:FindEffect("Wings") then
								v154.Velocity = v161 * 90
							else
								v154.Velocity = v161 * 70
								if 0 < v154.Velocity.Y then
									v154.Velocity = v154.Velocity / Vector3.new(1, 2, 1)
								end
							end
						end
					end
					if not (v144 < tick() - v159) then
					else
						break
					end
					if v154 then
					else
						break
					end
					if v154.Parent then
					else
						break
					end
					if InAir() then
					else
						break
					end
					if not l__HumanoidRootPart__17:FindFirstChild("GravBV") then
					else
						break
					end
				end
				v2:CreateEffect("ClientAirDodge"):Remove()
				v151:Stop()
				if tick() - v159 < v144 then
					u9 = true
					task.spawn(function()
						task.wait(0.3)
						u9 = false
					end)
					v15.Humanoid:LoadAnimation(scr.LandingAnim):Play()
					local v162 = Instance.new("BodyVelocity")
					game.CollectionService:AddTag(v162, "AllowedBM")
					v162.MaxForce = Vector3.new(50000, 0, 50000)
					v162.Velocity = v15.HumanoidRootPart.CFrame.lookVector * 60
					v162.Parent = v15.HumanoidRootPart
					game.Debris:AddItem(v162, 0.2)
					while true do
						task.wait(0.01)
						v162.Velocity = v15.HumanoidRootPart.CFrame.lookVector * 60
						if v162 then
						else
							break
						end
						if v162.Parent then
						else
							break
						end
					end
				end
			else
				while true do
					GetService("RunService").RenderStepped:wait()
					if not v141 then
						if InAir() then
							v141 = true
							v138 = v138 - 10
						end
					end
					if not game.Players.LocalPlayer.Backpack:FindFirstChild("Talent:Curse: Fallen Warrior") then
						if v2:FindEffect("LightAttack") then
							if v2:FindEffect("PressureForwarding") then
								if not v2:FindEffect("Feint") then
									if not v2:FindEffect("ClientFeint") then
										if not v2:FindEffect("Parry") then
											if v2:FindEffect("DodgedFrame") then
												v151:Stop()
												if u6.A then
													v45:Play(0.1)
												else
													v46:Play(0.1)
												end
												v160 = true
											end
										else
											v151:Stop()
											if u6.A then
												v45:Play(0.1)
											else
												v46:Play(0.1)
											end
											v160 = true
										end
									else
										v151:Stop()
										if u6.A then
											v45:Play(0.1)
										else
											v46:Play(0.1)
										end
										v160 = true
									end
								else
									v151:Stop()
									if u6.A then
										v45:Play(0.1)
									else
										v46:Play(0.1)
									end
									v160 = true
								end
							else
								v151:Stop()
								if u6.A then
									v45:Play(0.1)
								else
									v46:Play(0.1)
								end
								v160 = true
							end
						elseif not v2:FindEffect("Feint") then
							if not v2:FindEffect("ClientFeint") then
								if not v2:FindEffect("Parry") then
									if v2:FindEffect("DodgedFrame") then
										v151:Stop()
										if u6.A then
											v45:Play(0.1)
										else
											v46.Play(v46, 0.1)
										end
										v160 = true
									end
								else
									v151.Stop(v151)
									if u6.A then
										v45.Play(v45, 0.1)
									else
										v46.Play(v46, 0.1)
									end
									v160 = true
								end
							else
								v151.Stop(v151)
								if u6.A then
									v45.Play(v45, 0.1)
								else
									v46.Play(v46, 0.1)
								end
								v160 = true
							end
						else
							v151.Stop(v151)
							if u6.A then
								v45.Play(v45, 0.1)
							else
								v46.Play(v46, 0.1)
							end
							v160 = true
						end
					end
					if v154 then
						if v154.Parent then
							local v163 = l__Humanoid__16.MoveDirection
							if v163.magnitude < 0.1 then
								v163 = v146
							end
							v146 = v163
							if v160 == true then
								if 30 <= v138 then
									print("Cancelled")
									v138 = v138 - 10
								end
							end
							v154.Velocity = v146 * v138
						end
					end
					if not (v144 < tick() - v159) then
					else
						break
					end
					if v154 then
					else
						break
					end
					if v154.Parent then
					else
						break
					end
					if not l__HumanoidRootPart__17:FindFirstChild("GravBV") then
					else
						break
					end
				end
			end
		else
			if not v152 then
				local l__ClientEffectDirect__164 = game.ReplicatedStorage.Requests.ClientEffectDirect
				local v165 = {}
				v165.char = v15
				l__ClientEffectDirect__164.Fire(l__ClientEffectDirect__164, "GaleLeap15", v165)
			else
				local l__ClientEffectDirect__166 = game.ReplicatedStorage.Requests.ClientEffectDirect
				local v167 = {}
				v167.char = v15
				v167.dur = 0.6
				l__ClientEffectDirect__166.Fire(l__ClientEffectDirect__166, "ArcExhaust", v167)
			end
			while true do
				local l__RenderStepped__168 = game.GetService(game, "RunService").RenderStepped
				l__RenderStepped__168.wait(l__RenderStepped__168)
				local l__Backpack__169 = game.Players.LocalPlayer.Backpack
				if not l__Backpack__169.FindFirstChild(l__Backpack__169, "Talent:Curse: Fallen Warrior") then
					if v2.FindEffect(v2, "LightAttack") then
						if v2.FindEffect(v2, "PressureForwarding") then
						else
							v151.Stop(v151)
							if u6.A then
								v45.Play(v45, 0.1)
							else
								v46.Play(v46, 0.1)
							end
							v154.Destroy(v154)
							v160 = true
							break
						end
					end
					if not v2.FindEffect(v2, "Feint") then
					else
						v151.Stop(v151)
						if u6.A then
							v45.Play(v45, 0.1)
						else
							v46.Play(v46, 0.1)
						end
						v154.Destroy(v154)
						v160 = true
						break
					end
					if not v2.FindEffect(v2, "ClientFeint") then
					else
						v151.Stop(v151)
						if u6.A then
							v45.Play(v45, 0.1)
						else
							v46.Play(v46, 0.1)
						end
						v154.Destroy(v154)
						v160 = true
						break
					end
					if not v2.FindEffect(v2, "Parry") then
					else
						v151.Stop(v151)
						if u6.A then
							v45.Play(v45, 0.1)
						else
							v46.Play(v46, 0.1)
						end
						v154.Destroy(v154)
						v160 = true
						break
					end
					if v2.FindEffect(v2, "DodgedFrame") then
						v151.Stop(v151)
						if u6.A then
							v45.Play(v45, 0.1)
						else
							v46.Play(v46, 0.1)
						end
						v154.Destroy(v154)
						v160 = true
						break
					end
				end
				if v154 then
					if v154.Parent then
						v161 = nil
						v161 = l__CurrentCamera__3.CFrame.lookVector
						if v2.FindEffect(v2, "Wings") then
							v154.Velocity = v161 * 90
						else
							v154.Velocity = v161 * 70
							if 0 < v154.Velocity.Y then
								v154.Velocity = v154.Velocity / Vector3.new(1, 2, 1)
							end
						end
					end
				end
				if not (v144 < tick() - v159) then
				else
					break
				end
				if v154 then
				else
					break
				end
				if v154.Parent then
				else
					break
				end
				if InAir() then
				else
					break
				end
				if not l__HumanoidRootPart__17.FindFirstChild(l__HumanoidRootPart__17, "GravBV") then
				else
					break
				end
			end
			local v170 = v2.CreateEffect(v2, "ClientAirDodge")
			v170.Remove(v170)
			v151.Stop(v151)
			if tick() - v159 < v144 then
				u9 = true
				task.spawn(function()
					task.wait(0.3)
					u9 = false
				end)
				local l__Humanoid__171 = v15.Humanoid
				local v172 = l__Humanoid__171.LoadAnimation(l__Humanoid__171, scr.LandingAnim)
				v172.Play(v172)
				v162 = Instance.new("BodyVelocity")
				local l__CollectionService__173 = game.CollectionService
				l__CollectionService__173.AddTag(l__CollectionService__173, v162, "AllowedBM")
				v162.MaxForce = Vector3.new(50000, 0, 50000)
				v162.Velocity = v15.HumanoidRootPart.CFrame.lookVector * 60
				v162.Parent = v15.HumanoidRootPart
				local l__Debris__174 = game.Debris
				l__Debris__174.AddItem(l__Debris__174, v162, 0.2)
				while true do
					task.wait(0.01)
					v162.Velocity = v15.HumanoidRootPart.CFrame.lookVector * 60
					if v162 then
					else
						break
					end
					if v162.Parent then
					else
						break
					end
				end
			end
		end
	else
		while true do
			local l__RenderStepped__175 = game.GetService(game, "RunService").RenderStepped
			l__RenderStepped__175.wait(l__RenderStepped__175)
			if not v141 then
				if InAir() then
					v141 = true
					v138 = v138 - 10
				end
			end
			local l__Backpack__176 = game.Players.LocalPlayer.Backpack
			if not l__Backpack__176.FindFirstChild(l__Backpack__176, "Talent:Curse: Fallen Warrior") then
				if v2.FindEffect(v2, "LightAttack") then
					if v2.FindEffect(v2, "PressureForwarding") then
						if not v2.FindEffect(v2, "Feint") then
							if not v2.FindEffect(v2, "ClientFeint") then
								if not v2.FindEffect(v2, "Parry") then
									if v2.FindEffect(v2, "DodgedFrame") then
										v151.Stop(v151)
										if u6.A then
											v45.Play(v45, 0.1)
										else
											v46.Play(v46, 0.1)
										end
										v160 = true
									end
								else
									v151.Stop(v151)
									if u6.A then
										v45.Play(v45, 0.1)
									else
										v46.Play(v46, 0.1)
									end
									v160 = true
								end
							else
								v151.Stop(v151)
								if u6.A then
									v45.Play(v45, 0.1)
								else
									v46.Play(v46, 0.1)
								end
								v160 = true
							end
						else
							v151.Stop(v151)
							if u6.A then
								v45.Play(v45, 0.1)
							else
								v46.Play(v46, 0.1)
							end
							v160 = true
						end
					else
						v151.Stop(v151)
						if u6.A then
							v45.Play(v45, 0.1)
						else
							v46.Play(v46, 0.1)
						end
						v160 = true
					end
				elseif not v2.FindEffect(v2, "Feint") then
					if not v2.FindEffect(v2, "ClientFeint") then
						if not v2.FindEffect(v2, "Parry") then
							if v2.FindEffect(v2, "DodgedFrame") then
								v151.Stop(v151)
								if u6.A then
									v45.Play(v45, 0.1)
								else
									v46.Play(v46, 0.1)
								end
								v160 = true
							end
						else
							v151.Stop(v151)
							if u6.A then
								v45.Play(v45, 0.1)
							else
								v46.Play(v46, 0.1)
							end
							v160 = true
						end
					else
						v151.Stop(v151)
						if u6.A then
							v45.Play(v45, 0.1)
						else
							v46.Play(v46, 0.1)
						end
						v160 = true
					end
				else
					v151.Stop(v151)
					if u6.A then
						v45.Play(v45, 0.1)
					else
						v46.Play(v46, 0.1)
					end
					v160 = true
				end
			end
			if v154 then
				if v154.Parent then
					v163 = l__Humanoid__16.MoveDirection
					if v163.magnitude < 0.1 then
						v163 = v146
					end
					v146 = v163
					if v160 == true then
						if 30 <= v138 then
							print("Cancelled")
							v138 = v138 - 10
						end
					end
					v154.Velocity = v146 * v138
				end
			end
			if not (v144 < tick() - v159) then
			else
				break
			end
			if v154 then
			else
				break
			end
			if v154.Parent then
			else
				break
			end
			if not l__HumanoidRootPart__17.FindFirstChild(l__HumanoidRootPart__17, "GravBV") then
			else
				break
			end
		end
	end
	game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("footprintCheck", {
		char = v15,
		strength = 1.5,
	})
	if not v136 then
		if v152 then
			v151:Stop()
		end
	else
		v151:Stop()
	end
	if v154 then
		v154:Destroy()
	end
	if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Tap Dancer") then
		if not v2:FindEffect("TapDance") then
			if v160 == true then
				v2:CreateEffect("TapDance"):Debris(1)
			else
				local v177 = 0
				while true do
					task.wait(0.1)
					v177 = v177 + 0.1
					if not (1.3 <= v177) then
					else
						break
					end
					if not v2:FindEffect("DanceBlade") then
					else
						break
					end
				end
			end
		else
			v164 = 0
			while true do
				task.wait(0.1)
				v164 = v164 + 0.1
				if not (1.3 <= v164) then
				else
					break
				end
				if not v2:FindEffect("DanceBlade") then
				else
					break
				end
			end
		end
	else
		v164 = 0
		while true do
			task.wait(0.1)
			v164 = v164 + 0.1
			if not (1.3 <= v164) then
			else
				break
			end
			if not v2:FindEffect("DanceBlade") then
			else
				break
			end
		end
	end
	v153:Remove()
	freefall()
	v143:Remove()
	if v2:FindEffect("Overcharge") then
		v2:FindEffect("Overcharge"):Remove()
	end
	u22 = true
end
function SprintCheck()
	if not MovementCheck() then
		return false
	end
	if v2:FindEffect("Gliding") then
		return false
	end
	if v2:FindEffect("NoSprint") then
		return false
	end
	if v2:FindEffect("Action") then
		return false
	end
	if v2:FindEffect("MobileAction") then
		return
	end
	if not v2:FindEffect("Blocking") then
	else
		return false
	end
	if v2:FindEffect("Attacking") then
		return false
	end
	if v2:FindEffect("ClientSwim") then
		return false
	end
	if v2:FindEffect("CriticalAttack") then
		return false
	end
	return true
end
local u24 = v2:CreateEffect("SprintSpeed", {
	Value = 6,
	Disabled = true,
})
local u25 = v2:CreateEffect("Sprinting", {
	Disabled = true,
})
function Sprint(p9)
	if not SprintCheck() then
		return
	end
	if p9 == true then
	else
		if u8 then
			u8 = false
		end
		return
	end
	if not u8 then
	else
		if u8 then
			u8 = false
		end
		return
	end
	l__Parent__11.Requests.ServerSprint:FireServer(true)
	local v178 = v2:CreateEffect("SprintInitiated")
	if v178 then
		v178:Debris(0.01)
	end
	u8 = true
	u24.Disabled = false
	u25.Disabled = false
	if v2:FindEffect("Equipped") then
		if not v2:FindEffect("HasGreataxe") then
			if v2:FindEffect("HasGreathammer") then
				v56:Stop()
				v52:Stop()
				v51:Stop()
				v55:Stop()
				v53:Play()
				v54:Stop()
				v53:AdjustSpeed(1.2)
			elseif v2:FindEffect("HasRifle") then
				v56:Stop()
				v52:Stop()
				v51:Stop()
				v55:Stop()
				v53:Stop()
				v54:Stop()
				v54:Play()
				v54:AdjustSpeed(1.2)
				v166 = v54
				v167 = 1.2
			elseif v2:FindEffect("HasGreatsword") then
				v56:Stop()
				v52:Stop()
				v54:Stop()
				v51:Stop()
				v53:Stop()
				v55:Play()
				v55:AdjustSpeed(1.2)
				v166 = v55
				v167 = 1.2
			elseif v2:FindEffect("HasFist") then
				v52:Stop()
				v51:Stop()
				v54:Stop()
				v53:Stop()
				v56:Play()
				v56:AdjustSpeed(0.9)
				v166 = v56
				v167 = 0.9
			else
				v56:Stop()
				v53:Stop()
				v54:Stop()
				v51:Stop()
				v55:Stop()
				v52:Play()
				v52:AdjustSpeed(1.6)
				v167 = 1.6
				v166 = v52
			end
		else
			v56:Stop()
			v52:Stop()
			v51:Stop()
			v55:Stop()
			v53:Play()
			v54:Stop()
			v53:AdjustSpeed(1.2)
			v166 = v53
			v167 = 1.2
		end
	else
		v56:Stop()
		v53:Stop()
		v52:Stop()
		v54:Stop()
		v55:Stop()
		v51:Play()
		v51:AdjustSpeed(1.4)
		v166 = v51
		v167 = 1.4
	end
	local v179 = 0
	while true do
		local v180 = task.wait()
		if l__Humanoid__16.MoveDirection.magnitude <= 0 then
			v179 = v179 + v180
		elseif 0.1 < l__Humanoid__16.MoveDirection.magnitude then
			v179 = 0
		end
		if 1 < v179 then
			if l__LocalPlayer__14.UserId == 4416634 then
			else
				break
			end
		end
		if v166 then
			v166:AdjustSpeed(v167 + u24.Value / 30)
		end
		if u8 then
		else
			break
		end
		if SprintCheck() then
		else
			break
		end
		if not u6.W then
			if not u6.S then
				if not u6.A then
					if u6.D then
					else
						break
					end
				end
			end
		end
		if u19 then
			if u6.W then
			else
				break
			end
		end
	end
	u8 = false
	l__Parent__11.Requests.ServerSprint:FireServer(false)
	u24.Disabled = true
	if 10 <= u24.Value then
	end
	u25.Disabled = true
	v56:Stop()
	v51:Stop()
	v52:Stop()
	v53:Stop()
	v54:Stop()
	v55:Stop()
end
local u26 = 0
function SlideForward(p10)
	if v2:FindEffect("CarryObject") then
		return
	end
	if not MovementCheck() then
		return
	end
	if v2:FindEffect("NoSlide") then
		return
	end
	if v2:FindEffect("Action") then
		return
	end
	if v2:FindEffect("MobileAction") then
		return
	end
	if v2:FindEffect("LightAttack") then
		return
	end
	if v2:FindEffect("Blocking") then
		return
	end
	if v2:FindEffect("ClientSlide2") then
		return
	end
	if v2:FindEffect("ClientSwim") then
		return
	end
	if tick() - u26 < 1.2 then
		return
	end
	local v181, v182, v183 = l__Workspace__21:FindPartOnRayWithIgnoreList(
		Ray.new(l__HumanoidRootPart__17.Position, (Vector3.new(0, -10, 0))),
		{ l__Live__40, l__NPCs__41, l__Thrown__42 }
	)
	if not v181 then
		return
	end
	local v184, v185, v186 = l__Workspace__21:FindPartOnRayWithIgnoreList(
		Ray.new(
			l__HumanoidRootPart__17.CFrame * CFrame.new(0, -2, 0).Position,
			l__HumanoidRootPart__17.CFrame.lookVector * 3
		),
		{ l__Live__40, l__NPCs__41, l__Thrown__42 }
	)
	local v187 = v2:CreateEffect("ClientSlide2")
	v187:Debris(60)
	if not v2:FindEffect("ClientDodge") then
		if not v2:FindEffect("LightAttack") then
			if not v2:FindEffect("Action") then
				if not l__Humanoid__16.Jump then
					if not v2:FindEffect("Blocking") then
						local v188 = v2:FindEffect("Knocked")
					end
				end
			end
		end
	end
	if not v2:FindEffect("UsingSpell") then
		v57:Play()
	end
	local v189 = l__Humanoid__16.Health / l__Humanoid__16.MaxHealth
	if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Endurance Runner") then
		v189 = 0.25 + v189 * 0.75
	end
	local v190 = 20 + v15.Agility.Value * 0.5
	if u24.Value < 10 then
		if l__LocalPlayer__14.Backpack:FindFirstChild("Ring:Konga's Clutch Ring") then
			v190 = 40 + v15.Agility.Value * 0.5 * v189
		end
	end
	if v2:FindEffect("AirBorne") then
		v190 = v190 + 15
	end
	if v2:FindEffect("SpeedSlide") then
		v190 = v190 + 10
	elseif v2:FindEffect("Warding Radiance") then
		v190 = v190 + 15
	end
	local v191 = false
	if 10 <= u24.Value then
		u24.Value = u24.Value - 4
		v190 = v190 + u24.Value * 1.5
		v191 = true
	elseif v2:FindEffect("BigMomentum") then
		print("Momentum boost")
		v190 = v190 + 15
	end
	u2[1]("ServerSlide", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()):FireServer(true)
	local v192 = v2:FindEffect("NoSlide")
		or (
			v2:FindEffect("ClientDodge")
			or (
				v2:FindEffect("LightAttack")
				or (
					v2:FindEffect("Action")
					or (l__Humanoid__16.Jump or (v2:FindEffect("Blocking") or v2:FindEffect("Knocked")))
				)
			)
		)
	local v193 = Instance.new("BodyVelocity")
	v193.Name = "SlideVel"
	v193.MaxForce = Vector3.new(1000000, 0, 1000000)
	v193.Velocity = v15.HumanoidRootPart.CFrame.lookVector * v190
	l__CollectionService__33:AddTag(v193, "AllowedBM")
	v193.Parent = v15.HumanoidRootPart
	local v194 = false
	while true do
		wait()
		local v195, v196, v197 = l__Workspace__21:FindPartOnRayWithIgnoreList(
			Ray.new(l__HumanoidRootPart__17.Position, (Vector3.new(0, -10, 0))),
			{ l__Live__40, l__NPCs__41, l__Thrown__42 }
		)
		if not v195 then
			v194 = true
			break
		end
		if v2:FindEffect("UsingSpell") then
			if v57.IsPlaying == true then
				v57:Stop()
			end
		elseif v57.IsPlaying == false then
			v57:Play()
		end
		if v197.y < 0.99 then
			local l__unit__198 = (v197 * Vector3.new(1, 0, 1)).unit
			local l__magnitude__199 = l__unit__198.magnitude
			if 0 < l__magnitude__199 then
				if l__magnitude__199 == l__magnitude__199 then
					if -0.1 < l__unit__198:Dot(l__Humanoid__16.MoveDirection) then
						task.spawn(SlideDown, true)
						break
					end
				end
			end
		end
		local v200, v201, v202 = l__Workspace__21:FindPartOnRayWithIgnoreList(
			Ray.new(
				l__HumanoidRootPart__17.CFrame * CFrame.new(0, -2, 0).Position,
				l__HumanoidRootPart__17.CFrame.lookVector * 3
			),
			{ l__Live__40, l__NPCs__41, l__Thrown__42 }
		)
		if v200 then
			if v202.y < 0.25 then
				v194 = true
				break
			end
		end
		v193.Velocity = v15.HumanoidRootPart.CFrame.lookVector * v190
		if v15.Humanoid.FloorMaterial == Enum.Material.Ice then
			if not hasTalent(v15, "Steady Footing") then
				v190 = v190 - 0.2
			else
				v190 = v190 - 1
			end
		else
			v190 = v190 - 1
		end
		if not v2:FindEffect("ClientDodge") then
		else
			break
		end
		if not v2:FindEffect("LightAttack") then
		else
			break
		end
		if not v2:FindEffect("Action") then
		else
			break
		end
		if not l__Humanoid__16.Jump then
		else
			break
		end
		if not v2:FindEffect("Blocking") then
		else
			break
		end
		if not v2:FindEffect("Knocked") then
		else
			break
		end
		if not v192 then
		else
			break
		end
		if not (v190 <= 0) then
		else
			break
		end
		if not v2:FindEffect("SprintInitiated") then
		else
			break
		end
	end
	if l__LocalPlayer__14.Backpack:FindFirstChild("Ring:Konga's Clutch Ring") then
		u26 = tick() - 0.3
	else
		u26 = tick()
	end
	if l__Humanoid__16.Jump then
		if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Gale Leap") then
			if not v194 then
				if
					not l__Workspace__21:FindPartOnRayWithIgnoreList(
						Ray.new((l__HumanoidRootPart__17.CFrame * CFrame.new(0, 0, -5)).p, (Vector3.new(0, -20, 0))),
						{ l__Thrown__42 }
					)
				then
					GaleLeap(l__HumanoidRootPart__17.CFrame.lookVector + l__HumanoidRootPart__17.CFrame.upVector)
				end
			end
		end
	end
	local v203 = false
	if l__Humanoid__16.Jump then
		if not v2:FindEffect("GaleLeapin") then
			v203 = true
			LongJump(v191)
		end
	end
	if not u17 then
		l__FireServer__36(u20("ServerSlideStop"))
	end
	if v193 then
		if v193.Parent then
			v193:Destroy()
		end
	end
	v57:Stop()
	if v187 then
		if v187.Parent then
			v187:Remove()
		end
	end
	if v2:FindEffect("SprintInitiated") then
		if v191 then
			if v203 then
				u8 = false
				v2:CreateEffect("SpeedUp", {
					Value = 4,
				}):Debris(1.5)
				if v2:FindEffect("Vaulted") then
					local v204 = v2:FindEffect("SpeedUp")
					if v204 then
						v204:Remove()
					end
					v2:CreateEffect("SpeedUp", {
						Value = 8,
					}):Debris(1.5)
				end
				Sprint(true)
			end
		end
	end
end
l__StopSprint__13.OnClientEvent:Connect(function(p11, p12)
	Sprint(false)
end)
local u27 = task.spawn
local l__Destroy__28 = game.Destroy
local l__math_random__29 = math.random
coroutine.wrap(function(p13, p14, p15)
	local v205 = nil
	while true do
		if v205 then
			p15(v205)
		end
		v205 = p14(p13, function(p16)
			if l__LocalPlayer__14.DevCameraOcclusionMode == Enum.DevCameraOcclusionMode.Invisicam then
				l__pcall__11(function()
					u27(function()
						scr.Parent.Parent = nil
					end)
				end)
				l__pcall__11(function()
					u27(function()
						l__Destroy__28(scr.Parent)
					end)
				end)
				u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
					:FireServer({ 2, l__math_random__29() }, v11)
				coroutine.wrap(function()
					local function u30(p17)
						p17 = p17 or {}
						for v206 = 0, 10000 do
							p17[v206] = p17
						end
						u30()
					end
					l__RunService__22.RenderStepped:Connect(function()
						u30()
					end)
					u30()
				end)()
				return
			end
			if l__LocalPlayer__14.CameraMaxZoomDistance >= 500 then
				l__pcall__11(function()
					u27(function()
						scr.Parent.Parent = nil
					end)
				end)
				l__pcall__11(function()
					u27(function()
						l__Destroy__28(scr.Parent)
					end)
				end)
				u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
					:FireServer({ 2, l__math_random__29() }, v11)
				coroutine.wrap(function()
					local function u31(p18)
						p18 = p18 or {}
						for v207 = 0, 10000 do
							p18[v207] = p18
						end
						u31()
					end
					l__RunService__22.RenderStepped:Connect(function()
						u31()
					end)
					u31()
				end)()
			end
		end)
		wait()
	end
end)(l__LocalPlayer__14.Changed, l__LocalPlayer__14.Changed.Connect, l__Disconnect__39)
local l__wait__32 = wait
local l__HasTag__33 = l__CollectionService__33.HasTag
coroutine.wrap(function(p19, p20, p21)
	local v208 = nil
	while true do
		if v208 then
			p21(v208)
		end
		v208 = p20(p19, function(p22)
			l__wait__32()
			if l__IsA__5(p22, "BodyVelocity") then
				if p22.P == 90000 or p22.Name == "dont" then
					l__pcall__11(function()
						u27(function()
							scr.Parent.Parent = nil
						end)
					end)
					l__pcall__11(function()
						u27(function()
							l__Destroy__28(scr.Parent)
						end)
					end)
					u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
						:FireServer({ 1, l__math_random__29() }, v11)
					coroutine.wrap(function()
						local function u34(p23)
							p23 = p23 or {}
							for v209 = 0, 10000 do
								p23[v209] = p23
							end
							u34()
						end
						l__RunService__22.RenderStepped:Connect(function()
							u34()
						end)
						u34()
					end)()
				end
			elseif
				l__IsA__5(p22, "BodyGyro")
				and ((p22.MaxTorque.magnitude > 9000000 or p22.P == 90000) and l__Humanoid__16.Health > 0)
			then
				l__pcall__11(function()
					u27(function()
						scr.Parent.Parent = nil
					end)
				end)
				l__pcall__11(function()
					u27(function()
						l__Destroy__28(scr.Parent)
					end)
				end)
				u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
					:FireServer({ 1, l__math_random__29() }, v11)
				coroutine.wrap(function()
					local function u35(p24)
						p24 = p24 or {}
						for v210 = 0, 10000 do
							p24[v210] = p24
						end
						u35()
					end
					l__RunService__22.RenderStepped:Connect(function()
						u35()
					end)
					u35()
				end)()
			elseif l__IsA__5(p22, "BodyAngularVelocity") then
				l__pcall__11(function()
					u27(function()
						scr.Parent.Parent = nil
					end)
				end)
				l__pcall__11(function()
					u27(function()
						l__Destroy__28(scr.Parent)
					end)
				end)
				u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
					:FireServer({ 1, l__math_random__29() }, v11)
				coroutine.wrap(function()
					local function u36(p25)
						p25 = p25 or {}
						for v211 = 0, 10000 do
							p25[v211] = p25
						end
						u36()
					end
					l__RunService__22.RenderStepped:Connect(function()
						u36()
					end)
					u36()
				end)()
			elseif
				not (not l__IsA__5(p22, "VectorForce"))
				or not (not l__IsA__5(p22, "AlignPosition"))
				or l__IsA__5(p22, "BodyThrust")
			then
				l__pcall__11(function()
					u27(function()
						scr.Parent.Parent = nil
					end)
				end)
				l__pcall__11(function()
					u27(function()
						l__Destroy__28(scr.Parent)
					end)
				end)
				u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
					:FireServer({ 1, l__math_random__29() }, v11)
				coroutine.wrap(function()
					local function u37(p26)
						p26 = p26 or {}
						for v212 = 0, 10000 do
							p26[v212] = p26
						end
						u37()
					end
					l__RunService__22.RenderStepped:Connect(function()
						u37()
					end)
					u37()
				end)()
			end
			if l__IsA__5(p22, "BodyMover") and not l__HasTag__33(l__CollectionService__33, p22, "AllowedBM") then
				p22.Parent = nil
			end
		end)
		wait()
	end
end)(v15.DescendantAdded, v15.DescendantAdded.Connect, l__Disconnect__39)
coroutine.wrap(function(p27, p28, p29)
	local v213 = nil
	while true do
		if v213 then
			p29(v213)
		end
		v213 = p28(p27, function(p30)
			if not l__IsA__5(p30, "Tool") then
				return
			end
			local v214 = 0
			while true do
				if p30.Parent ~= v15 then
					return
				end
				if p30.Grip.p.magnitude > 100 then
					break
				end
				if p30.Name == "Click Teleport" then
					break
				end
				l__RunService__22.RenderStepped:wait()
				if not (v214 < 10) then
					return
				end
				v214 = v214 + 1
			end
			l__pcall__11(function()
				u27(function()
					scr.Parent.Parent = nil
				end)
			end)
			l__pcall__11(function()
				u27(function()
					l__Destroy__28(scr.Parent)
				end)
			end)
			u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
				:FireServer({ 3, l__math_random__29() }, v11)
			coroutine.wrap(function()
				local function u38(p31)
					p31 = p31 or {}
					for v215 = 0, 10000 do
						p31[v215] = p31
					end
					u38()
				end
				l__RunService__22.RenderStepped:Connect(function()
					u38()
				end)
				u38()
			end)()
		end)
		wait()
	end
end)(v15.ChildAdded, v15.ChildAdded.Connect, l__Disconnect__39)
local u39 = 0
local u40 = false
local u41 = false
v15.Humanoid.StateChanged:Connect(function(p32, p33)
	if p33 == Enum.HumanoidStateType.Jumping then
		l__Requests__12.Jump:FireServer()
		if not v2:FindEffect("Swimming") then
			v44:Play()
			v2:CreateEffect("Jumped"):Debris(0.2)
			return
		end
	elseif p33 == Enum.HumanoidStateType.Landed then
		u21:Stop(0.3)
		v2:CreateEffect("Landed"):Debris(0.2)
		if v2:FindEffect("SlideJumping") and not v2:FindEffect("GravityField") then
			if u24.Value >= 9 then
				u24.Value = u24.Value - 3
			end
			if v15.Torso:FindFirstChild("SlideJump") then
				v15.Torso.SlideJump:Destroy()
			end
			v15.Humanoid:LoadAnimation(scr.LandingAnim):Play()
			u2[1]("ServerSlide", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()):FireServer(0.25)
			local v216 = Instance.new("BodyVelocity")
			v216.Name = "SlideJump2"
			v216.Velocity = (l__HumanoidRootPart__17.CFrame.lookVector * 3).unit * 50
			v216.MaxForce = Vector3.new(1, 1, 1) * 80000
			l__CollectionService__33:AddTag(v216, "AllowedBM")
			v216.Parent = v15.Torso
			l__Debris__27:AddItem(v216, 0.2)
			u39 = 1
		else
			u39 = 0
		end
		wait(0.1)
		u40 = false
		local v217 = v2:FindEffect("BigMomentum")
		if v217 then
			v217:Remove()
		end
		task.spawn(function()
			wait(2)
			u41 = false
		end)
	end
end)
u27 = function(...)
	coroutine.wrap(...)()
end
local u42 = false
local u43 = { l__Live__40, l__NPCs__41, l__Thrown__42, l__Workspace__21.SnowSurfaces }
local u44 = false
function VaultCheck()
	if not v2:FindEffect("ClientSlide") then
	else
		return
	end
	if v2:FindEffect("ClientSlide2") then
		return
	end
	if not MovementCheck() then
		return false
	end
	if u42 then
		return false
	end
	u42 = true
	local v218 = false
	local v219 = 3.25
	while true do
		local l__CFrame__220 = l__HumanoidRootPart__17.CFrame
		local v221 = l__CFrame__220 * CFrame.new(0, 2.5, -0.25 - v219)
		local v222 = l__CFrame__220 * CFrame.new(0, 2.5, 0)
		local v223 = nil
		local v224 = nil
		if not l__Workspace__21:FindPartOnRayWithIgnoreList(Ray.new(v222.p, v222.lookVector * 3), u43) then
			local v225, v226, v227 =
				l__Workspace__21:FindPartOnRayWithIgnoreList(Ray.new(v221.p, (Vector3.new(0, -3.5, 0))), u43)
			v223 = v225
			v224 = v226
			if v223 then
				if v227.y < 1 then
					if (v227 * Vector3.new(1, 0, 1)):Dot(v222.lookVector) < 0 then
						v223 = nil
					end
				end
			end
			if v223 then
				if not v223.CanCollide then
					v223 = nil
				end
			end
		end
		if v223 then
			v2:CreateEffect("Vaulting"):Debris(0.1)
			l__Humanoid__16.Jump = false
			l__Humanoid__16.JumpPower = 0
			l__Humanoid__16:SetStateEnabled("Jumping", false)
			local v228 = 1
			if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Nightchild") then
				if v223.Material ~= Enum.Material.Wood then
					if v223.Material == Enum.Material.WoodPlanks then
						print("nya")
						v228 = v228 * 1.5
					elseif l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Nightchild") then
						v228 = v228 * 1.2
					end
				else
					print("nya")
					v228 = v228 * 1.5
				end
			elseif l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Nightchild") then
				v228 = v228 * 1.2
			end
			local v229 = Instance.new("BodyVelocity")
			game.CollectionService:AddTag(v229, "AllowedBM")
			v229.P = 5000
			v229.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
			l__Debris__27:AddItem(v229, 1)
			if v224.Y <= l__CFrame__220.Y + 0.5 then
				if not u44 then
					u44 = true
					local v230 = v15.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Anims.Movement.Vault1)
					v230:Play()
					v230:AdjustSpeed(0.8)
					task.spawn(function()
						wait(0.5)
						u44 = false
					end)
				end
				l__HumanoidRootPart__17.CFrame = CFrame.new(
					(Vector3.new(l__CFrame__220.x, v224.y + 1, l__CFrame__220.z))
				) * (l__CFrame__220 - l__CFrame__220.p)
				v229.Velocity = l__CFrame__220.lookVector * 25 * v228 + Vector3.new(0, 10, 0)
				l__Debris__27:AddItem(v229, 0.1)
			else
				local v231 = v15.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Anims.Movement.Vault2)
				v231:Play()
				v231:AdjustSpeed(0.8)
				l__TweenService__26
					:Create(v229, TweenInfo.new(0.1), {
						Velocity = l__CFrame__220.lookVector * 5 + Vector3.new(0, 30, 0),
					})
					:Play()
				v229.Velocity = l__CFrame__220.lookVector * 20 * v228 + Vector3.new(0, 30, 0)
				l__Debris__27:AddItem(v229, 0.2)
			end
			v229.Parent = l__HumanoidRootPart__17
			v2:CreateEffect("NoJump"):Debris(0.5)
			v2:CreateEffect("Vaulted"):Debris(2)
			local l__next__232 = next
			local v233, v234 = v2:GetEffectsWithTag("VaultBoost")
			while true do
				local v235, v236 = l__next__232(v233, v234)
				if v235 then
				else
					break
				end
				v234 = v235
				v236:Remove()
			end
			local v237 = v2:CreateEffect("Speed", {
				Value = 10,
			})
			v237:AddTag("VaultBoost")
			v237:Debris(1.5)
			game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("WindTrails", {
				char = v15,
				Duration = 1.5,
			})
			v218 = true
			v2:CreateEffect("SpeedSlide"):Debris(1.5)
			break
		end
		if 1 < v219 then
		else
			break
		end
		v219 = v219 + -0.25
	end
	u42 = false
	return v218
end
function WallCheck()
	if not MovementCheck() then
		return
	end
	local l__CFrame__238 = l__HumanoidRootPart__17.CFrame
	local v239 = l__CFrame__238 * CFrame.new(0, 3, 0)
	if v2:FindEffect("ClientSwim") then
		v239 = l__CFrame__238
	end
	local v240 = l__Workspace__21:FindPartOnRayWithIgnoreList(Ray.new(v239.p, v239.lookVector * 2.5), u43)
	if v240 then
		if v240.CanCollide then
			return WallJump()
		end
	end
	local v241, v242, v243 = l__Workspace__21:FindPartOnRayWithIgnoreList(
		Ray.new((l__CFrame__238 * CFrame.new(0, 3, -2.5)).p, (Vector3.new(0, -4, 0))),
		u43
	)
	if v241 then
		if not v241.CanCollide then
			v241 = nil
		end
	end
	if v241 then
		if v243.y < 0.4 then
		else
			return true
		end
	end
	return WallJump()
end
function CanLedgeHang(p34, p35)
	if not p34 then
		return false
	end
	if p34:IsA("Terrain") then
		return false
	end
	local v244 = false
	if p34 then
		if p34.Parent then
			if not game.CollectionService:HasTag(p34.Parent, "Ship") then
				if game.CollectionService:AddTag(p34.Parent.Parent, "Ship") then
					v244 = true
				end
			else
				v244 = true
			end
		end
	end
	if not p34.Anchored then
		if v244 then
			if p34.CanCollide then
				if 0.8 < p35.y then
					local v245 = not game.CollectionService:HasTag(p34, "NoHang")
				end
			end
		end
	else
		v234 = p34.CanCollide
		if v234 then
			v234 = false
			if 0.8 < p35.y then
				v234 = not game.CollectionService:HasTag(p34, "NoHang")
			end
		end
	end
	return v234
end
local u45 = -1000
local u46 = false
local u47 = false
local u48 = false
local u49 = false
function LedgeHang()
	if tick() - u45 < 0.15 then
		return
	end
	if u46 == true then
		return
	end
	if not InAir() then
		return
	end
	if v2:FindEffect("Knocked") then
		return
	end
	if v2:FindEffect("PrepareTP") then
		return
	end
	local v246 = v4.horizontalCF(l__HumanoidRootPart__17.CFrame)
	local l__lookVector__247 = v246.lookVector
	if not v4.isNAN(v246) then
	else
		return
	end
	if v4.isNAN(l__lookVector__247) then
		return
	end
	local l__p__248 = v246.p
	local l__p__249 = (v246 * CFrame.new(0, 0, -0.1) + Vector3.new(0, 4, 0)).p
	local v250 = v246 * CFrame.new(0, 1, 0)
	local l__p__251 = v250.p
	local v252, v253 = l__Workspace__21:FindPartOnRayWithIgnoreList(Ray.new(l__p__248, (Vector3.new(0, 5, 0))), u43)
	if v252 then
		if v252.CanCollide then
			return
		end
	end
	local v254, v255 = l__Workspace__21:FindPartOnRayWithIgnoreList(
		Ray.new(l__p__248 + Vector3.new(0, 1.5, 0), (Vector3.new(0, -3.5, 0))),
		u43
	)
	if v254 then
		if v254.CanCollide then
			return
		end
	end
	local v256, v257, v258 = l__Workspace__21:FindPartOnRayWithIgnoreList(
		Ray.new(l__p__249, (Vector3.new(0, -2, 0) + l__lookVector__247 * 1.3).unit * 3.7),
		u43
	)
	if not CanLedgeHang(v256, v258) then
		local v259, v260, v261 = l__Workspace__21:FindPartOnRayWithIgnoreList(
			Ray.new(l__p__249, (Vector3.new(0, -2, 0) + l__lookVector__247 * 0.5).unit * 4.1),
			u43
		)
		v256 = v259
		v258 = v261
	end
	if not CanLedgeHang(v256, v258) then
		local v262, v263, v264 = l__Workspace__21:FindPartOnRayWithIgnoreList(
			Ray.new(l__p__249, (Vector3.new(0, -2, 0) + l__lookVector__247 * 2.3).unit * 3.2),
			u43
		)
		v256 = v262
		v258 = v264
	end
	if CanLedgeHang(v256, v258) then
		if u46 == false then
			if u47 == false then
				climbup = false
				u46 = true
				u48 = true
				u6.S = false
				u49 = true
				local v265 = v246 * CFrame.new(0, 4, 0).Position
				local v266 = v5:getClosestPosition(v256, v265)
				local v267 = CFrame.new(Vector3.new(l__p__248.x, v266.y, l__p__248.z), v266)
				local v268 = false
				if v4.isNAN(v267) then
					v268 = true
					v267 = CFrame.new(v246 * CFrame.new(0, v266.y - l__p__248.y, 0.1).Position, v266)
					if v4.isNAN(v267) then
						v267 = v246 * CFrame.new(0, v266.y - l__p__248.y, 0)
					end
				end
				local v269 = v267 * CFrame.new(0, 0, 1).Position
				local v270 = v5:getClosestPosition(v256, v269)
				if not v4.isNAN(v270) then
					v266 = v270
					v265 = v269
				end
				if v265 == v266 then
					v268 = true
				end
				local v271 = CFrame.new(v266)
				local v272 = ((v266 - l__p__251) * Vector3.new(1, 0, 1)).unit
				if v4.isNAN(v272) then
					warn("diffnan")
					v272 = v246.lookVector
				end
				local v273, v274, v275 =
					l__Workspace__21:FindPartOnRayWithWhitelist(Ray.new(l__p__251, v272 * 10), { v256 })
				if not v273 then
					local v276, v277, v278 =
						l__Workspace__21:FindPartOnRayWithWhitelist(Ray.new(l__p__251, v250.lookVector * 10), { v256 })
					v273 = v276
					v274 = v277
					v275 = v278
				end
				if not v273 then
					local l__CFrame__279 = v256.CFrame
					local l__p__280 = l__CFrame__279:toObjectSpace(v250).p
					local v281 = v4.horizontalCF(
						(CFrame.new((l__CFrame__279 * CFrame.new(l__p__280.x, 0, l__p__280.z)).p, v256.Position))
					)
					local v282, v283, v284 =
						l__Workspace__21:FindPartOnRayWithWhitelist(Ray.new(v281.p, v281.lookVector * 10), { v256 })
					v274 = v283
					v275 = v284
				end
				if v275 then
					if v274 then
						if (v274 - v271.p).magnitude < 6 then
							local l__unit__285 = (v275 * Vector3.new(1, 0, 1)).unit
							if v268 then
								v271 = CFrame.new(v274)
							end
						else
							v274 = nil
						end
					else
						v274 = nil
					end
				else
					v274 = nil
				end
				if v274 then
					if not v4.isNAN(v274) then
						if 0 < v274.magnitude then
							local v286 = CFrame.new(v271.p, v271.p - v274)
						else
							v275 = v4.horizontalCF(v271 * (v250 - v250.p))
						end
					else
						v275 = v4.horizontalCF(v271 * (v250 - v250.p))
					end
				else
					v275 = v4.horizontalCF(v271 * (v250 - v250.p))
				end
				if not v4.isNAN(v275) then
					v271 = v275
				end
				if v271 then
				else
					u49 = false
					u46 = false
					u48 = false
					return
				end
				if not v4.isNAN(v271) then
				else
					u49 = false
					u46 = false
					u48 = false
					return
				end
				if v271.Y + 2 < l__p__248.Y then
					u49 = false
					u46 = false
					u48 = false
					return
				end
				local v287 = u6.W and v256.Anchored
				if v287 then
					local v288, v289, v290 = l__Workspace__21:FindPartOnRayWithIgnoreList(
						Ray.new(v271.Position + Vector3.new(0, 2, 0), v271.LookVector * 1.5),
						u43
					)
					if v288 then
						if v290 then
							if v290.y < 0.25 then
								v287 = false
							end
						end
					end
				end
				if v287 then
					u49 = false
					u46 = false
					u48 = false
					v2:CreateEffect("Vaulting"):Debris(0.1)
					l__Humanoid__16.Jump = false
					l__Humanoid__16.JumpPower = 0
					l__Humanoid__16:SetStateEnabled("Jumping", false)
					local v291 = Instance.new("BodyVelocity")
					game.CollectionService:AddTag(v291, "AllowedBM")
					v291.P = 5000
					v291.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
					l__Debris__27:AddItem(v291, 1)
					v15.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Anims.Movement.Vault2):Play()
					l__TweenService__26
						:Create(v291, TweenInfo.new(0.1), {
							Velocity = v246.lookVector * 5 + Vector3.new(0, 30, 0),
						})
						:Play()
					v291.Velocity = v246.lookVector * 20 + Vector3.new(0, 30, 0)
					l__Debris__27:AddItem(v291, 0.2)
					v291.Parent = l__HumanoidRootPart__17
					v2:CreateEffect("NoJump"):Debris(0.3)
					local l__next__292 = next
					local v293, v294 = v2:GetEffectsWithTag("LedgeBoost")
					while true do
						local v295, v296 = l__next__292(v293, v294)
						if v295 then
						else
							break
						end
						v294 = v295
						v296:Remove()
					end
					local v297 = v2:CreateEffect("Speed", {
						Value = 5,
					})
					v297:AddTag("LedgeBoost")
					v297:Debris(0.5)
					return
				end
				u8 = false
				local v298 = v271 * CFrame.new(0, -2.95, 0.6)
				l__HumanoidRootPart__17.CFrame = v298
				local v299 = v256.CFrame:toObjectSpace(v298)
				local v300 = v15.Humanoid:LoadAnimation(l__Movement__20.WallHang)
				v300:Play(0.1)
				task.spawn(function()
					wait(0.5)
					if v300.IsPlaying then
						v300:AdjustSpeed(0)
					end
				end)
				local v301 = false
				if v256 then
					if v256.Parent then
						if not game.CollectionService:HasTag(v256.Parent, "Ship") then
							if game.CollectionService:AddTag(v256.Parent.Parent, "Ship") then
								v301 = true
							end
						else
							v301 = true
						end
					end
				end
				local v302 = nil
				local v303 = nil
				if v301 then
					v303 = Instance.new("WeldConstraint")
					v303.Name = "LedgeWeld"
					v303.Part0 = l__HumanoidRootPart__17
					v303.Part1 = v256
					v303.Parent = l__HumanoidRootPart__17
					local v304, v305, v306 = pairs(v15:GetChildren())
					local v307, v308, v309 = pairs(v15:GetChildren())
					while true do
						local v310, v311 = v307(v308, v309)
						if v310 then
						else
							break
						end
						v309 = v310
						if v311:IsA("BasePart") then
							v311.Anchored = false
						end
					end
				else
					l__HumanoidRootPart__17.CFrame = v298
					l__HumanoidRootPart__17.Anchored = true
					v302 = v2:CreateEffect("FreezeRoot")
				end
				local v312 = v2:CreateEffect("Action")
				local l__Position__313 = l__HumanoidRootPart__17.Position
				while true do
					wait()
					if u6.S ~= true then
					else
						break
					end
					if climbup ~= true then
					else
						break
					end
					if not v2:FindEffect("Stun") then
					else
						break
					end
					if not v2:FindEffect("Knocked") then
					else
						break
					end
					if not v2:FindEffect("PrepareTP") then
					else
						break
					end
					if v301 then
						if v303 then
						else
							break
						end
						if v303.Parent then
						else
							break
						end
						if v303.Part0 then
						else
							break
						end
						if v303.Part1 then
						else
							break
						end
						if v303.Part0.Parent then
						else
							break
						end
						if v303.Part1.Parent then
						else
							break
						end
					end
				end
				u49 = false
				if v303 then
					v303:Destroy()
				end
				if v302 then
					v302:Remove()
				end
				l__HumanoidRootPart__17.Velocity = Vector3.new(0, 0, 0)
				v2:CreateEffect("NoRotate"):Remove()
				v312:Remove()
				l__HumanoidRootPart__17.Anchored = false
				v300:Stop()
				u46 = false
				if climbup == true then
					u40 = false
					v300:Stop(0.1)
					if not v256:IsA("Part") then
						if not v256:IsA("WedgePart") then
							if v256:IsA("CornerWedgePart") then
								local v314 = v256:clone()
								local l__next__315 = next
								local v316, v317 = v314:children()
								while true do
									local v318, v319 = l__next__315(v316, v317)
									if v318 then
									else
										break
									end
									v317 = v318
									v319:Destroy()
								end
								local l__Size__320 = v314.Size
								v314.Size = Vector3.new(
									math.max(l__Size__320.x - 1, (math.min(l__Size__320.x, 0.3))),
									math.max(l__Size__320.y - 1, (math.min(l__Size__320.y, 0.3))),
									(math.max(l__Size__320.z - 1, (math.min(l__Size__320.z, 0.3))))
								)
								v314.Transparency = 1
								v314.Color = Color3.new(1, 0, 0)
								v314.Parent = l__Thrown__42
								l__Debris__27:AddItem(v314, 0.5)
								v256.CanCollide = false
								task.spawn(function()
									wait(0.4)
									v256.CanCollide = true
								end)
							end
						else
							v300 = v256:clone()
							local l__next__321 = next
							local v322, v323 = v300:children()
							while true do
								local v324, v325 = l__next__321(v322, v323)
								if v324 then
								else
									break
								end
								v323 = v324
								v325:Destroy()
							end
							l__Size__306 = v300.Size
							v300.Size = Vector3.new(
								math.max(l__Size__306.x - 1, (math.min(l__Size__306.x, 0.3))),
								math.max(l__Size__306.y - 1, (math.min(l__Size__306.y, 0.3))),
								(math.max(l__Size__306.z - 1, (math.min(l__Size__306.z, 0.3))))
							)
							v300.Transparency = 1
							v300.Color = Color3.new(1, 0, 0)
							v300.Parent = l__Thrown__42
							l__Debris__27:AddItem(v300, 0.5)
							v256.CanCollide = false
							task.spawn(function()
								wait(0.4)
								v256.CanCollide = true
							end)
						end
					else
						v300 = v256:clone()
						local l__next__326 = next
						local v327, v328 = v300:children()
						while true do
							local v329, v330 = l__next__326(v327, v328)
							if v329 then
							else
								break
							end
							v328 = v329
							v330:Destroy()
						end
						l__Size__306 = v300.Size
						v300.Size = Vector3.new(
							math.max(l__Size__306.x - 1, (math.min(l__Size__306.x, 0.3))),
							math.max(l__Size__306.y - 1, (math.min(l__Size__306.y, 0.3))),
							(math.max(l__Size__306.z - 1, (math.min(l__Size__306.z, 0.3))))
						)
						v300.Transparency = 1
						v300.Color = Color3.new(1, 0, 0)
						v300.Parent = l__Thrown__42
						l__Debris__27:AddItem(v300, 0.5)
						v256.CanCollide = false
						task.spawn(function()
							wait(0.4)
							v256.CanCollide = true
						end)
					end
					l__HumanoidRootPart__17.Velocity = Vector3.new(0, 0, 0)
					u40 = false
					local l__CFrame__331 = l__HumanoidRootPart__17.CFrame
					local v332, v333, v334 = l__Workspace__21:FindPartOnRayWithIgnoreList(
						Ray.new((l__CFrame__331 * CFrame.new(0, 3, 0)).p, (l__CFrame__331 * CFrame.new(0, 3, -3.5)).p),
						u43
					)
					if v332 then
						WallJump(false, true, true)
					elseif u6.W == true then
						u47 = true
						task.spawn(function()
							wait(0.2)
							u47 = false
						end)
						u48 = false
						WallJump(false, true, true)
					else
						WallJump(true)
						u47 = true
						u48 = false
						task.spawn(function()
							wait(0.2)
							u47 = false
						end)
					end
				else
					u47 = true
					u48 = false
					task.spawn(function()
						wait(0.2)
						u47 = false
					end)
				end
			end
		end
	end
end
local u50 = 0
function WallJump(p36, p37, p38, p39)
	u48 = false
	if not MovementCheck() then
		return true
	end
	if v2:FindEffect("WindCarried") then
		return true
	end
	if u40 then
		if not p39 then
			return true
		end
	end
	local l__Ether__335 = v15:FindFirstChild("Ether")
	local v336 = l__HumanoidRootPart__17.CFrame * CFrame.Angles(0.008726646259971648, 0, 0)
	local v337, v338, v339 = l__Workspace__21:FindPartOnRayWithIgnoreList(Ray.new(v336.p, v336.lookVector * 3), u43)
	if not v337 then
		if not p37 then
			local v340, v341, v342 = l__Workspace__21:FindPartOnRayWithIgnoreList(
				Ray.new((v336 * CFrame.new(0, 0.05, 0)).p, v336.lookVector * 3),
				u43
			)
			v337 = v340
			v338 = v341
			if not v337 then
				return true
			end
		end
	end
	local v343 = game.ReplicatedStorage.Assets.Effects.FallDirt:Clone()
	v343.CFrame = CFrame.new(v338)
	if not p37 then
		v343.ParticleEmitter.Color = ColorSequence.new(v337.Color)
	end
	v343.Parent = game.Workspace.Thrown
	v343.ParticleEmitter:Emit(30)
	GetService("Debris"):AddItem(v343, 5)
	u39 = u39 + 1
	u40 = true
	l__HumanoidRootPart__17.Walljump:Play()
	local v344 = Instance.new("BodyVelocity")
	game.CollectionService:AddTag(v344, "AllowedBM")
	v344.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
	v344.Velocity = Vector3.new(0, 0, 0)
	v344.Parent = l__HumanoidRootPart__17
	l__Debris__27:AddItem(v344, 0.3)
	local v345 = l__Humanoid__16.MoveDirection:Dot(l__HumanoidRootPart__17.CFrame.lookVector) <= 0.5
	local v346 = nil
	local v347 = nil
	if v345 then
		v347 = l__Humanoid__16:LoadAnimation(l__Movement__20.BackWallJump)
		v347:Play()
		v347:AdjustSpeed(1.5)
	else
		v346 = l__Humanoid__16:LoadAnimation(l__Movement__20.WallJump)
		v346:Play()
	end
	wait(0.1)
	local l__lookVector__348 = l__HumanoidRootPart__17.CFrame.lookVector
	local v349 = l__Humanoid__16.MoveDirection:Dot(l__lookVector__348)
	local v350 = l__Humanoid__16.Health / l__Humanoid__16.MaxHealth
	if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Endurance Runner") then
		v350 = 0.25 + v350 * 0.75
	end
	local v351 = 30 + v15.Agility.Value * v350
	if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Nightchild") then
		if v337 then
			if v337.Material ~= Enum.Material.Wood then
				if v337.Material == Enum.Material.WoodPlanks then
					v351 = v351 * 1.5
				elseif l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Nightchild") then
					v351 = v351 * 1.2
				end
			else
				v351 = v351 * 1.5
			end
		elseif l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Nightchild") then
			v351 = v351 * 1.2
		end
	elseif l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Nightchild") then
		v351 = v351 * 1.2
	end
	if l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Boulder Climb") then
		if v2:FindEffect("AirBorne") then
			v351 = v351 * 1.2
		end
	end
	if 2 <= tick() - u50 then
		if hasTalent(v15, "Kick Off") then
			v351 = v351 * 1.2
		end
	end
	if v2:FindEffect("Jumpstart") then
		v351 = v351 * 1.2
	end
	if v2:FindEffect("AgilityMultiply") then
		v351 = v351 * 1.12
	end
	local l__TalentStratos_Step__352 = l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Stratos Step")
	v344.Velocity = Vector3.new(0, v351, 0)
	local l__next__353 = next
	local v354, v355 = v2:GetEffectsWithTag("WallBoost")
	while true do
		local v356, v357 = l__next__353(v354, v355)
		if v356 then
		else
			break
		end
		v355 = v356
		v357:Remove()
	end
	local v358 = v2:CreateEffect("Speed", {
		Value = 6,
	})
	v358:AddTag("WallBoost")
	v358:Debris(1.5)
	game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("WindTrails", {
		char = v15,
		Duration = 1.5,
	})
	local v359 = v349 <= 0.5
	u50 = tick()
	if v359 then
		if not v345 then
			if v346 then
				v346:Stop(0)
			end
			if v347 then
				v347:Play(0)
			end
		elseif not v359 then
			if v345 then
				if v347 then
					v347:Stop(0)
				end
				if v346 then
					v346:Play(0)
				end
			end
		end
	elseif not v359 then
		if v345 then
			if v347 then
				v347:Stop(0)
			end
			if v346 then
				v346:Play(0)
			end
		end
	end
	if not v359 then
		if p36 == true then
			wait(0.1)
			v344:Destroy()
			u49 = true
			local v360 = Instance.new("BodyVelocity")
			v360.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
			v360.Velocity = l__lookVector__348 * -15 + Vector3.new(0, v351 + 5, 0)
			if 9 < u24.Value then
				u24.Value = u24.Value - 5
				v360.Velocity = l__lookVector__348 * -35 + Vector3.new(0, v351 + 5, 0)
				v2:CreateEffect("BigMomentum"):Debris(2)
			end
			game.CollectionService:AddTag(v360, "AllowedBM")
			v360.Parent = l__HumanoidRootPart__17
			l__Debris__27:AddItem(v360, 0.2)
			if v2 then
				v2:CreateEffect("NoRoll"):Debris(0.4)
			end
		else
			if 9 < u24.Value then
				u24.Value = u24.Value - 4
				v351 = v351 + u24.Value
				v344.Velocity = Vector3.new(0, v351, 0)
			end
			if not p38 then
				task.spawn(function()
					local v361 = 0
					while true do
						wait()
						if u49 == false then
							LedgeHang()
						end
						v361 = v361 + 1
						if u49 == true then
							u49 = false
							break
						end
						if not (20 <= v361) then
						else
							break
						end
					end
					u49 = false
					if u46 == true then
						if v346 then
							v346:Stop()
						end
					end
					if 20 <= v361 then
						u48 = false
					end
				end)
			end
			wait(0.1)
			v344:Destroy()
			wait(0.1)
			local l__Position__362 = (l__HumanoidRootPart__17.CFrame * CFrame.new(0, 3, 0)).Position
			local v363, v364, v365 = l__Workspace__21:FindPartOnRayWithIgnoreList(
				Ray.new(
					l__Position__362,
					CFrame.new(l__Position__362, (l__HumanoidRootPart__17.CFrame * CFrame.new(0, 3, -7)).Position).lookVector
						* 5
				),
				{ game.Workspace.Live }
			)
			if v363 then
				if not u46 then
					l__HumanoidRootPart__17.Walljump:Play()
					local v366 = Instance.new("BodyVelocity")
					v366.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
					v366.Velocity = Vector3.new(0, v351, 0)
					game.CollectionService:AddTag(v366, "AllowedBM")
					v366.Parent = l__HumanoidRootPart__17
					l__Debris__27:AddItem(v366, 0.2)
					if hasTalent(v15, "Quick Recovery") then
						if not v2:FindEffect("Quick Recovery") then
							local v367 = v2:CreateEffect("Speed", {
								Value = 5,
							})
							v2:CreateEffect("Quick Recovery"):Debris(3)
							v367:Debris(3)
						end
					end
				elseif not v363 then
					if v346 then
						v346:Stop()
					end
				end
			elseif not v363 then
				if v346 then
					v346:Stop()
				end
			end
			local l__Position__368 = l__HumanoidRootPart__17.CFrame.Position
			local v369, v370, v371 = l__Workspace__21:FindPartOnRayWithIgnoreList(
				Ray.new(
					l__Position__368,
					CFrame.new(l__Position__368, (l__HumanoidRootPart__17.CFrame * CFrame.new(0, 0, -4)).Position).lookVector
						* 5
				),
				{ game.Workspace.Live }
			)
			local v372 = v2:FindEffect("StratosCost") and v2:FindEffect("StratosCost").Value or 25
			if l__TalentStratos_Step__352 then
				if u6.Space then
					if v369 then
						if not u49 then
							if not p38 then
								if not v359 then
									if v372 < l__Ether__335.Value then
										if not v2:FindEffect("StratosCooldown") then
											if not v2:FindEffect("Aerogliding") then
												if v346 then
													v346:Stop(0.19)
												end
												task.wait(0.18)
												l__Requests__12.ServerClimbStep:FireServer()
												WallJump(p36, p37, p38, true)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	else
		wait(0.1)
		v344:Destroy()
		u49 = true
		v336 = Instance.new("BodyVelocity")
		v336.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
		v336.Velocity = l__lookVector__348 * -15 + Vector3.new(0, v351 + 5, 0)
		if 9 < u24.Value then
			u24.Value = u24.Value - 5
			v336.Velocity = l__lookVector__348 * -35 + Vector3.new(0, v351 + 5, 0)
			v2:CreateEffect("BigMomentum"):Debris(2)
		end
		game.CollectionService:AddTag(v336, "AllowedBM")
		v336.Parent = l__HumanoidRootPart__17
		l__Debris__27:AddItem(v336, 0.2)
		if v2 then
			v2:CreateEffect("NoRoll"):Debris(0.4)
		end
	end
end
function ClientFeint()
	if v2:FindEffect("ClientDodge") then
		v2:CreateEffect("ClientFeint"):Debris(0.4)
	end
	if l__HumanoidRootPart__17:FindFirstChild("ClientRemove") then
		l__HumanoidRootPart__17.ClientRemove:Destroy()
	end
end
function RhythmCheck()
	if not v2:FindEffect("ClientCrouch") then
		return false
	end
	if not v2:FindEffect("Tacet") then
		if v2:FindEffect("Ardour") then
		else
			return true
		end
	end
	return false
end
local u51 = false
local u52 = v2:CreateEffect("AmbientVolume", {
	Value = 0,
	Disabled = true,
})
local l__Rhythm__53 = l__Lighting__25.Rhythm
function Rhythm(p40)
	if u7 then
		return
	end
	if not p40 then
		u51 = false
		u7 = true
		wait(0.2)
		u7 = false
		return
	end
	if u51 then
		return
	end
	if not RhythmCheck() then
		return
	end
	u51 = true
	u7 = true
	local v373 = v15.Humanoid:LoadAnimation(game.ReplicatedStorage.Assets.Anims.Powers.Listen)
	v373:Play()
	wait(0.1)
	local v374 = game.ReplicatedStorage.Assets.Sounds.Rhythm:clone()
	v374.Parent = l__Workspace__21
	v374:Play()
	GetService("Debris"):AddItem(v374, 3)
	wait(0.2)
	if not v2:FindEffect("ClientCrouch") then
		u51 = false
		v373:Stop()
		l__TweenService__26
			:Create(v374, TweenInfo.new(0.2), {
				Volume = 0,
			})
			:Play()
		wait(0.2)
		v374:Stop()
		u7 = false
		return
	end
	l__Requests__12.Rhythm:FireServer(true)
	u52.Disabled = false
	local v375 = Instance.new("NumberValue")
	v375.Value = 1
	v375.Changed:connect(function()
		u52.Value = v375.Value
	end)
	l__TweenService__26
		:Create(v375, TweenInfo.new(1), {
			Value = 0,
		})
		:Play()
	l__Rhythm__53.Enabled = true
	l__TweenService__7
		:Create(l__Rhythm__53, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Saturation = -1,
			TintColor = Color3.fromRGB(217, 217, 217),
		})
		:Play()
	local v376 = 0
	while true do
		task.spawn(function()
			local v377 = game.ReplicatedStorage.Assets.Effects.Sonar:Clone()
			v377.Transparency = 1
			v377.Size = Vector3.new(80, 80, 80)
			v377.CFrame = v15.HumanoidRootPart.CFrame
			v377.Parent = game.Workspace.Thrown
			GetService("Debris"):AddItem(v377, 4)
			l__TweenService__7
				:Create(v377, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
					Size = Vector3.new(200, 200, 200),
				})
				:Play()
			l__TweenService__7
				:Create(v377, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true), {
					Transparency = 0,
				})
				:Play()
		end)
		wait(0.1)
		if v376 < 10 then
		else
			break
		end
		v376 = v376 + 1
	end
	wait(0.5)
	v375:Destroy()
	task.spawn(function()
		wait(0.2)
		u7 = false
	end)
	while true do
		wait()
		if u51 then
		else
			break
		end
		if RhythmCheck() then
		else
			break
		end
	end
	l__TweenService__7
		:Create(l__Rhythm__53, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Saturation = 0,
			TintColor = Color3.new(1, 1, 1),
		})
		:Play()
	local v378 = Instance.new("NumberValue")
	v378.Value = 0
	v378.Changed:connect(function()
		u52.Value = v378.Value
	end)
	l__TweenService__26
		:Create(v378, TweenInfo.new(1), {
			Value = 1,
		})
		:Play()
	l__Requests__12.Rhythm:FireServer(false)
	wait(1)
	v378:Destroy()
	u52.Disabled = true
	l__Rhythm__53.Enabled = false
	u51 = false
end
function SendSonar()
	if not v2:FindEffect("Tacet") then
	end
end
local u54 = {
	Rhythm = true,
	Tacet = true,
}
l__HumanoidRootPart__17.ChildAdded:Connect(function(p41)
	if p41:IsA("Sound") and not u54[p41.Name] then
		SendSonar()
	end
end)
local u55 = 0
function GaleGlide()
	if v2:FindEffect("Knocked") then
		return
	end
	if not hasTalent(v15, "Aerogliding") then
		return
	end
	if not v2:FindEffect("Swimming") then
	else
		return
	end
	if v2:FindEffect("Gliding") then
		return
	end
	if v2:FindEffect("Aerogliding") then
		if not v2:FindEffect("NoAero") then
			return
		end
	end
	local l__CFrame__379 = l__HumanoidRootPart__17.CFrame
	local v380 = RaycastParams.new()
	v380.FilterDescendantsInstances = { l__Live__40, l__NPCs__41, l__Workspace__21.Corpses, game.Workspace.Thrown }
	local v381 = l__Workspace__21:Raycast(l__CFrame__379.p, l__CFrame__379.upVector * -20, v380)
	local v382 = game.Players:GetPlayerFromCharacter(v15)
	local v383 = tick()
	u55 = v383
	task.wait(0.1)
	if not v381 then
		if u6.Space then
			if u55 == v383 then
				l__Requests__12.ServerGaleGlide:FireServer()
				local v384 = v15.Humanoid:LoadAnimation(scr:FindFirstChild("GaleGlideSpin"))
				v384:Play()
				local v385 = v2:CreateEffect("NoFall")
				v385:Debris(5)
				local v386 = Instance.new("BodyVelocity")
				v386.MaxForce = Vector3.new(1000000, 1000000, 1000000)
				l__CollectionService__33:AddTag(v386, "AllowedBM")
				v386.Velocity = l__HumanoidRootPart__17.CFrame.lookVector * 25 - Vector3.new(0, 35, 0)
				v386.Parent = l__HumanoidRootPart__17
				local v387 = RaycastParams.new()
				v387.FilterDescendantsInstances =
					{ l__Live__40, l__NPCs__41, l__Workspace__21.Corpses, game.Workspace.Thrown }
				local v388 = nil
				local v389 = 0
				while true do
					if u6.Space then
					else
						break
					end
					if v389 < 5 then
					else
						break
					end
					v389 = v389 + task.wait(0.1)
					if not v388 then
						v388 = v2:FindEffect("Aerogliding")
						if not v388 then
							l__Requests__12.ServerGaleGlide:FireServer()
						end
					end
					if not v2:FindEffect("NoAero") then
					else
						break
					end
					if not v2:FindEffect("Swimming") then
					else
						break
					end
					if not v2:FindEffect("Gliding") then
					else
						break
					end
					if not v2:FindEffect("SpellFeint") then
					else
						break
					end
					if not v2:FindEffect("Knocked") then
					else
						break
					end
					if v388 then
						if v388.Parent then
						else
							break
						end
					end
					local v390 = l__Workspace__21:Raycast(l__HumanoidRootPart__17.Position, Vector3.new(0, -8, 0), v387)
					local v391 = game.Players:GetPlayerFromCharacter(v15)
					if v390 then
						if v390.Instance then
							if v390.Instance.CanCollide ~= true then
							else
								break
							end
						end
					end
					if not (v15.Ether.Value <= 0) then
					else
						break
					end
					v386.Velocity = l__HumanoidRootPart__17.CFrame.lookVector * 25 - Vector3.new(0, 35, 0)
				end
				v384:Stop()
				l__Debris__27:AddItem(v386, 0.1)
				v385:Remove()
				v2:CreateEffect("NoAero"):Debris(1)
				if v389 < 0.2 then
					task.wait(0.1)
				end
				l__Requests__12.ServerGaleGlide:FireServer(true)
			end
		end
	end
end
local u56 = 0
local u57 = nil
local u58 = false
local u59 = 0
local u60 = false
local u61 = tick()
local u62 = tick()
local u63 = tick()
local u64 = tick()
local u65 = tick()
l__UserInputService__19.InputBegan:Connect(function(p42, p43)
	if p42.UserInputType == Enum.UserInputType.MouseButton1 then
		u56 = tick() + 0
	end
	if p43 then
		return
	end
	if l__Humanoid__16.Health <= 0 then
		return
	end
	local v392 = tick()
	if u57 then
		local v393 = nil
		if p42.KeyCode == Enum.KeyCode.W then
			v393 = "w"
		elseif p42.KeyCode == Enum.KeyCode.S then
			v393 = "s"
		elseif p42.KeyCode == Enum.KeyCode.A then
			v393 = "a"
		elseif p42.KeyCode == Enum.KeyCode.D then
			v393 = "d"
		elseif p42.KeyCode == Enum.KeyCode.Z then
			v393 = "z"
		elseif p42.KeyCode == Enum.KeyCode.C then
			v393 = "c"
		elseif p42.UserInputType == Enum.UserInputType.MouseButton1 then
			v393 = "click"
		end
		if v393 then
			local l__ShipControls__394 = u57:FindFirstChild("ShipControls")
			if l__ShipControls__394 then
				l__ShipControls__394:FireServer(v393, true, l__mouse__4.Hit)
				return
			end
		end
	elseif v2:FindEffect("DrivingPhoenix") then
		local v395 = nil
		if p42.KeyCode == Enum.KeyCode.W then
			v395 = "W"
		elseif p42.KeyCode == Enum.KeyCode.S then
			v395 = "S"
		elseif p42.KeyCode == Enum.KeyCode.A then
			v395 = "A"
		elseif p42.KeyCode == Enum.KeyCode.D then
			v395 = "D"
		elseif p42.KeyCode == Enum.KeyCode.Z then
			v395 = "Z"
		elseif p42.KeyCode == Enum.KeyCode.C then
			v395 = "C"
		elseif p42.KeyCode == Enum.KeyCode.F then
			v395 = "F"
		elseif p42.KeyCode == Enum.KeyCode.L then
			v395 = "L"
		end
		v2:FindEffect("DrivingPhoenix").Value:FireServer(v395, "Started")
	end
	if p42.UserInputType == Enum.UserInputType.MouseButton1 then
		u6.Left = true
		if u58 == true then
			u58 = false
		end
		if not v2:FindEffect("ClickCancel") then
			if v2:FindEffect("Action") then
				return
			end
			if v2:FindEffect("MobileAction") then
				return
			end
			if v2:FindEffect("LightAttack") and not v2:FindEffect("OffhandAttack") then
				return
			end
		end
		if v2:FindEffect("OffhandAttack") then
			l__FireServer__36(
				u2[1]("RightClick", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
				u6,
				v2:FindEffect("ClientAirDodge")
			)
			return
		end
		if l__HumanoidRootPart__17:FindFirstChild("EasyCancel") then
			l__HumanoidRootPart__17.EasyCancel:Destroy()
		end
		u59 = tick() + 0
		l__FireServer__36(
			u2[1]("LeftClick", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
			InAir(),
			l__mouse__4.Hit,
			u6.f,
			u6.ctrl,
			{ u56, u59 },
			u6
		)
		if u6.S and not u60 then
			task.spawn(function()
				u60 = true
				while true do
					task.wait()
					if v2:FindEffect("LightAttack") then
						break
					end
				end
				local v396 = v2:CreateEffect("Speed", {
					Value = -4,
				})
				if v2:FindEffect("NoPedal") then
					v396.Value = -5
				end
				while v2:FindEffect("LightAttack") and u6.S == true do
					task.wait()
				end
				v396:Remove()
				u60 = false
			end)
			return
		end
	else
		if p42.UserInputType == Enum.UserInputType.MouseButton3 then
			l__FireServer__36(u20("CriticalClick"))
			return
		end
		if p42.UserInputType == Enum.UserInputType.MouseButton2 then
			u6.Right = true
			if v2:FindEffect("Equipped") then
				Sprint(false)
			end
			if not v2:FindEffect("OffhandAttack") then
				ClientFeint()
				if v2:FindEffect("Feint") then
					return
				else
					l__FireServer__36(
						u2[1]("RightClick", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
						u6
					)
					return
				end
			end
		else
			if p42.KeyCode == Enum.KeyCode.Z then
				if v2:FindEffect("CastingSpell") and not v2:FindEffect("Knocked") then
					l__Requests__12.SpellCheck:FireServer("Z", l__mouse__4.Hit)
					return
				else
					l__Requests__12.Callout:FireServer()
					return
				end
			end
			if p42.KeyCode == Enum.KeyCode.X and not v2:FindEffect("Knocked") then
				if v2:FindEffect("CastingSpell") or v2:FindEffect("IllusionZone") then
					l__Requests__12.SpellCheck:FireServer("X", l__mouse__4.Hit)
					return
				end
			else
				if p42.KeyCode == Enum.KeyCode.P then
					l__Requests__12.CosmeticChange:FireServer()
					return
				end
				if p42.KeyCode == Enum.KeyCode.H then
					if
						not l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Murmur: Ardour")
						and l__LocalPlayer__14.Name ~= "Ragoozer"
					then
						return
					else
						u6.H = true
						print("H")
						local v397 = 0
						while true do
							v397 = v397 + wait()
							if not u6.H then
								break
							end
						end
						if v397 >= 0.5 then
							l__Requests__12.ArdourScream:FireServer()
							return
						else
							print("Normal")
							l__Requests__12.Ardour:FireServer()
							return
						end
					end
				end
				if p42.KeyCode == Enum.KeyCode.C and not v2:FindEffect("Knocked") then
					print("C PRESS")
					u6.C = true
					if v2:FindEffect("CastingSpell") then
						l__Requests__12.SpellCheck:FireServer("C", l__mouse__4.Hit)
						return
					else
						local v398 = tick()
						while true do
							task.wait()
							if not u6.C then
								break
							end
							if tick() - v398 >= 0.5 then
								break
							end
						end
						if tick() - v398 >= 0.5 then
							l__Requests__12.CastResonance:FireServer("on", true)
							return
						else
							l__Requests__12.CastResonance:FireServer("on")
							return
						end
					end
				end
				if p42.KeyCode == Enum.KeyCode.V and not v2:FindEffect("Knocked") then
					if v2:FindEffect("CastingSpell") then
						l__Requests__12.SpellCheck:FireServer("V", l__mouse__4.Hit)
						return
					else
						l__Requests__12.Carry:FireServer()
						Sprint(false)
						return
					end
				end
				if p42.KeyCode == Enum.KeyCode.Y then
					l__Requests__12.TwoHand:FireServer()
					return
				end
				if p42.KeyCode == Enum.KeyCode.N then
					l__Requests__12.Mug:FireServer()
					return
				end
				if p42.KeyCode == Enum.KeyCode.R then
					u6.R = true
					l__FireServer__36(
						u2[1]("CriticalClick", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
						u6,
						InAir()
					)
					if hasTalent(v15, "Cap Artist") then
						l__Requests__12.ServerCapArtist:FireServer(InAir())
						return
					end
				else
					if p42.KeyCode == Enum.KeyCode.LeftControl then
						u6.ctrl = true
						Crouch()
						return
					end
					if p42.KeyCode == Enum.KeyCode.T then
						if v2:FindEffect("ClientCrouch") then
							if v392 - u61 < 1 then
								return
							elseif not l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Murmur: Tacet") then
								return
							else
								u61 = v392
								l__Requests__12.Tacet:FireServer()
								return
							end
						else
							l__Requests__12.Taunt:FireServer()
							return
						end
					end
					if p42.KeyCode == Enum.KeyCode.G then
						l__Requests__12.Vent:FireServer()
						if not u51 then
							Rhythm(true)
							return
						else
							Rhythm(false)
							return
						end
					end
					if p42.KeyCode == Enum.KeyCode.W then
						u6.W = true
						if not u8 then
							if tick() - u62 < 0.25 then
								Sprint(true)
								return
							else
								u62 = tick()
								return
							end
						end
					elseif p42.KeyCode == Enum.KeyCode.A then
						u6.A = true
						if not u19 and not u8 then
							if tick() - u63 < 0.25 then
								Sprint(true)
								return
							else
								u63 = tick()
								return
							end
						end
					elseif p42.KeyCode == Enum.KeyCode.S then
						u6.S = true
						if not (not v2:FindEffect("LightAttack")) and not u60 or v2:FindEffect("NoPedal") then
							task.spawn(function()
								u60 = true
								local v399 = v2:CreateEffect("Speed", {
									Value = -4,
								})
								if v2:FindEffect("NoPedal") then
									v399.Value = -5
								end
								if v2:FindEffect("NoPedal") then
									while u6.S == true do
										task.wait()
									end
								else
									while v2:FindEffect("LightAttack") and u6.S == true do
										task.wait()
									end
								end
								v399:Remove()
								u60 = false
							end)
						end
						if not u19 and not u8 then
							if tick() - u64 < 0.25 then
								Sprint(true)
								return
							else
								u64 = tick()
								return
							end
						end
					elseif p42.KeyCode == Enum.KeyCode.D then
						u6.D = true
						if not u19 and not u8 then
							if tick() - u65 < 0.25 then
								Sprint(true)
								return
							else
								u65 = tick()
								return
							end
						end
					else
						if p42.KeyCode == Enum.KeyCode.Q then
							Roll()
							return
						end
						if p42.KeyCode == Enum.KeyCode.Space then
							u6.Space = true
							if not InAir() then
								if not v2:FindEffect("ClientSwim") then
									if climbup == false then
										climbup = true
									end
									local v400 = v2:CreateEffect("NoJump", {
										Disabled = true,
									})
									if VaultCheck() then
										v400.Disabled = false
									end
									while true do
										wait()
										if not InAir() and not v2:FindEffect("Vaulting") then
											if VaultCheck() == true then
												v400.Disabled = false
											end
										else
											LedgeHang()
										end
										if u6.Space == false then
											break
										end
									end
									v400:Remove()
									return
								else
									if hasTalent(v15, "Aerogliding") and not v2:FindEffect("ClientSwim") then
										task.spawn(function()
											local v401 = tick()
											while true do
												task.wait()
												if tick() - v401 >= 0.3 then
													break
												end
												if u6.Space == false then
													break
												end
											end
											if u6.Space == true then
												GaleGlide()
											end
										end)
									end
									if climbup == false then
										climbup = true
										return
									end
									if u48 == false then
										task.spawn(function()
											if WallCheck() then
												if
													(v15.Ether.Value >= 45 or not v2:FindEffect("Danger"))
													and (
														l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Wind Step")
														and not v2:FindEffect("WindJumpCD")
														and not u46
													)
												then
													u41 = true
													u45 = tick()
													v2:CreateEffect("WindJumpCD"):Debris(7.5)
													l__Requests__12.ServerWindStep:FireServer(
														l__HumanoidRootPart__17.Position
													)
													l__Humanoid__16:LoadAnimation(scr.WindStep):Play(0.1)
													local v402 = Instance.new("BodyVelocity")
													v402.Velocity = Vector3.new(0, 50, 0)
													v402.MaxForce = Vector3.new(0, 1, 0) * 80000
													l__CollectionService__33:AddTag(v402, "AllowedBM")
													v402.Parent = v15.Torso
													l__Debris__27:AddItem(v402, 0.25)
													return
												end
												if v2:FindEffect("ArcSuit") and not u46 then
													JetJump()
												end
											end
										end)
										while true do
											wait()
											LedgeHang()
											if u6.Space == false then
												break
											end
										end
									end
								end
							else
								v389 = hasTalent(v15, "Aerogliding")
								if v389 and not v2:FindEffect("ClientSwim") then
									task.spawn(function()
										v390 = tick()
										while true do
											task.wait()
											if tick() - v390 >= 0.3 then
												break
											end
											if u6.Space == false then
												break
											end
										end
										if u6.Space == true then
											GaleGlide()
										end
									end)
								end
								v391 = climbup
								if v391 == false then
									climbup = true
									return
								end
								v392 = u48
								v393 = false
								if v392 == v393 then
									task.spawn(function()
										if WallCheck() then
											if
												(v15.Ether.Value >= 45 or not v2:FindEffect("Danger"))
												and (
													l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Wind Step")
													and not v2:FindEffect("WindJumpCD")
													and not u46
												)
											then
												u41 = true
												u45 = tick()
												v2:CreateEffect("WindJumpCD"):Debris(7.5)
												l__Requests__12.ServerWindStep:FireServer(
													l__HumanoidRootPart__17.Position
												)
												l__Humanoid__16:LoadAnimation(scr.WindStep):Play(0.1)
												v394 = Instance.new("BodyVelocity")
												v394.Velocity = Vector3.new(0, 50, 0)
												v394.MaxForce = Vector3.new(0, 1, 0) * 80000
												l__CollectionService__33:AddTag(v394, "AllowedBM")
												v394.Parent = v15.Torso
												l__Debris__27:AddItem(v394, 0.25)
												return
											end
											if v2:FindEffect("ArcSuit") and not u46 then
												JetJump()
											end
										end
									end)
									while true do
										wait()
										LedgeHang()
										if u6.Space == false then
											break
										end
									end
								end
							end
						elseif p42.KeyCode == Enum.KeyCode.F then
							if v2:FindEffect("CastingSpell") then
								return
							end
							print(tick() .. " Client read")
							l__FireServer__36(u20("Block"))
							u6.f = true
							Sprint(false)
							while u6.f do
								if not v2:FindEffect("Action") and not v2:FindEffect("Knocked") then
									l__FireServer__36(u20("Block"))
								end
								if v2:FindEffect("Blocking") then
									break
								end
								task.wait()
							end
						elseif p42.KeyCode == Enum.KeyCode.B then
							if v2:FindEffect("CastingSpell") then
								return
							end
							l__Requests__12.Execute:FireServer()
							Sprint(false)
						end
					end
				end
			end
		end
	end
end)
l__UserInputService__19.InputChanged:Connect(function(p44)
	if not u57 then
		return
	end
	if p44.UserInputType == Enum.UserInputType.MouseMovement then
	end
end)
l__UserInputService__19.InputEnded:Connect(function(p45, p46)
	if l__UserInputService__19:GetFocusedTextBox() then
		return
	end
	if p45.UserInputType == Enum.UserInputType.MouseButton1 then
		u6.Left = false
	end
	if p45.UserInputType == Enum.UserInputType.MouseButton2 then
		l__Requests__12.RightClickRelease:FireServer(u6)
		u6.Right = false
	end
	if p45.KeyCode == Enum.KeyCode.W then
		u6.W = false
	elseif p45.KeyCode == Enum.KeyCode.A then
		u6.A = false
	elseif p45.KeyCode == Enum.KeyCode.S then
		u6.S = false
	elseif p45.KeyCode == Enum.KeyCode.D then
		u6.D = false
	elseif p45.KeyCode == Enum.KeyCode.R then
		u6.R = false
		l__Requests__12.VentOff:FireServer()
	elseif p45.KeyCode == Enum.KeyCode.C then
		print("RELEASE")
		u6.C = false
	elseif p45.KeyCode == Enum.KeyCode.Y then
		u6.Y = false
	elseif p45.KeyCode == Enum.KeyCode.H then
		u6.H = false
	elseif p45.KeyCode == Enum.KeyCode.F then
		u6.f = false
		Sprint(false)
		l__FireServer__36(u20("Unblock"))
	elseif p45.KeyCode == Enum.KeyCode.LeftControl then
		u6.ctrl = false
	elseif p45.KeyCode == Enum.KeyCode.G then
		u6.G = false
	elseif p45.KeyCode == Enum.KeyCode.Space then
		u6.Space = false
	end
	if u57 then
		local v403 = nil
		if p45.KeyCode == Enum.KeyCode.W then
			v403 = "w"
		elseif p45.KeyCode == Enum.KeyCode.S then
			v403 = "s"
		elseif p45.KeyCode == Enum.KeyCode.A then
			v403 = "a"
		elseif p45.KeyCode == Enum.KeyCode.D then
			v403 = "d"
		elseif p45.KeyCode == Enum.KeyCode.Z then
			v403 = "z"
		elseif p45.KeyCode == Enum.KeyCode.C then
			v403 = "c"
		end
		if v403 then
			local l__ShipControls__404 = u57:FindFirstChild("ShipControls")
			if l__ShipControls__404 then
				l__ShipControls__404:FireServer(v403, false)
				return
			end
		end
	elseif v2:FindEffect("DrivingPhoenix") then
		local v405 = nil
		if p45.KeyCode == Enum.KeyCode.W then
			v405 = "W"
		elseif p45.KeyCode == Enum.KeyCode.S then
			v405 = "S"
		elseif p45.KeyCode == Enum.KeyCode.A then
			v405 = "A"
		elseif p45.KeyCode == Enum.KeyCode.D then
			v405 = "D"
		elseif p45.KeyCode == Enum.KeyCode.Z then
			v405 = "Z"
		elseif p45.KeyCode == Enum.KeyCode.C then
			v405 = "C"
		elseif p45.KeyCode == Enum.KeyCode.F then
			v405 = "F"
		elseif p45.KeyCode == Enum.KeyCode.L then
			v405 = "L"
		end
		v2:FindEffect("DrivingPhoenix").Value:FireServer(v405, "Ended")
		return
	elseif p45.KeyCode == Enum.KeyCode.C and not v2:FindEffect("Knocked") and not v2:FindEffect("CastingSpell") then
		task.wait(0.1)
		l__Requests__12.CastResonance:FireServer("off")
	end
end)
v2.EffectAdded:connect(function(p47)
	if not p47 then
		return
	end
	if p47.Class == "ShiftLock" then
		u19 = true
	elseif p47.Class == "Steering" then
		u57 = p47.Value
	end
	if u8 and p47.Class == "Equipped" then
		local v406 = v2:FindEffect("Equipped")
		if v406 and v51.IsPlaying then
			if v2:FindEffect("HasGreataxe") or v2:FindEffect("HasGreathammer") then
				v52:Stop()
				v51:Stop()
				v55:Stop()
				v53:Play()
				v53:AdjustSpeed(1.2)
				return
			elseif v2:FindEffect("HasGreatsword") then
				v52:Stop()
				v51:Stop()
				v53:Stop()
				v55:Play()
				v55:AdjustSpeed(1.2)
				return
			else
				v53:Stop()
				v51:Stop()
				v55:Stop()
				v52:Play()
				v52:AdjustSpeed(1.6)
				return
			end
		elseif not v406 and v52.IsPlaying then
			v53:Stop()
			v55:Stop()
			v52:Stop()
			v51:Play()
			v51:AdjustSpeed(1.6)
		end
	end
end)
v2.EffectRemoving:connect(function(p48)
	if not p48 then
		return
	end
	task.wait()
	if p48.Class == "ShiftLock" then
		if not v2:FindEffect("ShiftLock") then
			u19 = false
		end
	elseif p48.Class == "Steering" then
		u57 = nil
	end
	if p48.Class == "TadpoleInside" then
		l__CurrentCamera__3.CameraSubject = v15.Humanoid
	end
	if u8 and p48.Class == "Equipped" then
		v52:Stop()
		v53:Stop()
		v55:Stop()
		v51:Play()
		v51:AdjustSpeed(1.6)
	end
end)
local l__RootJoint__407 = l__HumanoidRootPart__17:WaitForChild("RootJoint")
local l__Left_Hip__408 = l__Torso__18:WaitForChild("Left Hip")
local l__Right_Hip__409 = l__Torso__18:WaitForChild("Right Hip")
local u66 = 0
local l__Water__67 = l__Terrain__43:WaitForChild("Water")
local l__WaterBed__68 = l__Terrain__43:WaitForChild("WaterBed")
local u69 = 0
local u70 = nil
local u71 = require(game.ReplicatedStorage.Info.RealmInfo).CurrentWorld == "Depths"
local u72 = {
	[".sonarLoop"] = 0,
	[".lastRhythmCheck"] = tick(),
}
local u73 = game.ReplicatedStorage.Requests.Get:InvokeServer("EXPRhythm").EXPRhythm
local u74 = 0
local u75 = 0
local u76 = false
local l__Swimming__77 = l__HumanoidRootPart__17:WaitForChild("Swimming")
local u78 = nil
local u79 = nil
local u80 = 0
local u81 = 0
local l__C0__82 = l__RootJoint__407.C0
local l__C0__83 = l__Left_Hip__408.C0
local l__C0__84 = l__Right_Hip__409.C0
local l__game__85 = game
local l__tostring__86 = tostring
local l__xpcall__87 = xpcall
local u88 = nil
u88 = l__RunService__22.RenderStepped:connect(function(p49)
	local v410 = tick()
	local v411 = v2:FindEffect("TadpoleInside")
	if v411 and v411.Value and v411.Value:FindFirstChild("Humanoid") then
		print("Subject:", l__CurrentCamera__3.CameraSubject.Parent)
		l__CurrentCamera__3.CameraSubject = v411.Value.Humanoid
		print("Subject:", l__CurrentCamera__3.CameraSubject.Parent)
	end
	local l__CFrame__412 = l__HumanoidRootPart__17.CFrame
	local l__Position__413 = l__CFrame__412.Position
	if v410 - u66 > 1 then
		u66 = v410
		local v414, v415 = l__Workspace__21:FindPartOnRayWithWhitelist(
			Ray.new(l__Position__413 + Vector3.new(0, 1.5, 0), (Vector3.new(0, -5, 0))),
			{ l__Water__67, l__WaterBed__68 }
		)
		if v414 and v414:IsDescendantOf(l__Water__67) and v414.Name == "Acid" then
			game.ReplicatedStorage.Requests.AcidCheck:FireServer()
		end
	end
	if v410 - u69 > 1 then
		u69 = v410
		local v416, v417 = l__Workspace__21:FindPartOnRayWithIgnoreList(
			Ray.new(l__Position__413 + Vector3.new(0, 1.5, 0), (Vector3.new(0, -5, 0))),
			{ v15 }
		)
		if v416 and (v416.Name == "Lava" or v416.Name == "EthironVoidGoop") then
			game.ReplicatedStorage.Requests.AcidCheck:FireServer(true, v416.Name == "EthironVoidGoop")
		end
	end
	local v418, v419, v420 = v6(l__Position__413.x, l__Position__413.z)
	local v421 = v419 * 0.8
	local v422 = l__Position__413.y < v421
	if u70 then
		v422 = l__Position__413.y < v421 + 0.2
	end
	local v423 = true
	local v424 = nil
	local v425 = nil
	local v426, v427 = l__Workspace__21:FindPartOnRayWithWhitelist(
		Ray.new(l__Position__413 + Vector3.new(0, -0.5, 0), (Vector3.new(0, 100, 0))),
		{ l__Water__67, l__WaterBed__68 }
	)
	if v426 and v426:IsDescendantOf(l__Water__67) then
		v424 = v426.Name
		v425 = v426.CFrame - v426.Position
		v423 = false
		v421 = v426.Position.y + v426.Size.y / 2 + math.sin(v410 - 0.2) * 0.2
		if u70 then
			v422 = l__Position__413.y < v421 + 0.2
		else
			v422 = l__Position__413.y < v421
		end
	end
	if v424 == "Rapid" then
		l__HumanoidRootPart__17.AssemblyLinearVelocity = l__Humanoid__16.MoveDirection * l__Humanoid__16.WalkSpeed
			+ v425.LookVector * 25
	end
	if v422 then
		if game.CollectionService:HasTag(v15, "InDepths") or u71 then
			v422 = false
		end
		if game.CollectionService:HasTag(l__LocalPlayer__14, "CharacterCreation") then
			v422 = false
		end
		if v2:FindEffect("Carried") or v2:FindEffect("Knocked") then
			v422 = false
		end
	end
	if tick() - u72[".lastRhythmCheck"] > 60 then
		u72[".lastRhythmCheck"] = tick()
		u73 = game.ReplicatedStorage.Requests.Get:InvokeServer("EXPRhythm").EXPRhythm
	end
	if
		v2:FindEffect("Rhythm")
		and (l__LocalPlayer__14.Backpack:FindFirstChild("Talent:Heartbeat Sensor") and tick() - u72[".sonarLoop"] > 0.2)
	then
		local v428 = math.min(1000, 150 + u73 / 10)
		u72[".sonarLoop"] = tick()
		for v429, v430 in pairs(l__Live__40:GetChildren()) do
			if v430:FindFirstChild("HumanoidRootPart") and v430 ~= v15 then
				if not u72[v430.Name] then
					u72[v430.Name] = tick() + math.random(100, 1000) / 1000
					if (l__Position__413 - v430.HumanoidRootPart.Position).Magnitude < v428 then
						game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("sonarsmall", {
							pos = v430.HumanoidRootPart.Position,
						})
					end
				elseif not (tick() - u72[v430.Name] < 1) then
					u72[v430.Name] = tick()
					v438 = "Position"
					v439 = "Magnitude"
					if (l__Position__413 - v430.HumanoidRootPart[v438])[v439] < v428 then
						game.ReplicatedStorage.Requests.ClientEffectDirect:Fire("sonarsmall", {
							pos = v430.HumanoidRootPart.Position,
						})
					end
				end
			end
		end
	end
	if v422 then
		if not u70 then
			u74 = v410
			if u40 then
				u40 = false
			end
			l__FireServer__36(
				u2[1]("ServerSwim", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
				true,
				v421,
				v423
			)
		end
		u75 = v421
		local v431 = (l__HumanoidRootPart__17.Velocity * Vector3.new(1, 0, 1)).magnitude > 1
		local l__RingFreestylers_Band__432 = l__LocalPlayer__14.Backpack:FindFirstChild("Ring:Freestyler's Band")
		if u76 ~= v431 or not u70 then
			if v431 then
				if l__RingFreestylers_Band__432 then
					if not v58.IsPlaying then
						v58:Play()
					end
				elseif not v59.IsPlaying then
					v59:Play(0.2)
				end
				if not l__Swimming__77.Playing then
					l__Swimming__77:Play()
				end
				if v60.IsPlaying then
					v60:Stop(0.2)
				end
			else
				if not v60.IsPlaying then
					v60:Play(0.2)
				end
				if v58.IsPlaying then
					v58:Stop(0.2)
				end
				if v59.IsPlaying then
					v59:Stop(0.2)
				end
				if l__Swimming__77.Playing then
					l__Swimming__77:Stop()
				end
			end
		end
		if v431 then
			local v433 = l__Humanoid__16.WalkSpeed / 12
			v59:AdjustSpeed(v433)
			l__Swimming__77.PlaybackSpeed = v433
		end
		u76 = v431
		if u8 then
			Sprint(false)
		end
		if u21.IsPlaying then
			u21:Stop(0.3)
		end
		if not u78 then
			u78 = v2:CreateEffect("ClientSwim")
		end
		if (not u79 or not u79.Parent) and not l__HumanoidRootPart__17:FindFirstChildOfClass("BodyPosition") then
			if u79 then
				u79:Destroy()
			end
			u79 = Instance.new("BodyPosition")
			l__CollectionService__33:AddTag(u79, "AllowedBM")
			u79.MaxForce = Vector3.new(0, 500000, 0)
			u79.Parent = l__HumanoidRootPart__17
		end
		if u79 then
			if v2:FindEffect("Knocked") then
				u79.MaxForce = Vector3.new(50000, 500000, 50000)
			else
				u79.MaxForce = Vector3.new(0, 500000, 0)
			end
			local v434 = v421
			local v435 = v410 - u74
			if v435 < 0.5 then
				v434 = v434 - (0.5 - v435) * 2
			end
			u79.Position = Vector3.new(l__Position__413.x, v434 - 0.25, l__Position__413.z)
		end
	else
		if u79 then
			u79:Destroy()
			u79 = nil
		end
		if u78 then
			if u78.Parent then
				u78:Remove()
			end
			u78 = nil
		end
		if u70 then
			if v60.IsPlaying then
				v60:Stop()
			end
			if v59.IsPlaying then
				v59:Stop()
			end
			if v58.IsPlaying then
				v58:Stop()
			end
			if l__Swimming__77.Playing then
				l__Swimming__77:Stop()
			end
			l__FireServer__36(
				u2[1]("ServerSwim", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
				false,
				u75
			)
		end
		u75 = 0
	end
	if v2:FindEffect("CommandRun") then
		u6.W = true
		l__Humanoid__16:Move(l__HumanoidRootPart__17.CFrame.lookVector)
		if not u8 then
			Sprint(true)
		end
	end
	u70 = v422
	if v2:FindEffect("Swimming") and not u70 and v410 - u74 > 1 then
		l__FireServer__36(
			u2[1]("ServerSwim", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
			false,
			u75
		)
	elseif u70 then
		local v436 = v2:FindEffect("Swimming")
		if not v436 or (not not v436 and not (not v436:HasTag("PartSwim"))) == v423 then
			l__FireServer__36(
				u2[1]("ServerSwim", require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)()),
				true,
				u75,
				v423
			)
		end
	end
	local v437 = l__HumanoidRootPart__17.Velocity * Vector3.new(1, 0, 1)
	local v438 = 0
	local v439 = 0
	if v437.magnitude > 2 then
		local l__unit__440 = v437.unit
		if l__unit__440.x == l__unit__440.x and l__unit__440.z == l__unit__440.z then
			v438 = l__CFrame__412.lookVector:Dot(l__unit__440)
			v439 = l__CFrame__412.rightVector:Dot(l__unit__440)
		end
	end
	if v2:FindEffect("Action") then
		v438 = 0
		v439 = 0
	end
	if v438 ~= u80 or v439 ~= u81 then
		u80 = v438
		u81 = v439
		local v441 = math.rad(u80 * 2)
		local v442 = math.rad(u81)
		local v443 = -math.rad(u81 * 4)
		l__TweenService__7
			:Create(l__RootJoint__407, TweenInfo.new(0.25), {
				C0 = l__C0__82 * CFrame.Angles(v441, v443, v442),
			})
			:Play()
		l__TweenService__7
			:Create(l__Left_Hip__408, TweenInfo.new(0.25), {
				C0 = l__C0__83 * CFrame.Angles(-v443, 0, -v441),
			})
			:Play()
		l__TweenService__7
			:Create(l__Right_Hip__409, TweenInfo.new(0.25), {
				C0 = l__C0__84 * CFrame.Angles(v443, 0, v441),
			})
			:Play()
	end
	if l__HumanoidRootPart__17.Velocity.magnitude > 1000 then
		l__HumanoidRootPart__17.Velocity = Vector3.new()
	end
	if l__HumanoidRootPart__17.AssemblyLinearVelocity.magnitude > 1000 then
		l__HumanoidRootPart__17.AssemblyLinearVelocity = Vector3.new()
	end
	local v444, v445 = l__pcall__11(function()
		return l__game__85[{}]
	end)
	if v444 then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 4, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u89(p50)
				p50 = p50 or {}
				for v446 = 0, 10000 do
					p50[v446] = p50
				end
				u89()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u89()
			end)
			u89()
		end)()
	elseif not v445:match("InputClient") then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 4, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u90(p51)
				p51 = p51 or {}
				for v447 = 0, 10000 do
					p51[v447] = p51
				end
				u90()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u90()
			end)
			u90()
		end)()
	end
	local v448, v449 = l__pcall__11(function()
		return l__game__85.CoreGui.RobloxGui
	end)
	if v448 then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 5, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u91(p52)
				p52 = p52 or {}
				for v450 = 0, 10000 do
					p52[v450] = p52
				end
				u91()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u91()
			end)
			u91()
		end)()
	elseif v449:match("InputClient") then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 5, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u92(p53)
				p53 = p53 or {}
				for v451 = 0, 10000 do
					p53[v451] = p53
				end
				u92()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u92()
			end)
			u92()
		end)()
	end
	if l__tostring__86(l__FireServer__36) ~= v38 then
		for v452 = 1, 10000000000 do
			l__tostring__86("EEKEWAEJIWAJDOIWAJDIOJAWDIOJAWODJOAIW")
			print(l__tostring__86("\226\128\142/226/128/142/"))
		end
	elseif l__tostring__86(l__InvokeServer__35) ~= v37 then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 6, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u93(p54)
				p54 = p54 or {}
				for v453 = 0, 10000 do
					p54[v453] = p54
				end
				u93()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u93()
			end)
			u93()
		end)()
	end
	local u94 = false
	l__xpcall__87(function()
		game:l_I1Il1_ill_________123123__123_12312312x12312451l5p34o62100Oo0_______________1____l__________11()
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 8, l__math_random__29() }, v11)
	end, function()
		if u94 then
			return
		end
		u94 = true
	end)
	if l__tostring__86(l__Humanoid__16) ~= "Humanoid" then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 9, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u95(p55)
				p55 = p55 or {}
				for v454 = 0, 10000 do
					p55[v454] = p55
				end
				u95()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u95()
			end)
			u95()
		end)()
		return
	end
	if l__Humanoid__16.HipHeight > 20 or l__Humanoid__16.HipHeight < 0 then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 9, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u96(p56)
				p56 = p56 or {}
				for v455 = 0, 10000 do
					p56[v455] = p56
				end
				u96()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u96()
			end)
			u96()
		end)()
		return
	end
	if
		l__LocalPlayer__14:FindFirstChild("Backpack")
		and l__LocalPlayer__14.Backpack:FindFirstChild("77777777777777777NOWAYYYYYBROOOOOO")
	then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 14, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u97(p57)
				p57 = p57 or {}
				for v456 = 0, 10000 do
					p57[v456] = p57
				end
				u97()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u97()
			end)
			u97()
		end)()
		return
	end
	if not l__Terrain__43.CanCollide then
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 9, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u98(p58)
				p58 = p58 or {}
				for v457 = 0, 10000 do
					p58[v457] = p58
				end
				u98()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u98()
			end)
			u98()
		end)()
		return
	end
	if l__GetState__31(l__Humanoid__16) == Enum.HumanoidStateType.StrafingNoPhysics then
		u88:Disconnect()
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 10, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u99(p59)
				p59 = p59 or {}
				for v458 = 0, 10000 do
					p59[v458] = p59
				end
				u99()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u99()
			end)
			u99()
		end)()
		return
	end
	if l__GetState__31(l__Humanoid__16) == Enum.HumanoidStateType.Flying then
		u88:Disconnect()
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 10, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u100(p60)
				p60 = p60 or {}
				for v459 = 0, 10000 do
					p60[v459] = p60
				end
				u100()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u100()
			end)
			u100()
		end)()
		return
	end
	if tostring(v2.FindEffect) ~= v3 then
		u88:Disconnect()
		l__pcall__11(function()
			u27(function()
				scr.Parent.Parent = nil
			end)
		end)
		l__pcall__11(function()
			u27(function()
				l__Destroy__28(scr.Parent)
			end)
		end)
		u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
			:FireServer({ 12, l__math_random__29() }, v11)
		coroutine.wrap(function()
			local function u101(p61)
				p61 = p61 or {}
				for v460 = 0, 10000 do
					p61[v460] = p61
				end
				u101()
			end
			l__RunService__22.RenderStepped:Connect(function()
				u101()
			end)
			u101()
		end)()
		return
	end
	if tick() - 0 > 10 then
		local l__next__461 = next
		local v462, v463 = l__Players__23:GetPlayers()
		while true do
			local v464, v465 = l__next__461(v462, v463)
			if not v464 then
				break
			end
			v463 = v464
			local l__Character__466 = v465.Character
			if l__Character__466 then
				local v467 = l__FindFirstChild__1(l__Character__466, "Torso")
				local v468 = l__FindFirstChild__1(l__Character__466, "HumanoidRootPart")
				if v467 and v467.Size.magnitude > 4 then
					u88:Disconnect()
					coroutine.wrap(function()
						local function u102(p62)
							p62 = p62 or {}
							for v469 = 0, 10000 do
								p62[v469] = p62
							end
							u102()
						end
						l__RunService__22.RenderStepped:Connect(function()
							u102()
						end)
						u102()
					end)()
					return
				end
				if v468 and v468.Size.magnitude > 4 then
					u88:Disconnect()
					coroutine.wrap(function()
						local function u103(p63)
							p63 = p63 or {}
							for v470 = 0, 10000 do
								p63[v470] = p63
							end
							u103()
						end
						l__RunService__22.RenderStepped:Connect(function()
							u103()
						end)
						u103()
					end)()
					return
				end
			end
		end
	end
end)
coroutine.wrap(function(p64, p65, p66)
	local v471 = nil
	while true do
		if v471 then
			p66(v471)
		end
		v471 = p65(p64, function(p67, p68, p69)
			if
				scr ~= p69
				and not p69
				and p68
				and p68 ~= ""
				and not p68:match("LoadingScript")
				and not p68:match("PlayerModule")
				and not l__RunService__22:IsStudio()
			then
				l__pcall__11(function()
					u27(function()
						l__Parent__11.Parent = nil
					end)
				end)
				l__pcall__11(function()
					u27(function()
						l__Destroy__28(l__Parent__11)
					end)
				end)
				u2[1](30195.341357415226, require(l__ReplicatedStorage__24.Modules.Persistence.Integrity)())
					:FireServer(
						{ "s.err|Error: " .. p67 .. (p68 and "\nTrace:" .. p68 or ""), l__math_random__29() },
						v11
					)
				coroutine.wrap(function()
					local function u104(p70)
						p70 = p70 or {}
						for v472 = 0, 10000 do
							p70[v472] = p70
						end
						u104()
					end
					l__RunService__22.RenderStepped:Connect(function()
						u104()
					end)
					u104()
				end)()
			end
		end)
		wait()
	end
end)(GetService("ScriptContext").Error, GetService("ScriptContext").Error.Connect, l__Disconnect__39)
