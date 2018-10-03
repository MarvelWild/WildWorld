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
	
	-- todo: save location  in prev world?
	-- todo: coords in next world
	
	local okEvent=Event.new()
	okEvent.code="set_world_ok"
	
	okEvent.world=Universe.getWorld(event.worldName)
	
	if okEvent.world==nil then
		log("error: no world:"..event.worldName)
		
	end
	
end

return _