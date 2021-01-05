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

-- todo: separate iterable containers from magic

-- root container
-- level 1 v=entity_names by k=level_name
-- populated on load
local _root_container=nil

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




local is_magic_container=function(level_name)
	-- описаны в server\shared\lib\db\db.lua
	if level_name=="var" then
		return true 
	end
	
	if level_name=="level" then
		return true 
	end
	
	return false
end




local each_container=function(f)
	for level_name, entities in pairs(_root_container) do
		if not is_magic_container(level_name) then 
			log("processing container:"..level_name, "verbose")
			f(entities,level_name)
		end
	end
end

_.each_container=each_container

--local each_entity_in_container=function(c,f)
--	for k,v in pairs(c) do
--		nop()
--	end
	
--end

local self_test=function()
	local dump_to_log=function()
		
	end
	
--	local same_table_ref={"same_table_ref",1,42}
--	_.set_var("test_ref_1", same_table_ref)
--	_.set_var("test_ref_2", same_table_ref)
--	_.set_var("test_ref_3", nil)
	
	
end


_.self_test=self_test


-- 
local each_entity=function(f)
	each_container(function(entities,level_name)
			for k,entity_container in pairs(entities) do
				if type(entity_container)=="number" then
					log("error:wrong type")
				end
				
				for k2,entity in pairs(entity_container) do
					nop()
					f(entity)
				end
			end
		end
	)
end

_.each_entity=each_entity


_.each_entity_on_level=function(level_name,f)
	local level_container=_root_container[level_name]
	for entity_name,entity_container in pairs(level_container) do
		for k,entity in pairs(entity_container) do
			f(entity)
		end
	end
end


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
--		if _root_container==nil or level_name==nil then
--		end
		
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

_.get_level=function(name)
	return _root_container.level[name]
end

_.set_level=function(name,level)
	-- extract name from level?
	_root_container.level[name]=level
end

-- put entity into level
-- level_name optional
_.add=function(entity, level_name)
	assert(entity)
	
--	if level_name=="player" then
--		log("adding to player level:".._ets(entity))
--	end
	
	
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
		-- todo: fix this warn (on logoff)
		--log("warn: trying to delete entity that is not present:"..entityId)
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
	result.level={} -- metainfo about levels
	
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
	
	self_test()
end


_.get_any=function(entity_name, level_name)
	if not level_name then level_name="start" end
	local level_container=getLevelContainer(level_name)
	local entity_container=getEntityContainer(level_container, entity_name)
	local index,first_entity=next(entity_container)
	return first_entity
 
	
end

return _