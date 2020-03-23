local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	
	return result
end

_.interact=function(actor)
	log("blueberry interact with:".._ets(actor))
	-- todo implement harvest
end



return _