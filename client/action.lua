-- global ClientAction
local _={}

--[[

]]--
_.pickup=function(entity)
	local event=Event.new()
	event.code="pickup"
	event.entityName=entity.entity
	event.entityId=entity.id
	event.entityLogin=entity.login
	event.target="server"
end


return _