local _=function(event)
	log("set_world_ok")
	
	-- todo: reload world
	
	--[[ what should be deleted?
	all inWorld entities
	
	]]--
	
	local actorRef=event.actorRef
	
	-- wip implement, test
	-- what should be moved with player?
	local entitiesToPersist={}
	
	local actor=Entity.getByRef(actorRef)
	if actor.mountedOn~=nil then
		local mount=Entity.getByRef(actor.mountedOn)
		table.insert(entitiesToPersist, mount)
	end
	
	local currPlayerRef=Entity.getReference(CurrentPlayer)
	
	if Entity.refEquals(actorRef, currPlayerRef) then
		log("wip: we")
	else
		log("wip: someone else")
	end
	
	
	local a=1
	
	-- clear prev world
	if CurrentWorld~=nil then
		local worldEntities=Entity.getWorld()
		
		local delCount=0
		for k,entity in pairs(worldEntities) do
	--		log("del:".._ets(entity))
			E.deleteByEntity(entity)
			delCount=delCount+1
		end
		
		log("deleted:"..tostring(delCount))
	end
		
--	log("world entities deleted")

	-- wip mount should go to next world
	-- как это сделать?
	-- на ok, вместе 
	-- удобство что можно персистить что угодно
	
	-- вариант 2: маунт принадлежит игроку, не серверу
	-- 

	local www=Inspect(event.world)

	-- wip: это делает только актёр, остальные либо добавляют, либо удаляют его из мира (и его маунта)
	World.setCurrent(event.world)
end

return _