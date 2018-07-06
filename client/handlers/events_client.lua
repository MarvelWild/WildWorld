-- с сервера на клиент пришли события
local events_client=function(data,clientId)
	log("received events:"..pack(data))
	
	local events=data.events
	--local login=Server.loginByClient[clientId] 
	
	for k,event in pairs(events) do
		--event.isRemote=true
		Event.register(event)
	end
end

return events_client
