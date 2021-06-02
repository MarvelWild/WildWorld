local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="jiraffe"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.mount_slots=
	{
		{
			x=15,
			y=23,
			rider=nil,
		},
	}
	
	Mountable.init(result)
	
	result.originX=15
	result.originY=23
	
	result.foot_x=15
	result.foot_y=31
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)

end

_.interact=Mountable.toggle_mount




return _