local Draw = { Objects = {} }

-- Requires
local DrawObject = require("Modules/Drawing/DrawObject")
local Helper = require("Modules/Helpers/Helper")

function Draw:NewObject(Type)
	-- Create a new drawing object with type.
	local DrawingObject = DrawObject:New(Type)

	-- Insert into table, the drawing object.
	table.insert(self.Objects, DrawingObject)

	-- Return drawing object
	return DrawingObject
end

function Draw:Clear()
	Helper.LoopLuaTable(self.Objects, function(Index, Object)
		Object:Remove()
	end)
end

return Draw
