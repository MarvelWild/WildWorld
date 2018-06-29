local _=function(event)
	-- server only event, not processed on client
	-- todo: generic way toi mark event as server only (event flag)
	if not Session.isClient then
		log("processing transfer_to_server event")
		Entity.acceptAtServer(event.entities)
	end
end

return _