local events_client=function(data,clientId)
	log("events_client:"..pack(data))
	
	local events=data.events
	--local login=Server.loginByClient[clientId] 
	
	for k,event in pairs(events) do
		event.isRemote=true
		-- wip
		-- event.login=login
		-- ожидаем что есть
		Event.register(event)
	end
end

return events_client
