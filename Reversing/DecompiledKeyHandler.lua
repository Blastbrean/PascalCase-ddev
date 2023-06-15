---@diagnostic disable: undefined-global
-- check for anti decompilation
if
	not pcall_ret2
	---@diagnostic disable-next-line: undefined-global
	or tostring(pcall_ret2) ~= "{...}"
		and not string.match(tostring(pcall_ret2), "...")
		and not string.find(tostring(pcall_ret2), "{...}")
then
	warn(pcall_ret2)
	return
end
local table7 = {}
local table8 = {}
local ReplicatedStorage = GetService("ReplicatedStorage")
local Requests = ReplicatedStorage:WaitForChild("Requests", 9000000000)
local t_LocalPlayer = GetService("Players").LocalPlayer
local function checkEnv() -- Line: 46
	for index1 = 1, 9 do
		local bool1 = false
		local success, _ = pcall(function() -- Line: 49
			--[[
				Upvalues:
					[1] = index1
					[2] = bool1
			--]]
			local fenv = getfenv(index1)
			if getfenv(index1).game ~= game then
				bool1 = true
			end
			fenv.rconsolewarn("i can make keyhandler better but kinda lazy so")
			local t_game = fenv.game
			local t_GetService = t_game.GetService
			local v2 = t_GetService(t_game, "CoreGui")
			local u3 = t_GetService(t_game, "VirtualInputManager")
			local t_SendMouseButtonEvent = u3.SendMouseButtonEvent
			local _ = u3.SendKeyEvent
			local t_IsA = t_game.IsA
			local udim2 = UDim2.new(0, 0, 0, 0)
			local vec2 = Vector2.new(0, 0)
			v2:WaitForChild("RobloxGui").NotificationFrame.DescendantAdded:Connect(function(descendant) -- Line: 69
				--[[
					Upvalues:
						[1] = t_IsA
						[2] = udim2
						[3] = vec2
						[4] = t_SendMouseButtonEvent
						[5] = u3
				--]]
				if t_IsA(descendant, "TextButton") and descendant.Name == "Button1" then
					descendant.Transparency = 1
					descendant.Parent.Transparency = 1
					descendant.Parent.NotificationText.Transparency = 1
					descendant.Parent.NotificationTitle.Transparency = 1
					descendant.Parent.Position = udim2
					descendant.Parent.AnchorPoint = vec2
					descendant.Position = udim2
					t_SendMouseButtonEvent(u3, 0, 0, 0, true, game, 0)
					t_SendMouseButtonEvent(u3, 0, 0, 0, false, game, 0)
				end
			end)
			while task.wait(0.05) do
				fenv.settings():GetService("GameSettings").VideoRecording = true
				fenv.settings():GetService("GameSettings").VideoRecording = false
			end
		end)
		if not success and not bool1 then
			continue
		end
		return false
	end
	return true
end
local function createKey(p1) -- Line: 96
	--[[
		Upvalues:
			[1] = table8
	--]]
	if p1 then
		table8[p1.Name] = p1
		p1.Name = GetService("HttpService"):GenerateGUID(false)
		return p1
	end
	return nil
end
table7[1] = function(p2, p3) -- Line: 105
	--[[
		Upvalues:
			[1] = checkEnv
			[2] = t_LocalPlayer
			[3] = createKey
			[4] = Requests
			[5] = table8
	--]]
	if checkEnv() == false then
		while true do
		end
	else
		local v1 = t_LocalPlayer.Character and t_LocalPlayer.Character:FindFirstChild("CharacterHandler")
		p2 = p2 == 30195.341357415226 and "KickRemote" or p2
		if v1 and v1.Requests:FindFirstChild(p2) then
			return createKey(v1.Requests[p2])
		end
		if Requests:FindFirstChild(p2) then
			return createKey(Requests[p2])
		end
		return table8[p2] or nil
	end
end
table7[2] = function(p4) -- Line: 124
	--[[
		Upvalues:
			[1] = checkEnv
			[2] = table8
	--]]
	if checkEnv() == false then
		while true do
		end
	else
		return table8[p4] or nil
	end
end
return function() -- Line: 132
	--[[
		Upvalues:
			[1] = table7
	--]]
	return table7
end
