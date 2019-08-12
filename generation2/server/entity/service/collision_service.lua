-- цель - коллизии по уровням

local _entityName='CollisionService'
local _=BaseEntity.new(_entityName, true)


local _levelCollisions={}

local getLevelCollisions=function(levelName)
	local result=_levelCollisions[levelName]
	if result=nil then
		result=Pow.newCollision()
		_levelCollisions[levelName]=result
	end
	
	return result
end


_.addEntity=function(entity)
	local levelName=entity.levelName
	
	if levelName==nil then
		log('error: adding entity with no levelName to collision system')
		return
	end
	
	local collision=getLevelCollisions(levelName)
	collision.add(entity)
end


return _