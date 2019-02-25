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
	
	local event=_event.new("create_player_response")
	event.player=player
	
	event.target="login"
	event.targetLogin=login
	
	log('new event: create_player_response')
	
	-- wip: react to this on client
	-- задача: слушать такое не всегда,
end



_.start=function()
	_event.addHandler("create_player", createPlayer)
	
	_server.listen(ConfigService.port)
	
end

_.update=function(dt)
	_serverUpdate(dt)
end

_.lateUpdate=function(dt)
	_serverLateUpdate(dt)
end




return _