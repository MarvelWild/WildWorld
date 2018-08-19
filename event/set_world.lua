-- triggered from debugger by f4 (keyDebuggerPortal)

local _=function(event)
	log("set_world event processing:"..pack(event))
	--[[ data example:
	{ target="server", code="set_world", id=233, entity="Event", worldName="devlevel", login="defaultLogin" }
	]]--
	
	assert(Session.isServer)
	-- wip: детализировать задачу
	
	
	
	

end

return _