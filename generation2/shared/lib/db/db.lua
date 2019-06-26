--[[
global Db
stores entities
format: 
local entitiesContainer=_levelContainer[levelName]
local entityContainer=entitiesContainer[entityName]
local entity=entityContainer[entityId]

]]--

local _={}


-- level 1 entity names by level name
local _levelContainers={}

local _saveName="db"


-- creates empty
local getEntityContainer=function(levelContainer, entityName)
	local result = levelContainer[entityName]
	if result==nil then
		result={}
		levelContainer[entityName]=result
	end
	return result
end


-- key=entityName val={id=entity}
local getLevelContainer=function(levelName)
	local result = _levelContainers[levelName]
	if result==nil then 
		result={}
		_levelContainers[levelName]=result
	end
	
	return result
end

local getLevelName=function(entity)
	-- это только для игрока, остальные сущности сразу должны помещаться в контейнер, который определяет уровень
	local result=entity.levelName
	
	if result==nil then
		log("error: cannot determine level for entity:"..serialize(entity))
	end
	
	return result
end


_.add=function(entity, levelName)
	assert(entity)
	
	if levelName==nil then
		levelName=getLevelName(entity)
		assert(levelName)
	end
	
	local levelContainer=getLevelContainer(levelName)
	
	local entityName=entity.entityName
	
	local entityContainer=getEntityContainer(levelContainer,entityName)
	-- table.insert(entityContainer, entity)
	local entityId=entity.id
	assert(entityContainer[entityId]==nil)
	entityContainer[entityId]=entity
end




local get=function(levelName,entityName, entityId)
	local levelContainer=getLevelContainer(levelName)
	local entityContainer=getEntityContainer(levelContainer, entityName)
	local result = entityContainer[entityId]
	return result
end

local getByRef=function(ref, levelName)
	return get(levelName, ref.entityName, ref.id)
end

_.get=get
_.getByRef=getByRef
_.getLevelContainer=getLevelContainer
_.getEntityContainer=getEntityContainer

_.save=function()
	log('db save')
	
	local serialized=Pow.serialize(_container)
	love.filesystem.write(_saveName, serialized)
end

_.load=function()
	log('db load', "db")
	
	local serialized=love.filesystem.read(_saveName)
	
	if serialized~=nil then
		_container=Pow.deserialize(serialized)
	else
		_container={}
	end
end

return _