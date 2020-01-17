-- global 
-- game specific network client
local _=BaseEntity.new("client_service",true)

local _client=Pow.client

local _event=Pow.net.event

local startGameForPlayer=function(player)
	local event=_event.new("game_start")
	
	
	event.playerId=player.id
	GameState.playerId=player.id
	event.target="server"
	
	-- response: full_state
	_event.process(event)
end

	

local afterPlayerCreated=function(response)
	-- start as player
	
		--[[
		response example: 
		{
			code = "create_player_response", 
			entity = "Event",
			id = 9,
			player = {
				entity = "player",
				id = 9, name = "mw"
			} 
		, target = "login",
		targetLogin = "c1"
		}
		]]--
	
	log('afterPlayerCreated', "verbose")
	
	local player=response.player
	startGameForPlayer(player)
	-- response is generic : onStateReceived
end

local unload_state=function()
	Entity.unload_state()
end


local onStateReceived=function(response)
	log('onStateReceived','verbose')
	
	unload_state()
	
	-- state = {level = {bg = "main.png"} --[[table: 0x0f49dd38]], player = {entity = "player", id = 21, level = "start", name = "mw"} --[[table: 0x0f4510a8]]}
	local state=response.state
	local level=state.level
	GameState.level=level
	GameState.set(state)
	
	-- here comes entities from getLevelEntities -> Db.getLevelContainer(level_name)
	-- and level container has subcontainers for each entity
	
	-- todo: unregister previous / update
	-- but now we only receive state once, then updates
	for k,entityContainer in pairs(level.entities) do
		-- should we do it on server?
		-- do we need separate entity containers on client?
		
		for k2,entity in pairs(entityContainer) do
			Entity.add(entity)
		end
	end
end

local doMove=function(event)
	
	-- local actor=Db.getByRef(event.actorRef)
	local actor=GameState.findEntity(event.actorRef)
	if actor==nil then
		local a=1
	end
	
	Movable.move(actor,event.x,event.y)
end

local onEntityRemoved=function(event)
	--[[ event example:
	{
		code = "entity_removed", entity_name = "Event", entityRef = 
			{entity_name = "player", id = 11}  
		id = 42, level = "start", target = "level"}	
	]]--
--	log("onEntityRemoved:"..Pow.inspect(event))
	
--	if event.entityRef.entity_name=="player" then
--		local a=1
--	end
	
	GameState.removeEntity(event.entityRef)
end



-- response to list_players
local onPlayersListed=function(event)
	log("onPlayersListed")
	local players=event.players
	-- todo: select by player
	
	local selectedPlayer=Pow.lume.first(players)
	if selectedPlayer==nil then
			local event=_event.new("create_player")
			event.player_name="mw"
			event.target="server"
			_event.process(event)
	else
		startGameForPlayer(selectedPlayer)
	end
	
end

local onEntityAdded=function(event)
	--log("onEntityAdded start")
	if GameState.level==nil then
		log("no level yet")
		return
	end
	
	
	local entities=event.entities
	for k,entity in pairs(entities) do
--		if entity.entity_name=="player" then
--			local a=1
--		end
		
		if GameState.level.level_name~=entity.level_name then
			-- сейчас при проходе в портал добавляется новый игрок на новом уровне:
			--  сервер уже знает что игрок на новом уровне, а клиент ещё нет.
			-- log("todo: do not send event like this")
		else
			log("onEntityAdded:".._ets(entity))
			GameState.addEntity(entity)
		end
	end
end


-- 
local afterLogin=function(response)
	log('after login:'..Pow.pack(response), "net")
	
	-- todo: move to pow
	Pow.net.state.login=response.login
	love.window.setTitle(love.window.getTitle().." l:"..response.login)
	
	_event.addHandler("create_player_response", afterPlayerCreated)
	_event.addHandler("full_state", onStateReceived)
	_event.addHandler("move", doMove)
	_event.addHandler("entity_removed", onEntityRemoved)
	_event.addHandler("entity_added", onEntityAdded)
	
	log("added handler of create_player_response",'event')
	-- todo: remove handler on completion
	-- generic way? single response
	
	local event=_event.new("list_players")
	event.target="server"
	_event.process(event,onPlayersListed)
end


local login=function()
	log('login start','verbose')
	-- todo: get this from user
	local login=Pow.arg.get("login=", "defaultLogin")
	
		local data={
			cmd="login",
			login=login,
		}
		
		
	_client.send(data,afterLogin)
	
end

local registerGenericCode=function(entity)
	local entity_name=entity.entity_name
	local code=Entity.getCode(entity)
	if code~=nil then return end
	
	code=Generic
	
	log('Registering generic entity:'..entity_name)
	Entity.addCode(entity_name,code)
end


_.start=function()
	Entity.beforeAdd=registerGenericCode
	
	local isConnected=_client.connect(ConfigService.serverHost, ConfigService.port)
	if isConnected then
		login()
	else
		log("error:cannot connect to"..ConfigService.serverHost..":"..ConfigService.port)
	end
	
end

_.update=function(dt)
	_client:update(dt)
end

-- send move intention to server
-- game coordinates
_.move=function(x,y)
	-- todo: canMove checks
	local event=_event.new("intent_move")
	event.target="server"
	
	-- todo: server knows about player, remove this
	local player=GameState.getPlayer()
	event.actorRef=BaseEntity.getReference(player)
	event.x=x
	event.y=y
	_event.process(event)
end




_.logoff=function()
	
end

	

_.defaultAction=function()
	local event=_event.new("default_action")
	event.target="server"
	_event.process(event)
end

return _