local _=function(event)
	log("wip pickup event:"..Inspect(event))
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
	
	-- wip remove from world
	-- wip: broadcast entity removed from world 
end

return _