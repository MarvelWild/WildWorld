local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="snail"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=6
	result.foot_y=15
	
	result.move_speed=1
	
	return result
end

_.updateAi=function(entity)
	Ai.moveRandom(entity)

end

--_.interact=Mountable.toggle_mount




return _