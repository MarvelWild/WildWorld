local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="bear"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=36
	result.foot_y=48
	
	result.mount_slots=
	{
		{
			x=41,
			y=27,
			rider=nil,
		},
		{
			x=30,
			y=29,
			rider=nil,
		},
	}
	
	Mountable.init(result)
	return result
end

_.updateAi=function(entity)
	Ai.moveRandom(entity)
end

-- todo: think easy mountable init, from prop
_.interact=Mountable.toggle_mount





return _