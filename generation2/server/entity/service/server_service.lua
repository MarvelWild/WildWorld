-- game specific server code


local _entity_name='ServerService'
local _=BaseEntity.new(_entity_name, true)

_.is_service=true

local _server=Pow.server
local _event=Pow.net.event
local _serverUpdate=_server.update
local _serverLateUpdate=_server.lateUpdate


local _updated_entities={}

local send_updated_entities=function()
	for entity,t in pairs(_updated_entities) do
		local event=Event.new("entity_updated")
		event.entity=entity
		event.target="level"
		event.level=entity.level_name
		event.do_not_process_on_server=true
		Event.process(event)
	end
	
	_updated_entities={}
end

-- защищена от двойного добавления
-- notify server should send updated entity 
_.entity_updated=function(entity)
	_updated_entities[entity]=true
end

-- handler to create_player command
local createPlayer=function(event)
	local playerName=event.player_name
	local login=event.login
	
	log('creating player:'..playerName..' login:'..login,'verbose')
	
	local player=Player.new()
	player.name=playerName
	player.login=login
	
	Db.add(player, "player")
	
	local responseEvent=_event.new("create_player_response")
	responseEvent.player=player
	
	responseEvent.target="login"
	responseEvent.targetLogin=login
	
	_event.process(responseEvent)
	
--	log('new event: create_player_response')
	
end

local getLevelEntities=function(level_name)
	local levelContainer=Db.getLevelContainer(level_name)
	return levelContainer
end


local getLevelState=function(level_name)
	log("getLevelState:"..level_name, "verbose")
	
	local state={}
	
	local level=Level.get_level(level_name)
	state.level_name=level_name
	state.level=level
	state.entities=getLevelEntities(level_name)
	return state
end


-- player has been created by createPlayer, present in Db
local getPlayerState=function(player_id)
	local player=Player.getById(player_id)
	if not player then
		local a=1
		assert(player)
	end
	
	-- todo: do not return everything server knows about player
	return player
end



local getFullState=function(playerId)
  local player=getPlayerState(playerId)
	local levelState=getLevelState(player.level_name)
	local result={}
	result.level=levelState
	result.player=player
	return result
end


_.sendFullState=function(player)
	local playerId=player.id
	local login=player.login
	
	if not login then
		log("error: player without login")
	end
	
	local fullState=getFullState(playerId)
	
	local responseEvent=_event.new("full_state")
	responseEvent.target="login"
	responseEvent.targetLogin=login
	responseEvent.state=fullState
	_event.process(responseEvent)
end


local put_player_into_world=function(player, level_name)
	local controlled_entity_ref=player.controlled_entity_ref
	if controlled_entity_ref==nil then
		
		-- todo: try others
		local controlled_entity=Humanoid.new()
		
		-- todo: start coord
		controlled_entity.x=100
		controlled_entity.y=20
		
		controlled_entity_ref=_ref(controlled_entity)
		player.controlled_entity_ref=controlled_entity_ref
		Db.add(controlled_entity,level_name)
		
	else
--		log("experimental: reattach player") -- manual test success
		player.controlled_entity_ref=controlled_entity_ref
	end
end


-- client picked player, and wants to start game. send him game state
local gameStart=function(event)
	log("game_start:"..Pow.pack(event), "verbose")
	
	local login=event.login
	local playerId=event.playerId
	
	
	local player=Player.getById(playerId)
	local level_name=player.level_name
	assert(level_name)
	
	local alreadyLogged=Db.get(level_name,Player.entity_name,player.id)
	if alreadyLogged==nil then
		put_player_into_world(player, level_name)
	else
		-- it's ok, players continue to exist in the world		
		--		log("warn:logging player which already on level")
	end
	
	Level.activate(level_name)
	
	_.sendFullState(player)
end

-- handler to intent_move
local movePlayer=function(event)
	local player=Player.getByLogin(event.login)
	local controlled_entity_ref=player.controlled_entity_ref
	local controlled_entity=_deref(controlled_entity_ref)
	
	-- todo: выловить этот баг
	if controlled_entity==nil then
		local a=1
	end
	
	
	if Movable.cannot_move(controlled_entity) then
		log("cannot move")
		return
	end
	
	local x=event.x
	local y=event.y
	Movable.move_event(controlled_entity,x,y)
end



-- server handler to "move"
local do_move=function(event)
	local actorRef=event.actorRef
	
	local actor=Db.getByRef(actorRef, actorRef.level_name)
	
	-- test not allow to move mount while rider still mounting

	-- todo: duration не передаётся извне 
	Movable.move(actor,event.x,event.y,event.duration)
end

local logoff=function(event)
	-- event example: {code = "logoff", entity_name = "Event", id = 1579, login = "client1", target = "server"}
	
	-- remove player from level
	local player=Player.getByLogin(event.login)
	local level_name=player.level_name
	Db.remove(player,level_name)
	

	
	local logoffOkEvent=_event.new("logoff_ok", event.id)
	logoffOkEvent.target="login"
	logoffOkEvent.targetLogin=event.login
	_event.process(logoffOkEvent)
	
end



-- get players for login
local listPlayers=function(event)
 	local login=event.login
	
	-- todo: поддержка нескольких игроков
	-- пока что 1 игрок - 1 логин
	local player=Player.getByLogin(login)
	
	local response=_event.new("list_players_response")
	response.target="login"
	response.targetLogin=login
	response.requestId=event.id
	response.players={player}
	_event.process(response)
end


-- todo: put editor entities in special level, do not recreate them every time
local _editorItemsCache=nil

local get_editor_items=function()
	local result={}
	
	for k,entity in ipairs(WorldEntities) do
		if not entity.new then
			log("error: entity has no new():"..Inspect(entity))
		end
		
		local editorInstance=entity.new()
		table.insert(result, editorInstance)
	end
	
	local portal_start=Portal.new()
	BaseEntity.set_sprite(portal_start,"portal_start")
	portal_start.location="start"
	table.insert(result, portal_start)
	
	local portal_volcano=Portal.new()
	portal_volcano.location="volcano"
	BaseEntity.set_sprite(portal_volcano,"portal_volcano")
	
	table.insert(result, portal_volcano)
--	local seed=Seed.new()
--	table.insert(_editorItemsCache, seed)
	
--	local panther=Panther.new()
--	table.insert(_editorItemsCache, panther)

	return result
end


local editorItems=function(event)
	local response=_event.new("editor_items_response", event.id)
	
	if _editorItemsCache==nil then
		_editorItemsCache=get_editor_items()
	end
	
	
	response.items=_editorItemsCache

	
	response.target="login"
	response.targetLogin=event.login
	_event.process(response)
end


local editor_place_item=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	local item=event.item
	local entityCode=Entity.get_code(item)
	
	-- так делать нельзя (instance.sprite=item.sprite) - меняется и размер и точки и коллизи нужно обновить.
	-- можно сделать set_sprite()

	local instance=entityCode.new(nil,item.sprite)
	
	local x=item.x
	
	if x==nil then 
		local a=1
	end
	
	
	instance.x=x
	instance.y=item.y
	
	-- custom prop: portal dest, sprite

	instance.location=item.location
	
	local level_name=player.level_name
	Db.add(instance,level_name)
end





--attached to  Db.onAdded
local onEntityAdded=function(entity,level_name)
	local message="onEntityAdded:".._ets(entity).." level:"..level_name
--	if entity.entity_name=="player" then
--		local a=1
--	end
	
	
	log(message, "entity")
	local notifyEvent=_event.new("entity_added")
	notifyEvent.target="level"
	notifyEvent.level=level_name
	notifyEvent.do_not_process_on_server=true
	notifyEvent.entities={entity}
	
	_event.process(notifyEvent)
end



local onEntityRemoved=function(entity,level_name)
	local removedEvent=_event.new("entity_removed")
	removedEvent.entityRef=BaseEntity.getReference(entity)
	removedEvent.target="level"
	removedEvent.do_not_process_on_server=true
	removedEvent.level=level_name
	_event.process(removedEvent)
end

_.notifyEntityRemoved=onEntityRemoved

local getCollisions=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	local level_name=player.level_name
	
	local collisions=CollisionService.getCollisionShapes(level_name)
	
	local response=_event.new("collisions_get_response")
	response.target="login"
	response.targetLogin=login
	response.requestId=event.id
	response.collisions=collisions
	_event.process(response)
end



-- вызвать interact у сущности actor
local default_action_generic=function(actor,target,player)
	log("default_action_generic","verbose")
	
	local actorCode=Entity.get_code(actor)
	local fnInteract=actorCode.interact
	if fnInteract==nil then return false end
	
	local interact_result=fnInteract(actor,target,player)
	return interact_result
end

-- Выбрать действие по умолчанию и выполнить его
-- пытается взаимодействовать со всеми
-- filter - функция принимает сущность, возвращает учитывать ли её при взаимодействии (true-не учитывать, отфильтровать)
local default_action_select=function(controlled_entity,player,filter)
	-- todo: d button to drop
	-- todo: multi action
	
	local collision_entities=CollisionService.getEntityCollisions(controlled_entity)
	if collision_entities==nil then return end
	
	
--	local collision_entities_filtered={}
	local collision_entities_filtered=collision_entities
	-- exclude mounted
	
-- тут фильтровались маунты на которых есть наездник. сейчас неактуально?	
-- фильтровать маунтов
--	local is_excluded=function(entity)
--		if entity.mounted_by~=nil then
--			return true
--		end
		
--		return false
--	end
	
	if filter then
		collision_entities_filtered={}
		for k,entity in pairs(collision_entities) do
			if not filter(entity) then
				table.insert(collision_entities_filtered, entity)
			end
		end
	end
	
	-- /
	
	local interact_candidates={}
	
	-- todo получение списка сущностей, с которыми возможно взаимодействие
	for k,entity in pairs(collision_entities_filtered) do
		-- todo
		local can_interact=true
		if can_interact then 
			table.insert(interact_candidates, entity)
		else
			log("can not interact with:"..entity.entity_name,"verbose")
		end
	end
	
	-- todo: выбор кандидата через запрос клиенту
	
	for k,entity in pairs(interact_candidates) do
		local is_interacted=default_action_generic(controlled_entity,entity,player)
		if is_interacted then
			return true
		else
			log("not interacted with:".._ets(entity))
		end
	end
	
	if controlled_entity.hand_slot~=nil then
		Carrier.do_drop(controlled_entity)
		return
	end
	
end

local filter_mounts=function(entity)
	return entity.is_mountable
end

local filter_not_mounts=function(entity)
	return not entity.is_mountable
end

local mount_dismount=function(event)
	log("mount_dismount","verbose")
	local login=event.login
	local player=Player.getByLogin(login)
	
	local controlled_entity=Player.get_controlled_entity(player)
	
	local mounted_on=controlled_entity.mounted_on
	
	local target=nil
	
	if mounted_on~=nil then
		-- слезть с маунта
		target=_deref(mounted_on)
		default_action_generic(controlled_entity,target)
	else
		-- сесть на маунта
		default_action_select(controlled_entity,player,filter_not_mounts)
	end
end




-- player press space, enter portal / pickup-drop item etc
-- event handler "default_action"
local default_action=function(event)
	log("default_action","verbose")
	
	local login=event.login
	local player=Player.getByLogin(login)
	
	local controlled_entity=Player.get_controlled_entity(player)

	default_action_select(controlled_entity,player,filter_mounts)
end



-- server mount handler to "do_mount" event
local do_mount=function(event)
	log("server_service.do_mount start", "verbose")
	
	-- need to know level name here
	--[[
	
	how its done in other places
	local player=Player.getByLogin(event.login)
	local level_name=player.level_name
	
	how i see it:
	put level name into ref
	
	use old method for now
	
	where event.login populated?
		Event.new
	
	why it empty in do_mount event?
		emitted on server
	]]--
	
	local rider_ref=event.rider_ref
	local mount_ref=event.mount_ref
	
	local rider=_deref(rider_ref)
	local mount=_deref(mount_ref)
	
	local slot_id=event.mount_slot_id
	
	Mountable.do_mount(rider,mount, event.is_mounting,slot_id)
end

-- emitted on growable.start_grow
local do_grow=function(event)
	local entity=_deref(event.entity)
	Growable.do_grow(entity,event.sprite)
end


-- начало крафта - запрос от клиента что можно скрафтить
local craft=function(event)
	log("server craft","verbose")

	local login=event.login
	local player=Player.getByLogin(login)
	
	local controlled_entity=Player.get_controlled_entity(player)
	
	
	local craft_range=Crafting_service.craft_range
	local entities_around=CollisionService.get_around(controlled_entity, craft_range)
	
	local craftables=Crafting_service.get_craftables_from_items(entities_around)
	
	local response=_event.new("craft_list")
	response.craftables=craftables
	response.target="login"
	response.targetLogin=login
	
	_event.process(response)
end

-- клиент выбрал что крафтить, запрос на крафт
local craft_request=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	
	local controlled_entity=Player.get_controlled_entity(player)
	
	--  craftable = {h = 16, name = "axe", quantity = 42, w = 16, x = 16, y = 16}
	local craftable=event.craftable
	
	Crafting_service.do_craft(craftable,controlled_entity,login)
end

local entity_swap_request=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	
	local controlled_entity=Player.get_controlled_entity(player)
	
	local target=Swap.pick_target(controlled_entity,player)
	
	local is_swapped=Swap.do_swap(controlled_entity,target,player)
		
	if not is_swapped then
		log("not swapped with:".._ets(target))
		return 
	end
	
	log("swapping with:".._ets(target))
	-- todo уведомить клиента, чтобы камеру перевесил
end

local connect_handlers=function()
	_event.add_handler("create_player", createPlayer)
	_event.add_handler("game_start", gameStart)
	_event.add_handler("intent_move", movePlayer)
	_event.add_handler("move", do_move)
	_event.add_handler("logoff", logoff)
	_event.add_handler("list_players", listPlayers)
	_event.add_handler("editor_items", editorItems)
	_event.add_handler("editor_place_item", editor_place_item)
	_event.add_handler("collisions_get", getCollisions)
	_event.add_handler("default_action", default_action)
	_event.add_handler("mount_dismount", mount_dismount)
	_event.add_handler("do_mount", do_mount)
	_event.add_handler("do_grow", do_grow)
	_event.add_handler("craft", craft)
	_event.add_handler("craft_request", craft_request)
	_event.add_handler("entity_swap_request", entity_swap_request)
end


_.start=function()
	
	connect_handlers()
	
	Db.onAdded=onEntityAdded
	Db.setOnRemoved(onEntityRemoved)
	
	_server.listen(Config.port)
	
end

_.update=function(dt)
	send_updated_entities()
	_serverUpdate(dt)
end

_.lateUpdate=function(dt)
	_serverLateUpdate(dt)
end


local clearWorld=function()
	local level_name="start"
	
	local levelEntityContainers=getLevelEntities(level_name)
	for entity_name,container in pairs(levelEntityContainers) do
		if entity_name~="player" then
			for k2,entity in pairs(container) do
				Db.remove(entity,level_name)
			end
		end
		
	end
	
	
	
end





local toggle_help=function()
	if not HelpScreen.active then
		Entity.add(HelpScreen)
		HelpScreen.active=true
	else
		Entity.remove(HelpScreen)
		HelpScreen.active=false
	end
end


_.keyPressed=function(key)
	if key=="delete" then
		clearWorld()
	elseif key=="f1" then
		toggle_help()
	end
end




return _

