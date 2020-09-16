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
					draw_layer = 0, entity_name = "player", foot_x = 7, foot_y = 15, id = 12, level_name = "start", login = "mw", name = "mw", sprite = "player", x = 100, y = 20
				}
			}
		}
	}
			
]]--
local _lastState=nil

local _controlled_entity=nil

_.playerId=nil

local clear_prev_state_caches=function()
	_controlled_entity=nil
end





_.each_entity=function(process)
	local level = _lastState.level
	local containers=level.entities
	for entity_name,container in pairs(containers) do
		for k,entity in pairs(container) do
			process(entity)
		end
	end
end


local register_state_entities=function()
	_.each_entity(Entity.add)
end

_.set=function(state)
	if _lastState then
		--log("warn: state update not implemented")
		-- ок, пока что и не нужно.
	end
	
	
	_lastState=state
	
	log("state set. level:"..state.level.level_name)
	register_state_entities()
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
		if playerContainer==nil then
			local a=1
		else
			local a=1
		end
		
		
		
		local playerId=_.playerId
		for k, player in pairs(playerContainer) do
			if (player.id==playerId) then
				return player
			end
		end

		return nil
	end
end

local get_player=_.getPlayer



_.get_controlled_entity=function()
	if _controlled_entity~=nil then return _controlled_entity end
	
	local player=get_player()
	if player==nil then return nil end
	
	_controlled_entity=_deref(player.controlled_entity_ref)
	
	return _controlled_entity
end




_.findEntity=function(entityRef,onFound)
	assert(entityRef)
	
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