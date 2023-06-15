local DrawObject = {}

-- Requires
local Helper = require("../Modules/Helpers/Helper.lua")

function DrawObject:Update(Data)
	if not self.Drawing then
		return
	end

	-- Copy Data into Keys and Fields of Drawing
	Helper.LoopLuaTable(Data, function(Index, Object)
		self.Drawing[Index] = Object
	end)
end

function DrawObject:Remove()
	if not self.Drawing then
		return
	end

	self.Drawing:Remove()
end

function DrawObject:New(Type)
	-- Create Draw Object with data
	local DrawObjectData = {
		Drawing = Drawing.new(Type),
		Type = Type,
	}

	-- Set the metatable of the Draw object
	setmetatable(DrawObjectData, self)

	-- Set index back to itself
	self.__index = self

	-- Return back Draw object
	return DrawObjectData
end

return DrawObject
