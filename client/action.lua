local _={}

_.pickup=function(entity)
	---- canPickup is done, do pickup
--_.pickup=function(player,entity)
--	log("pickup:"..Entity.toString(entity))
--	-- todo: server command/event
--end
	-- wip
	
	-- event vs command?
	--[[
	
	
	]]--
	
	
	-- wip pickup event
	local event=Event.new()
	event.code="pickup"
	event.entityId=entity.idntity
	event.entityLogin=entity.login
	
	-- пример события, не отправляемого на сервере, а обрабатываемого локально (server only event)
		-- с клиента отправляется на сервер
	-- wip: handle on server
	-- wip: react to server response
end


return _