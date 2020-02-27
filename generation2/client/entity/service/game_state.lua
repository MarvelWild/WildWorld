-- client game state
-- global GameState

local _={}

_.level=nil

-- заполняется в client_service onStateReceived

-- структура:
--[[ 
{
	level = 
	{
		bg = "main",
		entities = 
		{
			player = 
			{
				[12] = 
				{
					drawLayer = 0, entity_name = "player", footX = 7, footY = 15, id = 12, level_name = "start", login = "mw", name = "mw", sprite = "player", x = 100, y = 20
				}
			}
		}
	}
			
]]--
local _lastState=nil

-- свой ид
_.playerId=nil

_.set=function(state)
	_lastState=state
	
	log("state set. level:"..state.level.level_name)
end

_.get=function()
	return _lastState
end



_.getPlayer=function()
	if _lastState~=nil then
		--todo optimize, cache
		local level=_lastState.level
		local entities=level.entities
		local playerContainer=entities['player']
		local playerId=_.playerId
		for k, player in pairs(playerContainer) do
			if (player.id==playerId) then
				return player
			end
		end

		return nil
	end
end


-- onFound создавался для возможности удалить, понимается плохо, порефакторить
_.findEntity=function(entityRef,onFound)
	if _lastState==nil then return nil end
	
-- prev  code
--	local player=_.getPlayer()
	
--	local playerRef=BaseEntity.getReference(player)
--	if BaseEntity.referenceEquals(playerRef, entityRef) then
--		return player
--	end
	local entityContainers=_lastState.level.entities
	local entities=entityContainers[entityRef.entity_name]
	if entities==nil then return nil end
	
	for k,entity in pairs(entities) do
		if BaseEntity.isReferencedBy(entity,entityRef) then
			if onFound~=nil then
				onFound(k,entity,entities)
			end
			
			
			return entity
		end
	end
	
	return nil
end

local deleteOnFound=function(k,entity,entities)
	entities[k]=nil
end


-- todo: часть функционала пересекается с db, обдумать.
-- ну и пусть, всё таки бд- сервер сайд, а тут клиент
_.removeEntity=function(entityRef)
	local entity=_.findEntity(entityRef,deleteOnFound)
	if entity==nil then 
		log("warn: trying remove entity that not exists:"..BaseEntity.refToSting(entityRef))
		return 
	end
	
	Entity.remove(entity)
end

local getEntityContainer=function(entity_name)
	if _lastState==nil then return nil end
	local entityContainers=_lastState.level.entities
	local container=entityContainers[entity_name]
	if container==nil then
		container={}
		entityContainers[entity_name]=container
	end
	
	return container
end


-- adds into world too
_.addEntity=function(entity)
	local entity_name=entity.entity_name
	local container=getEntityContainer(entity_name)
	if container==nil then return nil end
	
	table.insert(container,entity)
	Entity.add(entity)
end


local is_ignored_update_prop=function(name)
	if name=="x" or name=="y" then return true end
	return false
end


local do_update_entity=function(remote,local_entity)
	for key,value in pairs(remote) do
		if not is_ignored_update_prop(key) then
			local prev_value=local_entity[key]

			if prev_value~=value then
--				log("value "..key.." changed from "..tostring(prev_value).." to "..tostring(value).." ent_rem:".._ets(remote))
				local_entity[key]=value
			end
		end
	end
end

	

-- how to handle?
-- copy props? ok try this.

-- entity comes from server, and state may have local
_.update_entity=function(entity)
	local ref=_ref(entity)
	local local_entity=_.findEntity(ref)
	if local_entity==nil then
		_.addEntity(entity)
	else
		do_update_entity(entity,local_entity)
	end
end


return _