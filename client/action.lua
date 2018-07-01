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
	event.isServerOnly=true
	-- let everyone process it? no, item could be unavailable, need confirm from server
	-- no, its just a request to server
	
	-- пример события, не отправляемого на сервере, а обрабатываемого локально (server only event)
		-- с клиента отправляется на сервер
end


return _