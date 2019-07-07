-- game specific network client
local _=BaseEntity.new("client_service",true)

local _client=Pow.client

local _event=Pow.net.event

local afterPlayerCreated=function(response)
	-- wip : start as player
	
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
	
	local event=_event.new("game_start")
	
	local player=response.player
	event.playerId=player.id
	GameState.playerId=player.id
	event.target="server"
	
	_event.process(event)
	
	-- response is generic : onStateReceived
end


local onStateReceived=function(response)
	log('onStateReceived','verbose')
	
	
	-- wip bg
	-- state = {level = {bg = "main.png"} --[[table: 0x0f49dd38]], player = {entity = "player", id = 21, level = "start", name = "mw"} --[[table: 0x0f4510a8]]}
	local state=response.state
	local level=state.level
	GameState.level=level
	GameState.lastState=state
	
	-- here comes entities from getLevelEntities -> Db.getLevelContainer(levelName)
	-- and level container has subcontainers for each entity
	
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
	Movable.move(actor,event.x,event.y)
end

local onEntityRemoved=function(event)
	-- wip remove from local state
	log("onEntityRemoved:"..Pow.inspect(event))
	
	-- wip: do logoff if self removed? now always, only when logoff requested
end



-- 
local afterLogin=function(response)
	log('after login:'..Pow.pack(response), "net")
	
	-- todo: move to pow
	Pow.net.state.login=response.login
	
	_event.addHandler("create_player_response", afterPlayerCreated)
	_event.addHandler("full_state", onStateReceived)
	_event.addHandler("move", doMove)
	_event.addHandler("entity_removed", onEntityRemoved)
	
	log("added handler of create_player_response",'event')
	-- todo: remove handler on completion
	-- generic way?
	
	
	local event=_event.new("create_player")
	event.player_name="mw"
	event.target="server"
	_event.process(event)
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

_.start=function()
	local isConnected=_client.connect(ConfigService.serverHost, ConfigService.port)
	if isConnected then
		login()
	else
		log("error:cannot connect")
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
	
	local player=GameState.getPlayer()
	event.actorRef=BaseEntity.getReference(player)
	event.x=x
	event.y=y
	_event.process(event)
end




_.logoff=function()
	
end

	
return _