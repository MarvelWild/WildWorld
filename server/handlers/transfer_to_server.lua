-- server accepts entity, and sends update to clients
-- unused: moved to event
local transfer_to_server=function(data,clientId)
	log("[UNUSED] transfer_to_server:"..pack(data))
	
	local login=Server.loginByClient[clientId]
	
	local entities=data.entities
	for k,entity in pairs(entities) do
		entity.login=Session.login

		entity.prevId=entity.id
		entity.id=Id.new(entity.entity)
		
		Entity.register(entity)
	end
	
	local response={}
	
	response.cmd="entities_transferred"
	response.originalLogin=login
	response.entities=entities
	
	Server.send(response)
	
end

return transfer_to_server