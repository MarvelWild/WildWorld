-- evoker: mount.lua
-- could be mount or unmount.
-- processed on all
local _=function(event)
	log("mount_ok:"..pack(event))
	
	-- created in ClientAction.toggleMount
	local mountEvent=event.mountEvent
	local isMounting=mountEvent.targetEntityName~=nil
	local mount=nil
	
	if isMounting then
		mount=Entity.find(mountEvent.targetEntityName,mountEvent.targetEntityId,
			mountEvent.targetEntityLogin)
		assert(mount)
		--assert(mount.mountedBy==nil)
	end
	
	local actor=Entity.find(mountEvent.actorEntityName,mountEvent.actorEntityId,
		mountEvent.actorEntityLogin)
	assert(actor)
	-- тут все проверки пройдены, садим райдера на маунта
	
	if isMounting then
		assert(actor.mountedOn==nil)
	else
		assert(actor.mountedOn~=nil)
	end
	
	-- set connection
	if isMounting then
		mount.mountedBy=Entity.getReference(actor)
		actor.mountedOn=Entity.getReference(mount)
		
		
		local riderX,riderY=Entity.getRiderPoint(mount,actor)
		Entity.smoothMove(actor,0.5,riderX,riderY)
		
	else
		mount=Entity.findByRef(actor.mountedOn)
		mount.mountedBy=nil
		actor.mountedOn=nil
	end
	
	
end

return _