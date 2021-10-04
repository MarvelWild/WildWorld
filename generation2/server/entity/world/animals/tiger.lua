local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=14
	result.foot_y=31
	
	result.mount_slots=
	{
		{
			x=14,
			y=22,
			rider=nil,
		},
	}
	
	Mountable.init(result)
	
	result.move_speed=23
	
	return result
end

_.updateAi=function(entity)
	-- todo вкл
--	Ai.moveRandom(entity)
end

_.interact=Mountable.toggle_mount

return _