-- client updates transferred entities
local entities_transferred=function(data,clientId)
	log("entities_transferred:"..pack(data))
	
	local entities=data.entities
	local login=data.login
	
	local isOurs=Session.login==login
	
	-- сейчас сущность перезаписывается, можно сделать с обновлением, но лучше немутабельность
	
	if isOurs then
		-- unregister old
		for k,entity in pairs(entities) do
			Entity.delete(entity.entity,entity.prevId)
		end
	end
	
	-- register new
	for k,entity in pairs(entities) do
		entity.isRemote=true -- можно отказаться и проверять логин
		Entity.register(entity)
	end
end


return entities_transferred