local _=function(event)
	log("entity_deleted handler:"..Event.toString(event))
	
	assert(Session.isClient)
	
	local entity=Entity.find(event.entityName,event.entityId,event.entityLogin)
	assert(entity)
	local deletedEntity=Entity.deleteByEntity(entity)
	
	-- no need to respond

end

return _