-- top collision abstraction layer / api

local _={}

-- registered collision objects

--entity by shape
local _shapeByEntity={}
--shape by entity
local _entityByShape={}
local _pointer=Hc.point(0,0)

local pointerFakeEntity={name="pointer"}
_shapeByEntity[pointerFakeEntity]=_pointer
_entityByShape[_pointer]=pointerFakeEntity

-- highlighted in draw
local _debugShape=nil

_.add=function(entity)
	if _shapeByEntity[entity] then
		log("error: entity already registered:"..Inspect(entity))
		return
	end
	
	local shape = Hc.rectangle(entity.x,entity.y,entity.w,entity.h)
	_shapeByEntity[entity]=shape
	_entityByShape[shape]=entity
	
	--log("Collidable entity registered: "..xywh(entity).." "..entity.entity)
	log("Collidable entity registered: "..Entity.toString(entity))
end

_.moved=function(entity)
--	log("Collision moved:"..Entity.toString(entity))
	local movedRect=_shapeByEntity[entity]
	
	-- bug: still not working
	movedRect:moveTo(Entity.getCenter(entity))
	
	-- _debugShape=movedRect
end


_.getAtPoint=function(x,y)
	
	local result={}
	
	_pointer:moveTo(x,y)
	log("_pointer moved:"..xy(x,y))
	local collisions = Hc.collisions(_pointer)
	for shape,v in pairs(collisions) do
		-- log("collision k:"..pack(k).." v:"..pack(v))
		local entity=_entityByShape[shape]
		table.insert(result,entity)
	end

	return result
end

-- returns nil or table with entities
_.getAtRect=function(x,y,w,h)
	log("Collision.getAtRect")
	
	local rect=Hc.rectangle(x,y,w,h)
	
	-- Get shapes that are colliding with shape and the vector to separate the shapes
	-- see http://hc.readthedocs.io/en/latest/MainModule.html
	local collisions=Hc.collisions(rect)
	
	Hc.remove(rect)
	
	local result=nil
	for shape,v in pairs(collisions) do
		log("collision:"..Inspect(shape).. " v:"..Inspect(v))
		
		local entity=_entityByShape[shape]
		if entity==nil then
			local test1=_pointer==shape
			
			local a
		end
		
		assert(entity)
		
		if result==nil then result={} end
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