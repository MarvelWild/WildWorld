-- client updates transferred entities
local entities_transferred=function(data,clientId)
	log("entities_transferred client handler begin:"..pack(data))
	
	local entities=data.entities
	local originalLogin=data.originalLogin
	
	assert(originalLogin)
	
	local wasOurs=Session.login==originalLogin
	
	-- сейчас сущность перезаписывается, можно сделать с обновлением, но лучше немутабельность
	
	if wasOurs then
		-- unregister old
		for k,entity in pairs(entities) do
			log("entities_transferred deleting prev:"..entity.entity.." id:"..entity.prevId.." orig login:"..originalLogin)
			Entity.delete(entity.entity,entity.prevId,originalLogin)
			
			local testIsDeleted=Entity.find(entity.entity,entity.prevId,originalLogin)
			if testIsDeleted then 
				log("error: entity not deleted")
			end
			
		end
	else
		log("entities_transferred not ours")
	end
	
	-- register new
	for k,entity in pairs(entities) do
		entity.isRemote=true -- можно отказаться и проверять логин
		entity.aiEnabled=false -- ai is server-only
		entity.isTransferring=false
		Entity.register(entity)
		
		log("entity transferred:"..Entity.toString(entity))
	end
	
--	Entity.debugPrint()
end


return entities_transferred