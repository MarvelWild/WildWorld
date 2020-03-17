--[[
global Db
stores-persists entities
format: 
local entitiesContainer=_levelContainer[level_name]
local entityContainer=entitiesContainer[entity_name]
local entity=entityContainer[entityId]

server only. todo: make it not exist on client


magic levels:
service - 
player - logged off players
var - table for persisting single vars
]]--

local _={}


-- root container
-- level 1 entity names by level name
local _root_container={}

local _saveName="db"


local _saveDir=""

-- external hook to notify clients from server
-- server service sends entity_added to level
_.onAdded=nil
local _onRemoved=nil

_.setOnRemoved=function(hook)
	assert(_onRemoved==nil)
	_onRemoved=hook
end



_.init=function(saveDir)
	_saveDir=saveDir
end

-- creates empty
-- 
local getEntityContainer=function(levelContainer, entity_name)
	local result = levelContainer[entity_name]
	if result==nil then
		result={}
		levelContainer[entity_name]=result
	end
	return result
end


-- key=entity_name val={id=entity}
local getLevelContainer=function(level_name)
	local result = _root_container[level_name]
	if result==nil then 
		result={}
		if _root_container==nil or level_name==nil then
			local a=1
		end
		
		_root_container[level_name]=result
	end
	
	return result
end


_.set_var=function(name,value)
	_root_container.var[name]=value
end

_.get_var=function(name)
	return _root_container.var[name]
end



-- put entity into level
-- level_name optional
_.add=function(entity, level_name)
	assert(entity)
	
	if level_name==nil then
		level_name=entity.level_name
		assert(level_name)
	else

		if level_name~="player" then
			entity.level_name=level_name
		end
		
	end
	
	local levelContainer=getLevelContainer(level_name)
	
	local entity_name=entity.entity_name
	
	local entityContainer=getEntityContainer(levelContainer,entity_name)
	-- table.insert(entityContainer, entity)
	local entityId=entity.id
	assert(entityContainer[entityId]==nil)
	entityContainer[entityId]=entity
	
	if Level.isActive(level_name) then
		-- todo: preevent double add
		Entity.add(entity)
	end
	
	
	if _.onAdded~=nil then
		_.onAdded(entity, level_name)
	end
	
end

-- remove entity from level
_.remove=function(entity,level_name)
	if level_name==nil then
		level_name=entity.level_name
		assert(level_name)
	end
	
	local levelContainer=getLevelContainer(level_name)
	
	local entity_name=entity.entity_name
	
	local entityContainer=getEntityContainer(levelContainer,entity_name)
	-- table.insert(entityContainer, entity)
	local entityId=entity.id
	if (entityContainer[entityId]==nil) then
		log("warn: trying to delete entity that is not present")
	end
	
	entityContainer[entityId]=nil
	
	if Level.isActive(level_name) then
		Entity.remove(entity)
	end
	
	if _onRemoved~=nil then
		-- sends entity_removed notification
		_onRemoved(entity, level_name)
	end
end

local get=function(level_name,entity_name, entityId)
	local levelContainer=getLevelContainer(level_name)
	local entityContainer=getEntityContainer(levelContainer, entity_name)
	local result = entityContainer[entityId]
	return result
end

local getByRef=function(ref, level_name)
	if level_name==nil then 
		level_name=ref.level_name 
	end
	return get(level_name, ref.entity_name, ref.id)
end

_.get=get
_.getByRef=getByRef
_.getLevelContainer=getLevelContainer
_.getEntityContainer=getEntityContainer

_.save=function()
	log('db save')
	
	local serialized=Pow.serialize(_root_container)
	love.filesystem.write(_saveDir.._saveName, serialized)
end

local new_root_container=function()
	local result={}
	
	-- magic levels
	result.var={}
	result.service={}
	result.player={}
	
	return result
end



_.load=function()
	log('db load', "db")
	
	local serialized=love.filesystem.read(_saveDir.._saveName)
	
	if serialized~=nil then
		_root_container=Pow.deserialize(serialized)
	else
		_root_container=new_root_container()
	end
end

return _