-- glob Collision
-- top collision abstraction layer / api
-- HC lib beneath
-- todo: debug mode (draw collision shapes)

local _={}

local _log=function(message)
	log(message,"collision")
end


-- registered collision objects

--entity by shape
local _shapeByEntity={}
--shape by entity
local _entityByShape={}
local _pointer=Hc.point(0,0)

local pointerEntity=Pointer.new()
_shapeByEntity[pointerEntity]=_pointer
_entityByShape[_pointer]=pointerEntity

-- highlighted in draw
local _debugShape=nil

_.add=function(entity)
--	if entity.entity~="Player" then
--		local a=1
--	end
	
	
	_log("Collision.add:"..Entity.toString(entity))
--	_log(debug.traceback()) -- search key: stack traceback:
	
	
	if _.isRegistered(entity) then
		_log("error: entity already registered in collision system:"..Inspect(entity))
		return
	end
	
	local shape = Hc.rectangle(entity.x,entity.y,entity.w,entity.h)
	_shapeByEntity[entity]=shape
	_entityByShape[shape]=entity 
	
	--_log("Collidable entity registered: "..Entity.toString(entity))
end

_.isRegistered=function(entity)
	if _shapeByEntity[entity] then
		return true
	end
	
	return false
end



_.remove=function(entity)
	_log("collision.remove:"..Entity.toString(entity))
	local shape=_shapeByEntity[entity]
	if not shape then
		_log("warn: entity wasnt in collision system:"..Entity.toString(entity))
		return
	end
	
	_shapeByEntity[entity]=nil
	_entityByShape[shape]=nil
	Hc.remove(shape)
end


_.moved=function(entity)
--	log("Collision moved:"..Entity.toString(entity))
	local movedRect=_shapeByEntity[entity]
	
	-- bug: still not working
	if movedRect~=nil then
		movedRect:moveTo(Entity.getCenter(entity))
	else
		-- Pantera. Its ok for now
		-- также сюда приходим при использовании котла
		log("entity has no collision:"..entity.entity)
	end
	
	
	-- _debugShape=movedRect
end


_.getAtPoint=function(x,y)
	
	local result={}
	
	_pointer:moveTo(x,y)
	_log("_pointer moved:"..xy(x,y))
	local collisions = Hc.collisions(_pointer)
	for shape,v in pairs(collisions) do
		-- _log("collision k:"..pack(k).." v:"..pack(v))
		local entity=_entityByShape[shape]
		table.insert(result,entity)
	end

	return result
end

-- option to exclude self?

-- returns nil or table with entities
_.getAtRect=function(x,y,w,h)
	log("Collision.getAtRect:"..xywh(x,y,w,h))
	local rect=Hc.rectangle(x,y,w,h)
	
	-- Get sh apes that are colliding with shape and the vector to separate the shapes
	-- see http://hc.readthedocs.io/en/latest/MainModule.html
	local collisions=Hc.collisions(rect)
	
	Hc.remove(rect)
	
	local result=nil
	for shape,v in pairs(collisions) do
--		log("collision:".._.shapeToString(shape).. " v:"..Inspect(v))
		
		local entity=_entityByShape[shape]
--		if entity==nil then
--			local test1=_pointer==shape
			
--			local a
--		end
		
		assert(entity, "entity not registered in _entityByShape. shape:"..pack(shape))
		
		if result==nil then result={} end
		table.insert(result,entity)
	end
	
	_log("Collision.getAtRect. Count:"..#result)
	return result
end


_.draw=function()
	if _debugShape then
		_debugShape:draw('line')
	end
	
end

_.shapeToString=function(shape)
--	return Inspect(shape)
	
	local centroid=shape._polygon.centroid
	return "shape:"..xy(centroid.x,centroid.y)
end





return _