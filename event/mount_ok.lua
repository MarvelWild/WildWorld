-- evoker: mount.lua
local _=function(event)
	log("mount_ok:"..pack(event))
	
	-- created in ClientAction.mount
	local mountEvent=event.mountEvent
	local mount=Entity.find(mountEvent.targetEntityName,mountEvent.targetEntityId,
		mountEvent.targetEntityLogin)
	assert(mount)
	
	local actor=Entity.find(mountEvent.actorEntityName,mountEvent.actorEntityId,
		mountEvent.actorEntityLogin)
	assert(actor)

	-- тут все проверки пройдены, садим райдера на маунта
	assert(mount.mountedBy==nil)
	assert(actor.mountedOn==nil)
	
	-- set connection
	mount.mountedBy=Entity.getReference(actor)
	actor.mountedOn=Entity.getReference(mount)
	
	-- wip: команда мув теперь идёт маунту
	-- wip: наездник движется с маунтом
	-- wip: анмаунт
	

end

return _