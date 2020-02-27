local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="zombie_1"
	
	BaseEntity.init_bounds_from_sprite(result)
	
--	result.originX=3
--	result.originY=7
	result.footX=3
	result.footY=14
	
	
	
	return result
end

local update_ai_combat=function(entity)
	-- todo: seek target, move to it
	
	-- wip detect target in melee range (collision check)
	local collsions=CollisionService.getEntityCollisions(entity)
	for k,entity in pairs(collsions) do
		log("collision:".._ets(entity))
		-- todo
		
	end
	
	
	return false
end


_.updateAi=function(entity)
	
	if update_ai_combat(entity) then return end
	
	AiService.moveRandom(entity)
end



--_.interact=Mountable.toggle_mount

return _