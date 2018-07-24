local _=function(event)
	log("pickup_ok event:"..Inspect(event))
	
	--[[

	]]--
	
	local picked=Entity.delete(event.entityName,event.entityId,event.entityLogin)
		
	if event.actorLogin==Session.login then
		Entity.changeLogin(picked,event.actorLogin)
		Player.addFavorite(World.player,picked)
	end
end

return _