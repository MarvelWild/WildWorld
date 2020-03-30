local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.footX=7
	result.footY=15
	
	result.move_speed=14
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)
end


return _