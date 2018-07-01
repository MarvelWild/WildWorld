local _=function(event)
	log("pickup event:"..Util.oneLine(Inspect(event)))
	--[[example:
pickup event:{
  aiEnabled = false,
  code = "pickup",
  entity = "Event",
	entityName = "Bucket",
  entityId = 3,
  entityLogin = "defaultLogin",
  h = 0,
  id = 52,
  isActive = true,
  isDrawable = false,
  isServerOnly = true,
  login = "defaultLogin",
  w = 0,
  x = 0,
  y = 0
}	
	]]--
	
	assert(Session.isServer)
	
	local entity=Entity.find(event.entityName,event.entityId,event.entityLogin)
	
	
	-- problem: broadcasted delete will return later
	-- solution1: do not broadcast deletion to caller
	-- generic: broadcast from Entity.delete
	-- problem: server can reject deletion
	-- sol: handle delete event on serv, respond to deletion on caller
	-- way to respond to event? direct command?
	if not entity then 
		log("warn: pickup: no entity")
		return
	end
	
	local responseEvent=Event.new()
	responseEvent.code="pickup_ok"
	responseEvent.entityName=entity.entity
	responseEvent.entityId=entity.id
	responseEvent.entityLogin=entity.login
	responseEvent.actorLogin=event.login
	
end

return _