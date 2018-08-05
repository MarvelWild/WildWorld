local _=function(event)
	assert(Session.isServer)
	log("mount event handler:"..Event.toString(event))
	
	local actor=Entity.find(event.actorEntityName,event.actorEntityId,
		event.actorEntityLogin)
	assert(actor)
	
	local mount=Entity.find(event.targetEntityName,event.targetEntityId,
		event.targetEntityLogin)
	assert(mount)
	
	
	local isAllowed=true
	if mount.mountedBy then
		log("warn: mount already mounted")
		isAllowed=false
	end
	
	if actor.mountedOn then
		log("warn: actor already mounted")
		isAllowed=false
	end
	
	if not isAllowed then
		-- todo: send response to emitter, unlock it
		log("error: not implemented")
	else
		local responseEvent=Event.new()
		responseEvent.code="mount_ok"
		responseEvent.mountEvent=event
		responseEvent.target="others" 
		
		-- process locally mount_ok (to prevent double success case)
		-- в логе запись что обработано, затем пропущено - ок, пусть.
		Event.doProcessEvent(responseEvent)
		
	end
end

return _