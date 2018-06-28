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
--	joinResponse.entities=Entity.getLocal()
	joinResponse.entities=Entity.getWorld(login)
	
	Server.send(joinResponse, clientId, data.requestId)
	
	local response={}
	response.cmd="entity_add"
	response.entities={joiningPlayer}
	
	Server.sendFiltered(response,login)
end

return join