local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	BaseEntity.set_sprite(result,_.entity_name)
	
	result.foot_x=14
	result.foot_y=29
	
	result.move_speed=14
	
	return result
end

_.updateAi=function(entity)
	Ai.moveRandom(entity)
end


return _