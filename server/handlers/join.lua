-- send initial world state, and subscribe client to updates
local join=function(data,clientId)
	log("join:"..pack(data))
	
	
	-- receive player entity 
	local joiningPlayer=data.player
	joiningPlayer.isRemote=true
	
	local login=Server.loginByClient[clientId]
	joiningPlayer.login=login
	
	Entity.register(joiningPlayer)
	
	local joinResponse={}
		-- todo: also from other clients
	joinResponse.entities=Entity.getLocal()
	
	Server.send(joinResponse, clientId, data.requestId)
	
end

return join