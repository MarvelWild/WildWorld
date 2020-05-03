local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="bee"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=1
	result.foot_y=1
	
	result.move_speed=17
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)
end

return _