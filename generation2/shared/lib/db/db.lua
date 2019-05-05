-- global Db
-- stores entities
local _={}

local _container={}

local _saveName="db"

_.getEntityContainer=function(entityName)
	local entityContainer=_container[entityName]
	if entityContainer==nil then
		entityContainer={}
		_container[entityName]=entityContainer
	end
	return entityContainer
end


_.add=function(entity)
	assert(entity)
	local entityName=entity.entityName
	
	local entityContainer=_.getEntityContainer(entityName)
	-- table.insert(entityContainer, entity)
	local entityId=entity.id
	assert(entityContainer[entityId]==nil)
	entityContainer[entityId]=entity
end




_.save=function()
	log('db save')
	
	local serialized=Pow.serialize(_container)
	love.filesystem.write(_saveName, serialized)
end

_.load=function()
	log('db load')
	
	local serialized=love.filesystem.read(_saveName)
	
	if serialized~=nil then
		_container=Pow.deserialize(serialized)
	else
		_container={}
	end
end


-- reverse: BaseEntity.getReference
_.getByRef=function(ref)
	local entityName=ref.entityName
	local entityId=ref.id
	local entityContainer=_.getEntityContainer(entityName)
	return entityContainer[entityId]
end




return _