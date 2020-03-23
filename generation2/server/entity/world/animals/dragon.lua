local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.footX=20
	result.footY=29
	
	result.mountX=12
	result.mountY=19
	result.move_speed=27
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)
end

_.interact=Mountable.toggle_mount


return _