local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	
	return result
end

_.interact=function(actor)
	log("apple interact with:".._ets(actor))
	-- wip implement
	
	-- wip put into player hand
	-- wip move with player - pin to hand
	-- wip remove from ground
end



return _