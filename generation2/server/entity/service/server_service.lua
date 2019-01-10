-- game specific server code

local _=BaseEntity.new()

_.isService=true

local _server=Pow.server
local _event=Pow.net.event
local _serverUpdate=_server.update


local createPlayer=function(event)
	local playerName=event.player_name
	local login=event.login
	
	-- где персистим игроков?
	-- wip
	
end



_.start=function()
	_event.addHandler("create_player", createPlayer)
	
	_server.listen(ConfigService.port)
	
end

_.update=function(dt)
	_serverUpdate(dt)
end



return _