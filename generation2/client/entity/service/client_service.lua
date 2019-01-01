-- game specific network client
local _=BaseEntity.new()

_.isService=true

local _client=Pow.client

local _event=Pow.net.event


local afterLogin=function(response)
	log('after login:'..Pow.pack(response))
	
	-- todo: move to pow
	Pow.net.state.login=response.login
	
	local event=_event.new("create_player")
	event.player_name="mw"
	event.target="server"
	
	log("created event create_player")
end


local login=function()
	log('login start')
	-- todo: get this from user
	local login="c1"
	
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


return _