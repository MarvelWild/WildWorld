-- server handle events from clients
local events=function(data,clientId)
	log("events:"..pack(data))
	
	local events=data.events
	local login=Server.loginByClient[clientId]
	
	for k,event in pairs(events) do
		event.isRemote=true
		event.login=login
		Event.register(event)
	end
end

return events