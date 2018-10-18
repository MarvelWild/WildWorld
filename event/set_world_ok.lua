local _=function(event)
	log("set_world_ok")
	
	-- todo: reload world
	
	--[[ what should be deleted?
	all inWorld entities
	
	]]--
	
	-- clear prev world
	if CurrentWorld~=nil then
		local worldEntities=Entity.getWorld()
		
		for k,entity in pairs(worldEntities) do
	--		log("del:".._ets(entity))
			E.deleteByEntity(entity)
		end
	end
		
--	log("world entities deleted")

	local www=Inspect(event.world)

	World.setCurrent(event.world)
end

return _