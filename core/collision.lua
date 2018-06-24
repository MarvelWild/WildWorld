-- top collision abstraction layer / api

local _={}

-- registered collision objects
local _registered={}
local _registeredReverse={}
local _pointer=Hc.point(0,0)

local _debugShape=nil

_.add=function(entity)
	local rect = Hc.rectangle(entity.x,entity.y,entity.w,entity.h)
	--table.insert(_registered,rect)
	_registered[rect]=entity
	_registeredReverse[entity]=rect
	
	--log("Collidable entity registered: "..xywh(entity).." "..entity.entity)
end

_.moved=function(entity)
	--log("Collision moved:"..Entity.toString(entity))
	local movedRect=_registeredReverse[entity]
	
	-- bug: still not working
	movedRect:moveTo(Entity.getCenter(entity))
	
	-- _debugShape=movedRect
end


_.getAtPoint=function(x,y)
	
	local result={}
	
	_pointer:moveTo(x,y)
	local collisions = Hc.collisions(_pointer)
	for k,v in pairs(collisions) do
		-- log("collision k:"..pack(k).." v:"..pack(v))
		local entity=_registered[k]
		table.insert(result,entity)
	end

	return result
end

_.draw=function()
	if _debugShape then
		_debugShape:draw('line')
	end
	
end




return _