-- global CollisionService
-- todo: make it part of pow
-- цель - коллизии по уровням,
-- следующий уровень абстракции: collision (одноуровневая модель)

local _entity_name='CollisionService'
local _=BaseEntity.new(_entity_name, true)


-- key: level name
-- val: collision \server\shared\lib\powlov\module\collision.lua
local _levelCollisions={}

-- returns instance of shared\lib\powlov\module\collision.lua
local getLevelCollisions=function(level_name)
	local result=_levelCollisions[level_name]
	if result==nil then
		log("created collision level:"..level_name, "verbose")
		result=Pow.newCollision()
		_levelCollisions[level_name]=result
	end
	
	return result
end

---- unfinished - we can paint it later
--_.getCollisionShapes=function(level_name)
--	local collisions=getLevelCollisions(level_name)
--	local result={}
	
--	collisions.getShapes()
	
--	return result
--end


-- коллиизии с сущностью
-- returns array of entity - who collides with entity shape
_.getEntityCollisions=function(entity)
	local level_name=entity.level_name
	local levelCollisions=getLevelCollisions(level_name)
	local entityCollisions=levelCollisions.getAtEntity(entity)
	return entityCollisions
end

-- get_at_point

-- вокруг сущности + прямоугольника с отступами margin от всех сторон
-- что есть?
_.get_around=function(entity, margin)
	if not margin then margin=100 end
	local x=entity.x-margin
	local w=entity.w+margin+margin
	local y=entity.y-margin
	local h=entity.h+margin+margin
	
	local level_name=entity.level_name

	local result=_.get_in_rect(x,y,w,h,level_name)
	-- todo exclude self
	
	return result
end

-- по умолчанию не отдаёт сервисные сущности. по необходимости добавить опцию
_.get_in_rect=function(x,y,w,h,level_name)
	-- see shared\lib\powlov\module\collision.lua
	local level_collisions=getLevelCollisions(level_name)
	
	-- level_collisions instance of shared\lib\powlov\module\collision.lua
	local all_collisions=level_collisions.getAtRect(x,y,w,h)
	
	local result_filtered={}
	for k,collision in pairs(all_collisions) do
		if not collision.is_service then
			table.insert(result_filtered, collision)
		end
	end
	
	return result_filtered
end



_.addEntity=function(entity)
	if entity==nil then 
		log("warn: adding null entity") 
		return
	end
	
	if entity.is_service then
		return
	end
	
	
	

	local level_name=entity.level_name
	
	if level_name==nil then
		log('error: adding entity with no level_name to collision system')
		return
	end
	
	local collision=getLevelCollisions(level_name)
	collision.add(entity)
	
	local log_message="collision entity added:".._ets(entity)
	log(log_message, "collision")
end



_.removeEntity=function(entity)
		local level_name=entity.level_name
	
	if level_name==nil then
		log('error: removing entity with no level_name from collision system')
		return
	end
	
	local collision=getLevelCollisions(level_name)
	collision.remove(entity)
	log("collision entity removed:".._ets(entity),"collision")
end

_.onEntityMoved=function(entity)
	local level_name=entity.level_name
	
	if level_name==nil then
		log('error: moving entity with no level_name into collision system')
		return
	end
	
	local collision=getLevelCollisions(level_name)
	collision.moved(entity)
	log("collision.moved:".._ets(entity),"collision")
end


_.log_state=function()
	local level_collision_system=_levelCollisions["start"]
	level_collision_system.debug_print()
	
end

return _
