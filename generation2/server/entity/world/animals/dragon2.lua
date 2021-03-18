local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	-- todo: animation
	result.sprite="dragon_stand1"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=62
	result.foot_y=64
	
	
	result.mount_slots=
	{
		{
			x=56,
			y=25,
			rider=nil,
		},
	}
	
	result.move_speed=100
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)
end

_.interact=Mountable.toggle_mount


return _