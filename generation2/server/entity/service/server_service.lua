-- game specific server code


local _entityName='ServerService'
local _=BaseEntity.new(_entityName, true)

_.isService=true

local _server=Pow.server
local _event=Pow.net.event
local _serverUpdate=_server.update
local _serverLateUpdate=_server.lateUpdate


local createPlayer=function(event)
	local playerName=event.player_name
	local login=event.login
	
	local player=Player.new()
	player.name=playerName
	Db.add(player)
	
	local responseEvent=_event.new("create_player_response")
	responseEvent.player=player
	
	responseEvent.target="login"
	responseEvent.targetLogin=login
	
	_event.process(responseEvent)
	
	log('new event: create_player_response')
	
end



-- client picked player, and wants to start game. send him game state
local gameStart=function(event)
	-- wip: implement
	log("game_start:"..Pow.pack(event))
end

_.start=function()
	_event.addHandler("create_player", createPlayer)
	_event.addHandler("game_start", gameStart)
	
	
	_server.listen(ConfigService.port)
	
end

_.update=function(dt)
	_serverUpdate(dt)
end

_.lateUpdate=function(dt)
	_serverLateUpdate(dt)
end




return _