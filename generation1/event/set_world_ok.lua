local clearWorld=function()
	-- clear prev world
	
	--[[ what should be deleted?
	all inWorld entities
	
	]]--
	
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
end

-- everything that change world with actor: mount, rider (later)
local getMovingEntities=function(actor)
	local result={}
	
	if actor.mountedOn~=nil then
		local mount=Entity.getByRef(actor.mountedOn)
		table.insert(result, mount)
	end
	
	return result
end



local _=function(event)
	log("set_world_ok")
	
	-- event.event.world
	
	-- todo: reload world

	
	local actorRef=event.actorRef
	
	
	local actor=Entity.getByRef(actorRef)
	local entitiesToPersist=getMovingEntities(actor)
	local currPlayerRef=Entity.getReference(CurrentPlayer)
	
	if Entity.refEquals(actorRef, currPlayerRef) then
		log("todo: we")
		clearWorld()
	else
		log("todo: someone else")
		
		-- todo: send only to relevant players (same world)
		-- todo: remove moved actor
		-- todo: remove his persist entities
	end
	
	-- todo: add moving entities to new world
	
	
	local a=1
	

		
--	log("world entities deleted")

	-- todo mount should go to next world
	-- как это сделать?
	-- на ok, вместе 
	-- удобство что можно персистить что угодно
	
	-- вариант 2: маунт принадлежит игроку, не серверу
	-- 

	-- local www=Inspect(event.world)

	-- todo: это делает только актёр, остальные либо добавляют, либо удаляют его из мира (и его маунта)
	World.setCurrent(event.world)
end

return _