local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=7
	result.foot_y=14
	
	result.mount_slots=
	{
		{
			x=6,
			y=7,
			rider=nil,
		},
	}
	
	result.move_speed=24
	
	return result
end

_.updateAi=function(entity)
	
	if not Mountable.is_mounted(entity) then
		AiService.moveRandom(entity)
	end
end

_.interact=Mountable.toggle_mount

return _