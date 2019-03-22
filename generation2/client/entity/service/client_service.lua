-- game specific network client
local _=BaseEntity.new()

_.isService=true

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
	
	log('afterPlayerCreated')
	
	local event=_event.new("game_start")
	
	local player=response.player
	event.playerId=player.id
	event.target="server"
	
	-- response is generic : onStateReceived
end


local onStateReceived=function(response)
	log('onStateReceived')
	-- wip: apply to game world
end



local afterLogin=function(response)
	log('after login:'..Pow.pack(response))
	
	-- todo: move to pow
	Pow.net.state.login=response.login
	
	_event.addHandler("create_player_response", afterPlayerCreated)
	_event.addHandler("state", onStateReceived)
	
	log("added handler of create_player_response")
	-- wip: remove handler on completion
	-- generic way?
	
	
	local event=_event.new("create_player")
	event.player_name="mw"
	event.target="server"
	_event.process(event)
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