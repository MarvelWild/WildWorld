local _=function(event)
	log("pickup_ok nahdle")
	
	--[[
	ex 
	]]--
	
	local deleted=Entity.delete(event.entityName,event.entityId,event.entityLogin)
	Entity.removeFromWorld(deleted)
		
	if event.actorLogin==Session.login then
		--wip add to fav/backpack
		deleted.login=event.actorLogin
		Player.addFavorite(World.player,deleted)
	end
	
	log("pickup_ok event:"..Inspect(event))

end

return _