-- Decompiled with the Synapse X Luau decompiler.

local u1 = {
	__index = function(p1, p2)
		local v1 = rawget(p1._props, p2)
		if v1 == nil then
			v1 = rawget(p1, p2)
		end
		if v1 == nil then
			v1 = rawget(u1, p2)
		end
		return v1
	end,
	__metatable = "Effect",
	__tostring = function(p3)
		if p3.Disabled then
			local v2 = "X"
		else
			v2 = "\226\156\147"
		end
		return string.format(
			"Effect: %s [%s] (%s|%s) [%s]",
			tostring(p3.ID),
			string.upper(p3.Domain),
			tostring(p3.Class),
			tostring(p3.Value),
			v2
		)
	end,
}
local u2 = { "Class", "ID", "Domain" }
function u1.__newindex(p4, p5, p6)
	if table.find(u2, p5) then
		return error(string.format("Attempt to change %s of effect", p5))
	end
	rawset(p4._props, p5, p6)
	if rawget(p4, "Shadow") then
		p4.Shadow:Fire(p5, p6)
	end
end
local l__HttpService__3 = GetService("HttpService")
local u4 = require(script.Parent.Signal)
function u1.new(p7, p8, p9, p10)
	local v3 = {}
	local v4 = p8.Domain
	if not v4 then
		if p9 then
			v4 = "Server"
		else
			v4 = "Client"
		end
	end
	v3.Domain = v4
	v3.ID = p8.ID or l__HttpService__3:GenerateGUID(false)
	v3.Class = p8.Class
	v3.Disabled = p8.Disabled and false
	v3.Value = p8.Value ~= nil and p8.Value or "???"
	v3.Parent = p7
	v3.Tags = p8.Tags or {}
	v3.DebrisTime = p10 and 0
	local v5 = setmetatable({
		_props = v3,
	}, u1)
	rawset(v5, "TagAdded", u4.new())
	rawset(v5, "TagRemoving", u4.new())
	return v5
end
function u1.ParseEffect(p11)
	return {
		Class = p11.Class,
		Disabled = p11.Disabled,
		Tags = p11.Tags,
		Domain = p11.Domain,
		ID = p11.ID,
		Value = p11.Value,
		DebrisTime = p11.DebrisTime,
	}
end
function u1.Debris(p12, p13)
	task.delay(p13, p12.Destroy, p12)
end
function u1.Connect(p14, p15)
	if not p14.Shadow then
		rawset(p14, "Shadow", u4.new())
	end
	p14.Shadow:Connect(p15)
end
u1.connect = u1.Connect
function u1.AddTag(p16, p17)
	p16.Tags[p17] = true
	p16.TagAdded:Fire(p17)
end
function u1.RemoveTag(p18, p19)
	p18.Tags[p19] = nil
	p18.TagRemoving:Fire(p19)
end
function u1.HasTag(p20, p21)
	return p20.Tags[p21] == true
end
function u1.Destroy(p22)
	if p22.Destroyed then
		return
	end
	p22.Destroyed = true
	if p22.Parent and p22.Parent.Effects then
		p22.Parent.Effects[p22.ID] = nil
		p22.Parent.EffectRemoving:Fire(p22)
	end
	p22.TagAdded:Destroy()
	p22.TagRemoving:Destroy()
	if p22.Shadow then
		p22.Shadow:Destroy()
		p22.Shadow = nil
	end
	p22.TagAdded = nil
	p22.TagRemoving = nil
	p22.Parent = nil
end
u1.Remove = u1.Destroy
return u1
