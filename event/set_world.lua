-- triggered from debugger by f4 (keyDebuggerPortal)

local _=function(event)
	log("set_world event processing:"..pack(event))
	--[[ data example:
	{ target="server", code="set_world", id=233, entity="Event", worldName="devlevel", login="defaultLogin", actorRef={...} }
	]]--
	
	assert(Session.isServer)
	
	-- actor is player only for now
	local actor=Entity.findByRef(event.actorRef)
	actor.worldName=event.worldName
	
	-- wip: save location  in prev world?
	-- wip: coords in next world
	-- wip: return next world to client (or just notify he can reload)
	
	local okEvent=Event.new()
	okEvent.code="set_world_ok"
end

return _