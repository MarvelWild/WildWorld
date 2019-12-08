-- game specific server code


local _entityName='ServerService'
local _=BaseEntity.new(_entityName, true)

_.isService=true

local _server=Pow.server
local _event=Pow.net.event
local _serverUpdate=_server.update
local _serverLateUpdate=_server.lateUpdate


-- handler to create_player command
local createPlayer=function(event)
	local playerName=event.player_name
	local login=event.login
	
	log('creating player:'..playerName..' login:'..login,'verbose',true)
	
	local player=Player.new()
	player.name=playerName
	-- todo: start coord
	player.x=100
	player.y=20
	player.login=login
	
	Db.add(player, "player")
	
	local responseEvent=_event.new("create_player_response")
	responseEvent.player=player
	
	responseEvent.target="login"
	responseEvent.targetLogin=login
	
	_event.process(responseEvent)
	
	log('new event: create_player_response')
	
end

local getLevelEntities=function(levelName)
	local levelContainer=Db.getLevelContainer(levelName)
	return levelContainer
end


local getLevelState=function(levelName)
	log("getLevelState:"..levelName)
	
	local state={}
	
	local levelDescriptor=Level.getDescriptor(levelName)
	state.levelName=levelName
	state.levelDescriptor=levelDescriptor
	state.entities=getLevelEntities(levelName)
	return state
end


-- player has been created by createPlayer, present in Db
local getPlayerState=function(playerId)
	local player=Player.getById(playerId)
	assert(player)
	
	-- todo: do not return everything server knows about player
	return player
end



local getFullState=function(playerId)
  local player=getPlayerState(playerId)
	local levelState=getLevelState(player.levelName)
	local result={}
	result.level=levelState
	return result
end


_.sendFullState=function(player)
	local playerId=player.id
	local login=player.login
	
	
	local fullState=getFullState(playerId)
	
	local responseEvent=_event.new("full_state")
	responseEvent.target="login"
	responseEvent.targetLogin=login
	responseEvent.state=fullState
	_event.process(responseEvent)
end



-- client picked player, and wants to start game. send him game state
local gameStart=function(event)
	log("game_start:"..Pow.pack(event))
	
	local login=event.login
	local playerId=event.playerId
	
	
	local player=Player.getById(playerId)
	local levelName=player.levelName
	local alreadyLogged=Db.get(levelName,Player.entityName,player.id)
	if alreadyLogged==nil then
		
		Db.add(player, levelName)
	else
		log("warn:logging player which already on level")
	end
	
	Level.activate(levelName)
	
	_.sendFullState(player)
end

local movePlayer=function(event)
	local responseEvent=_event.new("move")
	responseEvent.target="all"
	responseEvent.x=event.x
	responseEvent.y=event.y
	
	responseEvent.actorRef=event.actorRef

	_event.process(responseEvent)
end



-- handler to "move"
local doMove=function(event)
	-- local levelName="player"
	local actorRef=event.actorRef
	if actorRef==nil then
		local a=1
	end
	
	local actor=Db.getByRef(actorRef, actorRef.levelName)
	Movable.move(actor,event.x,event.y)
end

local logoff=function(event)
	-- event example: {code = "logoff", entityName = "Event", id = 1579, login = "client1", target = "server"}
	
	-- remove player from level
	local player=Player.getByLogin(event.login)
	local levelName=player.levelName
	Db.remove(player,levelName)
	

	
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

local populateEditorItemsCache=function()
	_editorItemsCache={}
	
	for k,entity in ipairs(WorldEntities) do
		local editorInstance=entity.new()
		table.insert(_editorItemsCache, editorInstance)
	end
--	local seed=Seed.new()
--	table.insert(_editorItemsCache, seed)
	
--	local panther=Panther.new()
--	table.insert(_editorItemsCache, panther)
end


local editorItems=function(event)
	local response=_event.new("editor_items_response", event.id)
	
	if _editorItemsCache==nil then
		populateEditorItemsCache()
		
	end
	
	
	response.items=_editorItemsCache

	
	response.target="login"
	response.targetLogin=event.login
	_event.process(response)
end


local editorPlaceItem=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	local item=event.item
	local entityCode=Entity.getCode(item)
	local instance=entityCode.new()
	instance.x=item.x
	instance.y=item.y
	
	local levelName=player.levelName
	Db.add(instance,levelName)
end





--attached to  Db.onAdded
local onEntityAdded=function(entity,levelName)
	local message="onEntityAdded:".._ets(entity).." level:"..levelName
--	if entity.entityName=="player" then
--		local a=1
--	end
	
	
	log(message)
	local notifyEvent=_event.new("entity_added")
	notifyEvent.target="level"
	notifyEvent.level=levelName
	notifyEvent.entities={entity}
	
	_event.process(notifyEvent)
end



local onEntityRemoved=function(entity,levelName)
	local removedEvent=_event.new("entity_removed")
	removedEvent.entityRef=BaseEntity.getReference(entity)
	removedEvent.target="level"
	removedEvent.level=levelName
	_event.process(removedEvent)
end

_.notifyEntityRemoved=onEntityRemoved

local getCollisions=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	local levelName=player.levelName
	
	local collisions=CollisionService.getCollisionShapes(levelName)
	
	local response=_event.new("collisions_get_response")
	response.target="login"
	response.targetLogin=login
	response.requestId=event.id
	response.collisions=collisions
	_event.process(response)
end

-- player press space, enter portal
local defaultAction=function(event)
	local login=event.login
	local player=Player.getByLogin(login)
	local collisions=CollisionService.getEntityCollisions(player)
	if collisions==nil then return end
	
	local collisionsCount=#collisions
	local target=nil
	if collisionsCount==1 then
		target=collisions[1]
	elseif collisionsCount>1 then
		-- todo: resolve target/give player a choice what to do
		log("warn: action on multiple objects not implemented")
	end
	
	if target==nil then return end
	
	local actorCode=Player
	local fnInteract=actorCode.interact
	if fnInteract==nil then return end
	
	fnInteract(player, target)
end


_.start=function()
	_event.addHandler("create_player", createPlayer)
	_event.addHandler("game_start", gameStart)
	_event.addHandler("intent_move", movePlayer)
	_event.addHandler("move", doMove)
	_event.addHandler("logoff", logoff)
	_event.addHandler("list_players", listPlayers)
	_event.addHandler("editor_items", editorItems)
	_event.addHandler("editor_place_item", editorPlaceItem)
	_event.addHandler("collisions_get", getCollisions)
	_event.addHandler("default_action", defaultAction)
	
	Db.onAdded=onEntityAdded
	Db.setOnRemoved(onEntityRemoved)
	
	_server.listen(ConfigService.port)
	
end

_.update=function(dt)
	_serverUpdate(dt)
end

_.lateUpdate=function(dt)
	_serverLateUpdate(dt)
end


local clearWorld=function()
	local levelName="start"
	
	local levelEntityContainers=getLevelEntities(levelName)
	for entityName,container in pairs(levelEntityContainers) do
		if entityName~="player" then
			for k2,entity in pairs(container) do
				Db.remove(entity,levelName)
			end
		end
		
	end
	
	
	
end



_.keyPressed=function(key)
	if key=="delete" then
		clearWorld()
	end
end
return _
