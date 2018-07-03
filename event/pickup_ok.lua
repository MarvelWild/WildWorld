local _=function(event)
	log("pickup_ok event:"..Util.oneLine(Inspect(event)))
	
	--[[
	ex 
	]]--
	
	local deleted=Entity.delete(event.entityName,event.entityId,event.entityLogin)
	Entity.removeFromWorld(deleted)
		
	if event.actorLogin==Session.login then
		deleted.login=event.actorLogin
		Player.addFavorite(World.player,deleted)
	end
end

return _