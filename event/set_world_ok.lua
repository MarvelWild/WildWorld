local _=function(event)
	log("set_world_ok")
	
	-- todo: reload world
	
	--[[ what should be deleted?
	all entities where entity.isInWorld
	
	]]--
	
	local worldEntities=Entity.getWorld()
	
	for k,entity in pairs(worldEntities) do
--		log("del:".._ets(entity))
		E.deleteByEntity(entity)
	end
	
--	log("world entities deleted")

	World.setCurrent(event.world)
end

return _