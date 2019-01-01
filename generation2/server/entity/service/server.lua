-- game specific server code

local _=BaseEntity.new()

_.isService=true

local _server=Pow.server
local _serverUpdate=_server.update



_.start=function()
	_server.listen(ConfigService.port)
	
end

_.update=function(dt)
	_serverUpdate(dt)
end



return _