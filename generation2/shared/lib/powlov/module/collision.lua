-- todo: collision world for levels

-- todo: multiple instances for levels
-- glob Collision
-- top collision abstraction layer / api
-- HC lib beneath

-- note use _log inside this module

local _={}

local _hc=nil
local _pow=nil
local _pointer=nil

--entity by shape
local _shapeByEntity={}
--shape by entity
local _entityByShape={}

local _log=function(message)
	log(message,"collision")
end

_log("collision init: _entityByShape mem:"..get_mem_addr(_entityByShape))

_.init=function(pow)
	_pow=pow
	_hc=pow.hc.new()
	_pointer=_hc:point(0,0)
	
	--это точка для поиска её коллизий в функциях точечных коллизий
	local pointerEntity=Pow.pointer.new()
	_shapeByEntity[pointerEntity]=_pointer
	_entityByShape[_pointer]=pointerEntity
end




-- registered collision objects

-- highlighted in draw
local _debugShape=nil



-- фигура коллизии это не спрайт, а отдельное описание.
_.getEntityShape=function(entity)
	local x,y,w,h=Entity.getCollisionBox(entity)
	local shape = _hc:rectangle(x,y,w,h)
	return shape
end



_.add=function(entity)
	if entity.entity_name=="player" then
		local a=1
	end
	
	
	_log("Collision.add:"..Entity.toString(entity))
--	_log(debug.traceback()) -- search key: stack traceback:
	
	
	if _.isRegistered(entity) then
		_log("error: entity already registered in collision system:"..Inspect(entity))
		return
	end
	
	local shape = _.getEntityShape(entity)
	if shape==nil then 
		_log("entity has no shape:"..Entity.toString(entity))
		return 
	end
	
	_shapeByEntity[entity]=shape
	_entityByShape[shape]=entity 
	
	--log("_entityByShape loc:"..get_mem_addr(_entityByShape))
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
	_hc:remove(shape)
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
		-- чтобы добавить коллизию - нужно чтобы было в _shapeByEntity -> Collision.add
		_log("entity has no collision:"..entity.entity_name)
	end
	-- _debugShape=movedRect
end


_.getAtPoint=function(x,y)
	
	local result={}
	
	_pointer:moveTo(x,y)
	_log("_pointer moved:"..xy(x,y))
	local collisions = _hc:collisions(_pointer)
	for shape,v in pairs(collisions) do
		-- _log("collision k:"..pack(k).." v:"..pack(v))
		local entity=_entityByShape[shape]
		table.insert(result,entity)
	end

	return result
end

-- returns nil or table with entities
_.getAtRect=function(x,y,w,h)
	_log("Collision.getAtRect:"..xywh(x,y,w,h))
	
	-- todo: хранить его как и pointer
	local rect=_hc:rectangle(x,y,w,h)
	
	-- Get shapes that are colliding with shape and the vector to separate the shapes
	-- see http://hc.readthedocs.io/en/latest/MainModule.html
	local collisions=_hc:collisions(rect)
	
	_hc:remove(rect)
	
	local result=nil
	
	-- todo: what is v?
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



-- returns array of entity or nil
_.getAtEntity=function(entity)
--	local x,y,w,h=Entity.getCollisionBox(entity)
--	return _.getAtRect(x,y,w,h)
	local shape=_.getEntityShape(entity)
	local collisions=_hc:collisions(shape)
	
	local result=nil
	local result_count=0
	for shape,v in pairs(collisions) do
		local collisionEntity=_entityByShape[shape]
		if collisionEntity==nil then
			local a=1
			_log("error:collisionEntity is nil")
			_.debug_print()
			--assert(collisionEntity)
		end
		
		if not Entity.equals(collisionEntity, entity) then 
			if result==nil then result={} end
			table.insert(result,collisionEntity)
			result_count=result_count+1
		end
	end
	
	_log("Collision.getAtEntity. Count:"..result_count.." entity:".._ets(entity))
	if result~=nil then
		for k,collision in pairs(result) do
			_log("getAtEntity collision:".._ets(collision))
		end
	end
	
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





_.debug_print=function()
	_log("collisions debug_print start")
	_log("ebs mem:"..get_mem_addr(_entityByShape))
	for shape,entity in pairs(_entityByShape) do
		_log("entity:".._ets(entity)..' shape:'..Pow.inspect(shape))
	end
	
	
	_log("collisions debug_print end")
end

return _