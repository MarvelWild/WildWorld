-- todo: make it part of pow
-- цель - коллизии по уровням,
-- следующий уровень абстракции: collision (одноуровневая модель)

local _entityName='CollisionService'
local _=BaseEntity.new(_entityName, true)


local _levelCollisions={}

-- returns instance of shared\lib\powlov\module\collision.lua
local getLevelCollisions=function(levelName)
	local result=_levelCollisions[levelName]
	if result==nil then
		result=Pow.newCollision()
		_levelCollisions[levelName]=result
	end
	
	return result
end

---- unfinished - we can paint it later
--_.getCollisionShapes=function(levelName)
--	local collisions=getLevelCollisions(levelName)
--	local result={}
	
--	collisions.getShapes()
	
--	return result
--end



_.addEntity=function(entity)
	if entity==nil then 
		log("warn: adding null entity") 
		return
	end
	
	if entity.isService then
		return
	end
	
	
	
	local levelName=entity.levelName
	
	if levelName==nil then
		log('error: adding entity with no levelName to collision system')
		return
	end
	
	local collision=getLevelCollisions(levelName)
	collision.add(entity)
end

_.removeEntity=function(entity)
		local levelName=entity.levelName
	
	if levelName==nil then
		log('error: removing entity with no levelName from collision system')
		return
	end
	
	local collision=getLevelCollisions(levelName)
	collision.remove(entity)
end

_.onEntityMoved=function(entity)
	-- wip
		
	local levelName=entity.levelName
	
	if levelName==nil then
		log('error: moving entity with no levelName into collision system')
		return
	end
	
	local collision=getLevelCollisions(levelName)
	collision.moved(entity)
end

return _
