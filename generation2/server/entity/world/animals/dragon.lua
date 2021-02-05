local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=20
	result.foot_y=29
	
	
	result.mount_slots=
	{
		{
			x=12,
			y=19,
			rider=nil,
		},
	}
	
	result.move_speed=27
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)
end

_.interact=Mountable.toggle_mount


return _