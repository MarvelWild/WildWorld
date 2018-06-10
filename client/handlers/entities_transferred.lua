local entities_transferred=function(data,clientId)
	log("entities_transferred:"..pack(data))
	
	local entities=data.entities
	local login=data.login
	
	local isOurs=Session.login==login
	
	if isOurs then
		-- unregister old
		-- wip: trace test
		for k,entity in pairs(entities) do
			Entity.delete(entity.entity,entity.oldId)
		end
	end
	
	-- register new
	-- wip: trace test
	for k,entity in pairs(entities) do
		entity.isRemote=true -- можно отказаться и проверять логин
		Entity.register(entity)
	end
	
	
	
	
	-- wip: сервер трансфернул, принять их, а владелец обновляет
--	local events=data.events
--	--local login=Server.loginByClient[clientId] 
	
--	for k,event in pairs(events) do
--		event.isRemote=true
--		-- wip
--		-- event.login=login
--		-- ожидаем что есть
--		Event.register(event)
--	end
end


return entities_transferred