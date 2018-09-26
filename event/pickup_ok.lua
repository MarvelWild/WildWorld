-- 
-- target: 
local _=function(event)
	log("pickup_ok event:"..Inspect(event))
	
	--[[

	]]--
	
	-- everyones
	local picked=Entity.delete(event.entityName,event.entityId,event.entityLogin)
		
	-- ours
	if event.actorLogin==Session.login then
		Entity.changeLogin(picked,event.actorLogin)
		picked.isRemote=false
		Player.addFavorite(CurrentPlayer,picked)
	end
end

return _