local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=31
	result.foot_y=63

	result.mountX=32
	result.mountY=47
	result.move_speed=16
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)
end

_.interact=Mountable.toggle_mount

return _