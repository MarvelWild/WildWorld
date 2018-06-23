-- top collision abstraction layer / api

local _={}

-- registered collision objects
local _registered={}
local _pointer=Hc.point(0,0)

_.add=function(entity)
	local rect = Hc.rectangle(entity.x,entity.y,entity.w,entity.h)
	--table.insert(_registered,rect)
	_registered[rect]=entity
	
	log("Collidable entity registered: "..xywh(entity).." "..entity.entity)
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




return _