-- client updates transferred entities
local entities_transferred=function(data,clientId)
	log("entities_transferred:"..pack(data))
	
	local entities=data.entities
	local login=data.originalLogin
	
	local isOurs=Session.login==login
	
	-- сейчас сущность перезаписывается, можно сделать с обновлением, но лучше немутабельность
	
	if isOurs then
		-- unregister old
		for k,entity in pairs(entities) do
			log("entities_transferred deleting prev:"..entity.entity.." id:"..entity.prevId)
			Entity.delete(entity.entity,entity.prevId)
			
			local testIsDeleted=Entity.find(entity.entity,entity.prevId)
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
		Entity.register(entity)
	end
	
	Entity.debugPrint()
end


return entities_transferred