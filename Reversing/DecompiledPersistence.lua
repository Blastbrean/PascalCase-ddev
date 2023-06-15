--[[
if not pcall_ret2 or tostring(pcall_ret2) ~= "{...}" and not string.match(tostring(pcall_ret2), "...") and not string.find(tostring(pcall_ret2), "{...}") then
	warn(pcall_ret2);
	return;
end
]]
-- This just checks if you patched out the anti-decompiler they have

local function env() -- Line: 38
	for index1 = 1, 9 do
		local bool1 = false
		local success, _ = pcall(function() -- Line: 41
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
			local v1 = t_GetService(t_game, "CoreGui")
			local u2 = t_GetService(t_game, "VirtualInputManager")
			local t_SendMouseButtonEvent = u2.SendMouseButtonEvent
			local _ = u2.SendKeyEvent
			local t_IsA = t_game.IsA
			local udim2 = UDim2.new(0, 0, 0, 0)
			local vec2 = Vector2.new(0, 0)
			v1:WaitForChild("RobloxGui").NotificationFrame.DescendantAdded:Connect(function(descendant) -- Line: 61
				--[[
					Upvalues:
						[1] = t_IsA
						[2] = udim2
						[3] = vec2
						[4] = t_SendMouseButtonEvent
						[5] = u2
				--]]
				if t_IsA(descendant, "TextButton") and descendant.Name == "Button1" then
					descendant.Transparency = 1
					descendant.Parent.Transparency = 1
					descendant.Parent.NotificationText.Transparency = 1
					descendant.Parent.NotificationTitle.Transparency = 1
					descendant.Parent.Position = udim2
					descendant.Parent.AnchorPoint = vec2
					descendant.Position = udim2
					t_SendMouseButtonEvent(u2, 0, 0, 0, true, game, 0)
					t_SendMouseButtonEvent(u2, 0, 0, 0, false, game, 0)
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
return function() -- Line: 88
	--[[
		Upvalues:
			[1] = env
	--]]
	if env() == false then
		while true do
		end
	else
		return "plum"
	end
end
