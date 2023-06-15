-- Decompiled with the Synapse X Luau decompiler.

local l__LocalPlayer__1 = GetService("Players").LocalPlayer
local v2 = {}
v2.__index = v2
local u1 = require(script.Signal)
local u2 = GetService("RunService"):IsServer()
local l__EffectReplication__3 = GetService("ReplicatedStorage").Requests:WaitForChild("EffectReplication")
function v2.new(p1)
	local v3 = setmetatable({}, v2)
	v3.EffectAdded = u1.new()
	v3.EffectRemoving = u1.new()
	v3.Container = nil
	v3.Effects = {}
	if not u2 then
		l__EffectReplication__3._update.OnClientEvent:Connect(function(...)
			v3:_handleClientUpdate(...)
		end)
	end
	return v3
end
function v2.GetEffect(p2, p3)
	return p2.Effects[typeof(p3) == "table" and p3.ID or p3]
end
function v2.FindEffect(p4, p5, p6)
	for v4, v5 in next, p4.Effects do
		if v5.Class == p5 then
			if not v5.Disabled then
				return v5
			end
			if p6 then
				return v5
			end
		end
	end
end
function v2.FindServerEffect(p7, p8, p9)
	for v6, v7 in next, p7.Effects do
		if v7.Class == p8 and v7.Domain == "Server" then
			if not v7.Disabled then
				return v7
			end
			if p9 then
				return v7
			end
		end
	end
end
function v2.FindEffectWithTag(p10, p11, p12)
	for v8, v9 in next, p10.Effects do
		if v9.Tags[p11] then
			if not v9.Disabled then
				return v9
			end
			if p12 then
				return v9
			end
		end
	end
end
function v2.FindEffectWithValue(p13, p14, p15, p16)
	for v10, v11 in next, p13.Effects do
		if v11.Class == p14 and v11.Value == p15 then
			if not v11.Disabled then
				return v11
			end
			if p16 then
				return v11
			end
		end
	end
end
local u4 = require(script.Effect)
function v2.CreateEffect(p17, p18, p19, p20)
	p19 = p19 or {}
	p19.Class = p18
	local v12 = u4.new(p17, p19, u2, p20)
	p17.Effects[v12.ID] = v12
	p17.EffectAdded:Fire(v12)
	return v12
end
function v2.GetEffects(p21)
	local v13 = {}
	for v14, v15 in next, p21.Effects do
		table.insert(v13, v15)
	end
	return v13
end
function v2.GetEffectsOfClass(p22, p23)
	local v16 = {}
	for v17, v18 in next, p22.Effects do
		if v18.Class == p23 then
			table.insert(v16, v18)
		end
	end
	return v16
end
function v2.GetEffectsWithTag(p24, p25)
	local v19 = {}
	for v20, v21 in next, p24.Effects do
		if v21.Tags[p25] then
			table.insert(v19, v21)
		end
	end
	return v19
end
function v2.GetEffectsWithValue(p26, p27, p28)
	local v22 = {}
	for v23, v24 in next, p26.Effects do
		if v24.Class == p27 and v24.Value == p28 then
			table.insert(v22, v24)
		end
	end
	return v22
end
function v2.ParseEffects(p29)
	local v25 = {}
	for v26, v27 in next, p29.Effects do
		table.insert(v25, v27:ParseEffect())
	end
	return v25
end
function v2.GetEffectsHash(p30)
	local v28 = {}
	for v29, v30 in next, p30.Effects do
		v28[v30.Class] = true
	end
	return v28
end
function v2._clearEffects(p31)
	local l__next__31 = next
	local v32, v33 = p31:GetEffects()
	while true do
		local v34, v35 = l__next__31(v32, v33)
		if not v34 then
			break
		end
		v33 = v34
		v35:Destroy()
	end
end
function v2._handleClientUpdate(p32, p33)
	local v36 = nil
	local l__updateType__37 = p33.updateType
	v36 = p33.sum
	if l__updateType__37 == "updatecontainer" then
		if v36 ~= p32.Container then
			p32:_clearEffects()
			p32.Container = v36
			return
		end
	elseif l__updateType__37 == "remove" then
		local v38 = p32.Effects[v36]
		if v38 then
			v38:Destroy(true)
			return
		end
	else
		if l__updateType__37 == "clear" then
			p32:_clearEffects()
			return
		end
		if l__updateType__37 == "update" then
			local l__next__39 = next
			local v40 = nil
			while true do
				local v41, v42 = l__next__39(v36, v40)
				if not v41 then
					break
				end
				local v43 = p32.Effects[v42.ID] or p32:CreateEffect(v42.Class, v42)
				if v42.Tags ~= nil then
					v43.Tags = v42.Tags
				end
				if v42.Value ~= nil then
					v43.Value = v42.Value
				end
				if v42.Disabled ~= nil then
					v43.Disabled = v42.Disabled
				end
				if v42.DebrisTime ~= nil then
					v43.DebrisTime = v42.DebrisTime
				end
				p32.Effects[v42.ID] = v43
			end
		end
	end
end
function v2.WaitForContainer(p34)
	while not p34.Container do
		task.wait()
	end
end
return u2 and v2 or v2.new()
