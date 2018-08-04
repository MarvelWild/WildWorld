local _=function(event)
	log("entity_delete handler")
	
	assert(Session.isServer)
	
	local entity=Entity.find(event.entityName,event.entityId,event.entityLogin)
	assert(entity,"concurrency not implemented")
	
	local deletedEntity=Entity.deleteByEntity(entity)
	
	local responseEvent=Event.new()
	responseEvent.code="entity_deleted"
	responseEvent.entityName=event.entityName
	responseEvent.entityId=event.entityId
	responseEvent.entityLogin=event.entityLogin
	responseEvent.target="others" 
end

return _