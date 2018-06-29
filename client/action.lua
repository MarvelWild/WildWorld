-- global ClientAction
local _={}

--[[

]]--
_.pickup=function(entity)
	local event=Event.new()
	event.code="pickup"
	event.entityId=entity.id
	event.entityLogin=entity.login
	event.isServerOnly=true
	
	-- пример события, не отправляемого на сервере, а обрабатываемого локально (server only event)
		-- с клиента отправляется на сервер
	-- wip: test no client execution
	-- wip: react to server response
end


return _