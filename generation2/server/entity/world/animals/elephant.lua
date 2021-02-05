local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="elephant"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=15
	result.foot_y=31
	
	result.mount_slots=
	{
		{
			x=20,
			y=21,
			rider=nil,
		},
		{
			x=10,
			y=21,
			rider=nil,
		},
	}
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)

end

-- todo: think easy mountable init, from prop
_.interact=Mountable.toggle_mount





return _